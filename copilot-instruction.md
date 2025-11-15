# GitHub Copilot Instructions - Hệ thống Quản lý Chuỗi Cửa hàng Tiện lợi

## 🎯 Vai trò & Mục tiêu Dự án

### Project Overview
- **Domain**: Hệ thống quản lý chuỗi cửa hàng tiện lợi (Convenience Store Chain Management System)
- **Architecture**: Distributed system với phân tán dữ liệu theo chi nhánh
- **Database**: SQL Server với phân vùng dữ liệu (branch databases + central server)
- **Tech Stack**: Spring Boot 3.4.0 + JPA/Hibernate + SQL Server + Spring Security

### Core Business Logic
1. **Store Management**: Quản lý nhiều chi nhánh cửa hàng
2. **Inventory Management**: Quản lý sản phẩm, danh mục theo từng chi nhánh
3. **Employee Management**: Quản lý nhân viên, chấm công, tính lương
4. **Sales Management**: Tạo hóa đơn bán hàng tại quầy (POS system)
5. **Customer Management**: Quản lý khách hàng thân thiết (loyalty program)
6. **Payroll System**: Tính lương nhân viên theo giờ làm + thưởng
7. **Data Synchronization**: Đồng bộ dữ liệu giữa chi nhánh và server trung tâm

---

## 📊 Database Architecture

### Database Structure
```
Central Server: store_management (global data)
├── store (master data - replicated)
├── category (master data - replicated)
├── customer (global - replicated)
└── aggregated reports

Branch Databases: QLCH_CN{ID} (branch-specific data)
├── product (partitioned by store_id)
├── employee (partitioned by store_id)
├── bill + bill_details (partitioned by store)
└── pay_roll (partitioned by store)
```

### Data Partitioning Rules
- **Global Entities** (replicated): `Store`, `Category`, `Customer`
- **Partitioned Entities**: `Product`, `Employee`, `Bill`, `BillDetail`, `PayRoll`
- **Sync Strategy**: Branch → Central (every 30 minutes via Quartz Scheduler)

---

## 🏗️ Domain Model & Entities

### Core Entities (Keep & Use)

#### 1. Store Entity
```java
@Entity
@Table(name = "store")
public class Store {
    @Id
    private String id;  // e.g., "CN01", "CN02"
    private String address;
    private String phone;
    private BigDecimal area;
    @OneToMany(mappedBy = "store")
    private List<Product> products;
    @OneToMany(mappedBy = "store")
    private List<Employee> employees;
}
```

#### 2. Category Entity (Global, Replicated)
```java
@Entity
@Table(name = "category")
public class Category {
    @Id
    private String id;
    @Column(unique = true)
    private String name;
    @OneToMany(mappedBy = "category")
    private List<Product> products;
}
```

#### 3. Product Entity (Partitioned by store_id)
```java
@Entity
@Table(name = "product", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"name", "store_id"})
})
public class Product {
    @Id
    private String id;
    private String name;
    private LocalDate expDate;  // Expiration date
    private BigDecimal price;
    private Integer quantity;
    @ManyToOne
    @JoinColumn(name = "cate_id")
    private Category category;
    @ManyToOne
    @JoinColumn(name = "store_id")
    private Store store;
    @OneToMany(mappedBy = "product")
    private List<BillDetail> billDetails;
}
```

#### 4. Employee Entity (Partitioned, with PositionType Enum)
```java
@Entity
@Table(name = "employee", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"phone", "store_id"})
})
public class Employee {
    @Id
    private String id;
    private String name;
    private String phone;
    private String address;
    @Enumerated(EnumType.STRING)
    private PositionType position;  // ✅ Use Enum instead of String
    private Integer baseSalary;  // Hourly wage
    @ManyToOne
    @JoinColumn(name = "store_id")
    private Store store;
    @OneToMany(mappedBy = "employee")
    private List<Bill> bills;
    @OneToMany(mappedBy = "employee")
    private List<PayRoll> payRolls;
}

// Supporting Enum
public enum PositionType {
    QUAN_LY("Quản lý"),
    THU_NGAN("Thu ngân"),
    BAN_HANG("Bán hàng"),
    KE_TOAN("Kế toán"),
    KHO("Nhân viên kho"),
    BAO_VE("Bảo vệ"),
    VE_SINH("Vệ sinh");
    
    private final String displayName;
    PositionType(String displayName) { this.displayName = displayName; }
    public String getDisplayName() { return displayName; }
}
```

