package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.dto.NewMedSale;
import com.coderstack.clinicgrid.dto.NewSale;
import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import com.coderstack.clinicgrid.model.*;
import com.coderstack.clinicgrid.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Locale;
import java.util.Map;

@RestController
@RequestMapping("/api/hospital/{hospital_id}/{role}/{user_id}")
public class SalesController {
    @Autowired
    private SaleRepository saleRepository;

    @Autowired
    private HospitalRepository hospitalRepository;

    @Autowired
    private MedSalesRepository medSalesRepository;

    @Autowired
    private MedicineRepository medicineRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @PostMapping("/sales")
    public ResponseEntity<?> addNewSales(
            @PathVariable int hospital_id,
            @PathVariable int user_id,
            @Valid @RequestBody NewSale newSale
    ) {
        Hospital hospital = hospitalRepository.findById(hospital_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));

        User user = userRepository.findById(user_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid user"));

        Patient patient = patientRepository.findByIdAndHospital(newSale.getPatientId(), hospital);
        if (patient == null) {
            return ResponseEntity.ok(Map.of("error", "Patient not found"));
        }

        Sale sale = new Sale();
        sale.setHospital(hospital);
        sale.setDoneBy(user);
        LocalDateTime dateTime = LocalDateTime.now();
        sale.setPaymentDoneOn(dateTime);
        sale.setPatient(patient);
        sale.setMedSales(new ArrayList<>());
        sale.setAmount(0);


        sale = saleRepository.save(sale);

        double totalAmount = 0.0;

        for (NewMedSale medSaleDTO : newSale.getMedSales()) {
            Medicine med = medicineRepository.findByIdAndHospital(medSaleDTO.getMedicineId(), hospital);
            if (med == null) {
                continue;
            }

            MedSale medSale = new MedSale();
            medSale.setHospital(hospital);
            medSale.setSale(sale);
            medSale.setMedicine(med);
            medSale.setTotalSold(medSaleDTO.getTotalSold());
            medSale.setPrice(medSaleDTO.getPrice());

            sale.getMedSales().add(medSale);
            totalAmount += med.getPrice();
        }

        sale.setAmount((int) totalAmount);
        saleRepository.save(sale);

        return ResponseEntity.ok(Map.of("message", "Sale recorded successfully", "total", totalAmount));
    }





}
