package com.openmpy.server.member.presentation

import com.openmpy.server.member.application.MemberAuthService
import com.openmpy.server.member.dto.request.MemberSetupRequest
import com.openmpy.server.member.dto.request.MemberSignupRequest
import com.openmpy.server.member.dto.response.MemberSignupResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class MemberAuthController(

    private val memberAuthService: MemberAuthService
) {

    @PostMapping("/v1/members/send-verification-code")
    fun sendVerificationCode(
        @RequestParam(value = "phone", required = true) phone: String
    ): ResponseEntity<Unit> {
        memberAuthService.sendVerificationCode(phone)
        return ResponseEntity.noContent().build()
    }

    @PostMapping("/v1/members/signup")
    fun signup(
        @RequestBody request: MemberSignupRequest
    ): ResponseEntity<MemberSignupResponse> {
        val response = memberAuthService.signup(request)
        return ResponseEntity.ok(response)
    }

    @PutMapping("/v1/members/setup")
    fun setup(
        @RequestBody request: MemberSetupRequest
    ): ResponseEntity<Unit> {
        memberAuthService.setup(1L, request)
        return ResponseEntity.noContent().build()
    }
}