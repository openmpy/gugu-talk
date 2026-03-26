package com.openmpy.server.member.dto.response

import com.openmpy.server.member.domain.type.Gender
import java.time.LocalDateTime

data class MemberGetResponse(

    val memberId: Long,
    val images: List<MemberPublicImageResponse>,
    val nickname: String,
    val gender: Gender,
    val age: Int,
    val likes: Long,
    val distance: Double?,
    val bio: String?,
    val isChatEnabled: Boolean,
    val updatedAt: LocalDateTime,
    val isLike: Boolean,
    val isPrivatePhoto: Boolean,
    val isOpenPrivatePhoto: Boolean,
    val isBlock: Boolean,
)

data class MemberPublicImageResponse(

    val url: String,
)
