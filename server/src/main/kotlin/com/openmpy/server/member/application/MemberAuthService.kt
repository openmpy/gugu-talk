package com.openmpy.server.member.application

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.dto.request.MemberSetupRequest
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

    @Transactional
    fun setup(
        memberId: Long,
        request: MemberSetupRequest
    ) {
        check(!memberRepository.existsByNickname(request.nickname)) { "이미 가입된 닉네임입니다." }

        val member = memberRepository.findById(memberId)
            .orElseThrow { IllegalArgumentException("찾을 수 없는 회원 번호입니다.") }

        member.setup(request.nickname, request.birthYear, request.bio)
    }
}