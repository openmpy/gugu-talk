package com.openmpy.server.report.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.common.properties.S3Properties
import com.openmpy.server.image.domain.entity.ReportImage
import com.openmpy.server.image.repository.ReportImageRepository
import com.openmpy.server.member.repository.MemberRepository
import com.openmpy.server.report.domain.entity.Report
import com.openmpy.server.report.dto.request.ReportSaveRequest
import com.openmpy.server.report.repository.ReportRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class ReportService(

    private val reportRepository: ReportRepository,
    private val memberRepository: MemberRepository,
    private val s3Properties: S3Properties,
    private val reportImageRepository: ReportImageRepository
) {

    @Transactional
    fun save(reporterId: Long, reportedId: Long, request: ReportSaveRequest) {
        val reporter = (memberRepository.findByIdOrNull(reporterId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val reported = (memberRepository.findByIdOrNull(reportedId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        val report = Report(
            reporter = reporter,
            reported = reported,
            type = request.type,
            reason = request.reason,
        )
        reportRepository.save(report)

        request.images.forEach {
            val reportImage = ReportImage(
                reportId = report.id,
                url = s3Properties.endpoint + it.key,
                key = it.key,
            )
            reportImageRepository.save(reportImage)
        }
    }
}