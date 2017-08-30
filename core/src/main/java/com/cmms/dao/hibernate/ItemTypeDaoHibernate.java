package com.cmms.dao.hibernate;

import com.cmms.dao.ItemTypeDao;
import com.cmms.model.ItemType;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 *
 * @author thuyetlv
 */
public class ItemTypeDaoHibernate extends GenericDaoHibernate<ItemType, Integer> implements ItemTypeDao {

    public ItemTypeDaoHibernate() {
        super(ItemType.class);
    }

    @Override
    public List<ItemType> getListItem(Integer id) {
        try {
            List<ItemType> rtn = new LinkedList<>();
            id = (id == null) ? 0 : id;
            String hql = "SELECT * FROM item_type WHERE parent_id=:parent_id";
            rtn = getSession().createSQLQuery(hql)
                    .addEntity(ItemType.class)
                    .setParameter("parent_id", id)
                    .list();
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }

    @Override
    public JSONArray getTreeView(Integer id) throws JSONException, SQLException {
        List<ItemType> roots = getListItem(id);

        JSONArray treeview = new JSONArray();
        for (ItemType root : roots) {
            JSONObject tree = getTree(root);
            treeview.put(tree);
        }
        return treeview;
    }

    public JSONObject getTree(ItemType root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        JSONArray children = new JSONArray();
        ItemType currentGroup = root;
        obj.put("text", currentGroup.getName());
//        obj.put("description", currentGroup.getDescription());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("iconCls", "folder");
//        obj.put("iconCls", "task-folder");
        obj.put("id", currentGroup.getId());
//        obj.put("children", children);
        return obj;
    }

    public static final Integer TREE_LEVEL = 7;

    @Override
    public String getStringChildren(Integer id) {
        try {
            StringBuffer rtn = null;
            id = (id == null) ? 0 : id;
            String hql = "SELECT id,GetFamilyTree(id,:level) FamilyTree FROM item_type WHERE id=:parent_id";
            List<Object[]> areaList = getSession().createSQLQuery(hql)
                    .setParameter("level", TREE_LEVEL)
                    .setParameter("parent_id", id)
                    .list();
            rtn = new StringBuffer();
            rtn.append(id);
            if (areaList != null && !areaList.isEmpty()) {
                for (Object[] obj : areaList) {
                    rtn.append(",").append(String.valueOf(obj[0]));
                }
            }

            return rtn.toString();
        } catch (Exception ex) {
            log.error("ERROR getStringChildren: ", ex);
            return null;
        }
    }
    
    @Override
    public List<Integer> getListChildren(Integer id) {
        try {
            List<Integer> rtn = null;
            id = (id == null) ? 0 : id;
            String hql = "SELECT id,GetFamilyTree(id,:level) FamilyTree FROM item_type WHERE id=:parent_id";

            List<Object[]> areaList = getSession()
                    .createSQLQuery(hql)
                    .setParameter("level", TREE_LEVEL)
                    .setParameter("parent_id", id)
                    .list();
            rtn = new LinkedList<>();
            rtn.add(id);
            if (areaList != null && !areaList.isEmpty()) {
                String familyTree = "";
                for (Object[] obj : areaList) {
                    familyTree = String.valueOf(obj[1]);
                }
                if (familyTree.length() > 0) {
                    String[] tmp = familyTree.split(",");
                    for (String child : tmp) {
                        rtn.add(Integer.valueOf(child));
                    }
                }
            }

            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListChildren: ", ex);
            return null;
        }
    }
}
