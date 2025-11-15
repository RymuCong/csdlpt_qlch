package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Controller xử lý authentication
 * - Login page
 * - Access denied page
 */
@Controller
public class AuthController {

    /**
     * Hiển thị trang đăng nhập
     * @param error - có lỗi đăng nhập không
     * @param logout - vừa đăng xuất không
     * @param model
     * @return trang login
     */
    @GetMapping("/login")
    public String getLoginPage(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            Model model) {
        
        if (error != null) {
            model.addAttribute("error", "Số điện thoại hoặc mật khẩu không đúng!");
        }
        
        if (logout != null) {
            model.addAttribute("message", "Đăng xuất thành công!");
        }
        
        return "client/auth/login";
    }

    /**
     * Hiển thị trang access denied
     * @return trang deny
     */
    @GetMapping("/access-deny")
    public String getDenyPage() {
        return "client/auth/deny";
    }
}

