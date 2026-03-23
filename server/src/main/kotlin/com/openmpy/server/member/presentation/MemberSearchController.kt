package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.common.dto.CursorResponse
import com.openmpy.server.member.application.MemberSearchService
import com.openmpy.server.member.dto.response.MemberSearchNicknameResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api")
@RestController
class MemberSearchController(

    private val memberSearchService: MemberSearchService
) {

    @GetMapping("/v1/members/search")
    fun searchMembers(
        @Login memberId: Long,
        @RequestParam(value = "nickname", required = true) nickname: String,
        @RequestParam(value = "cursorId", required = false) cursorId: Long?,
        @RequestParam(value = "limit", defaultValue = "20", required = false) limit: Int
    ): ResponseEntity<CursorResponse<MemberSearchNicknameResponse>> {
        val response = memberSearchService.searchMembers(memberId, nickname, cursorId, limit)
        return ResponseEntity.ok(response)
    }
}