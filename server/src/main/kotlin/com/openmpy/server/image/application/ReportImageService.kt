package com.openmpy.server.image.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.repository.MemberRepository
import com.openmpy.server.s3.application.S3Service
import com.openmpy.server.s3.dto.response.PresignedUrlResponse
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*

@Service
class ReportImageService(

    private val memberRepository: MemberRepository,
    private val s3Service: S3Service,
) {

    @Transactional
    fun getPresignedUrl(
        reporterId: Long,
        reportedId: Long,
    ): PresignedUrlResponse {
        memberRepository.findByIdOrNull(reporterId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        memberRepository.findByIdOrNull(reportedId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        val key = "reports/$reporterId/$reportedId/${UUID.randomUUID()}.jpeg"
        return s3Service.createPresignedUrl(key)
    }
}