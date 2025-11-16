package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.session.security.web.authentication.SpringSessionRememberMeServices;

import com.example.demo.service.CustomEmployeeDetailsService;
import com.example.demo.repository.EmployeeRepository;

import jakarta.servlet.DispatcherType;

/**
 * Security Configuration cho hệ thống POS
 * Sử dụng Employee authentication với PositionType roles
 */
@Configuration
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfiguration {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService(EmployeeRepository employeeRepository) {
        return new CustomEmployeeDetailsService(employeeRepository);
    }

    @Bean
    public DaoAuthenticationProvider authProvider(
            PasswordEncoder passwordEncoder,
            UserDetailsService userDetailsService) {
                
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder);
        // authProvider.setHideUserNotFoundExceptions(false);
        return authProvider;
    }

    @Bean
    public AuthenticationSuccessHandler customSuccessHandler() {
        return new CustomSuccessHandler();
    }

    
    @Bean
    public SpringSessionRememberMeServices rememberMeServices() {
        SpringSessionRememberMeServices rememberMeServices = new SpringSessionRememberMeServices();
        // optionally customize
        rememberMeServices.setAlwaysRemember(true);

        return rememberMeServices;
    }

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        // v6. lamda
        http
                .authorizeHttpRequests(authorize -> authorize
                        .dispatcherTypeMatchers(DispatcherType.FORWARD,
                                DispatcherType.INCLUDE)
                        .permitAll()

                        .requestMatchers("/", "/login", "/access-deny", "/client/**", "/css/**", "/js/**", "/images/**", "/product/**", "/resources/**")
                        .permitAll()

                        // Employee create/update/delete - chỉ ADMIN mới có quyền
                        .requestMatchers("/admin/employee/create", "/admin/employee/create/**", 
                                        "/admin/employee/update/**", "/admin/employee/delete/**")
                        .hasRole("ADMIN")
                        
                        // Category create/update/delete - chỉ ADMIN mới có quyền
                        .requestMatchers("/admin/category/create", "/admin/category/create/**",
                                        "/admin/category/update/**", "/admin/category/delete/**")
                        .hasRole("ADMIN")
                        
                        // Category view - tất cả role có quyền xem
                        .requestMatchers("/admin/category", "/admin/category/**")
                        .hasAnyRole("ADMIN", "QUAN_LY", "KE_TOAN", "KHO")
                        
                        // Admin Dashboard - KHO cần truy cập để xem layout
                        .requestMatchers("/admin", "/admin/")
                        .hasAnyRole("ADMIN", "QUAN_LY", "KE_TOAN", "KHO")
                        
                        // Product management routes - KHO (Warehouse) có quyền truy cập
                        .requestMatchers("/admin/product/**", "/admin/product")
                        .hasAnyRole("ADMIN", "QUAN_LY", "KE_TOAN", "KHO")
                        
                        // Admin routes - ADMIN, QUAN_LY (Manager) và KE_TOAN có quyền truy cập
                        .requestMatchers("/admin/**").hasAnyRole("ADMIN", "QUAN_LY", "KE_TOAN")
                        
                        // POS routes - Bán hàng, Quản lý và ADMIN
                        .requestMatchers("/pos/**").hasAnyRole("BAN_HANG", "QUAN_LY", "ADMIN")
                        
                        // Report routes - ADMIN, Quản lý và Kế toán
                        .requestMatchers("/report/**").hasAnyRole("ADMIN", "QUAN_LY", "KE_TOAN")

                        .anyRequest().authenticated())

                .sessionManagement((sessionManagement) -> sessionManagement
                        .sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
                        .invalidSessionUrl("/logout?expired")
                        .maximumSessions(1)
                        .maxSessionsPreventsLogin(false))
                    
                .logout(logout -> logout.deleteCookies("JSESSIONID").invalidateHttpSession(true))

                .rememberMe(r -> r.rememberMeServices(rememberMeServices()))
                .formLogin(formLogin -> formLogin
                        .loginPage("/login")
                        .failureUrl("/login?error")
                        .successHandler(customSuccessHandler())
                        .permitAll())
                .exceptionHandling(ex -> ex.accessDeniedPage("/access-deny"));

        return http.build();
    }

    

}
