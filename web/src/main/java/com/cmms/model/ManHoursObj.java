package com.cmms.model;

/**
 *
 * @author thuyetlv
 */
public class ManHoursObj {

    private Long id;
    private Long workOrderId;
    private Integer groupEngineerId;
    private Float mh;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getWorkOrderId() {
        return workOrderId;
    }

    public void setWorkOrderId(Long workOrderId) {
        this.workOrderId = workOrderId;
    }

    public Integer getGroupEngineerId() {
        return groupEngineerId;
    }

    public void setGroupEngineerId(Integer groupEngineerId) {
        this.groupEngineerId = groupEngineerId;
    }

    public Float getMh() {
        return mh;
    }

    public void setMh(Float mh) {
        this.mh = mh;
    }

}