#### 5. Customer Entity (Global, Replicated)
```java
@Entity
@Table(name = "customer")
public class Customer {
    @Id
    private String id;
    private String name;
    @Column(unique = true)
    private String phone;
    private Byte level;  // 1-4 (loyalty tiers)
    private BigDecimal totalPayment;  // Lifetime spending
    @OneToMany(mappedBy = "customer")
    private List<Bill> bills;
}
```

#### 6. Bill Entity (POS System)
```java
@Entity
@Table(name = "bill")
public class Bill {
    @Id
    private String id;
    @ManyToOne
    @JoinColumn(name = "cus_id")
    private Customer customer;  // Nullable - can be anonymous purchase
    @ManyToOne
    @JoinColumn(name = "emp_id")
    private Employee employee;  // Cashier who created the bill
    private Byte discount;  // 0-100%
    private BigDecimal totalPrice;
    private LocalDateTime paymentDate;
    @Enumerated(EnumType.STRING)
    private PaymentMethodType paymentMethod;  // ✅ Use Enum
    @OneToMany(mappedBy = "bill", cascade = CascadeType.ALL)
    private List<BillDetail> billDetails;
}

// Supporting Enum
public enum PaymentMethodType {
    TIEN_MAT("Tiền mặt"),
    CHUYEN_KHOAN("Chuyển khoản"),
    THE("Thẻ");
    
    private final String displayName;
    PaymentMethodType(String displayName) { this.displayName = displayName; }
    public String getDisplayName() { return displayName; }
}
```

#### 7. BillDetail Entity (Composite Key)
```java
@Entity
@Table(name = "bill_details")
@IdClass(BillDetailId.class)
public class BillDetail {
    @Id
    @ManyToOne
    @JoinColumn(name = "bill_id")
    private Bill bill;
    
    @Id
    @ManyToOne
    @JoinColumn(name = "prod_id")
    private Product product;
    
    private Integer quantity;
}

// Composite Key Class
public class BillDetailId implements Serializable {
    private String bill;
    private String product;
    // equals() and hashCode()
}
```

#### 8. PayRoll Entity (Salary Management)
```java
@Entity
@Table(name = "pay_roll")
public class PayRoll {
    @Id
    @Column(name = "pay_id")
    private String payId;
    @ManyToOne
    @JoinColumn(name = "emp_id")
    private Employee employee;
    private LocalDate payMonth;  // Tháng tính lương
    private Integer workingHours;  // Số giờ làm
    private Integer bonus;  // Thưởng
    private Integer total;  // = (baseSalary * workingHours) + bonus
}
```

### ❌ Entities to DELETE (Not Needed)
1. **User.java** - Replaced by `Employee` (nhân viên đã có authentication role)
2. **Role.java** - Use `PositionType` enum instead
3. **Cart.java** - Not needed for POS system (direct checkout)
4. **CartDetail.java** - Not needed
5. **Order.java** - Replaced by `Bill`
6. **OrderDetail.java** - Replaced by `BillDetail`

---

## 🔧 Technical Guidelines

### JPA & Hibernate Best Practices

