package com.openmpy.server.image.dto.response

data class MemberGetPrivateImageResponse(

    val images: List<MemberPrivateImageResponse>,
)

data class MemberPrivateImageResponse(

    val url: String,
)
