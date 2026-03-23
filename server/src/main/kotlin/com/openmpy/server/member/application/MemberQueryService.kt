package com.openmpy.server.member.application

import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.member.dto.response.MemberGetCommentResponse
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@Service
class MemberQueryService(

    private val memberRepository: MemberRepository,
) {

    @Transactional(readOnly = true)
    fun getComments(
        memberId: Long,
        gender: String,
        cursorId: Long?,
        limit: Int
    ): CursorResponse<MemberGetCommentResponse> {
        val resolvedGender = if (gender != "MALE" && gender != "FEMALE") null else gender
        val comments = memberRepository.findAllComments(
            memberId,
            resolvedGender,
            cursorId,
            limit + 1
        )
        val responses = comments.map {
            MemberGetCommentResponse(
                it.id,
                null,
                it.nickname,
                it.comment!!,
                it.gender,
                LocalDate.now().year - it.birthYear,
                it.likes,
                null,
                it.createdAt
            )
        }

        val hasNext = comments.size > limit
        val nextCursorId = if (hasNext) comments.last().id else null

        return CursorResponse(
            responses,
            nextCursorId,
            hasNext
        )
    }
}