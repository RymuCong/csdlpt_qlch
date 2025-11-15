package com.example.demo.service;

import com.example.demo.domain.Employee;
import com.example.demo.repository.EmployeeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * Custom UserDetailsService cho Employee authentication
 * Sử dụng phone number làm username
 */
@Service
public class CustomEmployeeDetailsService implements UserDetailsService {
    
    private static final Logger log = LoggerFactory.getLogger(CustomEmployeeDetailsService.class);
    
    private final EmployeeRepository employeeRepository;
    
    public CustomEmployeeDetailsService(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.info("🔍 Loading user by phone: {}", username);
        
        // Username là phone number của nhân viên
        Employee employee = employeeRepository.findByPhone(username)
            .orElseThrow(() -> {
                log.error("❌ Không tìm thấy nhân viên với số điện thoại: {}", username);
                return new UsernameNotFoundException("Không tìm thấy nhân viên với số điện thoại: " + username);
            });
        
        log.info("✓ Found employee: {} - {}", employee.getId(), employee.getName());
        log.info("🔑 Password hash from DB (first 40 chars): {}", 
            employee.getPassword() != null ? employee.getPassword().substring(0, Math.min(40, employee.getPassword().length())) : "NULL");
        
        // DEBUG: Test password match
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        boolean matches = encoder.matches("123456", employee.getPassword());
        log.info("🧪 TEST: Does '123456' match stored hash? {}", matches);
        
        // Tạo UserDetails với role dựa trên PositionType
        // Format: ROLE_{POSITION_NAME}
        // Ví dụ: QUAN_LY -> ROLE_QUAN_LY
        String role = "ROLE_" + employee.getPosition().name();
        log.info("👤 Assigning role: {}", role);
        
        return new User(
            employee.getPhone(),     // username là phone
            employee.getPassword(),  // password đã được hash
            Collections.singletonList(new SimpleGrantedAuthority(role))
        );
    }
}

