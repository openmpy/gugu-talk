package com.openmpy.server.image.domain.entity

import com.openmpy.server.image.domain.type.MemberImageType
import jakarta.persistence.*
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@Entity
@SQLRestriction("deleted_at IS NULL")
@Table(name = "member_image")
class MemberImage(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val memberId: Long,

    @Column(nullable = false)
    val url: String,

    @Column(nullable = false)
    val key: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val type: MemberImageType = MemberImageType.PUBLIC,

    @Column(nullable = false)
    var sortOrder: Int = 0,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column
    var deletedAt: LocalDateTime? = null,
) {

    fun delete() {
        this.deletedAt = LocalDateTime.now()
    }

    fun updateSortOrder(sortOrder: Int) {
        this.sortOrder = sortOrder
    }
}