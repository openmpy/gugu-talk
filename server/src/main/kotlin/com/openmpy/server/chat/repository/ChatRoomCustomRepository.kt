package com.openmpy.server.chat.repository

import com.openmpy.server.chat.repository.dto.ChatRoomGetResult
import java.time.LocalDateTime

interface ChatRoomCustomRepository {

    fun findByMemberIdWithCursor(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult>

    fun findUnreadChatRoomsByMemberId(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult>

    fun findByMemberIdWithCursorAndNickname(
        memberId: Long,
        keyword: String,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult>
}