package com.openmpy.server.chat.repository

import com.openmpy.server.chat.domain.entity.ChatMessage
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface ChatMessageRepository : JpaRepository<ChatMessage, Long> {

    @Query(
        value = """
        SELECT m 
        FROM ChatMessage m 
        WHERE m.chatRoomId = :chatRoomId 
          AND (:cursorId IS NULL OR m.id < :cursorId) 
        ORDER BY m.id DESC
        """
    )
    fun findByChatRoomIdWithCursor(
        @Param("chatRoomId") chatRoomId: Long,
        @Param("cursorId") cursorId: Long?,
        pageable: Pageable
    ): List<ChatMessage>
}