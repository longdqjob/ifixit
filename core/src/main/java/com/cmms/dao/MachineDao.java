package com.cmms.dao;

import com.cmms.model.Machine;
import java.util.List;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface MachineDao extends GenericDao<Machine, Long> {

    @Transactional
    Map getList(List<Integer> listItemType,List<Integer> listCompany, String code, String name, Integer start, Integer limit);
}
