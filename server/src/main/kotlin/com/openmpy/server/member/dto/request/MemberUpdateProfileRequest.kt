package com.openmpy.server.member.dto.request

data class MemberUpdateProfileRequest(

    val nickname: String,
    val birthYear: Int,
    val bio: String?
)
