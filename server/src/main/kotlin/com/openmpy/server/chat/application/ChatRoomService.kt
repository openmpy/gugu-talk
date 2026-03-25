package com.openmpy.server.chat.application

import com.openmpy.server.chat.domain.entity.ChatMessage
import com.openmpy.server.chat.domain.entity.ChatRoom
import com.openmpy.server.chat.dto.request.ChatRoomCreateRequest
import com.openmpy.server.chat.dto.response.ChatRoomGetResponse
import com.openmpy.server.chat.repository.ChatMessageRepository
import com.openmpy.server.chat.repository.ChatRoomRepository
import com.openmpy.server.common.dto.CompositeCursorResponse
import com.openmpy.server.common.exception.CustomException
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime
import kotlin.math.max
import kotlin.math.min

@Service
class ChatRoomService(

    private val chatRoomRepository: ChatRoomRepository,
    private val chatMessageRepository: ChatMessageRepository
) {

    @Transactional
    fun create(
        memberId: Long,
        targetId: Long,
        request: ChatRoomCreateRequest
    ) {
        val minId = min(memberId, targetId)
        val maxId = max(memberId, targetId)
        val chatRoom = chatRoomRepository.findByMember1IdAndMember2Id(minId, maxId)
            ?: run {
                val newRoom = ChatRoom(
                    member1Id = minId,
                    member2Id = maxId,
                )
                chatRoomRepository.save(newRoom)
            }
        val message = ChatMessage(
            chatRoomId = chatRoom.id,
            senderId = memberId,
            content = request.content
        )

        chatMessageRepository.save(message)
        chatRoom.updateLastRead(memberId, message.id)
        chatRoom.updateLastMessage(message.content)
    }

    @Transactional
    fun delete(memberId: Long, chatRoomId: Long) {
        val chatRoom = (chatRoomRepository.findByIdOrNull(chatRoomId)
            ?: throw CustomException("존재하지 않는 채팅방입니다."))

        if (chatRoom.member1Id != memberId && chatRoom.member2Id != memberId) {
            throw CustomException("참여하지 않은 채팅방입니다.")
        }

        chatRoom.delete()
    }

    @Transactional(readOnly = true)
    fun gets(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): CompositeCursorResponse<ChatRoomGetResponse> {
        val results = chatRoomRepository.findByMemberIdWithCursor(
            memberId,
            cursorId,
            cursorDateAt,
            limit + 1
        )

        val hasNext = results.size > limit
        val data = results.dropLast(if (hasNext) 1 else 0)
        val nextCursorId = if (hasNext) data.last().id else null
        val nextCursorDateAt = if (hasNext) data.last().lastMessageAt else null

        val responses = data.map {
            ChatRoomGetResponse(
                it.id,
                null,
                it.nickname,
                it.lastMessage,
                it.lastMessageAt,
            )
        }

        return CompositeCursorResponse(
            responses,
            nextCursorId,
            nextCursorDateAt,
            hasNext
        )
    }
}