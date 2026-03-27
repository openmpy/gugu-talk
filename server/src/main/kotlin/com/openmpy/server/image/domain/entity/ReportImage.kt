package com.openmpy.server.image.domain.entity

import jakarta.persistence.*
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@Entity
@SQLRestriction("deleted_at IS NULL")
@Table(name = "report_image")
class ReportImage(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val reportId: Long,

    @Column(nullable = false)
    val url: String,

    @Column(nullable = false)
    val key: String,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column
    var deletedAt: LocalDateTime? = null,
) {

    fun delete() {
        this.deletedAt = LocalDateTime.now()
    }
}