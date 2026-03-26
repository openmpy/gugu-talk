package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.repository.projection.MemberWithDistanceProjection
import org.locationtech.jts.geom.Point
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.time.LocalDateTime

interface MemberRepository : JpaRepository<Member, Long> {

    fun findByPhone(phone: String): Member?

    fun existsByPhone(phone: String): Boolean

    fun existsByNickname(nickname: String): Boolean

    fun existsByNicknameAndIdNot(nickname: String, id: Long): Boolean

    @Query(
        value = """
            SELECT 
                m.id AS id,
                m.nickname AS nickname,
                m.comment AS comment,
                m.bio AS bio,
                m.gender AS gender,
                m.birth_year AS birthYear,
                m.likes AS likes,
                CASE WHEN CAST(:location AS geography) IS NOT NULL
                     THEN ST_Distance(m.location::geography, CAST(:location AS geography)) / 1000
                END AS distance,
                m.updated_at AS updatedAt
            FROM member m 
            WHERE m.id <> :id
                AND m.comment IS NOT NULL
                AND (:gender IS NULL OR m.gender = :gender)
                AND (
                    CAST(:cursorDateAt AS timestamp) IS NULL
                    OR m.updated_at < :cursorDateAt
                    OR (m.updated_at = :cursorDateAt AND m.id < :cursorId)
                )
            ORDER BY m.updated_at DESC, m.id DESC
            LIMIT :limit
        """,
        nativeQuery = true
    )
    fun findAllComments(
        @Param("id") id: Long,
        @Param("location") location: Point?,
        @Param("gender") gender: String?,
        @Param("cursorId") cursorId: Long?,
        @Param("cursorDateAt") cursorDateAt: LocalDateTime?,
        @Param("limit") limit: Int,
    ): List<MemberWithDistanceProjection>

    @Query(
        value = """
            SELECT 
                m.id AS id,
                m.nickname AS nickname,
                m.comment AS comment,
                m.bio AS bio,
                m.gender AS gender,
                m.birth_year AS birthYear,
                m.likes AS likes,
                ST_Distance(m.location::geography, CAST(:location AS geography)) / 1000 AS distance,
                m.updated_at AS updatedAt
            FROM member m 
            WHERE m.id <> :id
                AND m.location IS NOT NULL
                AND :location IS NOT NULL
                AND (:gender IS NULL OR m.gender = :gender)
                AND (:cursorId IS NULL OR m.id < :cursorId)
            ORDER BY distance, m.updated_at DESC
            LIMIT :limit
        """,
        nativeQuery = true
    )
    fun findAllLocations(
        @Param("id") id: Long,
        @Param("location") location: Point?,
        @Param("gender") gender: String?,
        @Param("cursorId") cursorId: Long?,
        @Param("limit") limit: Int,
    ): List<MemberWithDistanceProjection>

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

    @Query(
        value = """
            SELECT 
                CASE WHEN CAST(:location AS geography) IS NOT NULL
                     THEN ST_Distance(m.location::geography, CAST(:location AS geography)) / 1000
                END AS distance
            FROM member m 
            WHERE m.id = :id
        """,
        nativeQuery = true
    )
    fun getDistanceByMember(
        @Param("id") id: Long,
        @Param("location") location: Point?,
    ): Double?
}