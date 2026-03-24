package com.openmpy.server.chat.repository

import com.openmpy.server.chat.domain.entity.ChatRoom
import org.springframework.data.jpa.repository.JpaRepository

interface ChatRoomRepository : JpaRepository<ChatRoom, Long>