package com.openmpy.server.member.dto.response

data class MemberLoginResponse(

    val memberId: Long,
    val accessToken: String,
    val refreshToken: String,
)