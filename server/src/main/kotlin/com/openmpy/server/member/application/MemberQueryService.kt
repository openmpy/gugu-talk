package com.openmpy.server.member.application

import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.dto.response.MemberGetCommentResponse
import com.openmpy.server.member.dto.response.MemberGetLocationResponse
import com.openmpy.server.member.dto.response.MemberGetResponse
import com.openmpy.server.member.repository.MemberBlockRepository
import com.openmpy.server.member.repository.MemberLikeRepository
import com.openmpy.server.member.repository.MemberPrivatePhotoRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@Service
class MemberQueryService(

    private val memberRepository: MemberRepository,
    private val memberLikeRepository: MemberLikeRepository,
    private val memberPrivatePhotoRepository: MemberPrivatePhotoRepository,
    private val memberBlockRepository: MemberBlockRepository,
) {

    @Transactional(readOnly = true)
    fun getComments(
        memberId: Long,
        gender: String,
        cursorId: Long?,
        limit: Int
    ): CursorResponse<MemberGetCommentResponse> {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        val resolvedGender = if (gender != "MALE" && gender != "FEMALE") null else gender
        val comments = memberRepository.findAllComments(
            memberId,
            member.location,
            resolvedGender,
            cursorId,
            limit + 1
        )

        val hasNext = comments.size > limit
        val data = comments.dropLast(if (hasNext) 1 else 0)
        val nextCursorId = if (hasNext) data.last().id else null

        val responses = data.map {
            MemberGetCommentResponse(
                it.id,
                null,
                it.nickname,
                it.comment!!,
                it.gender,
                LocalDate.now().year - it.birthYear,
                it.likes,
                it.distance,
                it.updatedAt
            )
        }

        return CursorResponse(
            responses,
            nextCursorId,
            hasNext
        )
    }

    @Transactional(readOnly = true)
    fun getLocations(
        memberId: Long,
        gender: String,
        cursorId: Long?,
        limit: Int
    ): CursorResponse<MemberGetLocationResponse> {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        if (member.location == null) {
            throw CustomException("잘못된 위치 값입니다.")
        }

        val resolvedGender = if (gender != "MALE" && gender != "FEMALE") null else gender
        val locations = memberRepository.findAllLocations(
            memberId,
            member.location,
            resolvedGender,
            cursorId,
            limit + 1
        )

        val hasNext = locations.size > limit
        val data = locations.dropLast(if (hasNext) 1 else 0)
        val nextCursorId = if (hasNext) data.last().id else null

        val responses = data.map {
            MemberGetLocationResponse(
                it.id,
                null,
                it.nickname,
                it.bio,
                it.gender,
                LocalDate.now().year - it.birthYear,
                it.likes,
                it.distance,
                it.updatedAt
            )
        }

        return CursorResponse(
            responses,
            nextCursorId,
            hasNext
        )
    }

    @Transactional(readOnly = true)
    fun get(memberId: Long, targetId: Long): MemberGetResponse {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val target = (memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        return MemberGetResponse(
            target.id,
            target.nickname,
            target.gender,
            LocalDate.now().year - target.birthYear,
            target.likes,
            memberRepository.getDistanceByMember(target.id, member.location),
            target.bio,
            target.updatedAt,
            memberLikeRepository.existsByLikerIdAndTargetId(member.id, target.id),
            memberPrivatePhotoRepository.existsByOwnerAndTarget(target, member),
            memberPrivatePhotoRepository.existsByOwnerAndTarget(member, target),
            memberBlockRepository.existsByBlockerAndBlocked(member, target)
        )
    }
}