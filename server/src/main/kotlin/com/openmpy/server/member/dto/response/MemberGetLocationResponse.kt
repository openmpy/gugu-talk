package com.openmpy.server.member.dto.response

import com.openmpy.server.member.domain.type.Gender
import java.time.LocalDateTime

data class MemberGetLocationResponse(

    val memberId: Long,
    val thumbnail: String?,
    val nickname: String,
    val bio: String?,
    val gender: Gender,
    val age: Int,
    val likes: Long,
    val distance: Double?,
    val updatedAt: LocalDateTime,
)