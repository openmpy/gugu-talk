package com.openmpy.server.member.application

import com.openmpy.server.auth.application.JwtService
import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.common.properties.JwtProperties
import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.dto.request.MemberLoginRequest
import com.openmpy.server.member.dto.request.MemberSetupRequest
import com.openmpy.server.member.dto.request.MemberSignupRequest
import com.openmpy.server.member.dto.response.MemberLoginResponse
import com.openmpy.server.member.dto.response.MemberSignupResponse
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.data.repository.findByIdOrNull
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
            throw CustomException("이미 인증 번호가 전송되었습니다.")
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

        if (redisTemplate.opsForValue().get(verificationKey) != request.verificationCode) {
            throw CustomException("인증 번호가 일치하지 않습니다.")
        }
        if (memberRepository.existsByPhone(request.phone)) {
            throw CustomException("이미 가입된 휴대폰 번호입니다.")
        }

        val member = Member(
            uuid = request.uuid,
            phone = request.phone,
            password = request.password,
            gender = request.gender
        )

        memberRepository.save(member)
        redisTemplate.delete(verificationKey)

        return MemberSignupResponse(
            member.id,
            jwtService.generateAccessToken(member.id),
            generateRefreshKey(member.id)
        )
    }

    @Transactional
    fun setup(
        memberId: Long,
        request: MemberSetupRequest
    ) {
        if (memberRepository.existsByNickname(request.nickname)) {
            throw CustomException("이미 가입된 닉네임입니다.")
        }

        val member = memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        member.setup(request.nickname, request.birthYear, request.bio)
    }

    @Transactional(readOnly = true)
    fun login(request: MemberLoginRequest): MemberLoginResponse {
        val member = memberRepository.findByPhone(request.phone)
            ?: throw CustomException("다시 한번 확인해주시길 바랍니다.")

        if (member.password != request.password) {
            throw CustomException("다시 한번 확인해주시길 바랍니다.")
        }

        return MemberLoginResponse(
            member.id,
            jwtService.generateAccessToken(member.id),
            generateRefreshKey(member.id)
        )
    }

    private fun generateVerificationCode(): String {
        return (10000..99999).random().toString()
    }

    private fun generateRefreshKey(memberId: Long): String {
        val refreshToken = jwtService.generateRefreshToken()
        val refreshTokenKey = REFRESH_TOKEN_KEY + refreshToken

        redisTemplate.opsForValue().set(
            refreshTokenKey,
            memberId.toString(),
            Duration.ofSeconds(jwtProperties.refreshTokenExpiration)
        )
        return refreshToken
    }
}