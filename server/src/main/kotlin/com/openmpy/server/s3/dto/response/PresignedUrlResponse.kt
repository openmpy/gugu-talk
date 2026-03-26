package com.openmpy.server.s3.dto.response

data class PresignedUrlResponse(

    val url: String,
    val key: String,
)