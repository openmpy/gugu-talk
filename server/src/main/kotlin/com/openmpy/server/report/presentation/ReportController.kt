package com.openmpy.server.report.presentation

import com.openmpy.server.auth.annotaion.Login
import com.openmpy.server.report.application.ReportService
import com.openmpy.server.report.dto.request.ReportSaveRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api")
@RestController
class ReportController(

    private val reportService: ReportService,
) {

    @PostMapping("/v1/members/{reportedId}/report")
    fun save(
        @Login reporterId: Long,
        @PathVariable reportedId: Long,
        @RequestBody request: ReportSaveRequest,
    ): ResponseEntity<Unit> {
        reportService.save(reporterId, reportedId, request)
        return ResponseEntity.ok().build()
    }
}