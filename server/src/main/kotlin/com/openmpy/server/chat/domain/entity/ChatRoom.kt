package com.openmpy.server.chat.domain.entity

import com.openmpy.server.chat.domain.type.ChatRoomStatus
import com.openmpy.server.common.exception.CustomException
import jakarta.persistence.*
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@Entity
@SQLRestriction("status = 'ACTIVE'")
@Table(name = "chat_room")
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
        this.lastMessage = if (content.length <= 70) content else content.substring(0, 67) + "..."
        this.lastMessageAt = LocalDateTime.now()
    }

    fun updateLastRead(memberId: Long, messageId: Long) {
        if (this.member1Id == memberId) this.member1LastReadMessageId = messageId else {
            this.member2LastReadMessageId = messageId
        }
    }

    fun delete() {
        if (this.status == ChatRoomStatus.DELETED) {
            throw CustomException("이미 삭제된 채팅방입니다.")
        }

        this.status = ChatRoomStatus.DELETED
        this.deletedAt = LocalDateTime.now()
    }
}