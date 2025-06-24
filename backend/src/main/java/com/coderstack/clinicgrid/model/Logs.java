package com.coderstack.clinicgrid.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.Map;

@Document(collection = "logs")
public class Logs {

    @Id
    private String id;

    // HTTP method (GET, POST, etc.)
    private String method;

    // Full request URL
    private String url;

    // Request headers (optional)
    private Map<String, String> requestHeaders;

    // Request body (if any)
    private String requestBody;

    // Response status code (e.g. 200, 404, etc.)
    private int responseStatus;

    // Response body
    private String responseBody;

    // Response headers (optional)
    private Map<String, String> responseHeaders;

    // Time of request
    private LocalDateTime timestamp;

    // Time taken to serve the request
    private long durationInMs;

    // Client IP address (optional)
    private String clientIp;

    // User-Agent (optional)
    private String userAgent;

    public Logs() {}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Map<String, String> getRequestHeaders() {
        return requestHeaders;
    }

    public void setRequestHeaders(Map<String, String> requestHeaders) {
        this.requestHeaders = requestHeaders;
    }

    public String getRequestBody() {
        return requestBody;
    }

    public void setRequestBody(String requestBody) {
        this.requestBody = requestBody;
    }

    public int getResponseStatus() {
        return responseStatus;
    }

    public void setResponseStatus(int responseStatus) {
        this.responseStatus = responseStatus;
    }

    public String getResponseBody() {
        return responseBody;
    }

    public void setResponseBody(String responseBody) {
        this.responseBody = responseBody;
    }

    public Map<String, String> getResponseHeaders() {
        return responseHeaders;
    }

    public void setResponseHeaders(Map<String, String> responseHeaders) {
        this.responseHeaders = responseHeaders;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public long getDurationInMs() {
        return durationInMs;
    }

    public void setDurationInMs(long durationInMs) {
        this.durationInMs = durationInMs;
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
// --- Getters and Setters ---
    // You can generate these using your IDE

    // Add all necessary getters & setters here

    // Optional: Override toString() for easy debugging
    @Override
    public String toString() {
        return "Logs{" +
                "id='" + id + '\'' +
                ", method='" + method + '\'' +
                ", url='" + url + '\'' +
                ", responseStatus=" + responseStatus +
                ", timestamp=" + timestamp +
                ", durationInMs=" + durationInMs +
                '}';
    }
}
