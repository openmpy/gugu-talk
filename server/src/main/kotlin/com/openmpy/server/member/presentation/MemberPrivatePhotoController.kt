package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.member.application.MemberPrivatePhotoService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class MemberPrivatePhotoController(

    private val memberPrivatePhotoService: MemberPrivatePhotoService
) {

    @PostMapping("/v1/members/{targetId}/private-photo")
    fun open(
        @Login ownerId: Long,
        @PathVariable targetId: Long
    ): ResponseEntity<Unit> {
        memberPrivatePhotoService.open(ownerId, targetId)
        return ResponseEntity.noContent().build()
    }

    @DeleteMapping("/v1/members/{targetId}/private-photo")
    fun close(
        @Login ownerId: Long,
        @PathVariable targetId: Long
    ): ResponseEntity<Unit> {
        memberPrivatePhotoService.close(ownerId, targetId)
        return ResponseEntity.noContent().build()
    }
}