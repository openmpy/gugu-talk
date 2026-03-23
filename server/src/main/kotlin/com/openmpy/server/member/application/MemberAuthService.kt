package com.openmpy.server.member.application

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.dto.request.MemberSignupRequest
import com.openmpy.server.member.dto.response.MemberSignupResponse
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MemberAuthService(

    private val memberRepository: MemberRepository,
) {

    @Transactional
    fun signup(request: MemberSignupRequest): MemberSignupResponse {
        check(!memberRepository.existsByPhone(request.phone)) { "이미 가입된 휴대폰 번호입니다." }

        val member = Member(
            uuid = request.uuid,
            phone = request.phone,
            password = request.password,
            gender = request.gender
        )
        memberRepository.save(member)

        return MemberSignupResponse(
            member.id,
            "access-token",
            "refresh-token"
        )
    }
}