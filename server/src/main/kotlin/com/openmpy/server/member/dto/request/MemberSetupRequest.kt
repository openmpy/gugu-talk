package com.openmpy.server.member.dto.request

data class MemberSetupRequest(

    val nickname: String,
    val birthYear: Int,
    val bio: String,
)
