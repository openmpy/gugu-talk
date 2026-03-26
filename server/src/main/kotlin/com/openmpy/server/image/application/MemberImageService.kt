package com.openmpy.server.image.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.image.domain.entity.MemberImage
import com.openmpy.server.image.dto.request.MemberImageSaveRequest
import com.openmpy.server.image.repository.MemberImageRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MemberImageService(

    private val memberImageRepository: MemberImageRepository,
    private val memberRepository: MemberRepository
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
                    url = "s3-url",
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
}