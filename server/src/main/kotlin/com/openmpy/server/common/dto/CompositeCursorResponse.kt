package com.openmpy.server.common.dto

import java.time.LocalDateTime

data class CompositeCursorResponse<T>(

    val payload: List<T>,
    val nextId: Long?,
    val nextDateAt: LocalDateTime?,
    val hasNext: Boolean
)