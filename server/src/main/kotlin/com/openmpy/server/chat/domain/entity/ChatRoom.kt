package com.openmpy.server.chat.domain.entity

import com.openmpy.server.chat.domain.type.ChatRoomStatus
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(
    name = "chat_room",
    uniqueConstraints = [UniqueConstraint(columnNames = ["member1_id", "member2_id"])]
)
class ChatRoom(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val member1Id: Long,

    @Column(nullable = false)
    val member2Id: Long,

    @Column
    var lastMessage: String? = null,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var status: ChatRoomStatus = ChatRoomStatus.ACTIVE,

    @Column
    var member1LastReadMessageId: Long? = null,

    @Column
    var member2LastReadMessageId: Long? = null,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column
    var lastMessageAt: LocalDateTime? = null,

    @Column
    var deletedAt: LocalDateTime? = null,
) {

    fun updateLastMessage(content: String) {
        this.lastMessage = content
        this.lastMessageAt = LocalDateTime.now()
    }

    fun updateLastRead(memberId: Long, messageId: Long) {
        if (this.member1Id == memberId) this.member1LastReadMessageId = messageId else {
            this.member2LastReadMessageId = messageId
        }
    }
}