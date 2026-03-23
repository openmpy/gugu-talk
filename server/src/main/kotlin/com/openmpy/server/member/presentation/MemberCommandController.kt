package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.member.application.MemberCommandService
import com.openmpy.server.member.dto.request.MemberUpdateCommentRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api")
@RestController
class MemberCommandController(

    private val memberCommandService: MemberCommandService
) {

    @PutMapping("/v1/members/comments")
    fun updateComment(
        @Login memberId: Long,
        @RequestBody request: MemberUpdateCommentRequest
    ): ResponseEntity<Unit> {
        memberCommandService.updateComment(memberId, request)
        return ResponseEntity.noContent().build()
    }

    @PutMapping("/v1/members/comments/bump")
    fun bumpComment(@Login memberId: Long): ResponseEntity<Unit> {
        memberCommandService.bumpComment(memberId)
        return ResponseEntity.noContent().build()
    }
}