package com.openmpy.server.chat.application

import com.openmpy.server.chat.domain.entity.ChatMessage
import com.openmpy.server.chat.dto.request.ChatMessageSendRequest
import com.openmpy.server.chat.dto.response.ChatMessageGetResponse
import com.openmpy.server.chat.repository.ChatMessageRepository
import com.openmpy.server.chat.repository.ChatRoomRepository
import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class ChatMessageService(

    private val chatMessageRepository: ChatMessageRepository,
    private val chatRoomRepository: ChatRoomRepository,
    private val memberRepository: MemberRepository
) {

    @Transactional
    fun save(
        memberId: Long,
        chatRoomId: Long,
        request: ChatMessageSendRequest
    ): ChatMessageGetResponse {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val chatRoom = chatRoomRepository.findByIdOrNull(chatRoomId)
            ?: throw CustomException("존재하지 않는 채팅방입니다.")

        if (chatRoom.member1Id != memberId && chatRoom.member2Id != memberId) {
            throw CustomException("참여하지 않은 채팅방입니다.")
        }

        val chatMessage = ChatMessage(
            chatRoomId = chatRoomId,
            senderId = memberId,
            content = request.content,
            type = request.type,
        )
        chatMessageRepository.save(chatMessage)
        chatRoom.updateLastMessage(request.content)
        chatRoom.updateLastRead(memberId, chatMessage.id)

        val receiverId = if (chatRoom.member1Id == memberId) {
            chatRoom.member2Id
        } else chatRoom.member1Id

        return ChatMessageGetResponse(
            chatMessage.id,
            chatMessage.senderId,
            receiverId,
            chatMessage.content,
            chatMessage.type,
            chatMessage.createdAt
        )
    }
}