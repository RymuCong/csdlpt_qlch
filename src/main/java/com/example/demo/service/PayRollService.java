package com.example.demo.service;

import com.example.demo.domain.Employee;
import com.example.demo.domain.PayRoll;
import com.example.demo.repository.EmployeeRepository;
import com.example.demo.repository.PayRollRepository;
import com.example.demo.util.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class PayRollService {
    
    private static final Logger log = LoggerFactory.getLogger(PayRollService.class);
    
    private final PayRollRepository payRollRepository;
    private final EmployeeRepository employeeRepository;
    private final IdGenerator idGenerator;
    
    public PayRollService(PayRollRepository payRollRepository, EmployeeRepository employeeRepository, IdGenerator idGenerator) {
        this.payRollRepository = payRollRepository;
        this.employeeRepository = employeeRepository;
        this.idGenerator = idGenerator;
    }
    
    /**
     * Tạo/Tính lương cho nhân viên
     * Logic: total = (baseSalary * workingHours) + bonus
     */
    public PayRoll createPayRoll(PayRollDTO payRollDTO) {
        log.info("🔄 Bắt đầu tính lương cho nhân viên: {}", payRollDTO.getEmployeeId());
        
        // 1. Validate nhân viên
        Employee employee = employeeRepository.findById(payRollDTO.getEmployeeId())
            .orElseThrow(() -> {
                log.error("❌ Không tìm thấy nhân viên: {}", payRollDTO.getEmployeeId());
                return new IllegalArgumentException("Nhân viên không tồn tại");
            });
        
        // 2. Kiểm tra đã tồn tại bảng lương cho tháng này chưa
        LocalDate startOfMonth = payRollDTO.getPayMonth().withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        if (payRollRepository.existsByEmployeeIdAndPayMonth(
                payRollDTO.getEmployeeId(), startOfMonth, startOfNextMonth)) {
            log.error("❌ Đã tồn tại bảng lương cho nhân viên {} trong tháng {}", 
                     payRollDTO.getEmployeeId(), payRollDTO.getPayMonth());
            throw new IllegalStateException("Đã tồn tại bảng lương cho nhân viên trong tháng này");
        }
        
        // 3. Tạo PayRoll entity
        PayRoll payRoll = new PayRoll();
        String storeId = employee.getStore().getId();
        LocalDate startOfMonthForCount = payRollDTO.getPayMonth().withDayOfMonth(1);
        LocalDate startOfNextMonthForCount = startOfMonthForCount.plusMonths(1);
        long payRollCount = payRollRepository.findByStoreIdAndPayMonth(storeId, startOfMonthForCount, startOfNextMonthForCount).size();
        payRoll.setPayId(idGenerator.generatePayRollId(storeId, payRollDTO.getPayMonth(), payRollCount));
        payRoll.setEmployee(employee);
        payRoll.setPayMonth(payRollDTO.getPayMonth());
        payRoll.setWorkingHours(payRollDTO.getWorkingHours());
        
        // 4. Set bonus (default = 0 nếu không có)
        Integer bonus = payRollDTO.getBonus() != null ? payRollDTO.getBonus() : 0;
        payRoll.setBonus(bonus);
        
        // 5. Tính tổng lương: (base_salary * hours) + bonus
        Integer totalSalary = (employee.getBaseSalary() * payRollDTO.getWorkingHours()) + bonus;
        payRoll.setTotal(totalSalary);
        
        // 6. Lưu vào database
        PayRoll savedPayRoll = payRollRepository.save(payRoll);
        
        log.info("✅ Tính lương thành công: {} - Nhân viên: {} - Giờ làm: {} - Lương cơ bản: {} - Thưởng: {} - Tổng: {}", 
                 savedPayRoll.getPayId(), employee.getName(), payRollDTO.getWorkingHours(), 
                 employee.getBaseSalary(), bonus, totalSalary);
        
        return savedPayRoll;
    }
    
    /**
     * Cập nhật bảng lương
     */
    public PayRoll updatePayRoll(String payRollId, PayRollDTO payRollDTO) {
        Optional<PayRoll> existingPayRoll = payRollRepository.findById(payRollId);
        if (existingPayRoll.isEmpty()) {
            log.error("❌ Không tìm thấy bảng lương: {}", payRollId);
            throw new IllegalArgumentException("Bảng lương không tồn tại");
        }
        
        PayRoll payRoll = existingPayRoll.get();
        Employee employee = payRoll.getEmployee();
        
        // Cập nhật thông tin
        payRoll.setWorkingHours(payRollDTO.getWorkingHours());
        
        Integer bonus = payRollDTO.getBonus() != null ? payRollDTO.getBonus() : 0;
        payRoll.setBonus(bonus);
        
        // Tính lại tổng lương
        Integer totalSalary = (employee.getBaseSalary() * payRollDTO.getWorkingHours()) + bonus;
        payRoll.setTotal(totalSalary);
        
        PayRoll updatedPayRoll = payRollRepository.save(payRoll);
        log.info("✅ Cập nhật bảng lương thành công: {}", payRollId);
        return updatedPayRoll;
    }
    
    
    /**
     * Tính lương hàng loạt cho tất cả nhân viên của cửa hàng
     */
    public List<PayRoll> createPayRollForStore(String storeId, LocalDate payMonth, 
                                               Integer defaultWorkingHours, Integer defaultBonus) {
        log.info("🔄 Bắt đầu tính lương hàng loạt cho cửa hàng: {} - Tháng: {}", storeId, payMonth);
        
        List<Employee> employees = employeeRepository.findByStoreId(storeId);
        List<PayRoll> payRolls = new ArrayList<>();
        
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        
        for (Employee employee : employees) {
            // Kiểm tra đã có bảng lương chưa
            if (!payRollRepository.existsByEmployeeIdAndPayMonth(employee.getId(), startOfMonth, startOfNextMonth)) {
                PayRollDTO dto = new PayRollDTO();
                dto.setEmployeeId(employee.getId());
                dto.setPayMonth(payMonth);
                dto.setWorkingHours(defaultWorkingHours);
                dto.setBonus(defaultBonus);
                
                try {
                    PayRoll payRoll = createPayRoll(dto);
                    payRolls.add(payRoll);
                } catch (Exception e) {
                    log.error("❌ Lỗi khi tính lương cho nhân viên {}: {}", employee.getId(), e.getMessage());
                }
            }
        }
        
        log.info("✅ Tính lương hàng loạt thành công: {} nhân viên", payRolls.size());
        return payRolls;
    }
    
    /**
     * Xóa bảng lương
     */
    public void deletePayRoll(String payRollId) {
        Optional<PayRoll> payRoll = payRollRepository.findById(payRollId);
        if (payRoll.isEmpty()) {
            log.error("❌ Không tìm thấy bảng lương: {}", payRollId);
            throw new IllegalArgumentException("Bảng lương không tồn tại");
        }
        
        payRollRepository.deleteById(payRollId);
        log.info("✅ Xóa bảng lương thành công: {}", payRollId);
    }
    
    /**
     * Lấy bảng lương theo ID
     */
    public Optional<PayRoll> getPayRollById(String payRollId) {
        return payRollRepository.findById(payRollId);
    }
    
    /**
     * Lấy tất cả bảng lương
     */
    public List<PayRoll> getAllPayRolls() {
        return payRollRepository.findAll();
    }
    
    /**
     * Lấy bảng lương theo cửa hàng (tất cả tháng)
     */
    public List<PayRoll> getPayRollsByStore(String storeId) {
        return payRollRepository.findByStoreId(storeId);
    }
    
    /**
     * Lấy bảng lương theo nhân viên
     */
    public List<PayRoll> getPayRollsByEmployee(String employeeId) {
        return payRollRepository.findByEmployeeId(employeeId);
    }
    
    /**
     * Lấy bảng lương theo nhân viên và tháng
     */
    public Optional<PayRoll> getPayRollByEmployeeAndMonth(String employeeId, LocalDate payMonth) {
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        return payRollRepository.findByEmployeeIdAndPayMonth(employeeId, startOfMonth, startOfNextMonth);
    }
    
    /**
     * Lấy bảng lương theo cửa hàng và tháng
     */
    public List<PayRoll> getPayRollsByStoreAndMonth(String storeId, LocalDate payMonth) {
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        log.debug("🔍 Tìm bảng lương cho store: {}, tháng: {} (từ {} đến {})", 
                 storeId, payMonth, startOfMonth, startOfNextMonth);
        List<PayRoll> result = payRollRepository.findByStoreIdAndPayMonth(storeId, startOfMonth, startOfNextMonth);
        log.debug("✅ Tìm thấy {} bảng lương", result.size());
        return result;
    }
    
    /**
     * Lấy bảng lương theo tháng
     */
    public List<PayRoll> getPayRollsByMonth(LocalDate payMonth) {
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        log.debug("🔍 Tìm bảng lương cho tháng: {} (từ {} đến {})", 
                 payMonth, startOfMonth, startOfNextMonth);
        List<PayRoll> result = payRollRepository.findByPayMonth(startOfMonth, startOfNextMonth);
        log.debug("✅ Tìm thấy {} bảng lương", result.size());
        return result;
    }
    
    /**
     * Tính tổng lương của cửa hàng theo tháng
     */
    public Long calculateTotalPayrollByStore(String storeId, LocalDate payMonth) {
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        return payRollRepository.calculateTotalPayrollByStoreAndMonth(storeId, startOfMonth, startOfNextMonth);
    }
    
    /**
     * Tính tổng lương của tất cả cửa hàng theo tháng
     */
    public Long calculateTotalPayrollByMonth(LocalDate payMonth) {
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        return payRollRepository.calculateTotalPayrollByMonth(startOfMonth, startOfNextMonth);
    }
    
    /**
     * Lấy danh sách nhân viên có lương cao nhất trong tháng
     */
    public List<PayRoll> getTopEarnersByMonth(LocalDate payMonth) {
        LocalDate startOfMonth = payMonth.withDayOfMonth(1);
        LocalDate startOfNextMonth = startOfMonth.plusMonths(1);
        return payRollRepository.findTopEarnersByMonth(startOfMonth, startOfNextMonth);
    }
    
    /**
     * Lấy báo cáo lương theo cửa hàng và tháng
     */
    public PayrollReport getPayrollReport(String storeId, LocalDate payMonth) {
        List<PayRoll> payRolls = getPayRollsByStoreAndMonth(storeId, payMonth);
        
        Long totalSalary = payRolls.stream()
            .mapToLong(PayRoll::getTotal)
            .sum();
        
        Long totalWorkingHours = payRolls.stream()
            .mapToLong(PayRoll::getWorkingHours)
            .sum();
        
        Long totalBonus = payRolls.stream()
            .mapToLong(PayRoll::getBonus)
            .sum();
        
        PayrollReport report = new PayrollReport();
        report.setStoreId(storeId);
        report.setPayMonth(payMonth);
        report.setEmployeeCount((long) payRolls.size());
        report.setTotalSalary(totalSalary);
        report.setTotalWorkingHours(totalWorkingHours);
        report.setTotalBonus(totalBonus);
        if (!payRolls.isEmpty()) {
            report.setAverageSalary(totalSalary / payRolls.size());
        } else {
            report.setAverageSalary(0L);
        }
        
        return report;
    }
    
    /**
     * Tính lương dự kiến cho nhân viên (không lưu vào DB)
     */
    public SalaryEstimate estimateSalary(String employeeId, Integer workingHours, Integer bonus) {
        Employee employee = employeeRepository.findById(employeeId)
            .orElseThrow(() -> new IllegalArgumentException("Nhân viên không tồn tại"));
        
        Integer bonusValue = bonus != null ? bonus : 0;
        Integer totalSalary = (employee.getBaseSalary() * workingHours) + bonusValue;
        
        SalaryEstimate estimate = new SalaryEstimate();
        estimate.setEmployeeId(employeeId);
        estimate.setEmployeeName(employee.getName());
        estimate.setBaseSalary(employee.getBaseSalary());
        estimate.setWorkingHours(workingHours);
        estimate.setBonus(bonusValue);
        estimate.setTotalSalary(totalSalary);
        
        return estimate;
    }
    
    /**
     * Lấy danh sách các tháng có dữ liệu bảng lương (tất cả store)
     */
    public List<LocalDate> getAvailableMonths() {
        return payRollRepository.findDistinctPayMonths();
    }
    
    /**
     * Lấy danh sách các tháng có dữ liệu bảng lương theo store
     */
    public List<LocalDate> getAvailableMonthsByStore(String storeId) {
        return payRollRepository.findDistinctPayMonthsByStore(storeId);
    }
    
    // ============= DTOs =============
    
    public static class PayRollDTO {
        private String employeeId;
        private LocalDate payMonth;
        private Integer workingHours;
        private Integer bonus;
        
        // Getters and Setters
        public String getEmployeeId() { return employeeId; }
        public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
        public LocalDate getPayMonth() { return payMonth; }
        public void setPayMonth(LocalDate payMonth) { this.payMonth = payMonth; }
        public Integer getWorkingHours() { return workingHours; }
        public void setWorkingHours(Integer workingHours) { this.workingHours = workingHours; }
        public Integer getBonus() { return bonus; }
        public void setBonus(Integer bonus) { this.bonus = bonus; }
    }
    
    public static class PayrollReport {
        private String storeId;
        private LocalDate payMonth;
        private Long employeeCount;
        private Long totalSalary;
        private Long totalWorkingHours;
        private Long totalBonus;
        private Long averageSalary;
        
        // Getters and Setters
        public String getStoreId() { return storeId; }
        public void setStoreId(String storeId) { this.storeId = storeId; }
        public LocalDate getPayMonth() { return payMonth; }
        public void setPayMonth(LocalDate payMonth) { this.payMonth = payMonth; }
        public Long getEmployeeCount() { return employeeCount; }
        public void setEmployeeCount(Long employeeCount) { this.employeeCount = employeeCount; }
        public Long getTotalSalary() { return totalSalary; }
        public void setTotalSalary(Long totalSalary) { this.totalSalary = totalSalary; }
        public Long getTotalWorkingHours() { return totalWorkingHours; }
        public void setTotalWorkingHours(Long totalWorkingHours) { this.totalWorkingHours = totalWorkingHours; }
        public Long getTotalBonus() { return totalBonus; }
        public void setTotalBonus(Long totalBonus) { this.totalBonus = totalBonus; }
        public Long getAverageSalary() { return averageSalary; }
        public void setAverageSalary(Long averageSalary) { this.averageSalary = averageSalary; }
    }
    
    public static class SalaryEstimate {
        private String employeeId;
        private String employeeName;
        private Integer baseSalary;
        private Integer workingHours;
        private Integer bonus;
        private Integer totalSalary;
        
        // Getters and Setters
        public String getEmployeeId() { return employeeId; }
        public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
        public String getEmployeeName() { return employeeName; }
        public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
        public Integer getBaseSalary() { return baseSalary; }
        public void setBaseSalary(Integer baseSalary) { this.baseSalary = baseSalary; }
        public Integer getWorkingHours() { return workingHours; }
        public void setWorkingHours(Integer workingHours) { this.workingHours = workingHours; }
        public Integer getBonus() { return bonus; }
        public void setBonus(Integer bonus) { this.bonus = bonus; }
        public Integer getTotalSalary() { return totalSalary; }
        public void setTotalSalary(Integer totalSalary) { this.totalSalary = totalSalary; }
    }
}

