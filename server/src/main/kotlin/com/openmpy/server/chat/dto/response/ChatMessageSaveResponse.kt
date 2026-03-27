package com.openmpy.server.chat.dto.response

import com.openmpy.server.chat.domain.type.ChatMessageType
import java.time.LocalDateTime

data class ChatMessageSaveResponse(

    // 메시지 정보
    val chatMessageId: Long,
    val content: String,
    val type: ChatMessageType,
    val createdAt: LocalDateTime,

    // 보낸 사람 정보
    val senderId: Long,
    val thumbnail: String? = null,
    val nickname: String? = null,

    // 받는 사람 정보
    val receiverId: Long,
)
