package com.openmpy.server.chat.dto.response

import com.fasterxml.jackson.annotation.JsonFormat
import java.time.LocalDateTime

data class ChatRoomGetResponse(

    val chatRoomId: Long,
    val thumbnail: String?,
    val nickname: String,
    val lastMessage: String,

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
    val lastMessageAt: LocalDateTime,
)
