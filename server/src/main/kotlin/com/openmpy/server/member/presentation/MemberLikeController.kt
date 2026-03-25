package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.member.application.MemberLikeService
import com.openmpy.server.member.dto.response.MemberLikeCountResponse
import com.openmpy.server.member.dto.response.MemberSettingResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class MemberLikeController(

    private val memberLikeService: MemberLikeService
) {

    @PostMapping("/v1/members/{targetId}/like")
    fun add(
        @Login likerId: Long,
        @PathVariable targetId: Long
    ): ResponseEntity<MemberLikeCountResponse> {
        val response = memberLikeService.add(likerId, targetId)
        return ResponseEntity.ok(response)
    }

    @DeleteMapping("/v1/members/{targetId}/like")
    fun cancel(
        @Login likerId: Long,
        @PathVariable targetId: Long
    ): ResponseEntity<MemberLikeCountResponse> {
        val response = memberLikeService.cancel(likerId, targetId)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/v1/members/likes")
    fun gets(
        @Login memberId: Long,
        @RequestParam(value = "cursorId", required = false) cursorId: Long?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CursorResponse<MemberSettingResponse>> {
        val response = memberLikeService.gets(memberId, cursorId, limit)
        return ResponseEntity.ok(response)
    }
}