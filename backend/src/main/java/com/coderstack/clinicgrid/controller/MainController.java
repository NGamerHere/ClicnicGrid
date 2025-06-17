package com.coderstack.clinicgrid.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MainController {
    @GetMapping("/")
    public String index() {
        return "Welcome to Clinic Grid";
    }

    @GetMapping("/api/hospital/{hospital_id}/dashboard")
    public String dashboard(){
        return "Welcome user , you have logged in";
    }

}
