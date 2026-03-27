package com.openmpy.server.chat.dto.response

import java.time.LocalDateTime

data class ChatRoomCreateResponse(

    // 채팅방 정보
    val chatRoomId: Long,
    val unreadCount: Long,

    // 보낸 사람 정보
    val senderId: Long,
    val thumbnail: String?,
    val nickname: String,

    // 받는 사람 정보
    val receiverId: Long,

    // 채팅 정보
    val chatMessageId: Long,
    val lastMessage: String,
    val lastMessageAt: LocalDateTime,
)
