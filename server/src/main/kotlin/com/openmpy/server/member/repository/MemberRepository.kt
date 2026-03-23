package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface MemberRepository : JpaRepository<Member, Long> {

    fun findByPhone(phone: String): Member?

    fun existsByPhone(phone: String): Boolean

    fun existsByNickname(nickname: String): Boolean

    @Query(
        value = """
            SELECT m.*
            FROM member m 
            WHERE m.id <> :id
                AND m.comment IS NOT NULL
                AND (:gender IS NULL OR m.gender = :gender)
                AND (:cursorId IS NULL OR m.id < :cursorId)
            ORDER BY m.updated_at DESC
            LIMIT :limit
        """,
        nativeQuery = true
    )
    fun findAllComments(
        @Param("id") id: Long,
        @Param("gender") gender: String?,
        @Param("cursorId") cursorId: Long?,
        @Param("limit") limit: Int,
    ): List<Member>

    @Query(
        value = """
            SELECT m.*
            FROM member m 
            WHERE m.id <> :id 
                AND m.nickname LIKE CONCAT(:nickname, '%')
                AND (:cursorId IS NULL OR m.id < :cursorId)
            ORDER BY m.updated_at DESC
            LIMIT :limit
        """,
        nativeQuery = true
    )
    fun findByNicknameStartsWith(
        @Param("id") id: Long,
        @Param("nickname") nickname: String,
        @Param("cursorId") cursorId: Long?,
        @Param("limit") limit: Int,
    ): List<Member>
}