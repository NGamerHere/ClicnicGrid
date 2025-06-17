package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.dto.Login;
import com.coderstack.clinicgrid.model.User;
import com.coderstack.clinicgrid.repository.UserRepository;
import com.coderstack.clinicgrid.utils.JwtUtil;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/api/login")
    public ResponseEntity<?> login(@RequestBody Login login) {
        User user = userRepository.findByPhone(login.phone);
        if (user == null) {
            return ResponseEntity.status(404).body(Map.of(
                    "error", "user not found"
            ));
        }

        if (user.comparePassword(login.password)) {
            HashMap<String, Object> tokenData = new HashMap<>();
            tokenData.put("id", user.getId());
            tokenData.put("role", user.getRole());
            String token = jwtUtil.generateToken(user.getFirstName() + " " + user.getLastName(), tokenData);
            return ResponseEntity.ok(Map.of(
                    "token", token,
                    "hospital_id",user.getHospital().getId(),
                    "user_id", user.getId(),
                    "role", user.getRole()
            ));
        } else {
            return ResponseEntity.status(404).body(Map.of(
                    "error", "wrong password"
            ));
        }

    }
}

