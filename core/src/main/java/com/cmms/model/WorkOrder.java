package com.cmms.model;

import com.google.gson.Gson;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
@Table(name = "work_order")
public class WorkOrder extends BaseObject implements Serializable {

    public static final Integer STATUS_COMPLETE = 0;
    public static final Integer STATUS_OPEN = 1;
    public static final Integer STATUS_INPROGRESS = 2;
    public static final Integer STATUS_OVERDUE = 3;

    private static final long serialVersionUID = -1L;
    private Long id;
    private String code;
    private String name;
    private Date startTime;
    private Date endTime;
    private Integer status;
    private Integer interval;
    private Integer isRepeat;
    private String task;
    private String reason;
    private String note;
    private Float mhTotal;
    private Float mhTotalCost;
    private Float stockTotalCost;
    private WorkType workType;
    private Machine machine;
    private GroupEngineer groupEngineer;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
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

    @Column(name = "start_time")
    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    @Column(name = "end_time")
    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    @Column(name = "status")
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    @Column(name = "reason")
    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    @Column(name = "note")
    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Column(name = "mh_total")
    public Float getMhTotal() {
        return mhTotal;
    }

    public void setMhTotal(Float mhTotal) {
        this.mhTotal = mhTotal;
    }

    @Column(name = "mh_total_cost")
    public Float getMhTotalCost() {
        return mhTotalCost;
    }

    public void setMhTotalCost(Float mhTotalCost) {
        this.mhTotalCost = mhTotalCost;
    }

    @Column(name = "stock_total_cost")
    public Float getStockTotalCost() {
        return stockTotalCost;
    }

    public void setStockTotalCost(Float stockTotalCost) {
        this.stockTotalCost = stockTotalCost;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "work_type_id")
    public WorkType getWorkType() {
        return workType;
    }

    public void setWorkType(WorkType workType) {
        this.workType = workType;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "machine_id")
    public Machine getMachine() {
        return machine;
    }

    public void setMachine(Machine machine) {
        this.machine = machine;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_engineer_id")
    public GroupEngineer getGroupEngineer() {
        return groupEngineer;
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

    public static void main(String[] args) {
        String code = "AABC_22092017";
        System.out.println("" + code.substring(0, code.lastIndexOf("_")));
    }

    public static final String CODE_SPA = "_";

    private String genCode(Date date) {
        String oldCode = this.code;
        if (this.code.contains(CODE_SPA)) {
            String dateTmp = this.code.substring(this.code.lastIndexOf(CODE_SPA) + 1);
            try {
                sdf.parse(dateTmp);
                oldCode = oldCode.substring(0, oldCode.lastIndexOf(CODE_SPA));
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return oldCode + CODE_SPA + sdf.format(date);
    }

    public static final SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyHHmmss");
    public static final SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");

    public WorkOrder cloneWo() {
        Date date = new Date();
        WorkOrder rtn = new WorkOrder();
        rtn.setCode(genCode(date));
        rtn.setName(this.name);
        rtn.setStartTime(this.startTime);
        rtn.setEndTime(this.endTime);
        rtn.setStatus(STATUS_OPEN);
        rtn.setInterval(this.interval);
        rtn.setIsRepeat(this.isRepeat);
        rtn.setNote("WO được tự động sinh bởi hệ thống ngày " + sdf1.format(date));
        rtn.setWorkType(this.workType);
        rtn.setMachine(this.machine);
        rtn.setGroupEngineer(this.groupEngineer);
        rtn.setMhTotal(0F);
        rtn.setMhTotalCost(0F);
        rtn.setStockTotalCost(0F);
        return rtn;
    }
}
