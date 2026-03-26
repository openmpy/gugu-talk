package com.openmpy.server.member.dto.response

import com.openmpy.server.image.domain.type.MemberImageType

data class MemberGetMyResponse(

    val memberId: Long,
    val publicImages: List<MemberGetImageResponse>,
    val privateImages: List<MemberGetImageResponse>,
    val nickname: String,
    val birthYear: Int,
    val bio: String?,
)

data class MemberGetImageResponse(

    val imageId: Long,
    val url: String,
    val key: String,
    val type: MemberImageType,
    val sortOrder: Int
)