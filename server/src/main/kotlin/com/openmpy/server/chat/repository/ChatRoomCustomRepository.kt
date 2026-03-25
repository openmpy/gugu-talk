package com.openmpy.server.chat.repository

import com.openmpy.server.chat.repository.dto.ChatRoomGetResult
import java.time.LocalDateTime

fun interface ChatRoomCustomRepository {

    fun findByMemberIdWithCursor(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult>
}