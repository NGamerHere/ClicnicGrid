package com.coderstack.clinicgrid.repository;

import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TreatmentRepository extends JpaRepository<Treatment, Integer> {

    List<Treatment> findAllByHospital(Hospital hospital);
}
