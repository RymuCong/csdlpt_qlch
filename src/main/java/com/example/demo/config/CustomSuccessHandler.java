package com.example.demo.config;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.example.demo.domain.Employee;
import com.example.demo.service.EmployeeService;

import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Custom Success Handler cho Employee authentication
 * Redirect dựa trên PositionType của nhân viên
 */
public class CustomSuccessHandler implements AuthenticationSuccessHandler {
    
    @Autowired
    private EmployeeService employeeService;

    protected String determineTargetUrl(final Authentication authentication) {
        Map<String, String> roleTargetUrlMap = new HashMap<>();
        
        // ADMIN (Administrator) -> Admin Dashboard
        roleTargetUrlMap.put("ROLE_ADMIN", "/admin");
        
        // QUAN_LY (Manager) -> Admin Dashboard
        roleTargetUrlMap.put("ROLE_QUAN_LY", "/admin");
        
        // KE_TOAN (Accountant) -> Admin Dashboard (Reports)
        roleTargetUrlMap.put("ROLE_KE_TOAN", "/admin");
        
        // BAN_HANG (Sales) -> POS System
        roleTargetUrlMap.put("ROLE_BAN_HANG", "/pos");
        
        // KHO (Warehouse) -> Inventory Management
        roleTargetUrlMap.put("ROLE_KHO", "/admin/product");
        
        // BAO_VE, VE_SINH -> Homepage
        roleTargetUrlMap.put("ROLE_BAO_VE", "/");
        roleTargetUrlMap.put("ROLE_VE_SINH", "/");

        final Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (final GrantedAuthority grantedAuthority : authorities) {
            String authorityName = grantedAuthority.getAuthority();
            if (roleTargetUrlMap.containsKey(authorityName)) {
                return roleTargetUrlMap.get(authorityName);
            }
        }

        // Default redirect
        return "/";
    }

    protected void clearAuthenticationAttributes(HttpServletRequest request, Authentication authentication) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
        
        // Username là phone number
        String phone = authentication.getName();
        Employee employee = this.employeeService.getEmployeeByPhone(phone).orElse(null);
        
        if (employee != null) {
            session.setAttribute("employeeId", employee.getId());
            session.setAttribute("employeeName", employee.getName());
            session.setAttribute("employeePhone", employee.getPhone());
            session.setAttribute("employeePosition", employee.getPosition().name());
            session.setAttribute("employeePositionDisplay", employee.getPosition().getDisplayName());
            session.setAttribute("storeId", employee.getStore().getId());
        }
    }

    private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        String targetUrl = determineTargetUrl(authentication);

        if (response.isCommitted()) {
            return;
        }

        redirectStrategy.sendRedirect(request, response, targetUrl);
        clearAuthenticationAttributes(request, authentication);
    }
}
