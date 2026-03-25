package com.openmpy.server.chat.repository.dto

import java.time.LocalDateTime

data class ChatRoomGetResult(

    val id: Long,
    val nickname: String,
    val lastMessage: String,
    val lastMessageAt: LocalDateTime,
)