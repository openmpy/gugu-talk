package com.openmpy.server.chat.application

import com.openmpy.server.chat.domain.entity.ChatMessage
import com.openmpy.server.chat.domain.entity.ChatRoom
import com.openmpy.server.chat.dto.request.ChatRoomCreateRequest
import com.openmpy.server.chat.dto.response.ChatMessageGetResponse
import com.openmpy.server.chat.dto.response.ChatRoomCreateResponse
import com.openmpy.server.chat.dto.response.ChatRoomGetResponse
import com.openmpy.server.chat.repository.ChatMessageRepository
import com.openmpy.server.chat.repository.ChatRoomRepository
import com.openmpy.server.common.dto.CompositeCursorResponse
import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.image.domain.type.MemberImageType
import com.openmpy.server.image.repository.MemberImageRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.domain.PageRequest
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime
import kotlin.math.max
import kotlin.math.min

@Service
class ChatRoomService(

    private val chatRoomRepository: ChatRoomRepository,
    private val chatMessageRepository: ChatMessageRepository,
    private val memberRepository: MemberRepository,
    private val memberImageRepository: MemberImageRepository,
) {

    @Transactional
    fun create(
        memberId: Long,
        targetId: Long,
        request: ChatRoomCreateRequest
    ): ChatRoomCreateResponse {
        val member = (memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

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

        return ChatRoomCreateResponse(
            chatRoomId = chatRoom.id,
            unreadCount = 1,
            senderId = memberId,
            thumbnail = memberImageRepository.findFirstByMemberIdAndTypeOrderBySortOrder(
                memberId,
                MemberImageType.PUBLIC
            )?.url,
            nickname = member.nickname,
            receiverId = targetId,
            chatMessageId = message.id,
            lastMessage = message.content,
            lastMessageAt = message.createdAt,
        )
    }

    @Transactional
    fun delete(memberId: Long, chatRoomId: Long): Long {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val chatRoom = (chatRoomRepository.findByIdOrNull(chatRoomId)
            ?: throw CustomException("존재하지 않는 채팅방입니다."))

        if (chatRoom.member1Id != memberId && chatRoom.member2Id != memberId) {
            throw CustomException("참여하지 않은 채팅방입니다.")
        }

        val otherMemberId = if (chatRoom.member1Id == memberId) {
            chatRoom.member2Id
        } else chatRoom.member1Id

        chatRoom.delete()
        return otherMemberId
    }

    @Transactional(readOnly = true)
    fun gets(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): CompositeCursorResponse<ChatRoomGetResponse> {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

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
                it.memberId,
                memberImageRepository.findFirstByMemberIdAndTypeOrderBySortOrder(
                    it.memberId,
                    MemberImageType.PUBLIC
                )?.url,
                it.nickname,
                it.lastMessage,
                it.lastMessageAt,
                it.unreadCount,
            )
        }

        return CompositeCursorResponse(
            responses,
            nextCursorId,
            nextCursorDateAt,
            hasNext
        )
    }

    @Transactional(readOnly = true)
    fun getsUnread(
        memberId: Long,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): CompositeCursorResponse<ChatRoomGetResponse> {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        val results = chatRoomRepository.findUnreadChatRoomsByMemberId(
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
                it.memberId,
                memberImageRepository.findFirstByMemberIdAndTypeOrderBySortOrder(
                    it.memberId,
                    MemberImageType.PUBLIC
                )?.url,
                it.nickname,
                it.lastMessage,
                it.lastMessageAt,
                it.unreadCount,
            )
        }

        return CompositeCursorResponse(
            responses,
            nextCursorId,
            nextCursorDateAt,
            hasNext
        )
    }

    @Transactional(readOnly = true)
    fun get(
        memberId: Long,
        chatRoomId: Long,
        cursorId: Long?,
        limit: Int
    ): CursorResponse<ChatMessageGetResponse> {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val chatRoom = chatRoomRepository.findByIdOrNull(chatRoomId)
            ?: throw CustomException("존재하지 않는 채팅방입니다.")

        if (chatRoom.member1Id != memberId && chatRoom.member2Id != memberId) {
            throw CustomException("참여하지 않은 채팅방입니다.")
        }

        val chatMessages = chatMessageRepository.findByChatRoomIdWithCursor(
            chatRoomId,
            cursorId,
            PageRequest.of(0, limit + 1)
        )

        val hasNext = chatMessages.size > limit
        val data = chatMessages.dropLast(if (hasNext) 1 else 0)
        val nextCursorId = if (hasNext) data.last().id else null

        val responses = data.map {
            val receiverId = if (chatRoom.member1Id == it.senderId) {
                chatRoom.member2Id
            } else chatRoom.member1Id

            ChatMessageGetResponse(
                it.id,
                it.senderId,
                receiverId,
                it.content,
                it.type,
                it.createdAt,
            )
        }

        return CursorResponse(
            responses,
            nextCursorId,
            hasNext
        )
    }

    @Transactional
    fun markAsRead(
        memberId: Long,
        chatRoomId: Long,
    ) {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val chatRoom = chatRoomRepository.findByIdOrNull(chatRoomId)
            ?: throw CustomException("존재하지 않는 채팅방입니다.")

        val lastChatMessage = chatMessageRepository.findTopByChatRoomIdOrderByIdDesc(chatRoomId)

        lastChatMessage?.let {
            chatRoom.updateLastRead(memberId, lastChatMessage.id)
        }
    }

    @Transactional(readOnly = true)
    fun search(
        memberId: Long,
        keyword: String,
        cursorId: Long?,
        cursorDateAt: LocalDateTime?,
        limit: Int
    ): CompositeCursorResponse<ChatRoomGetResponse> {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")

        val results = chatRoomRepository.findByMemberIdWithCursorAndNickname(
            memberId,
            keyword,
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
                it.memberId,
                memberImageRepository.findFirstByMemberIdAndTypeOrderBySortOrder(
                    it.memberId,
                    MemberImageType.PUBLIC
                )?.url,
                it.nickname,
                it.lastMessage,
                it.lastMessageAt,
                it.unreadCount,
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