package com.openmpy.server.chat.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.chat.application.ChatRoomService
import com.openmpy.server.chat.dto.request.ChatRoomCreateRequest
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class ChatRoomController(

    private val chatRoomService: ChatRoomService,
) {

    @PostMapping("/v1/chat-rooms")
    fun create(
        @Login memberId: Long,
        @RequestParam("targetId", required = true) targetId: Long,
        @RequestBody request: ChatRoomCreateRequest
    ): ResponseEntity<Unit> {
        chatRoomService.create(memberId, targetId, request)
        return ResponseEntity.status(HttpStatus.CREATED).build()
    }

    @DeleteMapping("/v1/chat-rooms/{chatRoomId}")
    fun delete(
        @Login memberId: Long,
        @PathVariable chatRoomId: Long
    ): ResponseEntity<Unit> {
        chatRoomService.delete(memberId, chatRoomId)
        return ResponseEntity.noContent().build()
    }
}