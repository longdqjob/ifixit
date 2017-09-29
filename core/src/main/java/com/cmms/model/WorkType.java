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
@Table(name = "work_type")
public class WorkType extends BaseObject implements Serializable {

    private static final long serialVersionUID = -1L;
    private Integer id;
    private String code;
    private String name;
    private Integer interval;
    private Integer isRepeat;
    private String task;
    private GroupEngineer groupEngineer;

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

    @Column(name = "i_interval")
    public Integer getInterval() {
        return interval;
    }

    public void setInterval(Integer interval) {
        this.interval = interval;
    }

    @Column(name = "is_repeat")
    public Integer getIsRepeat() {
        return isRepeat;
    }

    public void setIsRepeat(Integer isRepeat) {
        this.isRepeat = isRepeat;
    }

    @Column(name = "task")
    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_engineer_id")
    public GroupEngineer getGroupEngineer() {
        return groupEngineer;
    }

    @Transient
    public Integer getGroupEngineerId() {
        if (this.groupEngineer == null) {
            return null;
        }
        return this.groupEngineer.getId();
    }

    @Transient
    public String getGroupEngineerName() {
        if (this.groupEngineer == null) {
            return "";
        }
        return this.groupEngineer.getName();
    }

    public void setGroupEngineer(GroupEngineer groupEngineer) {
        this.groupEngineer = groupEngineer;
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
