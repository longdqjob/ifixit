package com.cmms.dao;

import com.cmms.model.Machine;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface MachineDao extends GenericDao<Machine, Long> {

    @Transactional
    Map getList(List<Integer> listItemType, List<Integer> listCompany, String code, String name, Integer start, Integer limit);

    @Transactional
    List<Machine> getListItem(List<Integer> lstSystem, Integer id);

    @Transactional
    JSONArray getTreeView(List<Integer> lstSystem, Integer id) throws JSONException, SQLException;

    @Transactional
    Integer delete(List<Long> list);

    @Transactional
    Boolean checkUnique(Long id, String code);
}
