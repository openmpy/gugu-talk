package com.openmpy.server.member.repository.projection

import com.openmpy.server.member.domain.type.Gender

data class MemberSettingProjection(

    val id: Long,
    val memberId: Long,
    val nickname: String,
    val gender: Gender,
    val birthYear: Int
)
