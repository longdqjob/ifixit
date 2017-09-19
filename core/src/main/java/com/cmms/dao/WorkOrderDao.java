package com.cmms.dao;

import com.cmms.model.WorkOrder;
import java.util.List;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface WorkOrderDao extends GenericDao<WorkOrder, Long> {

    @Transactional
    Map getList(List<Integer> listEng,List<Integer> listWorkType,Long mechanicId, String code, String name, Integer start, Integer limit);

    @Transactional
    Integer delete(List<Long> list);

    @Transactional
    Boolean checkUnique(Long id, String code);
}
