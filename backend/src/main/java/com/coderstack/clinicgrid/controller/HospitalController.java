package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.dto.AddHospital;
import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.User;
import com.coderstack.clinicgrid.repository.HospitalRepository;
import com.coderstack.clinicgrid.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HospitalController {

    @Autowired
    private HospitalRepository hospitalRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/api/superadmin/hospital")
    public String addHospital(@RequestBody AddHospital newInfo) {
        Hospital hospital = getHospital(newInfo);
        Hospital newHospital=hospitalRepository.save(hospital);
        User newUser=new User();
        newUser.setEmail(newInfo.getHospitalEmail());
        newUser.setFirstName(newInfo.getHospitalName());
        newUser.setLastName(newInfo.getHospitalName());
        newUser.setPassword(newInfo.getHospitalEmail());
        newUser.setPhone(newInfo.getHospitalPhone());
        newUser.setHospital(newHospital);
        newUser.setRole("ADMIN");
        userRepository.save(newUser);
        return "Hospital added successfully";
    }

    private static Hospital getHospital(AddHospital newInfo) {
        Hospital hospital = new Hospital();
        hospital.setHospitalName(newInfo.getHospitalName());
        hospital.setHospitalAddress(newInfo.getHospitalAddress());
        hospital.setHospitalCity(newInfo.getHospitalCity());
        hospital.setHospitalState(newInfo.getHospitalState());
        hospital.setHospitalZip(newInfo.getHospitalZip());
        hospital.setHospitalCountry(newInfo.getHospitalCountry());
        hospital.setHospitalPhone(newInfo.getHospitalPhone());
        hospital.setHospitalEmail(newInfo.getHospitalEmail());
        hospital.setHospitalDescription(newInfo.getHospitalDescription());
        return hospital;
    }

}
