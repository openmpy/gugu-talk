package com.openmpy.server.member.presentation

import com.openmpy.server.member.application.MemberAuthService
import com.openmpy.server.member.dto.request.MemberSignupRequest
import com.openmpy.server.member.dto.response.MemberSignupResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api")
@RestController
class MemberAuthController(

    private val memberAuthService: MemberAuthService
) {

    @PostMapping("/v1/members/signup")
    fun signup(
        @RequestBody request: MemberSignupRequest
    ): ResponseEntity<MemberSignupResponse> {
        val response = memberAuthService.signup(request)

        return ResponseEntity.ok(response)
    }
}