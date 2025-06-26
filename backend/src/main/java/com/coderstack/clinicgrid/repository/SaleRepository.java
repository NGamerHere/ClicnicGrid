package com.coderstack.clinicgrid.repository;


import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Patient;
import com.coderstack.clinicgrid.model.Sale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SaleRepository extends JpaRepository<Sale, Integer> {
    List<Sale> findByPatientAndHospital(Patient patient, Hospital hospital);

    List<Sale> findByHospital(Hospital hospital);

    Sale findByIdAndHospital(int id, Hospital hospital);

}
