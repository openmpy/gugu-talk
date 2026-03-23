package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import org.springframework.data.jpa.repository.JpaRepository

interface MemberRepository : JpaRepository<Member, Long> {

    fun findByPhone(phone: String): Member?

    fun existsByPhone(phone: String): Boolean

    fun existsByNickname(nickname: String): Boolean
}