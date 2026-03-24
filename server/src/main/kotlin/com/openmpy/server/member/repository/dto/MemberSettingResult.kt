package com.openmpy.server.member.repository.dto

import com.openmpy.server.member.domain.type.Gender

data class MemberSettingResult(

    val id: Long,
    val memberId: Long,
    val nickname: String,
    val gender: Gender,
    val birthYear: Int
)