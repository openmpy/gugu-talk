package com.openmpy.server.member.dto.response

import com.openmpy.server.member.domain.type.Gender

data class MemberSettingResponse(

    val id: Long,
    val memberId: Long,
    val thumbnail: String?,
    val nickname: String,
    val gender: Gender,
    val age: Int
)
