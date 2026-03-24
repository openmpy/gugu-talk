package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.member.application.MemberQueryService
import com.openmpy.server.member.dto.response.MemberGetCommentResponse
import com.openmpy.server.member.dto.response.MemberGetLocationResponse
import com.openmpy.server.member.dto.response.MemberGetResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

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
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CursorResponse<MemberGetCommentResponse>> {
        val response = memberQueryService.getComments(memberId, gender, cursorId, limit)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/members/locations")
    fun getLocations(
        @Login memberId: Long,
        @RequestParam(value = "gender") gender: String,
        @RequestParam(value = "cursorId") cursorId: Long?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CursorResponse<MemberGetLocationResponse>> {
        val response = memberQueryService.getLocations(memberId, gender, cursorId, limit)
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
}