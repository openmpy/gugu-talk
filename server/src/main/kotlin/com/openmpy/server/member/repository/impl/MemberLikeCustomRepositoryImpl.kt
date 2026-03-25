package com.openmpy.server.member.repository.impl

import com.openmpy.server.member.repository.MemberLikeCustomRepository
import com.openmpy.server.member.repository.dto.MemberSettingResult
import jakarta.persistence.EntityManager
import org.springframework.stereotype.Repository

@Repository
class MemberLikeCustomRepositoryImpl(
    private val entityManager: EntityManager
) : MemberLikeCustomRepository {

    override fun findByLikerIdWithCursor(
        likerId: Long,
        cursorId: Long?,
        limit: Int
    ): List<MemberSettingResult> {
        val jpql = buildString {
            append(
                """
                SELECT new com.openmpy.server.member.repository.dto.MemberSettingResult(
                    ml.id, m.id, m.nickname, m.gender, m.birthYear
                )
                FROM MemberLike ml
                JOIN Member m ON m.id = ml.targetId
                WHERE ml.likerId = :likerId
            """
            )
            if (cursorId != null) {
                append(" AND ml.id < :cursorId")
            }
            append(" ORDER BY ml.id DESC")
        }
        return entityManager.createQuery(jpql, MemberSettingResult::class.java).apply {
            setParameter("likerId", likerId)
            cursorId?.let { setParameter("cursorId", it) }
            maxResults = limit
        }.resultList
    }
}