package com.cmms.dao;

import com.cmms.model.Material;
import java.util.List;
import java.util.Map;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface MaterialDao extends GenericDao<Material, Long> {

    @Transactional
    Map getList(String code, String name, Integer start, Integer limit);

    @Transactional
    Integer delete(List<Long> list);

    @Transactional
    Boolean checkUnique(Long id, String code);

    @Transactional
    Boolean checkUse(List<Long> lstId);
}
