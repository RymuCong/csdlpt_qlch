package com.example.demo.domain;

import com.example.demo.enums.PositionType;
import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "employee", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"phone", "store_id"})
})
public class Employee {
    @Id
    @Column(length = 50)
    private String id;

    @NotNull
    @NotEmpty(message = "Tên nhân viên không được để trống")
    @Column(columnDefinition = "NVARCHAR(100)", nullable = false)
    private String name;

    @NotNull
    @NotEmpty(message = "Số điện thoại không được để trống")
    @Column(length = 15, nullable = false)
    private String phone;

    @Column(columnDefinition = "NVARCHAR(200)")
    private String address;
    
    @NotNull
    @NotEmpty(message = "Mật khẩu không được để trống")
    @Column(columnDefinition = "NVARCHAR(255)", nullable = false)
    private String password;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(length = 50, nullable = false)
    private PositionType position;

    @NotNull
    @Min(value = 1, message = "Lương cơ bản phải > 0")
    @Column(name = "base_salary", nullable = false)
    private Integer baseSalary;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    @Column(name = "updated_date")
    private LocalDateTime updatedDate;

    @OneToMany(mappedBy = "employee")
    private List<Bill> bills;

    @OneToMany(mappedBy = "employee")
    private List<PayRoll> payRolls;

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
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public PositionType getPosition() { return position; }
    public void setPosition(PositionType position) { this.position = position; }
    public Integer getBaseSalary() { return baseSalary; }
    public void setBaseSalary(Integer baseSalary) { this.baseSalary = baseSalary; }
    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    public List<Bill> getBills() { return bills; }
    public void setBills(List<Bill> bills) { this.bills = bills; }
    public List<PayRoll> getPayRolls() { return payRolls; }
    public void setPayRolls(List<PayRoll> payRolls) { this.payRolls = payRolls; }
}
