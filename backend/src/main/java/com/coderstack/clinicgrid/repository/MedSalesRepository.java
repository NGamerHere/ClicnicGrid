package com.coderstack.clinicgrid.repository;

import com.coderstack.clinicgrid.model.MedSale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MedSalesRepository extends JpaRepository<MedSale,Integer> {

}
