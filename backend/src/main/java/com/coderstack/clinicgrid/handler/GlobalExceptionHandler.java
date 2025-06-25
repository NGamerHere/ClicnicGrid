package com.coderstack.clinicgrid.handler;

import com.coderstack.clinicgrid.exceptions.BadRequestException;
import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationErrors(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        StringBuilder valError = new StringBuilder();

        ex.getBindingResult().getFieldErrors().forEach(error -> {
            valError.append(error.getDefaultMessage()).append(" \n ");
        });

        errors.put("error", valError.toString().trim());
        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
    }


    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Object> handleResourceNotFoundException(ResourceNotFoundException ex, WebRequest request) {
        Map<String, Object> response = new HashMap<>();
        response.put("error", ex.getMessage());
        //response.put("path", request.getDescription(false).substring(4));
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }
    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<Object> handleBadRequestException(ResourceNotFoundException ex, WebRequest request) {
        Map<String, Object> response = new HashMap<>();
        response.put("error", ex.getMessage());
        //response.put("path", request.getDescription(false).substring(4));
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }
}
