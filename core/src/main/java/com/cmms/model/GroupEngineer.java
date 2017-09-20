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
@Table(name = "group_engineer")
public class GroupEngineer extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Integer id;
    private String code;
    private String completeCode;
    private String name;
    private String description;
    private Float cost;
    private GroupEngineer parent;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Column(name = "code")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Column(name = "complete_code")
    public String getCompleteCode() {
        return completeCode;
    }

    public void setCompleteCode(String completeCode) {
        this.completeCode = completeCode;
    }

    @Column(name = "name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "description")
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "cost")
    public Float getCost() {
        return cost;
    }

    public void setCost(Float cost) {
        this.cost = cost;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id", nullable = true)
    public GroupEngineer getParent() {
        return parent;
    }

    @Transient
    public Integer getParentId() {
        if (this.parent == null) {
            return null;
        }
        return this.parent.getId();
    }

    @Transient
    public String getParentName() {
        if (this.parent == null) {
            return null;
        }
        return this.parent.getName();
    }

    @Transient
    public String getParentCode() {
        if (this.parent == null) {
            return null;
        }
        return this.parent.getCompleteCode();
    }

    public void setParent(GroupEngineer parent) {
        this.parent = parent;
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

    private int countComplete;
    private int countOpen;
    private int countOverDue;

    @Transient
    public int getCountComplete() {
        return countComplete;
    }

    public void setCountComplete(int countComplete) {
        this.countComplete = countComplete;
    }

    @Transient
    public int getCountOpen() {
        return countOpen;
    }

    public void setCountOpen(int countOpen) {
        this.countOpen = countOpen;
    }

    @Transient
    public int getCountOverDue() {
        return countOverDue;
    }

    public void setCountOverDue(int countOverDue) {
        this.countOverDue = countOverDue;
    }

}
