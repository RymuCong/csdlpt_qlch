package com.example.demo.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "customer")
public class Customer {
    @Id
    @Column(length = 50)
    private String id;

    @NotNull
    @NotEmpty(message = "Tên khách hàng không được để trống")
    @Column(columnDefinition = "NVARCHAR(100)", nullable = false)
    private String name;

    @NotNull
    @NotEmpty(message = "Số điện thoại không được để trống")
    @Column(length = 15, nullable = false, unique = true)
    private String phone;

    @Min(value = 1, message = "Level phải từ 1-4")
    @Max(value = 4, message = "Level phải từ 1-4")
    private Byte level;

    @Min(value = 0, message = "Tổng thanh toán phải >= 0")
    @Column(name = "total_payment", precision = 14, scale = 2)
    private BigDecimal totalPayment = BigDecimal.ZERO;

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    @Column(name = "updated_date")
    private LocalDateTime updatedDate;

    @OneToMany(mappedBy = "customer")
    private List<Bill> bills;

    @PrePersist
    protected void onCreate() {
        createdDate = LocalDateTime.now();
        updatedDate = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedDate = LocalDateTime.now();
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public Byte getLevel() { return level; }
    public void setLevel(Byte level) { this.level = level; }
    public BigDecimal getTotalPayment() { return totalPayment; }
    public void setTotalPayment(BigDecimal totalPayment) { this.totalPayment = totalPayment; }
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    public List<Bill> getBills() { return bills; }
    public void setBills(List<Bill> bills) { this.bills = bills; }
}
