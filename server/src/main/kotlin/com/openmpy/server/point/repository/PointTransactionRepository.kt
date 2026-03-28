package com.openmpy.server.point.repository

import com.openmpy.server.point.domain.entity.PointTransaction
import org.springframework.data.jpa.repository.JpaRepository

interface PointTransactionRepository : JpaRepository<PointTransaction, Long>