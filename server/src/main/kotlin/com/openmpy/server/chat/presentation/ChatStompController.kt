package com.openmpy.server.chat.presentation

import com.openmpy.server.chat.application.ChatMessageService
import com.openmpy.server.chat.dto.request.ChatMessageSendRequest
import org.springframework.messaging.handler.annotation.DestinationVariable
import org.springframework.messaging.handler.annotation.MessageMapping
import org.springframework.messaging.handler.annotation.Payload
import org.springframework.stereotype.Controller
import java.security.Principal

@Controller
class ChatStompController(

    private val ChatMessageService: ChatMessageService,
) {

    @MessageMapping("/chat-rooms/{chatRoomId}/message")
    fun sendChatMessage(
        @DestinationVariable chatRoomId: Long,
        @Payload request: ChatMessageSendRequest,
        principal: Principal
    ) {
    }
}