package com.openmpy.server.member.application

import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.domain.entity.MemberLike
import com.openmpy.server.member.dto.response.MemberLikeCountResponse
import com.openmpy.server.member.dto.response.MemberSettingResponse
import com.openmpy.server.member.repository.MemberLikeRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@Service
class MemberLikeService(

    private val memberLikeRepository: MemberLikeRepository,
    private val memberRepository: MemberRepository,
) {

    @Transactional
    fun add(likerId: Long, targetId: Long): MemberLikeCountResponse {
        if (likerId == targetId) throw CustomException("자기 자신에게 좋아요할 수 없습니다.")

        val target = (memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        if (memberLikeRepository.existsByLikerIdAndTargetId(likerId, targetId)) {
            throw CustomException("이미 좋아요한 회원입니다.")
        }

        val like = MemberLike(likerId = likerId, targetId = targetId)
        memberLikeRepository.save(like)
        target.increaseLike()

        return MemberLikeCountResponse(target.likes)
    }

    @Transactional
    fun cancel(likerId: Long, targetId: Long): MemberLikeCountResponse {
        val target = (memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val like = memberLikeRepository.findByLikerIdAndTargetId(likerId, targetId)
            ?: throw CustomException("좋아요 내역이 존재하지 않습니다.")

        memberLikeRepository.delete(like)
        target.decreaseLike()

        return MemberLikeCountResponse(target.likes)
    }

    @Transactional(readOnly = true)
    fun gets(memberId: Long, cursorId: Long?, limit: Int): CursorResponse<MemberSettingResponse> {
        val projections = memberLikeRepository.findByLikerIdWithCursor(
            memberId,
            cursorId,
            limit + 1
        )

        val hasNext = projections.size > limit
        val data = projections.dropLast(if (hasNext) 1 else 0)
        val nextCursorId = if (hasNext) data.last().id else null

        val responses = data.map {
            MemberSettingResponse(
                it.id,
                it.memberId,
                null,
                it.nickname,
                it.gender,
                LocalDate.now().year - it.birthYear
            )
        }

        return CursorResponse(
            responses,
            nextCursorId,
            hasNext
        )
    }
}