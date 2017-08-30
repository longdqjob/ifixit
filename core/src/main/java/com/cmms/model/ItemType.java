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

@Entity
@Table(name = "item_type")
public class ItemType extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Integer id;
    private String code;
    private String name;
    private String description;
    private String specification;

//    private ItemType parent;
//    private Set<ItemType> listChild = new HashSet<>(0);

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

    @Column(name = "specification")
    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
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
