package com.openmpy.server.chat.dto.event

import java.time.LocalDateTime

data class ChatRoomUpdateEvent(

    val type: String = "CHAT_ROOM_UPDATE",
    val chatRoomId: Long,
    val lastMessage: String,
    val lastMessageAt: LocalDateTime,
)
