package com.cmms.dao;

import com.cmms.model.GroupEngineer;
import java.sql.SQLException;
import java.util.List;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface GroupEngineerDao extends GenericDao<GroupEngineer, Integer> {

    @Transactional
    List<GroupEngineer> getListItem(Integer id);

    @Transactional
    public JSONObject getTree(GroupEngineer root, Boolean group) throws JSONException, SQLException;

    @Transactional
    JSONArray getTreeView(Integer id, Boolean group) throws JSONException, SQLException;

    @Transactional
    List<Integer> getListChildren(Integer id);

    @Transactional
    Integer delete(List<Integer> list);

    @Transactional
    Boolean checkUnique(Integer id, String code);

    @Transactional
    Boolean checkUseParent(List<Integer> lstId);

    @Transactional
    Boolean checkUseByWo(List<Integer> lstId);

    @Transactional
    Boolean checkUseByManHrs(List<Integer> lstId);

    @Transactional
    Boolean checkUseByUser(List<Integer> lstId);
}
