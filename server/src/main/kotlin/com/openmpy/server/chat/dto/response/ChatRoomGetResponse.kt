package com.openmpy.server.chat.dto.response

import java.time.LocalDateTime

data class ChatRoomGetResponse(

    val chatRoomId: Long,
    val thumbnail: String?,
    val nickname: String,
    val lastMessage: String,
    val lastMessageAt: LocalDateTime,
)
