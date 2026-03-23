package com.openmpy.server.member.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.dto.request.MemberUpdateCommentRequest
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MemberCommandService(

    private val memberRepository: MemberRepository,
) {

    @Transactional
    fun updateComment(memberId: Long, request: MemberUpdateCommentRequest) {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        member.updateComment(request.comment)
    }

    @Transactional
    fun bumpComment(memberId: Long) {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        member.bumpComment()
    }
}