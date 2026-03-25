package com.openmpy.server.chat.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.chat.application.ChatRoomService
import com.openmpy.server.chat.dto.event.ChatRoomDeleteEvent
import com.openmpy.server.chat.dto.event.ChatRoomNewEvent
import com.openmpy.server.chat.dto.request.ChatRoomCreateRequest
import com.openmpy.server.chat.dto.response.ChatMessageGetResponse
import com.openmpy.server.chat.dto.response.ChatRoomGetResponse
import com.openmpy.server.common.dto.CompositeCursorResponse
import com.openmpy.server.common.dto.CursorResponse
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.messaging.simp.SimpMessagingTemplate
import org.springframework.web.bind.annotation.*
import java.time.LocalDateTime

@RequestMapping("/api")
@RestController
class ChatRoomController(

    private val messageTemplate: SimpMessagingTemplate,
    private val chatRoomService: ChatRoomService,
) {

    @PostMapping("/v1/chat-rooms")
    fun create(
        @Login memberId: Long,
        @RequestParam("targetId", required = true) targetId: Long,
        @RequestBody request: ChatRoomCreateRequest
    ): ResponseEntity<Unit> {
        val response = chatRoomService.create(memberId, targetId, request)

        messageTemplate.convertAndSend(
            "/sub/chat-rooms/members/$targetId",
            ChatRoomNewEvent(
                chatRoomId = response.chatRoomId,
                memberId = response.memberId,
                thumbnail = null,
                nickname = response.nickname,
                lastMessage = response.lastMessage,
                lastMessageAt = response.lastMessageAt,
            )
        )
        return ResponseEntity.status(HttpStatus.CREATED).build()
    }

    @DeleteMapping("/v1/chat-rooms/{chatRoomId}")
    fun delete(
        @Login memberId: Long,
        @PathVariable chatRoomId: Long
    ): ResponseEntity<Unit> {
        val otherMemberId = chatRoomService.delete(memberId, chatRoomId)

        messageTemplate.convertAndSend(
            "/sub/chat-rooms/members/$otherMemberId",
            ChatRoomDeleteEvent(chatRoomId = chatRoomId)
        )
        return ResponseEntity.noContent().build()
    }

    @GetMapping("/v1/chat-rooms")
    fun gets(
        @Login memberId: Long,
        @RequestParam(value = "cursorId") cursorId: Long?,
        @RequestParam(value = "cursorDateAt") cursorDateAt: LocalDateTime?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CompositeCursorResponse<ChatRoomGetResponse>> {
        val response = chatRoomService.gets(memberId, cursorId, cursorDateAt, limit)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/chat-rooms/{chatRoomId}")
    fun get(
        @Login memberId: Long,
        @PathVariable chatRoomId: Long,
        @RequestParam(value = "cursorId") cursorId: Long?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CursorResponse<ChatMessageGetResponse>> {
        val response = chatRoomService.get(memberId, chatRoomId, cursorId, limit)
        return ResponseEntity.ok(response)
    }

    @PatchMapping("/v1/chat-rooms/{chatRoomId}/read")
    fun markAsRead(
        @Login memberId: Long,
        @PathVariable chatRoomId: Long,
    ): ResponseEntity<Unit> {
        chatRoomService.markAsRead(memberId, chatRoomId)
        return ResponseEntity.noContent().build()
    }
}