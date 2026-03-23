package com.openmpy.server.auth.application

import com.openmpy.server.common.properties.JwtProperties
import io.jsonwebtoken.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.util.*

@Service
class JwtService(

    private val jwtProperties: JwtProperties,
) {

    private val log: Logger by lazy { LoggerFactory.getLogger("JwtService") }

    fun generateAccessToken(memberId: Long): String {
        val claims = Jwts.claims()
        claims.putAll(mapOf("id" to memberId))

        val now = Date()
        val expiration = Date(now.time + jwtProperties.accessTokenExpiration * 1000)

        return Jwts.builder()
            .setClaims(claims)
            .setIssuedAt(now)
            .setExpiration(expiration)
            .signWith(SignatureAlgorithm.HS256, jwtProperties.secretKey)
            .compact()
    }

    fun generateRefreshToken(): String {
        return UUID.randomUUID().toString()
    }

    fun validateToken(token: String): Boolean =
        runCatching {
            Jwts.parser().setSigningKey(jwtProperties.secretKey).parseClaimsJws(token)
        }.onFailure { e ->
            when (e) {
                is ExpiredJwtException -> log.warn("토큰이 만료되었습니다. {}", e.message)
                is UnsupportedJwtException -> log.warn("지원되지 않는 토큰입니다. {}", e.message)
                is MalformedJwtException -> log.warn("형식이 잘못된 토큰입니다. {}", e.message)
                is SecurityException -> log.warn("유효하지 않은 서명입니다. {}", e.message)
                is IllegalArgumentException -> log.warn("토큰 클레임이 비어 있습니다. {}", e.message)
                else -> log.warn("알 수 없는 오류가 발생했습니다. {}", e.message)
            }
        }.isSuccess

    fun extractMemberId(accessToken: String): Long {
        val payload = getPayload(accessToken)
        return payload["id"].toString().toLong()
    }

    private fun getPayload(token: String): Map<String, Any> {
        return Jwts.parser()
            .setSigningKey(jwtProperties.secretKey)
            .parseClaimsJws(token)
            .body
    }
}