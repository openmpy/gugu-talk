package com.openmpy.server.image.dto.request

import com.openmpy.server.image.domain.type.MemberImageType

data class MemberImageSaveRequest(

    val images: List<ImageItemRequest>,
    val deleteIds: List<Long>,
)

data class ImageItemRequest(

    val id: Long?,
    val key: String?,
    val type: MemberImageType,
    val sortOrder: Int
)