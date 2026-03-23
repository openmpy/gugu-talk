package com.openmpy.server.member.dto.response

import com.openmpy.server.member.domain.type.Gender
import java.time.LocalDateTime

data class MemberGetResponse(

    val memberId: Long,
    val nickname: String,
    val gender: Gender,
    val age: Int,
    val likes: Long,
    val distance: Double?,
    val bio: String?,
    val updatedAt: LocalDateTime,
    val isLike: Boolean,
    val isPrivatePhoto: Boolean,
    val isBlock: Boolean,
)
