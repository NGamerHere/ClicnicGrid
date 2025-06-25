package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.dto.AddNewMedicine;
import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Medicine;
import com.coderstack.clinicgrid.repository.HospitalRepository;
import com.coderstack.clinicgrid.repository.MedicineRepository;
import com.coderstack.clinicgrid.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/api/hospital/{hospital_id}/{role}/{user_id}")
public class MedicineController {

    @Autowired
    HospitalRepository hospitalRepository;

    @Autowired
    PatientRepository patientRepository;

    @Autowired
    MedicineRepository medicineRepository;

    @PostMapping("/medicine")
    public ResponseEntity<?> addNewMedicine(
            @Valid @RequestBody AddNewMedicine newMedicine,
            @PathVariable int hospital_id,
            @PathVariable int user_id
    ) {
        Hospital hospital = hospitalRepository.findById(hospital_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));

        Medicine medicine = new Medicine();
        medicine.setHospital(hospital);
        medicine.setName(newMedicine.getName());
        medicine.setDescription(newMedicine.getDescription());
        medicine.setPrice(newMedicine.getPrice());
        medicine.setItemsPerStack(newMedicine.getItemsPerStack());
        medicine.setType(newMedicine.getType());
        medicine.setWeight(newMedicine.getWeight());
        medicine.setVolume(newMedicine.getVolume());
        medicine.setExpiresOn(newMedicine.getExpiresOn());
        medicine.setAddedOn(LocalDate.now());

        Medicine savedMedicine = medicineRepository.save(medicine);
        return ResponseEntity.ok(Map.of("message", "medicine saved successfully", "id", savedMedicine.getId()));
    }

    @GetMapping("/medicine")
    public ResponseEntity<?> getMedicine(
            @PathVariable int hospital_id,
            @PathVariable int user_id
    ) {
        Hospital hospital = hospitalRepository.findById(hospital_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));
        return ResponseEntity.ok(medicineRepository.findByHospital(hospital));
    }

    @PutMapping("/medicine/{medicineId}")
    public ResponseEntity<?> updateMedicine(
            @PathVariable int hospital_id,
            @PathVariable int user_id,
            @PathVariable int medicineId,
            @Valid @RequestBody AddNewMedicine updatedMedicine
    ) {
        Hospital hospital = hospitalRepository.findById(hospital_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));

        Medicine medicine = medicineRepository.findByIdAndHospital(medicineId, hospital);
        if (medicine == null) {
            return ResponseEntity.status(404).body(Map.of("error", "medicine not found"));
        }

        medicine.setName(updatedMedicine.getName());
        medicine.setDescription(updatedMedicine.getDescription());
        medicine.setPrice(updatedMedicine.getPrice());
        medicine.setItemsPerStack(updatedMedicine.getItemsPerStack());
        medicine.setType(updatedMedicine.getType());
        medicine.setWeight(updatedMedicine.getWeight());
        medicine.setVolume(updatedMedicine.getVolume());
        medicine.setExpiresOn(updatedMedicine.getExpiresOn());

        medicineRepository.save(medicine);
        return ResponseEntity.ok(Map.of("message", "medicine updated successfully"));
    }

    @DeleteMapping("/medicine/{medicineId}")
    public ResponseEntity<?> deleteMedicine(
            @PathVariable int hospital_id,
            @PathVariable int user_id,
            @PathVariable int medicineId
    ) {
        Hospital hospital = hospitalRepository.findById(hospital_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));

        Medicine medicine = medicineRepository.findById(medicineId)
                .orElseThrow(() -> new ResourceNotFoundException("Medicine not found"));

        if (medicine.getHospital().getId() != hospital.getId()) {
            throw new ResourceNotFoundException("Medicine doesn't belong to this hospital");
        }

        medicineRepository.delete(medicine);
        return ResponseEntity.ok(Map.of("message", "medicine deleted successfully"));
    }

    @GetMapping("/medicine/dashboard")
    public ResponseEntity<?> getDashboardInfo(
            @PathVariable int hospital_id
    ) {
        return ResponseEntity.ok(medicineRepository.getMedicineStats(hospital_id));
    }

}