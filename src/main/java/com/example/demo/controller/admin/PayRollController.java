package com.example.demo.controller.admin;

import com.example.demo.domain.PayRoll;
import com.example.demo.service.PayRollService;
import com.example.demo.service.PayRollService.PayRollDTO;
import com.example.demo.service.PayRollService.PayrollReport;
import com.example.demo.service.PayRollService.SalaryEstimate;
import com.example.demo.service.EmployeeService;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * PayRoll Controller - Quản lý bảng lương nhân viên
 */
@Controller
@RequestMapping("/admin/payroll")
public class PayRollController {
    
    private final PayRollService payRollService;
    private final EmployeeService employeeService;

    @Autowired
    public PayRollController(PayRollService payRollService, EmployeeService employeeService) {
        this.payRollService = payRollService;
        this.employeeService = employeeService;
    }
    
    /**
     * Hiển thị danh sách bảng lương (theo tháng)
     */
    @GetMapping
    public String showPayRolls(@RequestParam(required = false) 
                              @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate payMonth,
                              Model model,
                              HttpSession session) {
        if (payMonth == null) {
            payMonth = LocalDate.now().withDayOfMonth(1);
        }
        
        String storeId = (String) session.getAttribute("storeId");
        List<PayRoll> payRolls;
        
        if (storeId != null) {
            payRolls = payRollService.getPayRollsByStoreAndMonth(storeId, payMonth);
        } else {
            payRolls = payRollService.getPayRollsByMonth(payMonth);
        }
        
        model.addAttribute("payRolls", payRolls);
        model.addAttribute("selectedMonth", payMonth);
        return "admin/payroll/show";
    }
    
    /**
     * Hiển thị form tạo bảng lương
     */
    @GetMapping("/create")
    public String showCreateForm(@RequestParam(required = false) String employeeId,
                                 Model model,
                                 HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        
        if (storeId != null) {
            model.addAttribute("employees", employeeService.getEmployeesByStore(storeId));
        } else {
            model.addAttribute("employees", employeeService.getAllEmployees());
        }
        
        model.addAttribute("selectedEmployeeId", employeeId);
        return "admin/payroll/create";
    }
    
    /**
     * Xử lý tạo bảng lương
     */
    @PostMapping("/create")
    public String createPayRoll(@ModelAttribute PayRollDTO payRollDTO, Model model) {
        try {
            payRollService.createPayRoll(payRollDTO);
            return "redirect:/admin/payroll?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("employees", employeeService.getAllEmployees());
            return "admin/payroll/create";
        }
    }
    
    /**
     * Tính lương hàng loạt cho cửa hàng
     */
    @GetMapping("/batch-create")
    public String showBatchCreateForm(Model model, HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        if (storeId == null) {
            return "redirect:/admin/payroll?error=no_store";
        }
        
        model.addAttribute("storeId", storeId);
        model.addAttribute("employees", employeeService.getEmployeesByStore(storeId));
        return "admin/payroll/batch-create";
    }
    
    /**
     * Xử lý tính lương hàng loạt
     */
    @PostMapping("/batch-create")
    public String batchCreatePayRoll(@RequestParam String storeId,
                                    @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate payMonth,
                                    @RequestParam Integer defaultWorkingHours,
                                    @RequestParam(defaultValue = "0") Integer defaultBonus) {
        try {
            payRollService.createPayRollForStore(storeId, payMonth, defaultWorkingHours, defaultBonus);
            return "redirect:/admin/payroll?batch_success";
        } catch (Exception e) {
            return "redirect:/admin/payroll?error=" + e.getMessage();
        }
    }
    
    /**
     * Hiển thị chi tiết bảng lương
     */
    @GetMapping("/{id}")
    public String showPayRollDetail(@PathVariable String id, Model model) {
        Optional<PayRoll> payRoll = payRollService.getPayRollById(id);
        if (payRoll.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("payRoll", payRoll.get());
        return "admin/payroll/detail";
    }
    
    /**
     * Hiển thị form cập nhật bảng lương
     */
    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable String id, Model model) {
        Optional<PayRoll> payRoll = payRollService.getPayRollById(id);
        if (payRoll.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("payRoll", payRoll.get());
        return "admin/payroll/update";
    }
    
    /**
     * Xử lý cập nhật bảng lương
     */
    @PostMapping("/update")
    public String updatePayRoll(@RequestParam String payId,
                               @RequestParam Integer workingHours,
                               @RequestParam Integer bonus,
                               Model model) {
        try {
            PayRollDTO dto = new PayRollDTO();
            dto.setWorkingHours(workingHours);
            dto.setBonus(bonus);
            
            payRollService.updatePayRoll(payId, dto);
            return "redirect:/admin/payroll?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/payroll/update";
        }
    }
    
    /**
     * Xóa bảng lương
     */
    @PostMapping("/delete")
    public String deletePayRoll(@RequestParam String id) {
        try {
            payRollService.deletePayRoll(id);
            return "redirect:/admin/payroll?deleted";
        } catch (Exception e) {
            return "redirect:/admin/payroll?error=" + e.getMessage();
        }
    }
    
    /**
     * Báo cáo lương theo cửa hàng và tháng
     */
    @GetMapping("/report")
    public String showPayrollReport(@RequestParam(required = false) String storeId,
                                   @RequestParam(required = false) 
                                   @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate payMonth,
                                   Model model,
                                   HttpSession session) {
        if (storeId == null) {
            storeId = (String) session.getAttribute("storeId");
        }
        
        if (payMonth == null) {
            payMonth = LocalDate.now().withDayOfMonth(1);
        }
        
        if (storeId == null) {
            return "redirect:/admin/payroll?error=no_store";
        }
        
        PayrollReport report = payRollService.getPayrollReport(storeId, payMonth);
        model.addAttribute("report", report);
        return "admin/payroll/report";
    }
    
    /**
     * Dự tính lương (Salary Estimator)
     */
    @GetMapping("/estimate")
    @ResponseBody
    public SalaryEstimate estimateSalary(@RequestParam String employeeId,
                                        @RequestParam Integer workingHours,
                                        @RequestParam(defaultValue = "0") Integer bonus) {
        return payRollService.estimateSalary(employeeId, workingHours, bonus);
    }
}

