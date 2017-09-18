package com.cmms.model;

import com.google.gson.Gson;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

@Entity
@Table(name = "company")
public class Company extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Integer id;
    private String code;
    private String name;
    private String description;
    private Integer state;
//    private Integer parentId;
    private String parentName;
    private String completeCode;

    private Company company;
    private List<Machine> machines = new ArrayList<Machine>(0);

    @Transient
    @Column(name = "parent_name")
    public String getParentName() {
        if (this.company == null) {
            return "";
        }
        return this.company.getName();
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

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

    @Column(name = "state")
    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

//    @Column(name = "parent_id")
//    public Integer getParentId() {
//        return parentId;
//    }
//    public void setParentId(Integer parentId) {
//        this.parentId = parentId;
//    }
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "company")
    public List<Machine> getMachines() {
        return machines;
    }

    public void setMachines(List<Machine> machines) {
        this.machines = machines;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    public Company getCompany() {
        return company;
    }

    @Transient
    public String getParentCode() {
        if (this.company == null) {
            return "";
        }
        return this.company.getCompleteCode();
    }

    @Column(name = "completeCode")
    public String getCompleteCode() {
        return completeCode;
    }

    public void setCompleteCode(String completeCode) {
        this.completeCode = completeCode;
    }

    @Transient
    public Integer getParentId() {
        if (this.company == null) {
            return null;
        }
        return this.company.getId();
    }

    public void setCompany(Company company) {
        this.company = company;
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
