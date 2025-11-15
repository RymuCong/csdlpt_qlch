package com.example.demo.service;

import com.example.demo.domain.Bill;
import com.example.demo.domain.BillDetail;
import com.example.demo.domain.Customer;
import com.example.demo.domain.Employee;
import com.example.demo.domain.Product;
import com.example.demo.enums.PaymentMethodType;
import com.example.demo.repository.BillRepository;
import com.example.demo.repository.BillDetailRepository;
import com.example.demo.repository.CustomerRepository;
import com.example.demo.repository.EmployeeRepository;
import com.example.demo.repository.ProductRepository;
import com.example.demo.util.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BillService {
    
    private static final Logger log = LoggerFactory.getLogger(BillService.class);
    
    private final BillRepository billRepository;
    private final BillDetailRepository billDetailRepository;
    private final ProductRepository productRepository;
    private final EmployeeRepository employeeRepository;
    private final CustomerRepository customerRepository;
    private final ProductService productService;
    private final CustomerService customerService;
    private final IdGenerator idGenerator;
    
    public BillService(BillRepository billRepository,
                      BillDetailRepository billDetailRepository,
                      ProductRepository productRepository,
                      EmployeeRepository employeeRepository,
                      CustomerRepository customerRepository,
                      ProductService productService,
                      CustomerService customerService,
                      IdGenerator idGenerator) {
        this.billRepository = billRepository;
        this.billDetailRepository = billDetailRepository;
        this.productRepository = productRepository;
        this.employeeRepository = employeeRepository;
        this.customerRepository = customerRepository;
        this.productService = productService;
        this.customerService = customerService;
        this.idGenerator = idGenerator;
    }
    
    /**
     * Tạo hóa đơn mới (POS System)
     * Logic: 
     * 1. Validate nhân viên, khách hàng (nếu có)
     * 2. Validate tồn kho cho tất cả sản phẩm
     * 3. Tính discount dựa trên level khách hàng
     * 4. Tính tổng tiền sau discount
     * 5. Tạo bill và bill details
     * 6. Cập nhật số lượng sản phẩm (xuất kho)
     * 7. Cập nhật tổng thanh toán và level của khách hàng
     */
    public Bill createBill(BillDTO billDTO) {
        log.info("🔄 Bắt đầu tạo hóa đơn...");
        
        // 1. Validate và lấy thông tin nhân viên
        Employee employee = employeeRepository.findById(billDTO.getEmployeeId())
            .orElseThrow(() -> {
                log.error("❌ Không tìm thấy nhân viên: {}", billDTO.getEmployeeId());
                return new IllegalArgumentException("Nhân viên không tồn tại");
            });
        
        // 2. Validate và lấy thông tin khách hàng (nếu có)
        Customer customer = null;
        if (billDTO.getCustomerId() != null && !billDTO.getCustomerId().isEmpty()) {
            customer = customerRepository.findById(billDTO.getCustomerId())
                .orElseThrow(() -> {
                    log.error("❌ Không tìm thấy khách hàng: {}", billDTO.getCustomerId());
                    return new IllegalArgumentException("Khách hàng không tồn tại");
                });
        }
        
        // 3. Validate tồn kho cho tất cả sản phẩm trước
        validateStockAvailability(billDTO.getBillDetails());
        
        // 4. Tạo Bill entity
        Bill bill = new Bill();
        String storeId = employee.getStore().getId();
        bill.setId(generateBillId(storeId));
        bill.setEmployee(employee);
        bill.setCustomer(customer);
        bill.setPaymentMethod(billDTO.getPaymentMethod());
        bill.setPaymentDate(LocalDateTime.now());
        
        // 5. Tính discount dựa trên level khách hàng
        Byte discount = calculateDiscount(customer);
        bill.setDiscount(discount);
        
        // 6. Tính tổng tiền và tạo bill details
        BigDecimal totalPrice = BigDecimal.ZERO;
        List<BillDetail> billDetails = new ArrayList<>();
        
        // Đếm số bill detail hiện có cho bill này (để generate ID)
        // Vì bill chưa được lưu, đếm số bill detail có bill_id tương tự trong store
        long billDetailCount = 0; // Bắt đầu từ 0 cho bill mới
        
        for (BillDetailDTO detailDTO : billDTO.getBillDetails()) {
            Product product = productRepository.findById(detailDTO.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại: " + detailDTO.getProductId()));
            
            // Tính tiền cho sản phẩm này
            BigDecimal itemTotal = product.getPrice()
                .multiply(BigDecimal.valueOf(detailDTO.getQuantity()));
            totalPrice = totalPrice.add(itemTotal);
            
            // Tạo BillDetail với ID (đếm từ 0 cho bill mới)
            BillDetail billDetail = new BillDetail();
            billDetail.setId(idGenerator.generateBillDetailId(storeId, bill.getId(), billDetailCount++));
            billDetail.setBill(bill);
            billDetail.setProduct(product);
            billDetail.setQuantity(detailDTO.getQuantity());
            billDetails.add(billDetail);
            
            // Cập nhật số lượng sản phẩm (xuất kho)
            productService.reduceProductStock(product.getId(), detailDTO.getQuantity());
            log.info("  - Xuất kho: {} x{} = {}", product.getName(), detailDTO.getQuantity(), itemTotal);
        }
        
        // 7. Áp dụng discount
        BigDecimal discountAmount = totalPrice
            .multiply(BigDecimal.valueOf(discount))
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal finalPrice = totalPrice.subtract(discountAmount);
        
        bill.setTotalPrice(finalPrice);
        bill.setBillDetails(billDetails);
        
        // 8. Lưu bill và bill details
        Bill savedBill = billRepository.save(bill);
        
        // 9. Cập nhật tổng thanh toán và level của khách hàng (nếu có)
        if (customer != null) {
            customerService.updateCustomerPayment(customer.getId(), finalPrice);
            log.info("  ✅ Cập nhật khách hàng: {} - Tổng: {}", 
                     customer.getName(), customer.getTotalPayment().add(finalPrice));
        }
        
        log.info("✅ Tạo hóa đơn thành công: {} - Tổng tiền: {} - Discount: {}% - Thanh toán: {}", 
                 savedBill.getId(), totalPrice, discount, finalPrice);
        
        return savedBill;
    }
    
    /**
     * Validate tồn kho cho tất cả sản phẩm
     */
    private void validateStockAvailability(List<BillDetailDTO> billDetails) {
        for (BillDetailDTO detail : billDetails) {
            Product product = productRepository.findById(detail.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại: " + detail.getProductId()));
            
            if (product.getQuantity() < detail.getQuantity()) {
                log.error("❌ Không đủ hàng: {} (có: {}, cần: {})", 
                         product.getName(), product.getQuantity(), detail.getQuantity());
                throw new IllegalStateException(
                    String.format("Không đủ hàng trong kho: %s (còn lại: %d, cần: %d)", 
                                 product.getName(), product.getQuantity(), detail.getQuantity()));
            }
            
            // Kiểm tra sản phẩm đã hết hạn chưa
            if (product.getExpDate() != null && product.getExpDate().isBefore(LocalDate.now())) {
                log.error("❌ Sản phẩm đã hết hạn: {} (HSD: {})", 
                         product.getName(), product.getExpDate());
                throw new IllegalStateException(
                    String.format("Sản phẩm đã hết hạn: %s (HSD: %s)", 
                                 product.getName(), product.getExpDate()));
            }
        }
    }
    
    /**
     * Tính discount dựa trên level khách hàng
     * Level 1: 0%
     * Level 2: 5%
     * Level 3: 10%
     * Level 4: 15%
     */
    private Byte calculateDiscount(Customer customer) {
        if (customer == null) {
            return (byte) 0;
        }
        
        return switch (customer.getLevel()) {
            case 1 -> (byte) 0;
            case 2 -> (byte) 5;
            case 3 -> (byte) 10;
            case 4 -> (byte) 15;
            default -> (byte) 0;
        };
    }
    
    /**
     * Generate Bill ID (format: {storeId}_B00001, {storeId}_B00002, ...)
     */
    private String generateBillId(String storeId) {
        // Đếm số hóa đơn của cửa hàng này
        List<Bill> storeBills = billRepository.findAll().stream()
            .filter(b -> b.getEmployee() != null && b.getEmployee().getStore() != null 
                      && storeId.equals(b.getEmployee().getStore().getId()))
            .toList();
        
        long currentCount = storeBills.size();
        return idGenerator.generateBillId(storeId, currentCount);
    }
    
    /**
     * Lấy hóa đơn theo ID
     */
    public Optional<Bill> getBillById(String billId) {
        return billRepository.findById(billId);
    }
    
    /**
     * Lấy tất cả hóa đơn
     */
    public List<Bill> getAllBills() {
        return billRepository.findAll();
    }
    
    /**
     * Lấy hóa đơn theo khách hàng
     */
    public List<Bill> getBillsByCustomer(String customerId) {
        return billRepository.findByCustomerId(customerId);
    }
    
    /**
     * Lấy hóa đơn theo nhân viên
     */
    public List<Bill> getBillsByEmployee(String employeeId) {
        return billRepository.findByEmployeeId(employeeId);
    }
    
    /**
     * Lấy hóa đơn trong khoảng thời gian
     */
    public List<Bill> getBillsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return billRepository.findByDateRange(startDate, endDate);
    }
    
    /**
     * Tính doanh thu theo ngày
     */
    public BigDecimal calculateDailyRevenue(LocalDate date) {
        return billRepository.calculateDailyRevenue(date);
    }
    
    /**
     * Tính doanh thu trong khoảng thời gian
     */
    public BigDecimal calculateRevenueByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return billRepository.calculateRevenueByDateRange(startDate, endDate);
    }
    
    /**
     * Lấy báo cáo doanh thu theo ngày
     */
    public DailyRevenueReport getDailyRevenueReport(LocalDate date) {
        BigDecimal revenue = calculateDailyRevenue(date);
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.plusDays(1).atStartOfDay();
        Integer billCount = billRepository.countByPaymentDateBetween(startOfDay, endOfDay);
        
        DailyRevenueReport report = new DailyRevenueReport();
        report.setDate(date);
        report.setRevenue(revenue);
        report.setBillCount(billCount);
        if (billCount > 0) {
            report.setAverageOrderValue(revenue.divide(BigDecimal.valueOf(billCount), 2, RoundingMode.HALF_UP));
        } else {
            report.setAverageOrderValue(BigDecimal.ZERO);
        }
        
        return report;
    }
    
    /**
     * Lấy báo cáo hiệu suất nhân viên
     */
    public List<EmployeePerformanceReport> getEmployeePerformanceReport(
            String employeeId, LocalDate startDate, LocalDate endDate) {
        List<Bill> bills = billRepository.findByEmployeeIdAndDateRange(employeeId, startDate, endDate);
        
        // Group by employee and calculate stats
        List<EmployeePerformanceReport> reports = new ArrayList<>();
        
        BigDecimal totalRevenue = bills.stream()
            .map(Bill::getTotalPrice)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        EmployeePerformanceReport report = new EmployeePerformanceReport();
        report.setEmployeeId(employeeId);
        report.setBillCount((long) bills.size());
        report.setTotalRevenue(totalRevenue);
        if (!bills.isEmpty()) {
            report.setAverageOrderValue(
                totalRevenue.divide(BigDecimal.valueOf(bills.size()), 2, RoundingMode.HALF_UP));
        } else {
            report.setAverageOrderValue(BigDecimal.ZERO);
        }
        
        reports.add(report);
        return reports;
    }
    
    /**
     * Xóa hóa đơn (soft delete - chỉ admin)
     */
    public void deleteBill(String billId) {
        Optional<Bill> bill = billRepository.findById(billId);
        if (bill.isEmpty()) {
            log.error("❌ Không tìm thấy hóa đơn: {}", billId);
            throw new IllegalArgumentException("Hóa đơn không tồn tại");
        }
        
        // Note: Trong thực tế nên implement soft delete
        // hoặc không cho phép xóa hóa đơn đã thanh toán
        billRepository.deleteById(billId);
        log.info("✅ Xóa hóa đơn thành công: {}", billId);
    }
    
    // ============= DTOs =============
    
    public static class BillDTO {
        private String employeeId;
        private String customerId;
        private PaymentMethodType paymentMethod;
        private List<BillDetailDTO> billDetails;
        
        // Getters and Setters
        public String getEmployeeId() { return employeeId; }
        public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
        public String getCustomerId() { return customerId; }
        public void setCustomerId(String customerId) { this.customerId = customerId; }
        public PaymentMethodType getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(PaymentMethodType paymentMethod) { this.paymentMethod = paymentMethod; }
        public List<BillDetailDTO> getBillDetails() { return billDetails; }
        public void setBillDetails(List<BillDetailDTO> billDetails) { this.billDetails = billDetails; }
    }
    
    public static class BillDetailDTO {
        private String productId;
        private Integer quantity;
        
        // Getters and Setters
        public String getProductId() { return productId; }
        public void setProductId(String productId) { this.productId = productId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }
    
    public static class DailyRevenueReport {
        private LocalDate date;
        private BigDecimal revenue;
        private Integer billCount;
        private BigDecimal averageOrderValue;
        
        // Getters and Setters
        public LocalDate getDate() { return date; }
        public void setDate(LocalDate date) { this.date = date; }
        public BigDecimal getRevenue() { return revenue; }
        public void setRevenue(BigDecimal revenue) { this.revenue = revenue; }
        public Integer getBillCount() { return billCount; }
        public void setBillCount(Integer billCount) { this.billCount = billCount; }
        public BigDecimal getAverageOrderValue() { return averageOrderValue; }
        public void setAverageOrderValue(BigDecimal averageOrderValue) { 
            this.averageOrderValue = averageOrderValue; 
        }
    }
    
    public static class EmployeePerformanceReport {
        private String employeeId;
        private Long billCount;
        private BigDecimal totalRevenue;
        private BigDecimal averageOrderValue;
        
        // Getters and Setters
        public String getEmployeeId() { return employeeId; }
        public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
        public Long getBillCount() { return billCount; }
        public void setBillCount(Long billCount) { this.billCount = billCount; }
        public BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
        public BigDecimal getAverageOrderValue() { return averageOrderValue; }
        public void setAverageOrderValue(BigDecimal averageOrderValue) { 
            this.averageOrderValue = averageOrderValue; 
        }
    }
}

