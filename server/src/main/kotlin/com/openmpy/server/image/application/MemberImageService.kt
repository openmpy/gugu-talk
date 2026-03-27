package com.openmpy.server.image.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.common.properties.S3Properties
import com.openmpy.server.image.domain.entity.MemberImage
import com.openmpy.server.image.domain.type.MemberImageType
import com.openmpy.server.image.dto.request.MemberImageSaveRequest
import com.openmpy.server.image.dto.response.MemberGetPrivateImageResponse
import com.openmpy.server.image.dto.response.MemberPrivateImageResponse
import com.openmpy.server.image.repository.MemberImageRepository
import com.openmpy.server.member.repository.MemberPrivatePhotoRepository
import com.openmpy.server.member.repository.MemberRepository
import com.openmpy.server.s3.application.S3Service
import com.openmpy.server.s3.dto.response.PresignedUrlResponse
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*

@Service
class MemberImageService(

    private val memberImageRepository: MemberImageRepository,
    private val memberRepository: MemberRepository,
    private val memberPrivatePhotoRepository: MemberPrivatePhotoRepository,
    private val s3Service: S3Service,
    private val s3Properties: S3Properties
) {

    @Transactional
    fun save(memberId: Long, request: MemberImageSaveRequest) {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        if (request.deleteIds.isNotEmpty()) {
            memberImageRepository.findAllByMemberIdAndIdIn(
                memberId,
                request.deleteIds
            ).forEach { it.delete() }
        }

        request.images.forEach {
            if (it.id == null && it.key != null) { // 새 이미지 등록
                val memberImage = MemberImage(
                    memberId = memberId,
                    url = s3Properties.endpoint + it.key,
                    key = it.key,
                    type = it.type,
                    sortOrder = it.sortOrder
                )
                memberImageRepository.save(memberImage)
            } else if (it.id != null) { // 기존 이미지 순서 변경
                val memberImage = (memberImageRepository.findByIdOrNull(it.id)
                    ?: throw CustomException("존재하지 않는 이미지입니다."))
                if (memberImage.memberId != memberId) {
                    throw CustomException("본인 이미지만 수정할 수 있습니다.")
                }

                memberImage.updateSortOrder(it.sortOrder)
            }
        }
    }

    @Transactional
    fun getPresignedUrl(
        memberId: Long,
        type: String
    ): PresignedUrlResponse {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        val imageType = MemberImageType.from(type).name.lowercase()
        val key = "members/$memberId/$imageType/${UUID.randomUUID()}.jpeg"
        return s3Service.createPresignedUrl(key)
    }

    @Transactional(readOnly = true)
    fun getPrivateImages(memberId: Long, targetId: Long): MemberGetPrivateImageResponse {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val target = (memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        if (!memberPrivatePhotoRepository.existsByOwnerAndTarget(target, member)) {
            throw CustomException("비밀 사진을 볼 수 없는 대상입니다.")
        }

        val responses = memberImageRepository.findAllByMemberIdAndTypeOrderBySortOrder(
            targetId,
            MemberImageType.PRIVATE
        ).map {
            MemberPrivateImageResponse(it.url)
        }
        return MemberGetPrivateImageResponse(responses)
    }
}