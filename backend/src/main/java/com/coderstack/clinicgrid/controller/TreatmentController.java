package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.dto.AddNewTreatment;
import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.Treatment;
import com.coderstack.clinicgrid.model.User;
import com.coderstack.clinicgrid.repository.HospitalRepository;
import com.coderstack.clinicgrid.repository.TreatmentRepository;
import com.coderstack.clinicgrid.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/hospital/{hospital_id}/{role}/{user_id}")
public class TreatmentController {
    @Autowired
    private TreatmentRepository treatmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HospitalRepository hospitalRepository;

    @PostMapping("/treatment")
    public ResponseEntity<?> addNewTreatment(@RequestBody AddNewTreatment newTreatment, @PathVariable int hospital_id, @PathVariable int user_id) {
        User user = userRepository.findById(user_id).orElseThrow(() -> new ResourceNotFoundException("user not found"));
        Hospital hospital = hospitalRepository.findById(hospital_id).orElseThrow(() -> new ResourceNotFoundException("hospital not found"));

        Treatment treatment = new Treatment();
        treatment.setName(newTreatment.getName());
        treatment.setBasePrice(newTreatment.getBasePrice());
        treatment.setDescription(newTreatment.getDescription());
        treatment.setMaxDuration(newTreatment.getMaxDuration());
        treatment.setTotalSessions(newTreatment.getTotalSessions());
        treatment.setDefaultDuration(newTreatment.getDefaultDuration());
        treatment.setHospital(hospital);
        Treatment savedTreatment = treatmentRepository.save(treatment);
        return ResponseEntity.ok(Map.of("message", "Successfully added treatment","id", savedTreatment.getId()));
    }

    @GetMapping("/treatment")
    public ResponseEntity<?> getTreatment(@PathVariable int hospital_id, @PathVariable int user_id) {
        Hospital hospital = hospitalRepository.findById(hospital_id).orElseThrow(() -> new ResourceNotFoundException("hospital not found"));
        return ResponseEntity.ok(treatmentRepository.findAllByHospital(hospital));
    }


}
