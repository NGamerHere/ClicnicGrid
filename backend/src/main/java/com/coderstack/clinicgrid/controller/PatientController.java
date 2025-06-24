package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.dto.AddNewPatient;
import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Patient;
import com.coderstack.clinicgrid.model.User;
import com.coderstack.clinicgrid.repository.HospitalRepository;
import com.coderstack.clinicgrid.repository.PatientRepository;
import com.coderstack.clinicgrid.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hospital/{hospital_id}/{role}/{user_id}")
public class PatientController {

    @Autowired
    HospitalRepository hospitalRepository;

    @Autowired
    PatientRepository patientRepository;

    @Autowired
    UserRepository userRepository;


    @PostMapping("/patient")
    public ResponseEntity<?> addNewPatient(@RequestBody AddNewPatient newPatient, @PathVariable int hospital_id, @PathVariable int user_id) {
        Hospital hospital = hospitalRepository.findById(hospital_id).orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));
        User user = userRepository.findById(user_id).orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));
        Patient patient = new Patient();
        patient.setFirstName(newPatient.getFirstName());
        patient.setLastName(newPatient.getLastName());
        patient.setAddress(newPatient.getAddress());
        patient.setDateOfBirth(newPatient.getDateOfBirth());
        patient.setGender(newPatient.getGender());
        patient.setEmail(newPatient.getEmail());
        patient.setPhone(newPatient.getPhone());
        patient.setCity(newPatient.getCity());
        patient.setAddedBy(user);
        patient.setHospital(hospital);
        Patient savedPatient = patientRepository.save(patient);
        return ResponseEntity.ok(
                Map.of("message", "saved successfully", "id", savedPatient.getId())
        );

    }

    @GetMapping("/patient")
    public ResponseEntity<?> getPatients(@PathVariable int hospital_id, @PathVariable int user_id) {
        Hospital hospital = hospitalRepository.findById(hospital_id).orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));
        List<Patient> patients = patientRepository.findByHospital(hospital);
        return ResponseEntity.ok(Map.of("data", patients));
    }

    @PutMapping("/patient/{patient_id}")
    public ResponseEntity<?> EditPatient(@RequestBody AddNewPatient editPatient, @PathVariable int patient_id, @PathVariable int hospital_id, @PathVariable int user_id) {
        Hospital hospital = hospitalRepository.findById(hospital_id).orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));
        Patient patient = patientRepository.findByIdAndHospital(patient_id, hospital);
        if (patient == null) {
            return ResponseEntity.status(404).body(Map.of("error", "patient not found"));
        }
        patient.setFirstName(editPatient.getFirstName());
        patient.setLastName(editPatient.getLastName());
        patient.setAddress(editPatient.getAddress());
        patient.setDateOfBirth(editPatient.getDateOfBirth());
        patient.setGender(editPatient.getGender());
        patient.setEmail(editPatient.getEmail());
        patient.setPhone(editPatient.getPhone());
        patient.setCity(editPatient.getCity());
        Patient savedPatient = patientRepository.save(patient);
        return ResponseEntity.ok(
                Map.of("message", "saved successfully", "id", savedPatient.getId())
        );
    }


}
