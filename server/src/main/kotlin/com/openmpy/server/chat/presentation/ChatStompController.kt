package com.openmpy.server.chat.presentation

import com.openmpy.server.chat.application.ChatMessageService
import com.openmpy.server.chat.dto.event.ChatRoomUpdateEvent
import com.openmpy.server.chat.dto.request.ChatMessageSendRequest
import org.springframework.messaging.handler.annotation.DestinationVariable
import org.springframework.messaging.handler.annotation.MessageMapping
import org.springframework.messaging.handler.annotation.Payload
import org.springframework.messaging.simp.SimpMessagingTemplate
import org.springframework.stereotype.Controller
import java.security.Principal

@Controller
class ChatStompController(

    private val messageTemplate: SimpMessagingTemplate,
    private val chatMessageService: ChatMessageService,
) {

    @MessageMapping("/chat-rooms/{chatRoomId}/message")
    fun sendChatMessage(
        @DestinationVariable chatRoomId: Long,
        @Payload request: ChatMessageSendRequest,
        principal: Principal
    ) {
        val memberId = principal.name.toLong()
        val response = chatMessageService.save(memberId, chatRoomId, request)

        messageTemplate.convertAndSend("/sub/chat-rooms/$chatRoomId", response)
        messageTemplate.convertAndSend(
            "/sub/chat-rooms/members/${response.receiverId}",
            ChatRoomUpdateEvent(
                chatRoomId = chatRoomId,
                memberId = memberId,
                thumbnail = response.thumbnail,
                nickname = response.nickname,
                lastMessage = response.content,
                lastMessageAt = response.createdAt,
                unreadCount = 1,
            )
        )
    }
}