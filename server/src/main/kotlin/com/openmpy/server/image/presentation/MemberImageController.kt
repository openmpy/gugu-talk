package com.openmpy.server.image.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.image.application.MemberImageService
import com.openmpy.server.image.dto.request.MemberImageSaveRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api")
@RestController
class MemberImageController(

    private val memberImageService: MemberImageService
) {

    @PostMapping("/members/images")
    fun save(
        @Login memberId: Long,
        @RequestBody request: MemberImageSaveRequest
    ): ResponseEntity<Unit> {
        memberImageService.save(memberId, request)
        return ResponseEntity.ok().build()
    }
}