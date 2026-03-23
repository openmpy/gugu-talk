package com.openmpy.server.member.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.domain.entity.MemberBlock
import com.openmpy.server.member.repository.MemberBlockRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MemberBlockService(

    private val memberBlockRepository: MemberBlockRepository,
    private val memberRepository: MemberRepository,
) {

    @Transactional
    fun add(blockerId: Long, blockedId: Long) {
        if (blockerId == blockedId) throw CustomException("자기 자신을 차단할 수 없습니다.")

        val blocker = (memberRepository.findByIdOrNull(blockerId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val blocked = (memberRepository.findByIdOrNull(blockedId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        if (memberBlockRepository.existsByBlockerAndBlocked(blocker, blocked)) {
            throw CustomException("이미 차단한 회원입니다.")
        }

        val memberBlock = MemberBlock(
            blocker = blocker,
            blocked = blocked
        )
        memberBlockRepository.save(memberBlock)
    }

    @Transactional
    fun remove(blockerId: Long, blockedId: Long) {
        val blocker = (memberRepository.findByIdOrNull(blockerId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val blocked = (memberRepository.findByIdOrNull(blockedId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val block = memberBlockRepository.findByBlockerAndBlocked(blocker, blocked)
            ?: throw CustomException("차단 내역이 존재하지 않습니다.")

        memberBlockRepository.delete(block)
    }
}