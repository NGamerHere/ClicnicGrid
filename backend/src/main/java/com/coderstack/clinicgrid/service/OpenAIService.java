package com.coderstack.clinicgrid.service;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service
public class OpenAIService {

    @Value("${openai.api.key}")
    private String apiKey;

    public String sendMessage(String prompt) throws IOException, InterruptedException {
        // Create the HTTP request to OpenAI
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(
                        """
                        {
                          "model": "gpt-3.5-turbo",
                          "messages": [{"role": "user", "content": "%s"}]
                        }
                        """.formatted(prompt)
                ))
                .build();

        // Send request
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        return response.body();
    }
}

