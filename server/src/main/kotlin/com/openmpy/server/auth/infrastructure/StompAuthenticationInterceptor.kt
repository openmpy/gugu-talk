package com.openmpy.server.auth.infrastructure

import com.openmpy.server.auth.application.JwtService
import org.springframework.http.HttpHeaders
import org.springframework.messaging.Message
import org.springframework.messaging.MessageChannel
import org.springframework.messaging.MessageDeliveryException
import org.springframework.messaging.simp.stomp.StompCommand
import org.springframework.messaging.simp.stomp.StompHeaderAccessor
import org.springframework.messaging.support.ChannelInterceptor
import org.springframework.messaging.support.MessageHeaderAccessor
import org.springframework.stereotype.Component

@Component
class StompAuthenticationInterceptor(

    private val jwtService: JwtService
) : ChannelInterceptor {

    override fun preSend(
        message: Message<*>,
        channel: MessageChannel
    ): Message<*>? {
        val accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor::class.java)
            ?: return message

        if (accessor.command == StompCommand.CONNECT) {
            val header = accessor.getFirstNativeHeader(HttpHeaders.AUTHORIZATION)
                ?: throw MessageDeliveryException("인증 토큰이 없습니다.")

            if (!header.startsWith("Bearer ")) {
                throw MessageDeliveryException("유효하지 않은 토큰 형식입니다.")
            }

            val accessToken = header.substring(7)
            val memberId = jwtService.extractMemberId(accessToken)

            accessor.setUser { memberId.toString() }
        }
        return message
    }
}