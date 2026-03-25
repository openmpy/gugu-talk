package com.openmpy.server.chat.dto.event

import java.time.LocalDateTime

data class ChatRoomUpdateEvent(

    val type: String = "CHAT_ROOM_UPDATE",
    val chatRoomId: Long,
    val memberId: Long? = null,
    val thumbnail: String? = null,
    val nickname: String? = null,
    val lastMessage: String,
    val lastMessageAt: LocalDateTime,
    val unreadCount: Long? = null,
)
