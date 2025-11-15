package com.example.demo.controller.admin;

import com.example.demo.domain.PayRoll;
import com.example.demo.service.PayRollService;
import com.example.demo.service.PayRollService.PayRollDTO;
import com.example.demo.service.PayRollService.PayrollReport;
import com.example.demo.service.PayRollService.SalaryEstimate;
import com.example.demo.service.EmployeeService;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
    
    private static final Logger log = LoggerFactory.getLogger(PayRollController.class);
    
    private final PayRollService payRollService;
    private final EmployeeService employeeService;

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
        log.debug("🔍 showPayRolls() được gọi - payMonth: {}", payMonth);
        String storeId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        log.debug("📊 Session - storeId: {}, employeePosition: {}", storeId, employeePosition);
        
        // Nếu là TS01 (trụ sở chính) hoặc ADMIN, hiển thị tất cả bảng lương
        // Nếu là chi nhánh (CN01-CN07), chỉ hiển thị bảng lương của chi nhánh đó
        boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        List<PayRoll> payRolls;
        Long totalSalary = 0L;
        
        if (payMonth != null) {
            // Có filter theo tháng
            log.debug("🔍 Filtering with payMonth: {}", payMonth);
            if (shouldFilterByStore) {
                log.debug("🔍 Filtering by store: {} for month: {}", storeId, payMonth);
                payRolls = payRollService.getPayRollsByStoreAndMonth(storeId, payMonth);
                totalSalary = payRollService.calculateTotalPayrollByStore(storeId, payMonth);
            } else {
                log.debug("🔍 Getting all payrolls for month: {}", payMonth);
                payRolls = payRollService.getPayRollsByMonth(payMonth);
                totalSalary = payRollService.calculateTotalPayrollByMonth(payMonth);
            }
        } else {
            // Không có filter, hiển thị TẤT CẢ bảng lương (không filter theo tháng)
            log.debug("ℹ️ No payMonth param, showing ALL payrolls");
            if (shouldFilterByStore) {
                log.debug("🔍 Getting all payrolls for store: {}", storeId);
                payRolls = payRollService.getPayRollsByStore(storeId);
                // Tính tổng lương của tất cả tháng
                totalSalary = payRolls.stream().mapToLong(PayRoll::getTotal).sum();
            } else {
                log.debug("🔍 Getting all payrolls (all stores)");
                payRolls = payRollService.getAllPayRolls();
                // Tính tổng lương của tất cả tháng
                totalSalary = payRolls.stream().mapToLong(PayRoll::getTotal).sum();
            }
            payMonth = null; // Không có tháng cụ thể
        }
        
        log.debug("📊 Found {} payroll records, totalSalary: {}", payRolls.size(), totalSalary);
        
        // Lấy danh sách các tháng có dữ liệu để gợi ý (theo store nếu cần)
        List<LocalDate> availableMonths;
        if (shouldFilterByStore && storeId != null) {
            availableMonths = payRollService.getAvailableMonthsByStore(storeId);
            log.debug("📅 Available months for store {}: {}", storeId, availableMonths);
        } else {
            availableMonths = payRollService.getAvailableMonths();
            log.debug("📅 Available months (all stores): {}", availableMonths);
        }
        
        model.addAttribute("payrolls", payRolls);  // Sửa từ payRolls thành payrolls để khớp với JSP
        model.addAttribute("selectedMonth", payMonth);
        model.addAttribute("totalSalary", totalSalary);
        model.addAttribute("availableMonths", availableMonths);
        return "admin/payroll/show";
    }
    
    /**
     * Filter bảng lương theo tháng (từ form với input type="month")
     */
    @GetMapping("/filter")
    public String filterPayRolls(@RequestParam(required = false) String month,
                                 Model model,
                                 HttpSession session) {
        log.debug("🔍 filterPayRolls() được gọi - month param: {}", month);
        LocalDate payMonth;
        
        // Xử lý format tháng từ input type="month" (format: "YYYY-MM")
        if (month != null && !month.isEmpty()) {
            try {
                // Parse "2024-10" thành LocalDate (ngày 1 của tháng đó)
                String[] parts = month.split("-");
                if (parts.length == 2) {
                    int year = Integer.parseInt(parts[0]);
                    int monthValue = Integer.parseInt(parts[1]);
                    payMonth = LocalDate.of(year, monthValue, 1);
                    log.debug("✅ Parsed month: {} -> payMonth: {}", month, payMonth);
                } else {
                    payMonth = LocalDate.now().withDayOfMonth(1);
                    log.warn("⚠️ Invalid month format: {}, using current month", month);
                }
            } catch (Exception e) {
                payMonth = LocalDate.now().withDayOfMonth(1);
                log.error("❌ Error parsing month: {}, using current month", month, e);
            }
        } else {
            payMonth = LocalDate.now().withDayOfMonth(1);
            log.debug("ℹ️ No month param, using current month: {}", payMonth);
        }
        
        String storeId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        log.debug("📊 Session - storeId: {}, employeePosition: {}", storeId, employeePosition);
        
        // Nếu là TS01 (trụ sở chính) hoặc ADMIN, hiển thị tất cả bảng lương
        // Nếu là chi nhánh (CN01-CN07), chỉ hiển thị bảng lương của chi nhánh đó
        boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        List<PayRoll> payRolls;
        Long totalSalary = 0L;
        if (shouldFilterByStore) {
            log.debug("🔍 Filtering by store: {} for month: {}", storeId, payMonth);
            payRolls = payRollService.getPayRollsByStoreAndMonth(storeId, payMonth);
            totalSalary = payRollService.calculateTotalPayrollByStore(storeId, payMonth);
        } else {
            log.debug("🔍 Getting all payrolls for month: {}", payMonth);
            payRolls = payRollService.getPayRollsByMonth(payMonth);
            totalSalary = payRollService.calculateTotalPayrollByMonth(payMonth);
        }
        
        log.debug("📊 Found {} payroll records, totalSalary: {}", payRolls.size(), totalSalary);
        
        // Lấy danh sách các tháng có dữ liệu để gợi ý (theo store nếu cần)
        List<LocalDate> availableMonths;
        if (shouldFilterByStore && storeId != null) {
            availableMonths = payRollService.getAvailableMonthsByStore(storeId);
            log.debug("📅 Available months for store {}: {}", storeId, availableMonths);
        } else {
            availableMonths = payRollService.getAvailableMonths();
            log.debug("📅 Available months (all stores): {}", availableMonths);
        }
        
        model.addAttribute("payrolls", payRolls);  // Sửa từ payRolls thành payrolls để khớp với JSP
        model.addAttribute("selectedMonth", payMonth);
        model.addAttribute("totalSalary", totalSalary);
        model.addAttribute("availableMonths", availableMonths);
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
        String employeePosition = (String) session.getAttribute("employeePosition");
        
        // Nếu là TS01 (trụ sở chính) hoặc ADMIN, hiển thị tất cả nhân viên
        // Nếu là chi nhánh (CN01-CN07), chỉ hiển thị nhân viên của chi nhánh đó
        boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        if (shouldFilterByStore) {
            model.addAttribute("employees", employeeService.getEmployeesByStore(storeId));
        } else {
            model.addAttribute("employees", employeeService.getAllEmployees());
        }
        
        // Tạo PayRollDTO mới cho form
        PayRollDTO payRollDTO = new PayRollDTO();
        if (employeeId != null) {
            payRollDTO.setEmployeeId(employeeId);
        }
        model.addAttribute("payRollDTO", payRollDTO);
        model.addAttribute("selectedEmployeeId", employeeId);
        return "admin/payroll/create";
    }
    
    /**
     * Xử lý tạo bảng lương
     */
    @PostMapping("/create")
    public String createPayRoll(@RequestParam(required = false) String employeeId,
                                @RequestParam(required = false) String payMonth,
                                @RequestParam(required = false) Integer workingHours,
                                @RequestParam(required = false) Integer bonus,
                                Model model,
                                HttpSession session) {
        try {
            // Parse payMonth từ format "YYYY-MM" (từ input type="month")
            LocalDate payMonthDate = null;
            if (payMonth != null && !payMonth.isEmpty()) {
                try {
                    String[] parts = payMonth.split("-");
                    if (parts.length == 2) {
                        int year = Integer.parseInt(parts[0]);
                        int monthValue = Integer.parseInt(parts[1]);
                        payMonthDate = LocalDate.of(year, monthValue, 1);
                    }
                } catch (Exception e) {
                    model.addAttribute("error", "Định dạng tháng không hợp lệ");
                    String storeId = (String) session.getAttribute("storeId");
                    String employeePosition = (String) session.getAttribute("employeePosition");
                    boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                                 && !"ADMIN".equals(employeePosition);
                    if (shouldFilterByStore) {
                        model.addAttribute("employees", employeeService.getEmployeesByStore(storeId));
                    } else {
                        model.addAttribute("employees", employeeService.getAllEmployees());
                    }
                    PayRollDTO payRollDTO = new PayRollDTO();
                    model.addAttribute("payRollDTO", payRollDTO);
                    return "admin/payroll/create";
                }
            }
            
            if (payMonthDate == null || employeeId == null || workingHours == null) {
                model.addAttribute("error", "Vui lòng điền đầy đủ thông tin");
                String storeId = (String) session.getAttribute("storeId");
                String employeePosition = (String) session.getAttribute("employeePosition");
                boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                             && !"ADMIN".equals(employeePosition);
                if (shouldFilterByStore) {
                    model.addAttribute("employees", employeeService.getEmployeesByStore(storeId));
                } else {
                    model.addAttribute("employees", employeeService.getAllEmployees());
                }
                PayRollDTO payRollDTO = new PayRollDTO();
                model.addAttribute("payRollDTO", payRollDTO);
                return "admin/payroll/create";
            }
            
            PayRollDTO payRollDTO = new PayRollDTO();
            payRollDTO.setEmployeeId(employeeId);
            payRollDTO.setPayMonth(payMonthDate);
            payRollDTO.setWorkingHours(workingHours);
            payRollDTO.setBonus(bonus != null ? bonus : 0);
            
            payRollService.createPayRoll(payRollDTO);
            return "redirect:/admin/payroll?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            String storeId = (String) session.getAttribute("storeId");
            String employeePosition = (String) session.getAttribute("employeePosition");
            boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                         && !"ADMIN".equals(employeePosition);
            if (shouldFilterByStore) {
                model.addAttribute("employees", employeeService.getEmployeesByStore(storeId));
            } else {
                model.addAttribute("employees", employeeService.getAllEmployees());
            }
            PayRollDTO payRollDTO = new PayRollDTO();
            model.addAttribute("payRollDTO", payRollDTO);
            return "admin/payroll/create";
        }
    }
    
    /**
     * Tính lương (redirect đến batch-create)
     */
    @GetMapping("/calculate")
    public String showCalculateForm(Model model, HttpSession session) {
        // Redirect đến batch-create form
        return "redirect:/admin/payroll/batch-create";
    }
    
    /**
     * Tính lương hàng loạt cho cửa hàng
     */
    @GetMapping("/batch-create")
    public String showBatchCreateForm(Model model, HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        
        // Batch create chỉ áp dụng cho chi nhánh cụ thể, không áp dụng cho TS01
        if (storeId == null || storeId.equals("TS01") || "ADMIN".equals(employeePosition)) {
            return "redirect:/admin/payroll?error=batch_create_only_for_branches";
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
                                    @RequestParam String payMonth,
                                    @RequestParam Integer defaultWorkingHours,
                                    @RequestParam(defaultValue = "0") Integer defaultBonus) {
        try {
            // Parse payMonth từ format "YYYY-MM" (từ input type="month")
            LocalDate payMonthDate = null;
            if (payMonth != null && !payMonth.isEmpty()) {
                try {
                    String[] parts = payMonth.split("-");
                    if (parts.length == 2) {
                        int year = Integer.parseInt(parts[0]);
                        int monthValue = Integer.parseInt(parts[1]);
                        payMonthDate = LocalDate.of(year, monthValue, 1);
                    }
                } catch (Exception e) {
                    return "redirect:/admin/payroll?error=invalid_month_format";
                }
            }
            
            if (payMonthDate == null) {
                return "redirect:/admin/payroll?error=month_required";
            }
            
            payRollService.createPayRollForStore(storeId, payMonthDate, defaultWorkingHours, defaultBonus);
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
     * In phiếu lương (Print payroll)
     */
    @GetMapping("/{id}/print")
    public String printPayRoll(@PathVariable String id, Model model) {
        Optional<PayRoll> payRoll = payRollService.getPayRollById(id);
        if (payRoll.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("payroll", payRoll.get());
        return "admin/payroll/print";
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
                                   @RequestParam(required = false) String payMonth,
                                   Model model,
                                   HttpSession session) {
        if (storeId == null) {
            storeId = (String) session.getAttribute("storeId");
        }
        
        LocalDate payMonthDate = null;
        // Xử lý format tháng từ input type="month" (format: "YYYY-MM")
        if (payMonth != null && !payMonth.isEmpty()) {
            try {
                String[] parts = payMonth.split("-");
                if (parts.length == 2) {
                    int year = Integer.parseInt(parts[0]);
                    int monthValue = Integer.parseInt(parts[1]);
                    payMonthDate = LocalDate.of(year, monthValue, 1);
                }
            } catch (Exception e) {
                log.error("❌ Error parsing payMonth: {}", payMonth, e);
            }
        }
        
        if (payMonthDate == null) {
            payMonthDate = LocalDate.now().withDayOfMonth(1);
        }
        
        if (storeId == null) {
            return "redirect:/admin/payroll?error=no_store";
        }
        
        PayrollReport report = payRollService.getPayrollReport(storeId, payMonthDate);
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

