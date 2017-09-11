package com.cmms.dao;

import com.cmms.model.GroupEngineer;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface GroupEngineerDao extends GenericDao<GroupEngineer, Integer> {

    @Transactional
    Boolean checkUnique(Integer id, String code);
}
