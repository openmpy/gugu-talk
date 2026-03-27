package com.openmpy.server.chat.dto.response

data class ChatRoomGetMemberResponse(

    val memberId: Long,
    val nickname: String,
    val thumbnail: String?,
)
