package com.cmms.dao;

import com.cmms.model.Company;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author thuyetlv
 */
public interface CompanyDao extends GenericDao<Company, Integer> {

    @Transactional
    List<Company> getListItem(Integer id);

    @Transactional
    public JSONObject getTree(Company root) throws JSONException, SQLException;
    
    @Transactional
    JSONArray getTreeView(Integer id) throws JSONException, SQLException;

    @Transactional
    List<Integer> getListChildren(Integer id, boolean appendParent);

    @Transactional
    Map getListCompany(List<Integer> listParent, String code, String name, Integer start, Integer limit);

    @Transactional
    Integer deleteCompany(List<Integer> list);
    
    @Transactional
    Boolean checkUnique(Integer id,String code);
    
    @Transactional
    Boolean checkUseParent(List<Integer> lstId);
    
    @Transactional
    Boolean checkUseByMachenic(List<Integer> lstId);
    
    @Transactional
    Boolean checkUseByUser(List<Integer> lstId);
}
