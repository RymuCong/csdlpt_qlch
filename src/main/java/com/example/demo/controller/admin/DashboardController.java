package com.example.demo.controller.admin;

import com.example.demo.service.EmployeeService;
import com.example.demo.service.ProductService;
import com.example.demo.service.BillService;
import com.example.demo.service.StoreService;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;

/**
 * Dashboard Controller - Tổng quan hệ thống
 */
@Controller
public class DashboardController {
    
    private final EmployeeService employeeService;
    private final ProductService productService;
    private final BillService billService;
    private final StoreService storeService;

    @Autowired
    public DashboardController(EmployeeService employeeService,
                              ProductService productService,
                              BillService billService,
                              StoreService storeService) {
        this.employeeService = employeeService;
        this.productService = productService;
        this.billService = billService;
        this.storeService = storeService;
    }

    /**
     * Dashboard admin - Hiển thị thống kê tổng quan
     */
    @GetMapping("/admin")
    public String getDashboard(Model model, HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        
        if (storeId != null) {
            // Thống kê theo cửa hàng
            Long employeeCount = (long) employeeService.getEmployeesByStore(storeId).size();
            Long productCount = productService.countProductsByStore(storeId);
            Long lowStockCount = productService.countLowStockProducts(storeId, 10);
            var dailyRevenue = billService.getDailyRevenueReport(LocalDate.now());
            
            model.addAttribute("employeeCount", employeeCount);
            model.addAttribute("productCount", productCount);
            model.addAttribute("lowStockCount", lowStockCount);
            model.addAttribute("dailyRevenue", dailyRevenue);
            model.addAttribute("storeId", storeId);
        } else {
            // Thống kê toàn hệ thống
            Long totalEmployees = (long) employeeService.getAllEmployees().size();
            Long totalStores = (long) storeService.getAllStores().size();
            Long totalBills = (long) billService.getAllBills().size();
            
            model.addAttribute("totalEmployees", totalEmployees);
            model.addAttribute("totalStores", totalStores);
            model.addAttribute("totalBills", totalBills);
        }
        
        return "admin/dashboard/show";
    }
}
