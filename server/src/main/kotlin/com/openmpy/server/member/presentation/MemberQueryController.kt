package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.common.dto.CompositeCursorResponse
import com.openmpy.server.common.dto.PageResponse
import com.openmpy.server.member.application.MemberQueryService
import com.openmpy.server.member.dto.response.*
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.time.LocalDateTime

@RequestMapping("/api")
@RestController
class MemberQueryController(

    private val memberQueryService: MemberQueryService
) {

    @GetMapping("/v1/members/comments")
    fun getComments(
        @Login memberId: Long,
        @RequestParam(value = "gender") gender: String,
        @RequestParam(value = "cursorId") cursorId: Long?,
        @RequestParam(value = "cursorDateAt") cursorDateAt: LocalDateTime?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CompositeCursorResponse<MemberGetCommentResponse>> {
        val response = memberQueryService.getComments(
            memberId,
            gender,
            cursorId,
            cursorDateAt,
            limit
        )
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/members/locations")
    fun getLocations(
        @Login memberId: Long,
        @RequestParam(value = "gender") gender: String,
        @RequestParam(value = "page", defaultValue = "0") page: Int,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<PageResponse<MemberGetLocationResponse>> {
        val response = memberQueryService.getLocations(memberId, gender, page, limit)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/members/{targetId}")
    fun get(
        @Login memberId: Long,
        @PathVariable targetId: Long
    ): ResponseEntity<MemberGetResponse> {
        val response = memberQueryService.get(memberId, targetId)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/members/chat-enabled")
    fun getChatEnabled(
        @Login memberId: Long,
    ): ResponseEntity<MemberGetChatEnabledResponse> {
        val response = memberQueryService.getChatEnabled(memberId)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/members/my")
    fun getMy(
        @Login memberId: Long,
    ): ResponseEntity<MemberGetMyResponse> {
        val response = memberQueryService.getMy(memberId)
        return ResponseEntity.ok(response)
    }
}