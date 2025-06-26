package com.coderstack.clinicgrid.repository;

import com.coderstack.clinicgrid.dto.MedicineStats;
import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Medicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MedicineRepository extends JpaRepository<Medicine, Integer> {
    List<Medicine> findByHospital(Hospital hospital);

    Medicine findByIdAndHospital(int id, Hospital hospital);

    @Query(value = """
        SELECT 
            COUNT(*) AS total,
            SUM(CASE WHEN quantity < 10 THEN 1 ELSE 0 END) AS lowStock,
            SUM(CASE WHEN expires_on < NOW() THEN 1 ELSE 0 END) AS expired,
            SUM(CASE WHEN quantity = 0 THEN 1 ELSE 0 END) AS outOfStock
        FROM medicines
        WHERE hospital_id = :hospitalId
        """, nativeQuery = true)
    MedicineStats getMedicineStats(@Param("hospitalId") int hospitalId);
}
