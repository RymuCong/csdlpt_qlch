package com.example.demo.controller.admin;

import com.example.demo.domain.Bill;
import com.example.demo.enums.PaymentMethodType;
import com.example.demo.service.BillService;
import com.example.demo.service.BillService.BillDTO;
import com.example.demo.service.BillService.DailyRevenueReport;
import com.example.demo.service.CustomerService;
import com.example.demo.service.EmployeeService;
import com.example.demo.service.ProductService;

import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Bill Controller - POS System
 * Thay thế OrderController cũ với logic hóa đơn mới
 */
@Controller
@RequestMapping("/admin/bill")
public class BillController {
    
    private final BillService billService;
    private final EmployeeService employeeService;
    private final CustomerService customerService;
    private final ProductService productService;

    public BillController(BillService billService,
                         EmployeeService employeeService,
                         CustomerService customerService,
                         ProductService productService) {
        this.billService = billService;
        this.employeeService = employeeService;
        this.customerService = customerService;
        this.productService = productService;
    }
    
    /**
     * Hiển thị danh sách hóa đơn
     * Trả về TẤT CẢ dữ liệu để DataTables xử lý phân trang ở client-side
     */
    @GetMapping
    public String showBills(Model model) {
        List<Bill> bills = billService.getAllBills();
        model.addAttribute("bills", bills);
        return "admin/bill/show";
    }
    
    /**
     * Hiển thị form tạo hóa đơn mới (POS)
     */
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        // Lấy thông tin nhân viên từ session
        String employeeId = (String) session.getAttribute("employeeId");
        String storeId = (String) session.getAttribute("storeId");
        
        // Lấy danh sách sản phẩm theo cửa hàng
        if (storeId != null) {
            model.addAttribute("products", productService.getProductsByStore(storeId));
        }
        
        model.addAttribute("customers", customerService.getAllCustomers());
        model.addAttribute("paymentMethods", PaymentMethodType.values());
        model.addAttribute("defaultEmployeeId", employeeId);
        
        return "admin/bill/create";
    }
    
    /**
     * Xử lý tạo hóa đơn mới (API endpoint cho AJAX)
     */
    @PostMapping("/create")
    @ResponseBody
    public ResponseResult createBill(@RequestBody BillDTO billDTO) {
        try {
            Bill bill = billService.createBill(billDTO);
            return new ResponseResult(true, "Tạo hóa đơn thành công", bill.getId());
        } catch (Exception e) {
            return new ResponseResult(false, "Lỗi: " + e.getMessage(), null);
        }
    }
    
    /**
     * Hiển thị chi tiết hóa đơn
     */
    @GetMapping("/{id}")
    public String showBillDetail(@PathVariable String id, Model model) {
        Optional<Bill> bill = billService.getBillById(id);
        if (bill.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("bill", bill.get());
        model.addAttribute("billDetails", bill.get().getBillDetails());
        return "admin/bill/detail";
    }
    
    /**
     * In hóa đơn (Print receipt)
     */
    @GetMapping("/{id}/print")
    public String printBill(@PathVariable String id, Model model) {
        Optional<Bill> bill = billService.getBillById(id);
        if (bill.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("bill", bill.get());
        return "admin/bill/print";
    }
    
    /**
     * Xóa hóa đơn (chỉ admin)
     */
    @PostMapping("/delete")
    public String deleteBill(@RequestParam String id) {
        try {
            billService.deleteBill(id);
            return "redirect:/admin/bill?deleted";
        } catch (Exception e) {
            return "redirect:/admin/bill?error=" + e.getMessage();
        }
    }
    
    // ============= BÁO CÁO =============
    
    /**
     * Báo cáo doanh thu theo ngày
     */
    @GetMapping("/report/daily")
    public String showDailyReport(@RequestParam(required = false) 
                                  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
                                  Model model) {
        if (date == null) {
            date = LocalDate.now();
        }
        
        DailyRevenueReport report = billService.getDailyRevenueReport(date);
        model.addAttribute("report", report);
        model.addAttribute("selectedDate", date);
        return "admin/bill/daily-report";
    }
    
    /**
     * Báo cáo doanh thu theo khoảng thời gian
     */
    @GetMapping("/report/range")
    public String showRangeReport(@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
                                  @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
                                  Model model) {
        // Nếu không có parameters, hiển thị form mặc định với 30 ngày gần nhất
        if (startDate == null || endDate == null) {
            endDate = LocalDate.now();
            startDate = endDate.minusDays(30);
        }
        LocalDateTime startDateTime = startDate.atStartOfDay();
        LocalDateTime endDateTime = endDate.plusDays(1).atStartOfDay();
        
        List<Bill> bills = billService.getBillsByDateRange(startDateTime, endDateTime);
        BigDecimal totalRevenue = billService.calculateRevenueByDateRange(startDateTime, endDateTime);
        
        model.addAttribute("bills", bills);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        return "admin/bill/range-report";
    }
    
    /**
     * Báo cáo hiệu suất nhân viên
     */
    @GetMapping("/report/employee")
    public String showEmployeePerformance(@RequestParam String employeeId,
                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
                                         Model model) {
        var performance = billService.getEmployeePerformanceReport(employeeId, startDate, endDate);
        model.addAttribute("performance", performance);
        model.addAttribute("employee", employeeService.getEmployeeById(employeeId).orElse(null));
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        return "admin/bill/employee-performance";
    }
    
    // ============= HELPER CLASSES =============
    
    /**
     * Response cho AJAX calls
     */
    public static class ResponseResult {
        private boolean success;
        private String message;
        private String billId;
        
        public ResponseResult(boolean success, String message, String billId) {
            this.success = success;
            this.message = message;
            this.billId = billId;
        }
        
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public String getBillId() { return billId; }
    }
}

