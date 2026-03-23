package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.member.application.MemberLikeService
import com.openmpy.server.member.dto.response.MemberLikeCountResponse
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
}