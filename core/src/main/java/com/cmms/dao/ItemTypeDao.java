package com.cmms.dao;

import com.cmms.model.ItemType;
import java.sql.SQLException;
import java.util.List;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface ItemTypeDao extends GenericDao<ItemType, Integer> {

    @Transactional
    List<ItemType> getListItem(Integer id);

    @Transactional
    JSONArray getTreeView(Integer id) throws JSONException, SQLException;

    @Transactional
    String getStringChildren(Integer id);
    
    @Transactional
    List<Integer> getListChildren(Integer id);
    
    @Transactional
    Boolean checkUnique(Integer id,String code);

}
