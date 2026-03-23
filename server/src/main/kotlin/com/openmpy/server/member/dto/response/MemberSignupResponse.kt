package com.openmpy.server.member.dto.response

data class MemberSignupResponse(

    val memberId: Long,
    val accessToken: String,
    val refreshToken: String,
)