#### Entity Conventions
```java
// ✅ GOOD: Use audit timestamps
@Entity
public class Product {
    @Column(name = "created_date")
    private LocalDateTime createdDate;
    
    @Column(name = "updated_date")
    private LocalDateTime updatedDate;
    
    @PrePersist
    protected void onCreate() {
        createdDate = LocalDateTime.now();
        updatedDate = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedDate = LocalDateTime.now();
    }
}

// ✅ GOOD: Use business logic validation
@Entity
public class Employee {
    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private PositionType position;  // Type-safe with enum
    
    @Min(value = 1, message = "Lương cơ bản phải > 0")
    private Integer baseSalary;
}

// ❌ BAD: String-based position (typo-prone)
private String position;  // Avoid this!
```

#### Foreign Key Cascade Rules
```java
// Product → Category: CASCADE delete products when category deleted
@ManyToOne
@JoinColumn(name = "cate_id")
private Category category;

// Bill → Customer: SET NULL when customer deleted (keep bill history)
@ManyToOne
@JoinColumn(name = "cus_id")
private Customer customer;

// Bill → BillDetail: CASCADE delete details when bill deleted
@OneToMany(mappedBy = "bill", cascade = CascadeType.ALL)
private List<BillDetail> billDetails;
```

### Repository Layer Patterns

```java
public interface ProductRepository extends JpaRepository<Product, String> {
    // ✅ GOOD: Query by store_id for partitioning
    List<Product> findByStoreId(String storeId);
    
    // ✅ GOOD: Find low stock items for alerts
    @Query("SELECT p FROM Product p WHERE p.quantity < :threshold AND p.store.id = :storeId")
    List<Product> findLowStockProducts(@Param("threshold") Integer threshold, 
                                       @Param("storeId") String storeId);
    
    // ✅ GOOD: Check product expiration
    List<Product> findByExpDateBefore(LocalDate date);
}

public interface EmployeeRepository extends JpaRepository<Employee, String> {
    // ✅ GOOD: Find by store and position
    List<Employee> findByStoreIdAndPosition(String storeId, PositionType position);
    
    // ✅ GOOD: Check phone uniqueness per store
    boolean existsByPhoneAndStoreId(String phone, String storeId);
}

public interface BillRepository extends JpaRepository<Bill, String> {
    // ✅ GOOD: Find bills by date range for reports
    @Query("SELECT b FROM Bill b WHERE b.paymentDate BETWEEN :startDate AND :endDate")
    List<Bill> findByDateRange(@Param("startDate") LocalDateTime startDate,
                               @Param("endDate") LocalDateTime endDate);
    
    // ✅ GOOD: Calculate daily revenue
    @Query("SELECT SUM(b.totalPrice) FROM Bill b WHERE DATE(b.paymentDate) = :date")
    BigDecimal calculateDailyRevenue(@Param("date") LocalDate date);
}
```

### Service Layer Patterns

