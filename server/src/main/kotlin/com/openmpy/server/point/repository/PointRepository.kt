package com.openmpy.server.point.repository

import com.openmpy.server.point.domain.entity.Point
import org.springframework.data.jpa.repository.JpaRepository

interface PointRepository : JpaRepository<Point, Long>