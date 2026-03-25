package com.openmpy.server.chat.dto.request

import com.openmpy.server.chat.domain.type.ChatMessageType

data class ChatMessageSendRequest(

    val content: String,
    val type: ChatMessageType,
)
