package com.openmpy.server.report.repository

import com.openmpy.server.report.domain.entity.Report
import org.springframework.data.jpa.repository.JpaRepository

interface ReportRepository : JpaRepository<Report, Long>