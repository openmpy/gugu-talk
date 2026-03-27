package com.openmpy.server.image.repository

import com.openmpy.server.image.domain.entity.ReportImage
import org.springframework.data.jpa.repository.JpaRepository

interface ReportImageRepository : JpaRepository<ReportImage, Long>