package com.openmpy.server.member.repository.impl

import com.linecorp.kotlinjdsl.support.spring.data.jpa.repository.KotlinJdslJpqlExecutor
import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.entity.MemberLike
import com.openmpy.server.member.repository.MemberLikeCustomRepository
import com.openmpy.server.member.repository.projection.MemberSettingProjection
import org.springframework.stereotype.Repository

@Repository
class MemberLikeCustomRepositoryImpl(
    private val jpql: KotlinJdslJpqlExecutor
) : MemberLikeCustomRepository {

    override fun findByLikerIdWithCursor(
        likerId: Long,
        cursorId: Long?,
        limit: Int
    ): List<MemberSettingProjection> {

        return jpql.findAll {
            select(
                new(
                    MemberSettingProjection::class,
                    path(MemberLike::id),
                    path(Member::id),
                    path(Member::nickname),
                    path(Member::gender),
                    path(Member::birthYear),
                )
            ).from(
                entity(MemberLike::class),
                join(Member::class).on(
                    path(Member::id).eq(path(MemberLike::targetId))
                )
            ).whereAnd(
                path(MemberLike::likerId).eq(likerId),
                cursorId?.let { path(MemberLike::id).lt(it) }
            ).orderBy(path(MemberLike::id).desc())
        }.filterNotNull()
    }
}