package com.openmpy.server.member.application

import com.openmpy.server.auth.application.JwtService
import com.openmpy.server.common.properties.JwtProperties
import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.dto.request.MemberSetupRequest
import com.openmpy.server.member.dto.request.MemberSignupRequest
import com.openmpy.server.member.dto.response.MemberSignupResponse
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Duration

private const val VERIFICATION_CODE_KEY = "auth:phone:"
private const val REFRESH_TOKEN_KEY = "auth:refresh_token:"

@Service
class MemberAuthService(

    private val memberRepository: MemberRepository,
    private val redisTemplate: StringRedisTemplate,
    private val jwtService: JwtService,
    private val jwtProperties: JwtProperties,
) {

    @Transactional
    fun sendVerificationCode(phone: String) {
        val key = VERIFICATION_CODE_KEY + phone

        redisTemplate.opsForValue().get(key)?.let {
            throw IllegalArgumentException("이미 인증 번호가 전송되었습니다.")
        }

        val verificationCode = generateVerificationCode()
        redisTemplate.opsForValue().set(key, verificationCode, Duration.ofMinutes(5))

        // 가입되어 있으면 보낸 척만 하고 SMS API 호출 X
        if (!memberRepository.existsByPhone(phone)) {
            // SMS API 호출
            println("인증번호: $verificationCode")
        }
    }

    @Transactional
    fun signup(request: MemberSignupRequest): MemberSignupResponse {
        val verificationKey = VERIFICATION_CODE_KEY + request.phone

        check(redisTemplate.opsForValue().get(verificationKey) == request.verificationCode)
        { "인증 번호가 일치하지 않습니다." }
        check(!memberRepository.existsByPhone(request.phone))
        { "이미 가입된 휴대폰 번호입니다." }

        val member = Member(
            uuid = request.uuid,
            phone = request.phone,
            password = request.password,
            gender = request.gender
        )

        memberRepository.save(member)
        redisTemplate.delete(verificationKey)

        val refreshToken = jwtService.generateRefreshToken()
        val refreshTokenKey = REFRESH_TOKEN_KEY + refreshToken

        redisTemplate.opsForValue().set(
            refreshTokenKey,
            member.id.toString(),
            Duration.ofSeconds(jwtProperties.refreshTokenExpiration)
        )
        return MemberSignupResponse(
            member.id,
            jwtService.generateAccessToken(member.id),
            refreshToken
        )
    }

    @Transactional
    fun setup(
        memberId: Long,
        request: MemberSetupRequest
    ) {
        check(!memberRepository.existsByNickname(request.nickname))
        { "이미 가입된 닉네임입니다." }

        val member = memberRepository.findById(memberId)
            .orElseThrow { IllegalArgumentException("찾을 수 없는 회원 번호입니다.") }

        member.setup(request.nickname, request.birthYear, request.bio)
    }

    private fun generateVerificationCode(): String {
        return (10000..99999).random().toString()
    }
}