package com.openmpy.server.chat.repository.impl

import com.openmpy.server.chat.domain.type.ChatRoomStatus
import com.openmpy.server.chat.repository.ChatRoomCustomRepository
import com.openmpy.server.chat.repository.dto.ChatRoomGetResult
import jakarta.persistence.EntityManager
import org.springframework.stereotype.Repository
import java.time.LocalDateTime

@Repository
class ChatRoomCustomRepositoryImpl(
    private val entityManager: EntityManager
) : ChatRoomCustomRepository {

    override fun findByMemberIdWithCursor(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult> {
        val jpql = buildString {
            append(
                """
                    SELECT new com.openmpy.server.chat.repository.dto.ChatRoomGetResult(
                        cr.id,
                        CASE WHEN cr.member1Id = :memberId THEN m2.id ELSE m1.id END,
                        CASE WHEN cr.member1Id = :memberId THEN m2.nickname ELSE m1.nickname END,
                        cr.lastMessage,
                        cr.lastMessageAt,
                        (SELECT COUNT(cm.id) FROM ChatMessage cm
                        WHERE cm.chatRoomId = cr.id
                            AND cm.id > COALESCE(
                                CASE WHEN cr.member1Id = :memberId 
                                    THEN cr.member1LastReadMessageId 
                                    ELSE cr.member2LastReadMessageId END,
                                0L
                            )
                        )
                    )
                    FROM ChatRoom cr
                    JOIN Member m1 ON m1.id = cr.member1Id
                    JOIN Member m2 ON m2.id = cr.member2Id
                    WHERE (cr.member1Id = :memberId OR cr.member2Id = :memberId)
                        AND cr.status = :status
                """.trimIndent()
            )
            if (cursorDateAt != null && cursorId != null) {
                append(" AND (cr.lastMessageAt < :cursorDateAt")
                append(" OR (cr.lastMessageAt = :cursorDateAt AND cr.id < :cursorId))")
            }
            append(" ORDER BY cr.lastMessageAt DESC, cr.id DESC")
        }
        return entityManager.createQuery(jpql, ChatRoomGetResult::class.java).apply {
            setParameter("memberId", memberId)
            setParameter("status", ChatRoomStatus.ACTIVE)

            if (cursorDateAt != null && cursorId != null) {
                setParameter("cursorDateAt", cursorDateAt)
                setParameter("cursorId", cursorId)
            }
            maxResults = limit
        }.resultList
    }

    override fun findUnreadChatRoomsByMemberId(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult> {
        val jpql = buildString {
            append(
                """
                    SELECT new com.openmpy.server.chat.repository.dto.ChatRoomGetResult(
                        cr.id,
                        CASE WHEN cr.member1Id = :memberId THEN m2.id ELSE m1.id END,
                        CASE WHEN cr.member1Id = :memberId THEN m2.nickname ELSE m1.nickname END,
                        cr.lastMessage,
                        cr.lastMessageAt,
                        (SELECT COUNT(cm.id) FROM ChatMessage cm
                        WHERE cm.chatRoomId = cr.id
                            AND cm.id > COALESCE(
                                CASE WHEN cr.member1Id = :memberId 
                                    THEN cr.member1LastReadMessageId 
                                    ELSE cr.member2LastReadMessageId END,
                                0L
                            )
                        )
                    )
                    FROM ChatRoom cr
                    JOIN Member m1 ON m1.id = cr.member1Id
                    JOIN Member m2 ON m2.id = cr.member2Id
                    WHERE (cr.member1Id = :memberId OR cr.member2Id = :memberId)
                        AND cr.status = :status
                        AND EXISTS (
                            SELECT 1 FROM ChatMessage cm
                            WHERE cm.chatRoomId = cr.id
                            AND cm.id > COALESCE(
                                CASE WHEN cr.member1Id = :memberId 
                                    THEN cr.member1LastReadMessageId 
                                    ELSE cr.member2LastReadMessageId END,
                                0L
                            )
                        )
                """.trimIndent()
            )
            if (cursorDateAt != null && cursorId != null) {
                append(" AND (cr.lastMessageAt < :cursorDateAt")
                append(" OR (cr.lastMessageAt = :cursorDateAt AND cr.id < :cursorId))")
            }
            append(" ORDER BY cr.lastMessageAt DESC, cr.id DESC")
        }
        return entityManager.createQuery(jpql, ChatRoomGetResult::class.java).apply {
            setParameter("memberId", memberId)
            setParameter("status", ChatRoomStatus.ACTIVE)
            if (cursorDateAt != null && cursorId != null) {
                setParameter("cursorDateAt", cursorDateAt)
                setParameter("cursorId", cursorId)
            }
            maxResults = limit
        }.resultList
    }

    override fun findByMemberIdWithCursorAndNickname(
        memberId: Long,
        keyword: String,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): List<ChatRoomGetResult> {
        val jpql = buildString {
            append(
                """
                    SELECT new com.openmpy.server.chat.repository.dto.ChatRoomGetResult(
                        cr.id,
                        CASE WHEN cr.member1Id = :memberId THEN m2.id ELSE m1.id END,
                        CASE WHEN cr.member1Id = :memberId THEN m2.nickname ELSE m1.nickname END,
                        cr.lastMessage,
                        cr.lastMessageAt,
                        (SELECT COUNT(cm.id) FROM ChatMessage cm
                        WHERE cm.chatRoomId = cr.id
                            AND cm.id > COALESCE(
                                CASE WHEN cr.member1Id = :memberId 
                                    THEN cr.member1LastReadMessageId 
                                    ELSE cr.member2LastReadMessageId END,
                                0L
                            )
                        )
                    )
                    FROM ChatRoom cr
                    JOIN Member m1 ON m1.id = cr.member1Id
                    JOIN Member m2 ON m2.id = cr.member2Id
                    WHERE (cr.member1Id = :memberId OR cr.member2Id = :memberId)
                    AND cr.status = :status
                    AND (
                        (cr.member1Id = :memberId AND m2.nickname LIKE :keyword)
                        OR (cr.member2Id = :memberId AND m1.nickname LIKE :keyword)
                    )
                """.trimIndent()
            )
            if (cursorDateAt != null && cursorId != null) {
                append(" AND (cr.lastMessageAt < :cursorDateAt")
                append(" OR (cr.lastMessageAt = :cursorDateAt AND cr.id < :cursorId))")
            }
            append(" ORDER BY cr.lastMessageAt DESC, cr.id DESC")
        }
        return entityManager.createQuery(jpql, ChatRoomGetResult::class.java).apply {
            setParameter("memberId", memberId)
            setParameter("status", ChatRoomStatus.ACTIVE)
            setParameter("keyword", "$keyword%")

            if (cursorDateAt != null && cursorId != null) {
                setParameter("cursorDateAt", cursorDateAt)
                setParameter("cursorId", cursorId)
            }
            maxResults = limit
        }.resultList
    }
}