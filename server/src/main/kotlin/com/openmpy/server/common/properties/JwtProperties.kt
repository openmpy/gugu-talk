package com.openmpy.server.common.properties

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties("app.jwt")
data class JwtProperties(

    val secretKey: String,
    val accessTokenExpiration: Long,
    val refreshTokenExpiration: Long,
)
