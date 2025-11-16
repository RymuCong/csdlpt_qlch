package com.example.demo.controller.admin;

import com.example.demo.domain.Customer;
import com.example.demo.service.CustomerService;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Customer Controller - Quản lý khách hàng thân thiết
 */
@Controller
@RequestMapping("/admin/customer")
public class CustomerController {
    
    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }
    
    /**
     * Tạo nhanh khách hàng từ màn POS (AJAX)
     */
    @PostMapping("/quick-create")
    @ResponseBody
    public QuickCreateResponse quickCreate(@RequestBody Customer payload, jakarta.servlet.http.HttpSession session) {
        try {
            // Lấy storeId từ session
            String storeId = (String) session.getAttribute("storeId");
            if (storeId == null || storeId.isEmpty()) {
                return QuickCreateResponse.failure("Không tìm thấy thông tin chi nhánh. Vui lòng đăng nhập lại.");
            }
            
            // Chỉ cần name, phone; các field khác service sẽ tính mặc định
            Customer minimal = new Customer();
            minimal.setName(payload.getName());
            minimal.setPhone(payload.getPhone());
            Customer created = customerService.createCustomer(minimal, storeId);
            return QuickCreateResponse.success(created.getId(), created.getName(), created.getPhone(), created.getLevel());
        } catch (Exception e) {
            return QuickCreateResponse.failure(e.getMessage());
        }
    }
    
    public static class QuickCreateResponse {
        private boolean success;
        private String message;
        private String id;
        private String name;
        private String phone;
        private Byte level;

        public static QuickCreateResponse success(String id, String name, String phone, Byte level) {
            QuickCreateResponse r = new QuickCreateResponse();
            r.success = true;
            r.id = id;
            r.name = name;
            r.phone = phone;
            r.level = level;
            return r;
        }
        public static QuickCreateResponse failure(String message) {
            QuickCreateResponse r = new QuickCreateResponse();
            r.success = false;
            r.message = message;
            return r;
        }
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public String getId() { return id; }
        public String getName() { return name; }
        public String getPhone() { return phone; }
        public Byte getLevel() { return level; }
    }
    
    /**
     * Hiển thị danh sách khách hàng
     * Trả về TẤT CẢ dữ liệu để DataTables xử lý phân trang ở client-side
     */
    @GetMapping
    public String showCustomers(Model model) {
        List<Customer> customers = customerService.getAllCustomers();
        model.addAttribute("customers", customers);
        return "admin/customer/show";
    }
    
    /**
     * Hiển thị form tạo khách hàng mới
     */
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("newCustomer", new Customer());
        return "admin/customer/create";
    }
    
    /**
     * Xử lý tạo khách hàng mới
     */
    @PostMapping("/create")
    public String createCustomer(@ModelAttribute("newCustomer") @Valid Customer customer,
                                 BindingResult bindingResult,
                                 Model model,
                                 jakarta.servlet.http.HttpSession session) {
        if (bindingResult.hasErrors()) {
            return "admin/customer/create";
        }
        
        try {
            // Lấy storeId từ session
            String storeId = (String) session.getAttribute("storeId");
            if (storeId == null || storeId.isEmpty()) {
                model.addAttribute("error", "Không tìm thấy thông tin chi nhánh. Vui lòng đăng nhập lại.");
                return "admin/customer/create";
            }
            
            customerService.createCustomer(customer, storeId);
            return "redirect:/admin/customer?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/customer/create";
        }
    }
    
    /**
     * Hiển thị chi tiết khách hàng
     */
    @GetMapping("/{id}")
    public String showCustomerDetail(@PathVariable String id, Model model) {
        Optional<Customer> customer = customerService.getCustomerById(id);
        if (customer.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("customer", customer.get());
        return "admin/customer/detail";
    }
    
    /**
     * Hiển thị form cập nhật khách hàng
     */
    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable String id, Model model) {
        Optional<Customer> customer = customerService.getCustomerById(id);
        if (customer.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("customer", customer.get());
        return "admin/customer/update";
    }
    
    /**
     * Xử lý cập nhật khách hàng
     */
    @PostMapping("/update")
    public String updateCustomer(@ModelAttribute("customer") @Valid Customer customer,
                                 BindingResult bindingResult,
                                 Model model) {
        if (bindingResult.hasErrors()) {
            return "admin/customer/update";
        }
        
        try {
            customerService.updateCustomer(customer);
            return "redirect:/admin/customer?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/customer/update";
        }
    }
    
    /**
     * Xóa khách hàng
     */
    @PostMapping("/delete")
    public String deleteCustomer(@RequestParam String id) {
        try {
            customerService.deleteCustomer(id);
            return "redirect:/admin/customer?deleted";
        } catch (Exception e) {
            return "redirect:/admin/customer?error=" + e.getMessage();
        }
    }
    
    /**
     * Lọc khách hàng theo level
     * Trả về TẤT CẢ dữ liệu để DataTables xử lý phân trang ở client-side
     */
    @GetMapping("/filter")
    public String filterByLevel(@RequestParam Byte level,
                               Model model) {
        List<Customer> customers = customerService.getCustomersByLevel(level);
        model.addAttribute("customers", customers);
        model.addAttribute("selectedLevel", level);
        return "admin/customer/show";
    }
    
    /**
     * Top khách hàng VIP
     * Trả về TẤT CẢ dữ liệu để DataTables xử lý phân trang ở client-side
     */
    @GetMapping("/top")
    public String showTopCustomers(Model model) {
        List<Customer> topCustomers = customerService.getTopCustomers();
        model.addAttribute("customers", topCustomers);
        model.addAttribute("isTopList", true);
        return "admin/customer/show";
    }
}

