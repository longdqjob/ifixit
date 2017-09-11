package com.cmms.dao;

import com.cmms.model.MachineType;
import java.util.List;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface MachineTypeDao extends GenericDao<MachineType, Integer> {

    @Transactional
    Map getList(String code, String name, Integer start, Integer limit);
    
    @Transactional
    Integer delete(List<Integer> list);
    
    @Transactional
    Boolean checkUnique(Integer id,String code);
}
