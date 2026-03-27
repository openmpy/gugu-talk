package com.openmpy.server.image.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.image.application.ReportImageService
import com.openmpy.server.s3.dto.response.PresignedUrlResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api")
@RestController
class ReportImageController(

    private val reportImageService: ReportImageService
) {

    @GetMapping("/v1/reports/{reportedId}/presigned-url")
    fun getReportPresignedUrl(
        @Login reporterId: Long,
        @PathVariable reportedId: Long,
    ): ResponseEntity<PresignedUrlResponse> {
        val response = reportImageService.getPresignedUrl(reporterId, reportedId)
        return ResponseEntity.ok(response)
    }
}