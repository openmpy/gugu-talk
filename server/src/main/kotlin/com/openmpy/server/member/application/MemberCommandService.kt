package com.openmpy.server.member.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.dto.request.MemberUpdateCommentRequest
import com.openmpy.server.member.dto.request.MemberUpdateLocationRequest
import com.openmpy.server.member.dto.request.MemberUpdateProfileRequest
import com.openmpy.server.member.dto.response.MemberGetChatEnabledResponse
import com.openmpy.server.member.repository.MemberRepository
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
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

    @Transactional
    fun updateLocation(memberId: Long, request: MemberUpdateLocationRequest) {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        val point = request.longitude?.let { longitude ->
            request.latitude?.let { latitude ->
                GeometryFactory().createPoint(Coordinate(longitude, latitude))
            }
        }

        member.updateLocation(point)
    }

    @Transactional
    fun toggleChatEnabled(memberId: Long): MemberGetChatEnabledResponse {
        val member = memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        member.isChatEnabled = !member.isChatEnabled
        return MemberGetChatEnabledResponse(member.isChatEnabled)
    }

    @Transactional
    fun updateProfile(memberId: Long, request: MemberUpdateProfileRequest) {
        val member = memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        if (memberRepository.existsByNicknameAndIdNot(request.nickname, memberId)) {
            throw CustomException("이미 사용중인 닉네임입니다.")
        }

        member.updateProfile(request.nickname, request.birthYear, request.bio)
    }
}