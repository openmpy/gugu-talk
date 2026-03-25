package com.openmpy.server.chat.dto.event

data class ChatRoomDeleteEvent(

    val type: String = "CHAT_ROOM_DELETE",
    val chatRoomId: Long,
)
