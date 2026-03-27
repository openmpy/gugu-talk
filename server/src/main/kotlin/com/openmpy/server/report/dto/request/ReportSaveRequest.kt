package com.openmpy.server.report.dto.request

import com.openmpy.server.report.domain.type.ReportType

data class ReportSaveRequest(

    val type: ReportType,
    val images: List<ReportImageItemRequest>,
    val reason: String?,
)

data class ReportImageItemRequest(

    val key: String,
)