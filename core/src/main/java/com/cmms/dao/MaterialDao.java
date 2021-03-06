package com.cmms.dao;

import com.cmms.model.Material;
import com.cmms.obj.MaterialObj;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface MaterialDao extends GenericDao<Material, Long> {

    @Transactional
    List<Material> getListItem(Long id);

    @Transactional
    JSONArray getTreeView(Long id) throws JSONException, SQLException;

    @Transactional
    Map getList(List<Integer> lstItemType, String code, String name, Integer start, Integer limit);

    @Transactional
    Integer delete(List<Long> list);

    @Transactional
    Boolean checkUnique(Long id, String code);

    @Transactional
    Boolean checkUse(List<Long> lstId);

    @Transactional
    HashMap<Long, Integer> getQty(List<Long> lstId);

    @Transactional
    HashMap<String, Long> getList(List<String> lstCode);

    @Transactional
    Integer insertListWithParentUseSql(List<MaterialObj> listMat);

    @Transactional
    Integer insertListUseSql(List<MaterialObj> listMat);

    @Transactional
    void insertList(List<Material> listMat);
}
