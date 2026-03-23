package com.openmpy.server.common.dto

data class CursorResponse<T>(
    val payload: List<T>,
    val nextId: Long?,
    val hasNext: Boolean
)