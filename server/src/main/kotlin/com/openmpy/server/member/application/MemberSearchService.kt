package com.openmpy.server.member.application

import com.openmpy.server.common.dto.CompositeCursorResponse
import com.openmpy.server.member.dto.response.MemberSearchNicknameResponse
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.time.LocalDateTime

@Service
class MemberSearchService(

    private val memberRepository: MemberRepository,
) {

    @Transactional(readOnly = true)
    fun searchMembers(
        memberId: Long,
        nickname: String,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): CompositeCursorResponse<MemberSearchNicknameResponse> {
        val members = memberRepository.findByNicknameStartsWith(
            memberId,
            nickname,
            cursorId,
            cursorDateAt,
            limit + 1,
        )

        val hasNext = members.size > limit
        val data = members.dropLast(if (hasNext) 1 else 0)
        val nextCursorId = if (hasNext) data.last().id else null
        val nextCursorDateAt = if (hasNext) data.last().updatedAt else null

        val responses = data.map {
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

        return CompositeCursorResponse(
            responses,
            nextCursorId,
            nextCursorDateAt,
            hasNext
        )
    }
}