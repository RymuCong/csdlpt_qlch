package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Test class để generate BCrypt password hash
 */
public class PasswordEncoderTest {
    
    @Test
    public void generatePasswordHash() {
        PasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // Password: 123456
        String rawPassword = "123456";
        String encodedPassword = encoder.encode(rawPassword);
        
        System.out.println("================================================");
        System.out.println("RAW PASSWORD: " + rawPassword);
        System.out.println("ENCODED PASSWORD: " + encodedPassword);
        System.out.println("================================================");
        
        // Test verify
        boolean matches = encoder.matches(rawPassword, encodedPassword);
        System.out.println("Password matches: " + matches);
        
        // Test với hash hiện tại trong DB
        String currentHash = "$2a$10$C8bvPXxGVBOp8OVjSEMBiuXGlEpJLqjKv6bvN7FD6uBxJk8MjxQFa";
        boolean matchesCurrentHash = encoder.matches(rawPassword, currentHash);
        System.out.println("Matches current DB hash: " + matchesCurrentHash);
        System.out.println("================================================");
    }
}

