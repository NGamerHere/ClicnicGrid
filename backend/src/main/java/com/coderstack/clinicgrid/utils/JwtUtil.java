package com.coderstack.clinicgrid.utils;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {

    @Value("${security.jwt.secret-key}")
    private String SECRET_KEY;

    @Value("${security.jwt.expiration-time}")
    private long TOKEN_VALIDITY;

    /* ───────────────────────────────── Signing Key ───────────────────────────────── */
    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
    }

    /* ─────────────────────────────── Token Generation ────────────────────────────── */

    /** Generate token with standard + custom claims */
    public String generateToken(String username,
                                Long userId,
                                String role) {

        Map<String, Object> claims = new HashMap<>();
        claims.put("uid",  userId);   // custom claim: user ID
        claims.put("role", role);     // custom claim: user role (e.g., ADMIN)

        return createToken(claims, username);
    }

    /** Generate token when you already have a map of claims */
    public String generateToken(String username,
                                Map<String, Object> customClaims) {
        return createToken(customClaims, username);
    }

    private String createToken(Map<String, Object> claims, String subject) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
                .setClaims(claims)                    // custom claims here
                .setSubject(subject)                  // usually the username / email
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + TOKEN_VALIDITY))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /* ─────────────────────────────── Token Validation ────────────────────────────── */

    public boolean isTokenValid(String token, String username) {
        return extractUsername(token).equals(username) && !isTokenExpired(token);
    }

    /* ─────────────────────────────── Claim Extractors ────────────────────────────── */

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /** Custom extractor: get user ID */
    public Long extractUserId(String token) {
        return extractClaim(token, claims -> claims.get("uid", Long.class));
    }

    /** Custom extractor: get role */
    public String extractUserRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }

    /* ───────────────────────────────── Internals ─────────────────────────────────── */

    private <T> T extractClaim(String token, Function<Claims, T> resolver) {
        return resolver.apply(extractAllClaims(token));
    }

    public Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }
}
