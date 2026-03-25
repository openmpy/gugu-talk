package com.openmpy.server.chat.dto.event

import java.time.LocalDateTime

data class ChatRoomNewEvent(

    val type: String = "CHAT_ROOM_NEW",
    val chatRoomId: Long,
    val memberId: Long,
    val thumbnail: String?,
    val nickname: String,
    val lastMessage: String,
    val lastMessageAt: LocalDateTime,
)
