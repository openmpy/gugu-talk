package com.openmpy.server.member.dto.request

import com.openmpy.server.member.domain.type.Gender

data class MemberSignupRequest(

    val uuid: String,
    val phone: String,
    val password: String,
    val gender: Gender,
)
