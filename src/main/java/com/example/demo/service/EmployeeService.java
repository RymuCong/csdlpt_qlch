package com.example.demo.service;

import com.example.demo.domain.Employee;
import com.example.demo.enums.PositionType;
import com.example.demo.repository.EmployeeRepository;
import com.example.demo.repository.StoreRepository;
import com.example.demo.util.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class EmployeeService {
    
    private static final Logger log = LoggerFactory.getLogger(EmployeeService.class);
    
    private final EmployeeRepository employeeRepository;
    private final StoreRepository storeRepository;
    private final IdGenerator idGenerator;
    private final PasswordEncoder passwordEncoder;
    
    public EmployeeService(EmployeeRepository employeeRepository, 
                          StoreRepository storeRepository, 
                          IdGenerator idGenerator,
                          PasswordEncoder passwordEncoder) {
        this.employeeRepository = employeeRepository;
        this.storeRepository = storeRepository;
        this.idGenerator = idGenerator;
        this.passwordEncoder = passwordEncoder;
    }
    
    /**
     * Tạo nhân viên mới
     */
    public Employee createEmployee(Employee employee) {
        // Kiểm tra cửa hàng có tồn tại không
        if (storeRepository.findById(employee.getStore().getId()).isEmpty()) {
            log.error("❌ Cửa hàng không tồn tại: {}", employee.getStore().getId());
            throw new IllegalArgumentException("Cửa hàng không tồn tại");
        }
        
        // Kiểm tra số điện thoại đã tồn tại trong cửa hàng chưa
        if (employeeRepository.existsByPhoneAndStoreId(employee.getPhone(), employee.getStore().getId())) {
            log.error("❌ Số điện thoại đã tồn tại trong cửa hàng: {}", employee.getPhone());
            throw new IllegalArgumentException("Số điện thoại nhân viên đã tồn tại trong cửa hàng này");
        }
        
        // Generate Employee ID
        String storeId = employee.getStore().getId();
        long employeeCount = employeeRepository.findByStoreId(storeId).size();
        employee.setId(idGenerator.generateEmployeeId(storeId, employeeCount));
        
        // Hash password trước khi lưu
        if (employee.getPassword() != null && !employee.getPassword().isEmpty()) {
            String hashedPassword = passwordEncoder.encode(employee.getPassword());
            employee.setPassword(hashedPassword);
            log.info("🔐 Đã hash mật khẩu cho nhân viên: {}", employee.getId());
        }
        
        Employee savedEmployee = employeeRepository.save(employee);
        log.info("✅ Tạo nhân viên thành công: {} - {} - {}", 
                 savedEmployee.getId(), savedEmployee.getName(), savedEmployee.getPosition().getDisplayName());
        return savedEmployee;
    }
    
    /**
     * Cập nhật thông tin nhân viên
     */
    public Employee updateEmployee(Employee employee) {
        Optional<Employee> existingEmployee = employeeRepository.findById(employee.getId());
        if (existingEmployee.isEmpty()) {
            log.error("❌ Không tìm thấy nhân viên: {}", employee.getId());
            throw new IllegalArgumentException("Nhân viên không tồn tại");
        }
        
        // Kiểm tra số điện thoại mới có trùng với nhân viên khác trong cùng cửa hàng không
        Optional<Employee> empWithPhone = employeeRepository.findByPhone(employee.getPhone());
        if (empWithPhone.isPresent() && !empWithPhone.get().getId().equals(employee.getId())
                && empWithPhone.get().getStore().getId().equals(employee.getStore().getId())) {
            log.error("❌ Số điện thoại đã được sử dụng bởi nhân viên khác trong cửa hàng: {}", employee.getPhone());
            throw new IllegalArgumentException("Số điện thoại đã được sử dụng bởi nhân viên khác trong cửa hàng");
        }
        
        // Xử lý password: Nếu password mới được cung cấp và chưa được hash (không bắt đầu bằng $2a$ hoặc $2b$), thì hash nó
        // Nếu password đã là hash (bắt đầu bằng $2a$ hoặc $2b$), giữ nguyên
        if (employee.getPassword() != null && !employee.getPassword().isEmpty()) {
            String currentPassword = employee.getPassword();
            // Kiểm tra xem password có phải là BCrypt hash không (BCrypt hash bắt đầu bằng $2a$ hoặc $2b$)
            if (!currentPassword.startsWith("$2a$") && !currentPassword.startsWith("$2b$")) {
                // Password chưa được hash, hash nó
                String hashedPassword = passwordEncoder.encode(currentPassword);
                employee.setPassword(hashedPassword);
                log.info("🔐 Đã hash mật khẩu mới cho nhân viên: {}", employee.getId());
            } else {
                // Password đã được hash, giữ nguyên
                log.info("🔐 Mật khẩu đã được hash, giữ nguyên cho nhân viên: {}", employee.getId());
            }
        } else {
            // Nếu password rỗng, giữ nguyên password cũ từ database
            employee.setPassword(existingEmployee.get().getPassword());
            log.info("🔐 Giữ nguyên mật khẩu cũ cho nhân viên: {}", employee.getId());
        }
        
        Employee updatedEmployee = employeeRepository.save(employee);
        log.info("✅ Cập nhật nhân viên thành công: {}", updatedEmployee.getId());
        return updatedEmployee;
    }
    
    /**
     * Xóa nhân viên
     */
    public void deleteEmployee(String employeeId) {
        Optional<Employee> employee = employeeRepository.findById(employeeId);
        if (employee.isEmpty()) {
            log.error("❌ Không tìm thấy nhân viên: {}", employeeId);
            throw new IllegalArgumentException("Nhân viên không tồn tại");
        }
        
        employeeRepository.deleteById(employeeId);
        log.info("✅ Xóa nhân viên thành công: {}", employeeId);
    }
    
    /**
     * Lấy thông tin nhân viên theo ID
     */
    public Optional<Employee> getEmployeeById(String employeeId) {
        return employeeRepository.findById(employeeId);
    }
    
    /**
     * Lấy tất cả nhân viên
     */
    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }
    
    /**
     * Lấy nhân viên theo cửa hàng
     */
    public List<Employee> getEmployeesByStore(String storeId) {
        return employeeRepository.findByStoreId(storeId);
    }
    
    /**
     * Lấy nhân viên theo chức vụ
     */
    public List<Employee> getEmployeesByPosition(PositionType position) {
        return employeeRepository.findByPosition(position);
    }
    
    /**
     * Lấy nhân viên theo cửa hàng và chức vụ
     */
    public List<Employee> getEmployeesByStoreAndPosition(String storeId, PositionType position) {
        return employeeRepository.findByStoreIdAndPosition(storeId, position);
    }
    
    /**
     * Tìm nhân viên theo số điện thoại
     */
    public Optional<Employee> getEmployeeByPhone(String phone) {
        return employeeRepository.findByPhone(phone);
    }
    
    /**
     * Đếm số lượng nhân viên theo chức vụ trong cửa hàng
     */
    public Long countEmployeesByStoreAndPosition(String storeId, PositionType position) {
        return employeeRepository.countByStoreIdAndPosition(storeId, position);
    }
    
    /**
     * Lấy danh sách nhân viên có lương cao nhất trong cửa hàng
     */
    public List<Employee> getTopSalaryEmployees(String storeId) {
        return employeeRepository.findTopSalaryEmployeesByStore(storeId);
    }
}

