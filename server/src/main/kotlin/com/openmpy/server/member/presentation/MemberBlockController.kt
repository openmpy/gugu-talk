package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.member.application.MemberBlockService
import com.openmpy.server.member.dto.response.MemberSettingResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class MemberBlockController(

    private val memberBlockService: MemberBlockService
) {

    @PostMapping("/v1/members/{blockedId}/block")
    fun add(
        @Login blockerId: Long,
        @PathVariable blockedId: Long
    ): ResponseEntity<Unit> {
        memberBlockService.add(blockerId, blockedId)
        return ResponseEntity.noContent().build()
    }

    @DeleteMapping("/v1/members/{blockedId}/block")
    fun cancel(
        @Login blockerId: Long,
        @PathVariable blockedId: Long
    ): ResponseEntity<Unit> {
        memberBlockService.remove(blockerId, blockedId)
        return ResponseEntity.noContent().build()
    }

    @GetMapping("/v1/members/blocks")
    fun gets(
        @Login memberId: Long,
        @RequestParam(value = "cursorId") cursorId: Long?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CursorResponse<MemberSettingResponse>> {
        val response = memberBlockService.gets(memberId, cursorId, limit)
        return ResponseEntity.ok(response)
    }
}