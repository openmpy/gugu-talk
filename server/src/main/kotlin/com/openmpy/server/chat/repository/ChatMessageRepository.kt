package com.openmpy.server.chat.repository

import com.openmpy.server.chat.domain.entity.ChatMessage
import org.springframework.data.jpa.repository.JpaRepository

interface ChatMessageRepository : JpaRepository<ChatMessage, Long>