```java
@Service
@Transactional
public class BillService {
    // ✅ GOOD: Create bill with business logic
    public Bill createBill(BillDTO billDTO) {
        Bill bill = new Bill();
        bill.setId(generateBillId());  // e.g., "HD20240101001"
        bill.setEmployee(employeeRepo.findById(billDTO.getEmployeeId())
            .orElseThrow(() -> new ResourceNotFoundException("Employee not found")));
        
        // Apply discount based on customer level
        if (billDTO.getCustomerId() != null) {
            Customer customer = customerRepo.findById(billDTO.getCustomerId())
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found"));
            bill.setDiscount(calculateDiscount(customer.getLevel()));
        }
        
        // Create bill details and update product quantities
        List<BillDetail> details = new ArrayList<>();
        BigDecimal totalPrice = BigDecimal.ZERO;
        
        for (BillDetailDTO detailDTO : billDTO.getDetails()) {
            Product product = productRepo.findById(detailDTO.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException("Product not found"));
            
            // Check stock availability
            if (product.getQuantity() < detailDTO.getQuantity()) {
                throw new InsufficientStockException("Not enough stock for: " + product.getName());
            }
            
            // Update product quantity
            product.setQuantity(product.getQuantity() - detailDTO.getQuantity());
            productRepo.save(product);
            
            // Create bill detail
            BillDetail detail = new BillDetail();
            detail.setBill(bill);
            detail.setProduct(product);
            detail.setQuantity(detailDTO.getQuantity());
            details.add(detail);
            
            totalPrice = totalPrice.add(product.getPrice()
                .multiply(BigDecimal.valueOf(detailDTO.getQuantity())));
        }
        
        // Apply discount to total
        BigDecimal discountAmount = totalPrice
            .multiply(BigDecimal.valueOf(bill.getDiscount()))
            .divide(BigDecimal.valueOf(100));
        bill.setTotalPrice(totalPrice.subtract(discountAmount));
        
        bill.setBillDetails(details);
        return billRepo.save(bill);
    }
    
    // ✅ GOOD: Calculate discount based on customer level
    private Byte calculateDiscount(Byte customerLevel) {
        return switch (customerLevel) {
            case 1 -> (byte) 0;   // No discount
            case 2 -> (byte) 5;   // 5% discount
            case 3 -> (byte) 10;  // 10% discount
            case 4 -> (byte) 15;  // 15% discount
            default -> (byte) 0;
        };
    }
}

@Service
public class PayRollService {
    // ✅ GOOD: Calculate salary with business rules
    public PayRoll calculateSalary(String employeeId, LocalDate month, 
                                   Integer workingHours, Integer bonus) {
        Employee employee = employeeRepo.findById(employeeId)
            .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));
        
        PayRoll payRoll = new PayRoll();
        payRoll.setPayId(generatePayRollId());
        payRoll.setEmployee(employee);
        payRoll.setPayMonth(month);
        payRoll.setWorkingHours(workingHours);
        payRoll.setBonus(bonus);
        
        // Calculate total: (base_salary * hours) + bonus
        Integer total = (employee.getBaseSalary() * workingHours) + bonus;
        payRoll.setTotal(total);
        
        return payRollRepo.save(payRoll);
    }
}
```

### Controller Layer Patterns

```java
@RestController
@RequestMapping("/api/bills")
public class BillController {
    @Autowired
    private BillService billService;
    
    // ✅ GOOD: Create bill with validation
    @PostMapping
    public ResponseEntity<BillDTO> createBill(@Valid @RequestBody BillDTO billDTO) {
        Bill bill = billService.createBill(billDTO);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(BillMapper.toDTO(bill));
    }
    
    // ✅ GOOD: Get bills with date range filter
    @GetMapping
    public ResponseEntity<List<BillDTO>> getBills(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        List<Bill> bills = billService.findByDateRange(startDate, endDate);
        return ResponseEntity.ok(bills.stream()
            .map(BillMapper::toDTO)
            .collect(Collectors.toList()));
    }
    
    // ✅ GOOD: Get daily revenue report
    @GetMapping("/revenue/daily")
    public ResponseEntity<RevenueDTO> getDailyRevenue(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        BigDecimal revenue = billService.calculateDailyRevenue(date);
        return ResponseEntity.ok(new RevenueDTO(date, revenue));
    }
}

@RestController
@RequestMapping("/api/products")
public class ProductController {
    // ✅ GOOD: Get products by store (data partitioning)
    @GetMapping
    public ResponseEntity<List<ProductDTO>> getProducts(@RequestParam String storeId) {
        List<Product> products = productService.findByStore(storeId);
        return ResponseEntity.ok(products.stream()
            .map(ProductMapper::toDTO)
            .collect(Collectors.toList()));
    }
    
    // ✅ GOOD: Alert for low stock products
    @GetMapping("/low-stock")
    public ResponseEntity<List<ProductDTO>> getLowStockProducts(
            @RequestParam String storeId,
            @RequestParam(defaultValue = "10") Integer threshold) {
        List<Product> products = productService.findLowStockProducts(threshold, storeId);
        return ResponseEntity.ok(products.stream()
            .map(ProductMapper::toDTO)
            .collect(Collectors.toList()));
    }
}
```

