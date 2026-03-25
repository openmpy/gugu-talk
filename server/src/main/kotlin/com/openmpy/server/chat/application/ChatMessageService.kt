package com.openmpy.server.chat.application

import com.openmpy.server.chat.repository.ChatMessageRepository
import com.openmpy.server.chat.repository.ChatRoomRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.stereotype.Service

@Service
class ChatMessageService(

    private val chatRoomRepository: ChatRoomRepository,
    private val chatMessageRepository: ChatMessageRepository,
    private val memberRepository: MemberRepository
)