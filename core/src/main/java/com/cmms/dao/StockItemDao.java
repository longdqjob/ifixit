package com.cmms.dao;

import com.cmms.model.StockItem;
import java.util.List;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface StockItemDao extends GenericDao<StockItem, Long> {

    @Transactional
    Map getList(Long workType, Integer start, Integer limit);

    @Transactional
    Integer delete(List<Long> list);

    @Transactional
    Integer deleteByWorkOrder(List<Long> list);
}
