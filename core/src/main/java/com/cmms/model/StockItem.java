package com.cmms.model;

import com.google.gson.Gson;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

@Entity
@Table(name = "stock_item")
public class StockItem extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Long id;
    private WorkOrder workOrder;
    private Material material;
    private Integer quantity;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "work_order_id")
    public WorkOrder getWorkOrder() {
        return workOrder;
    }

    public void setWorkOrder(WorkOrder workOrder) {
        this.workOrder = workOrder;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "material_id")
    public Material getMaterial() {
        return material;
    }
    
    @Transient
    public Long getMaterialId() {
        if (this.material == null) {
            return null;
        }
        return this.material.getId();
    }

    public void setMaterial(Material material) {
        this.material = material;
    }

    @Column(name = "quantity")
    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }

    @Override
    public boolean equals(Object o) {
        return Objects.equals(this, o);
    }

    @Override
    public int hashCode() {
        return 0;
    }
}
