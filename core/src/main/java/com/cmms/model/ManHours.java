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
@Table(name = "man_hours")
public class ManHours extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Long id;
    private WorkOrder workOrder;
    private GroupEngineer groupEngineer;
    private Float mh;

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
    @JoinColumn(name = "group_engineer_id")
    public GroupEngineer getGroupEngineer() {
        return groupEngineer;
    }

    @Transient
    public Integer getGroupEngineerId() {
        if (this.groupEngineer == null) {
            return -1;
        }
        return this.groupEngineer.getId();
    }

    public void setGroupEngineer(GroupEngineer groupEngineer) {
        this.groupEngineer = groupEngineer;
    }

    @Column(name = "mh")
    public Float getMh() {
        return mh;
    }

    public void setMh(Float mh) {
        this.mh = mh;
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