---

## 🔐 Security & Authentication

### Security Configuration
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/bills/**").hasAnyRole("THU_NGAN", "QUAN_LY")
                .requestMatchers("/api/payrolls/**").hasRole("QUAN_LY")
                .requestMatchers("/api/reports/**").hasRole("QUAN_LY")
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults())
            .csrf(csrf -> csrf.disable());
        
        return http.build();
    }
    
    // ✅ GOOD: Use PositionType enum for roles
    @Bean
    public UserDetailsService userDetailsService() {
        return username -> {
            Employee employee = employeeRepo.findByPhone(username)
                .orElseThrow(() -> new UsernameNotFoundException("Employee not found"));
            
            return User.builder()
                .username(employee.getPhone())
                .password(passwordEncoder().encode("default123"))  // TODO: Implement proper password
                .roles(employee.getPosition().name())  // Use enum name as role
                .build();
        };
    }
}
```

---

## 📡 Data Synchronization Strategy

### Quartz Job for Sync
```java
@Component
public class DataSyncJob {
    @Autowired
    private RestTemplate restTemplate;
    
    @Scheduled(cron = "${sync.cron}")  // Every 30 minutes
    public void syncToCentralServer() {
        if (!syncEnabled) return;
        
        log.info("🔄 Starting data sync to central server...");
        
        try {
            // Sync bills created in last 30 minutes
            LocalDateTime lastSyncTime = LocalDateTime.now().minusMinutes(30);
            List<Bill> newBills = billRepo.findByCreatedDateAfter(lastSyncTime);
            
            if (!newBills.isEmpty()) {
                restTemplate.postForEntity(
                    centralServerUrl + "/api/sync/bills",
                    newBills,
                    Void.class
                );
                log.info("✅ Synced {} bills to central server", newBills.size());
            }
            
            // Sync customers (global data)
            List<Customer> customers = customerRepo.findAll();
            restTemplate.postForEntity(
                centralServerUrl + "/api/sync/customers",
                customers,
                Void.class
            );
            
        } catch (Exception e) {
            log.error("❌ Sync failed: {}", e.getMessage());
        }
    }
}
```

---

## 📊 Reporting & Analytics

### Common Reports Needed
```java
@Service
public class ReportService {
    // Daily revenue by store
    public RevenueReportDTO getDailyRevenue(String storeId, LocalDate date) {
        BigDecimal revenue = billRepo.calculateDailyRevenue(date);
        Integer billCount = billRepo.countByPaymentDateBetween(
            date.atStartOfDay(),
            date.plusDays(1).atStartOfDay()
        );
        return new RevenueReportDTO(date, revenue, billCount);
    }
    
    // Top selling products
    public List<ProductSalesDTO> getTopSellingProducts(String storeId, Integer limit) {
        return billDetailRepo.findTopSellingProducts(storeId, PageRequest.of(0, limit));
    }
    
    // Employee performance (bills created)
    public List<EmployeePerformanceDTO> getEmployeePerformance(String storeId, LocalDate month) {
        return billRepo.calculateEmployeePerformance(storeId, month);
    }
    
    // Stock alert report
    public List<ProductDTO> getStockAlerts(String storeId) {
        return productRepo.findLowStockProducts(10, storeId).stream()
            .map(ProductMapper::toDTO)
            .collect(Collectors.toList());
    }
}
```

---

## 🎯 Development Workflow

### Feature Implementation Checklist
When implementing a new feature:
1. ✅ Create/Update Entity with proper validation
2. ✅ Create Repository with custom queries
3. ✅ Implement Service with business logic
4. ✅ Create Controller with REST endpoints
5. ✅ Add DTO and Mapper classes
6. ✅ Write unit tests for Service layer
7. ✅ Test API endpoints with Postman
8. ✅ Add Swagger documentation
9. ✅ Update database migration scripts
10. ✅ Test data synchronization (if applicable)

### Code Style Guidelines
```java
// ✅ GOOD: Use Vietnamese for business domain terms in logs
log.info("Tạo hóa đơn thành công: {}", billId);
log.error("Không đủ hàng trong kho: {}", productName);

// ✅ GOOD: Use descriptive variable names
BigDecimal discountedPrice = calculateDiscountedPrice(originalPrice, discount);

// ✅ GOOD: Handle exceptions properly
@ExceptionHandler(InsufficientStockException.class)
public ResponseEntity<ErrorDTO> handleInsufficientStock(InsufficientStockException ex) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .body(new ErrorDTO("INSUFFICIENT_STOCK", ex.getMessage()));
}

// ✅ GOOD: Use enums for type safety
if (employee.getPosition() == PositionType.QUAN_LY) {
    // Only managers can access
}

// ❌ BAD: String comparison (typo-prone)
if (employee.getPosition().equals("Quan ly")) {  // Typo risk!
    // ...
}
```

---

## 🚀 Deployment Configuration

### Database Connection Properties
```properties
# Branch Database (Local)
spring.datasource.url=jdbc:sqlserver://${BRANCH_DB_HOST:localhost}:1433;databaseName=QLCH_CN${BRANCH_ID}
spring.datasource.username=${DB_USERNAME:sa}
spring.datasource.password=${DB_PASSWORD:123}

# Central Server Database
central.datasource.url=jdbc:sqlserver://${CENTRAL_DB_HOST:central-server}:1433;databaseName=store_management
central.datasource.username=${CENTRAL_DB_USERNAME:sa}
central.datasource.password=${CENTRAL_DB_PASSWORD:123}

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.SQLServerDialect

# Branch Configuration
branch.id=${BRANCH_ID:01}
branch.name=${BRANCH_NAME:Branch 01}

# Sync Configuration
sync.enabled=true
sync.cron=0 */30 * * * ?  # Every 30 minutes
```

---

## 📌 Final Notes

### Key Success Metrics
- **Bill Creation**: < 2 seconds (including inventory update)
- **Product Query**: < 500ms (with proper indexing)
- **Daily Report**: < 3 seconds (aggregation queries)
- **Data Sync**: < 5 minutes (for 30 minutes of data)
- **Concurrent Users**: Support 20+ cashiers per store

### Common Pitfalls to Avoid
1. ❌ **Don't use User entity** - Employee already handles authentication
2. ❌ **Don't use Cart** - POS system creates Bill directly
3. ❌ **Don't use String for position** - Use PositionType enum
4. ❌ **Don't forget data partitioning** - Always filter by store_id
5. ❌ **Don't cascade delete bills** - Keep history with SET NULL on FK
6. ❌ **Don't forget to sync** - Bill, Customer, Product changes must sync
7. ❌ **Don't skip validation** - Always validate stock before creating bill

### Remember
- **Simple & Maintainable** over complex architecture
- **Data Partitioning** is critical for performance
- **Type Safety** with Enums prevents runtime errors
- **Audit Trails** with createdDate/updatedDate on all entities
- **Business Logic in Service Layer** not in Controllers
- **Test with realistic data** (hundreds of products, multiple stores)

---

**Focus**: Build a reliable POS system that works offline-first, then syncs data. Prioritize cashier workflow speed and inventory accuracy. 🏪
```

Các điểm chính đã được tối ưu hóa:
1. ✅ **Loại bỏ entities không cần** (User, Cart, Order)
2. ✅ **Sử dụng Enum** cho `position` và `payment_method`
3. ✅ **Data partitioning** theo `store_id`
4. ✅ **POS workflow** thay vì e-commerce
5. ✅ **Sync strategy** rõ ràng
6. ✅ **Business logic** phù hợp cửa hàng tiện lợi