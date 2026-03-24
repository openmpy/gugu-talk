package com.openmpy.server.chat.domain.entity

import com.openmpy.server.chat.domain.type.ChatMessageType
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "chat_message")
class ChatMessage(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val chatRoomId: Long,

    @Column(nullable = false)
    val senderId: Long,

    @Column(nullable = false, columnDefinition = "TEXT")
    val content: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var type: ChatMessageType = ChatMessageType.TEXT,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),
)