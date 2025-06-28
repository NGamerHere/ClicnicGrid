package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import com.coderstack.clinicgrid.model.User;
import com.coderstack.clinicgrid.service.OpenAIService;
import com.coderstack.clinicgrid.repository.HospitalRepository;
import com.coderstack.clinicgrid.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/api/hospital/{hospital_id}/{role}/{user_id}")
public class profileController {
    @Autowired
    private UserRepository userRepository;

    private final OpenAIService openAIService;

    public profileController(OpenAIService openAIService) {
        this.openAIService = openAIService;
    }

    @GetMapping("/profile")
    public ResponseEntity<?> getProfileInfo(@PathVariable int hospital_id,@PathVariable int user_id){
        User user=userRepository.findById(hospital_id).orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));;
        return ResponseEntity.ok(user);
    }

    @GetMapping("/ask")
    public String askOpenAI(@RequestParam String prompt) throws IOException, InterruptedException {
        return openAIService.sendMessage(prompt);
    }


}
