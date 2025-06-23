package com.coderstack.clinicgrid.repository;

import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Integer> {
    Patient findByPhone(String phone);

    List<Patient> findByHospital(Hospital hospital);
}
