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
import org.apache.commons.lang.StringUtils;

@Entity
@Table(name = "item_type")
public class ItemType extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Integer id;
    private String code;
    private String completeCode;
    private String name;
    private String specification;
    private ItemType parent;

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

    @Column(name = "specification")
    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    public ItemType getParent() {
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
            return "";
        }
        return this.parent.getName();
    }

    @Transient
    public String getParentCode() {
        if (this.parent == null) {
            return "";
        }
        return this.parent.getCompleteCode();
    }

    public void setParent(ItemType parent) {
        this.parent = parent;
    }

    @Transient
    public String getText() {
        if (StringUtils.isBlank(this.code)) {
            return this.name;
        } else {

            return this.code + " - " + this.name;
        }
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

//    @ManyToOne(fetch = FetchType.EAGER)
//    @JoinColumn(name = "PARENT_ID")
//    public ItemType getParent() {
//        return parent;
//    }
//
//    @Transient
//    public Integer getParentId() {
//        if (this.parent == null) {
//            return null;
//        }
//        return this.parent.getId();
//    }
//
//    public void setParent(ItemType parent) {
//        this.parent = parent;
//    }
//
//    @OneToMany(fetch = FetchType.LAZY, mappedBy = "parent")
//    public Set<ItemType> getListChild() {
//        return listChild;
//    }
//
//    public void setListChild(Set<ItemType> listChild) {
//        this.listChild = listChild;
//    }
}
