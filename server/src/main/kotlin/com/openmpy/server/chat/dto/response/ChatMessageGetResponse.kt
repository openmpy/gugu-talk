package com.openmpy.server.chat.dto.response

import com.openmpy.server.chat.domain.type.ChatMessageType
import java.time.LocalDateTime

data class ChatMessageGetResponse(

    val chatMessageId: Long,
    val senderId: Long,
    val receiverId: Long,
    val content: String,
    val type: ChatMessageType,
    val createdAt: LocalDateTime,
)
