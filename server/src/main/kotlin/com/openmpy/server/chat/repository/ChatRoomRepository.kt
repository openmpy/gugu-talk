package com.openmpy.server.chat.repository

import com.openmpy.server.chat.domain.entity.ChatRoom
import org.springframework.data.jpa.repository.JpaRepository

interface ChatRoomRepository : JpaRepository<ChatRoom, Long>, ChatRoomCustomRepository {

    fun findByMember1IdAndMember2Id(member1Id: Long, member2Id: Long): ChatRoom?
}