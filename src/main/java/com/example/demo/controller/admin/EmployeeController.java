package com.example.demo.controller.admin;

import com.example.demo.domain.Employee;
import com.example.demo.enums.PositionType;
import com.example.demo.service.EmployeeService;
import com.example.demo.service.StoreService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/employee")
public class EmployeeController {
    
    private final EmployeeService employeeService;
    private final StoreService storeService;

    public EmployeeController(EmployeeService employeeService, StoreService storeService) {
        this.employeeService = employeeService;
        this.storeService = storeService;
    }
    
    /**
     * Hiển thị danh sách nhân viên (theo cửa hàng hiện tại)
     */
    @GetMapping
    public String showEmployees(Model model, HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        List<Employee> employees;
        
        if (storeId != null) {
            employees = employeeService.getEmployeesByStore(storeId);
        } else {
            employees = employeeService.getAllEmployees();
        }
        
        model.addAttribute("employees", employees);
        model.addAttribute("positions", PositionType.values());
        return "admin/employee/show";
    }
    
    /**
     * Hiển thị form tạo nhân viên mới
     */
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("newEmployee", new Employee());
        model.addAttribute("stores", storeService.getAllStores());
        model.addAttribute("positions", PositionType.values());
        return "admin/employee/create";
    }
    
    /**
     * Xử lý tạo nhân viên mới
     */
    @PostMapping("/create")
    public String createEmployee(@ModelAttribute("newEmployee") @Valid Employee employee,
                                 BindingResult bindingResult,
                                 Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("positions", PositionType.values());
            return "admin/employee/create";
        }
        
        try {
            employeeService.createEmployee(employee);
            return "redirect:/admin/employee?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("positions", PositionType.values());
            return "admin/employee/create";
        }
    }
    
    /**
     * Hiển thị chi tiết nhân viên
     */
    @GetMapping("/{id}")
    public String showEmployeeDetail(@PathVariable String id, Model model) {
        Optional<Employee> employee = employeeService.getEmployeeById(id);
        if (employee.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("employee", employee.get());
        return "admin/employee/detail";
    }
    
    /**
     * Hiển thị form cập nhật nhân viên
     */
    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable String id, Model model) {
        Optional<Employee> employee = employeeService.getEmployeeById(id);
        if (employee.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("employee", employee.get());
        model.addAttribute("stores", storeService.getAllStores());
        model.addAttribute("positions", PositionType.values());
        return "admin/employee/update";
    }
    
    /**
     * Xử lý cập nhật nhân viên
     */
    @PostMapping("/update")
    public String updateEmployee(@ModelAttribute("employee") @Valid Employee employee,
                                BindingResult bindingResult,
                                Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("positions", PositionType.values());
            return "admin/employee/update";
        }
        
        try {
            employeeService.updateEmployee(employee);
            return "redirect:/admin/employee?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("positions", PositionType.values());
            return "admin/employee/update";
        }
    }
    
    /**
     * Hiển thị form xác nhận xóa
     */
    @GetMapping("/delete/{id}")
    public String showDeleteForm(@PathVariable String id, Model model) {
        Optional<Employee> employee = employeeService.getEmployeeById(id);
        if (employee.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("employee", employee.get());
        return "admin/employee/delete";
    }
    
    /**
     * Xử lý xóa nhân viên
     */
    @PostMapping("/delete")
    public String deleteEmployee(@RequestParam String id) {
        try {
            employeeService.deleteEmployee(id);
            return "redirect:/admin/employee?deleted";
        } catch (Exception e) {
            return "redirect:/admin/employee?error=" + e.getMessage();
        }
    }
    
    /**
     * Lọc nhân viên theo chức vụ
     */
    @GetMapping("/filter")
    public String filterByPosition(@RequestParam(required = false) PositionType position,
                                   @RequestParam(required = false) String storeId,
                                   Model model) {
        List<Employee> employees;
        
        if (position != null && storeId != null) {
            employees = employeeService.getEmployeesByStoreAndPosition(storeId, position);
        } else if (storeId != null) {
            employees = employeeService.getEmployeesByStore(storeId);
        } else if (position != null) {
            employees = employeeService.getEmployeesByPosition(position);
        } else {
            employees = employeeService.getAllEmployees();
        }
        
        model.addAttribute("employees", employees);
        model.addAttribute("positions", PositionType.values());
        model.addAttribute("stores", storeService.getAllStores());
        model.addAttribute("selectedPosition", position);
        model.addAttribute("selectedStore", storeId);
        return "admin/employee/show";
    }
}

