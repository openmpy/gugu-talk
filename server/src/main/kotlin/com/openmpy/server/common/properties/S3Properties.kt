package com.openmpy.server.common.properties

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties("aws.s3")
data class S3Properties(

    val bucket: String,
    val endpoint: String,
    val region: String,
    val accessKey: String,
    val secretKey: String,
)
