package com.cmms.dao;

import com.cmms.model.Supplier;
import java.util.List;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface SupplierDao extends GenericDao<Supplier, Integer> {
    @Transactional
    Map getList(String code, String name, Integer start, Integer limit);
    
    @Transactional
    Integer delete(List<Integer> list);
    
    @Transactional
    Boolean checkUnique(Integer id,String code);
}
