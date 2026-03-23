package com.openmpy.server.member.application

import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.member.dto.response.MemberSearchNicknameResponse
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@Service
class MemberSearchService(

    private val memberRepository: MemberRepository,
) {

    @Transactional(readOnly = true)
    fun searchMembers(
        memberId: Long,
        nickname: String,
        cursorId: Long?,
        limit: Int
    ): CursorResponse<MemberSearchNicknameResponse> {
        val members = memberRepository.findByNicknameStartsWith(
            memberId,
            nickname,
            cursorId,
            limit + 1
        )
        val responses = members.map {
            MemberSearchNicknameResponse(
                it.id,
                null,
                it.nickname,
                it.gender,
                LocalDate.now().year - it.birthYear,
                it.likes,
                it.updatedAt,
            )
        }

        val hasNext = members.size > limit
        val nextCursorId = if (hasNext) members.last().id else null

        return CursorResponse(
            responses,
            nextCursorId,
            hasNext
        )
    }
}