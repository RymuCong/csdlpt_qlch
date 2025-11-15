package com.example.demo.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "pay_roll")
public class PayRoll {
    @Id
    @Column(name = "pay_id", length = 50)
    private String payId;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "emp_id", nullable = false)
    private Employee employee;

    @NotNull
    @Column(name = "pay_month", nullable = false)
    private LocalDate payMonth;

    @NotNull
    @Min(value = 0, message = "Giờ làm phải >= 0")
    @Column(name = "working_hours", nullable = false)
    private Integer workingHours;

    @Min(value = 0, message = "Thưởng phải >= 0")
    @Column(columnDefinition = "INT DEFAULT 0")
    private Integer bonus = 0;

    @Min(value = 0, message = "Tổng lương phải >= 0")
    private Integer total;

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

    // Getters and Setters
    public String getPayId() { return payId; }
    public void setPayId(String payId) { this.payId = payId; }
    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }
    public LocalDate getPayMonth() { return payMonth; }
    public void setPayMonth(LocalDate payMonth) { this.payMonth = payMonth; }
    public Integer getWorkingHours() { return workingHours; }
    public void setWorkingHours(Integer workingHours) { this.workingHours = workingHours; }
    public Integer getBonus() { return bonus; }
    public void setBonus(Integer bonus) { this.bonus = bonus; }
    public Integer getTotal() { return total; }
    public void setTotal(Integer total) { this.total = total; }
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
}
