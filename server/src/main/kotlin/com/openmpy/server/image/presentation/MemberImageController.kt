package com.openmpy.server.image.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.image.application.MemberImageService
import com.openmpy.server.image.dto.request.MemberImageSaveRequest
import com.openmpy.server.s3.dto.response.PresignedUrlResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class MemberImageController(

    private val memberImageService: MemberImageService
) {

    @PostMapping("/v1/members/images")
    fun save(
        @Login memberId: Long,
        @RequestBody request: MemberImageSaveRequest
    ): ResponseEntity<Unit> {
        memberImageService.save(memberId, request)
        return ResponseEntity.ok().build()
    }

    @GetMapping("/v1/members/images/presigned-url")
    fun getProfilePresignedUrl(
        @Login memberId: Long,
        @RequestParam("type", required = true) type: String,
    ): ResponseEntity<PresignedUrlResponse> {
        val response = memberImageService.getProfilePresignedUrl(memberId, type)
        return ResponseEntity.ok(response)
    }
}