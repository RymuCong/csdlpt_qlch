package com.example.demo.service;

import com.example.demo.domain.Customer;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.util.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CustomerService {
    
    private static final Logger log = LoggerFactory.getLogger(CustomerService.class);
    
    private final CustomerRepository customerRepository;
    private final IdGenerator idGenerator;
    
    public CustomerService(CustomerRepository customerRepository, IdGenerator idGenerator) {
        this.customerRepository = customerRepository;
        this.idGenerator = idGenerator;
    }
    
    /**
     * Tạo khách hàng mới
     */
    public Customer createCustomer(Customer customer) {
        // Kiểm tra số điện thoại đã tồn tại chưa
        if (customerRepository.existsByPhone(customer.getPhone())) {
            log.error("❌ Số điện thoại khách hàng đã tồn tại: {}", customer.getPhone());
            throw new IllegalArgumentException("Số điện thoại khách hàng đã tồn tại");
        }
        
        // Tự động sinh mã khách hàng
        long customerCount = customerRepository.count();
        customer.setId(idGenerator.generateCustomerId(customerCount));
        
        // Khởi tạo totalPayment = 0 nếu chưa có
        if (customer.getTotalPayment() == null) {
            customer.setTotalPayment(BigDecimal.ZERO);
        }
        
        // Tự động tính level dựa trên tổng chi tiêu
        Byte calculatedLevel = calculateCustomerLevel(customer.getTotalPayment());
        customer.setLevel(calculatedLevel);
        
        Customer savedCustomer = customerRepository.save(customer);
        log.info("✅ Tạo khách hàng thành công: {} - {} - Level {} (Chi tiêu: {})", 
                 savedCustomer.getId(), savedCustomer.getName(), savedCustomer.getLevel(), savedCustomer.getTotalPayment());
        return savedCustomer;
    }
    
    
    /**
     * Cập nhật thông tin khách hàng
     */
    public Customer updateCustomer(Customer customer) {
        Optional<Customer> existingCustomer = customerRepository.findById(customer.getId());
        if (existingCustomer.isEmpty()) {
            log.error("❌ Không tìm thấy khách hàng: {}", customer.getId());
            throw new IllegalArgumentException("Khách hàng không tồn tại");
        }
        
        // Kiểm tra số điện thoại mới có trùng với khách hàng khác không
        Optional<Customer> customerWithPhone = customerRepository.findByPhone(customer.getPhone());
        if (customerWithPhone.isPresent() && !customerWithPhone.get().getId().equals(customer.getId())) {
            log.error("❌ Số điện thoại đã được sử dụng bởi khách hàng khác: {}", customer.getPhone());
            throw new IllegalArgumentException("Số điện thoại đã được sử dụng bởi khách hàng khác");
        }
        
        // Tự động tính lại level dựa trên tổng chi tiêu
        if (customer.getTotalPayment() != null) {
            Byte calculatedLevel = calculateCustomerLevel(customer.getTotalPayment());
            customer.setLevel(calculatedLevel);
        }
        
        Customer updatedCustomer = customerRepository.save(customer);
        log.info("✅ Cập nhật khách hàng thành công: {} - Level {}", 
                 updatedCustomer.getId(), updatedCustomer.getLevel());
        return updatedCustomer;
    }
    
    /**
     * Xóa khách hàng
     */
    public void deleteCustomer(String customerId) {
        Optional<Customer> customer = customerRepository.findById(customerId);
        if (customer.isEmpty()) {
            log.error("❌ Không tìm thấy khách hàng: {}", customerId);
            throw new IllegalArgumentException("Khách hàng không tồn tại");
        }
        
        customerRepository.deleteById(customerId);
        log.info("✅ Xóa khách hàng thành công: {}", customerId);
    }
    
    /**
     * Lấy thông tin khách hàng theo ID
     */
    public Optional<Customer> getCustomerById(String customerId) {
        return customerRepository.findById(customerId);
    }
    
    /**
     * Lấy tất cả khách hàng
     */
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }
    
    /**
     * Tìm khách hàng theo số điện thoại
     */
    public Optional<Customer> getCustomerByPhone(String phone) {
        return customerRepository.findByPhone(phone);
    }
    
    /**
     * Lấy khách hàng theo level
     */
    public List<Customer> getCustomersByLevel(Byte level) {
        return customerRepository.findByLevel(level);
    }
    
    /**
     * Lấy top khách hàng theo tổng thanh toán
     */
    public List<Customer> getTopCustomers() {
        return customerRepository.findTopCustomersByPayment();
    }
    
    /**
     * Cập nhật tổng thanh toán và level của khách hàng
     */
    public Customer updateCustomerPayment(String customerId, BigDecimal additionalPayment) {
        Optional<Customer> customerOpt = customerRepository.findById(customerId);
        if (customerOpt.isEmpty()) {
            log.error("❌ Không tìm thấy khách hàng: {}", customerId);
            throw new IllegalArgumentException("Khách hàng không tồn tại");
        }
        
        Customer customer = customerOpt.get();
        BigDecimal newTotalPayment = customer.getTotalPayment().add(additionalPayment);
        customer.setTotalPayment(newTotalPayment);
        
        // Tự động cập nhật level dựa trên tổng thanh toán
        Byte newLevel = calculateCustomerLevel(newTotalPayment);
        customer.setLevel(newLevel);
        
        Customer updatedCustomer = customerRepository.save(customer);
        log.info("✅ Cập nhật thanh toán khách hàng: {} - Tổng: {} - Level: {}", 
                 customerId, newTotalPayment, newLevel);
        return updatedCustomer;
    }
    
    /**
     * Tính level của khách hàng dựa trên tổng thanh toán
     * Level 1: < 5 triệu (0% giảm giá)
     * Level 2: 5-20 triệu (5% giảm giá)
     * Level 3: 20-50 triệu (10% giảm giá)
     * Level 4: >= 50 triệu (15% giảm giá)
     */
    public Byte calculateCustomerLevel(BigDecimal totalPayment) {
        if (totalPayment.compareTo(new BigDecimal("50000000")) >= 0) {
            return (byte) 4;
        } else if (totalPayment.compareTo(new BigDecimal("20000000")) >= 0) {
            return (byte) 3;
        } else if (totalPayment.compareTo(new BigDecimal("5000000")) >= 0) {
            return (byte) 2;
        } else {
            return (byte) 1;
        }
    }
    
    /**
     * Đếm số lượng khách hàng theo level
     */
    public Long countCustomersByLevel(Byte level) {
        return customerRepository.countByLevel(level);
    }
    
    /**
     * Tính tổng doanh thu từ khách hàng
     */
    public BigDecimal getTotalRevenue() {
        return customerRepository.calculateTotalRevenue();
    }
}

