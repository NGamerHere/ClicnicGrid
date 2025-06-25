package com.coderstack.clinicgrid.logging;

import com.coderstack.clinicgrid.model.Logs;
import com.coderstack.clinicgrid.repository.LogsRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@Component
public class RequestResponseLoggingFilter extends OncePerRequestFilter {

    private final LogsRepository logsRepository;

    public RequestResponseLoggingFilter(LogsRepository logsRepository) {
        this.logsRepository = logsRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        CachedBodyHttpServletRequest wrappedRequest = new CachedBodyHttpServletRequest(request);
        CachedBodyHttpServletResponse wrappedResponse = new CachedBodyHttpServletResponse(response);

        LocalDateTime start = LocalDateTime.now();
        long startTime = System.currentTimeMillis();

        filterChain.doFilter(wrappedRequest, wrappedResponse);

        long duration = System.currentTimeMillis() - startTime;

        Logs log = new Logs();
        log.setTimestamp(start);
        log.setDurationInMs(duration);
        log.setMethod(request.getMethod());
        log.setUrl(request.getRequestURL().toString());
        log.setClientIp(request.getRemoteAddr());
        log.setUserAgent(request.getHeader("User-Agent"));

        log.setRequestHeaders(getHeadersMap(request));
        log.setRequestBody(new String(wrappedRequest.getCachedBody()));

        log.setResponseStatus(response.getStatus());
        log.setResponseBody(new String(wrappedResponse.getCachedBody()));
        log.setResponseHeaders(getHeadersMap(response));

        logsRepository.save(log);

        wrappedResponse.copyBodyToResponse(); // send response to client
    }

    private Map<String, String> getHeadersMap(HttpServletRequest request) {
        Map<String, String> map = new HashMap<>();
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String name = headerNames.nextElement();
            map.put(name, request.getHeader(name));
        }
        return map;
    }

    private Map<String, String> getHeadersMap(HttpServletResponse response) {
        Map<String, String> map = new HashMap<>();
        for (String name : response.getHeaderNames()) {
            map.put(name, response.getHeader(name));
        }
        return map;
    }
}
