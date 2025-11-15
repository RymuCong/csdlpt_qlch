package com.example.demo.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utility class để generate BCrypt password hash
 * Chạy class này để tạo hash cho password
 */
public class PasswordHashGenerator {
    
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        String rawPassword = "123456";
        
        // Generate 3 hash khác nhau để test
        System.out.println("================================================");
        System.out.println("GENERATING BCRYPT HASHES FOR PASSWORD: " + rawPassword);
        System.out.println("================================================");
        
        for (int i = 1; i <= 3; i++) {
            String hash = encoder.encode(rawPassword);
            System.out.println("Hash " + i + ": " + hash);
            
            // Verify
            boolean matches = encoder.matches(rawPassword, hash);
            System.out.println("Verify: " + matches);
            System.out.println();
        }
        
        System.out.println("================================================");
        System.out.println("TESTING CURRENT HASH IN DATABASE:");
        System.out.println("================================================");
        
        // Test hash hiện tại trong DB
        String currentHash = "$2a$10$C8bvPXxGVBOp8OVjSEMBiuXGlEpJLqjKv6bvN7FD6uBxJk8MjxQFa";
        System.out.println("Current hash: " + currentHash);
        boolean matchesCurrentHash = encoder.matches(rawPassword, currentHash);
        System.out.println("Password '123456' matches current hash: " + matchesCurrentHash);
        
        System.out.println("================================================");
        System.out.println("RECOMMENDED SQL UPDATE STATEMENT:");
        System.out.println("================================================");
        String newHash = encoder.encode(rawPassword);
        System.out.println("UPDATE employee SET password = '" + newHash + "';");
        System.out.println("================================================");
    }
}

