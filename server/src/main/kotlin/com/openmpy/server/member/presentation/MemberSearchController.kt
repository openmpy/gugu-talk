package com.openmpy.server.member.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.common.dto.CompositeCursorResponse
import com.openmpy.server.member.application.MemberSearchService
import com.openmpy.server.member.dto.response.MemberSearchNicknameResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.time.LocalDateTime

@RequestMapping("/api")
@RestController
class MemberSearchController(

    private val memberSearchService: MemberSearchService
) {

    @GetMapping("/v1/members/search")
    fun searchMembers(
        @Login memberId: Long,
        @RequestParam(value = "nickname") nickname: String,
        @RequestParam(value = "cursorId") cursorId: Long?,
        @RequestParam(value = "cursorDateAt") cursorDateAt: LocalDateTime?,
        @RequestParam(value = "limit", defaultValue = "20") limit: Int
    ): ResponseEntity<CompositeCursorResponse<MemberSearchNicknameResponse>> {
        val response = memberSearchService.searchMembers(
            memberId,
            nickname,
            cursorId,
            cursorDateAt,
            limit
        )
        return ResponseEntity.ok(response)
    }
}