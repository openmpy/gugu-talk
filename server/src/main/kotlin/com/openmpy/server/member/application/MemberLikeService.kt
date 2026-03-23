package com.openmpy.server.member.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.domain.entity.MemberLike
import com.openmpy.server.member.dto.response.MemberLikeCountResponse
import com.openmpy.server.member.repository.MemberLikeRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MemberLikeService(

    private val memberLikeRepository: MemberLikeRepository,
    private val memberRepository: MemberRepository,
) {

    @Transactional
    fun add(likerId: Long, targetId: Long): MemberLikeCountResponse {
        if (likerId == targetId) throw CustomException("자기 자신에게 좋아요할 수 없습니다.")

        memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        if (memberLikeRepository.existsByLikerIdAndTargetId(likerId, targetId)) {
            throw CustomException("이미 좋아요한 회원입니다.")
        }

        val like = MemberLike(likerId = likerId, targetId = targetId)
        memberLikeRepository.save(like)

        val likes = memberLikeRepository.countByTargetId(targetId)
        return MemberLikeCountResponse(likes)
    }

    @Transactional
    fun cancel(likerId: Long, targetId: Long): MemberLikeCountResponse {
        val like = memberLikeRepository.findByLikerIdAndTargetId(likerId, targetId)
            ?: throw CustomException("좋아요 내역이 존재하지 않습니다.")

        memberLikeRepository.delete(like)

        val likes = memberLikeRepository.countByTargetId(targetId)
        return MemberLikeCountResponse(likes)
    }
}