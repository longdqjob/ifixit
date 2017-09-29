package com.cmms.dao.hibernate;

import com.cmms.dao.MaterialDao;
import static com.cmms.dao.hibernate.GenericDaoHibernate.BATCH_LIMIT;
import com.cmms.model.Material;
import com.cmms.obj.MaterialObj;
import java.math.BigInteger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.jdbc.ReturningWork;

/**
 *
 * @author thuyetlv
 */
public class MaterialDaoHibernate extends GenericDaoHibernate<Material, Long> implements MaterialDao {

    public MaterialDaoHibernate() {
        super(Material.class);
    }

    //<editor-fold defaultstate="collapsed" desc="getListItem">
    @Override
    public List<Material> getListItem(Long id) {
        try {
            List<Material> rtn = new LinkedList<>();
            String hql = "";
            if (id == null || id <= 0) {
                hql = "SELECT * FROM material WHERE parent_id IS NULL  order by name";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Material.class)
                        .list();
            } else {
                hql = "SELECT * FROM material WHERE parent_id=:parent_id order by name";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Material.class)
                        .setParameter("parent_id", id)
                        .list();
            }
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getTree">
    public JSONObject getTree(Material root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        Material item = root;
        obj.put("name", item.getName());
        obj.put("namedisplay", item.getCode() + "." + item.getName());
        obj.put("description", item.getDescription());
        obj.put("code", item.getCode());
        obj.put("unit", item.getUnit());
        obj.put("cost", item.getCost());
        obj.put("completeCode", item.getCompleteCode());
        obj.put("completeParentCode", item.getParentCode());
        obj.put("parentName", item.getParentName());
        obj.put("parentId", item.getParentId());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("id", item.getId());
        return obj;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getTreeView">
    @Override
    public JSONArray getTreeView(Long id) throws JSONException, SQLException {
        List<Material> roots = getListItem(id);

        JSONArray treeview = new JSONArray();
        for (Material root : roots) {
            JSONObject tree = getTree(root);
            treeview.put(tree);
        }
        return treeview;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getList">
    @Override
    public Map getList(List<Integer> lstItemType, String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(Material.class);

            if (lstItemType != null) {
                criteria.add(Restrictions.in("itemType.id", lstItemType));
            }

            //Name
            if (!StringUtils.isBlank(code)) {
                criteria.add(Restrictions.like("code", "%" + code.trim() + "%").ignoreCase());
            }
            if (!StringUtils.isBlank(name)) {
                criteria.add(Restrictions.like("name", "%" + name.trim() + "%").ignoreCase());
            }
            criteria.addOrder(Order.desc("name"));
            Long total = 0L;
            if (limit != null && limit > 0) {
                // get the count
                criteria.setProjection(Projections.rowCount());
                total = ((Long) criteria.uniqueResult());
                //Reset
                criteria.setProjection(null);
                criteria.setResultTransformer(CriteriaSpecification.DISTINCT_ROOT_ENTITY);
                //End get count

                criteria.setFirstResult(start);
                criteria.setMaxResults(limit);
            }
            result.put("list", criteria.list());
            result.put("count", total);
            return result;
        } catch (Exception ex) {
            log.error("ERROR getList: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="delete">
    @Override
    public Integer delete(List<Long> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM material WHERE id in (:lstId)")
                    .addEntity(Material.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="checkUnique">
    @Override
    public Boolean checkUnique(Long id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<Material> list = new ArrayList<Material>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(Material.class);

            //Id
            if (id != null && id > 0) {
                criteria.add(Restrictions.ne("id", id));
            }

            //Code
            if (code != null && code.trim().length() > 0) {
                criteria.add(Restrictions.eq("code", code));
            }

            list = criteria.list();

            rtn = (list != null && list.size() > 0);

        } catch (Exception ex) {
            log.error("ERROR checkUnique: " + code, ex);
            return null;
        }
        return rtn;
    }//</editor-fold>

    /**
     *
     * @param lstId
     * @return true neu duoc su dung
     */
    //<editor-fold defaultstate="collapsed" desc="checkUse">
    @Override
    public Boolean checkUse(List<Long> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            String hql = "SELECT COUNT(id) FROM stock_item WHERE material_id in (:lstId)";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List list = query.list();
            return (((BigInteger) list.get(0)).intValue() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUse: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getQty">
    @Override
    public HashMap<Long, Integer> getQty(List<Long> lstId) {
        try {
            Query query;
            if (lstId == null || lstId.isEmpty()) {
                return new HashMap<Long, Integer>(0);
            }
            HashMap<Long, Integer> rtn = null;
            String hql = "SELECT id,quantity FROM material WHERE id in :lstId";
            query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List<Object[]> list = query.list();
            rtn = new HashMap<>(lstId.size());
            if (list != null && !list.isEmpty()) {
                for (Object[] obj : list) {
                    rtn.put(Long.valueOf(String.valueOf(obj[0])), Integer.valueOf(String.valueOf(obj[1])));
                }
            }

            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getQty: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getList">
    @Override
    public HashMap<String, Long> getList(List<String> lstCode) {
        try {
            Query query;
            if (lstCode == null || lstCode.isEmpty()) {
                return new HashMap<String, Long>();
            }
            HashMap<String, Long> rtn = null;
            String hql = "SELECT id,complete_code FROM material WHERE complete_code in :lstId";
            query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstCode);

            List<Object[]> list = query.list();
            rtn = new HashMap<>();
            if (list != null && !list.isEmpty()) {
                for (Object[] obj : list) {
                    rtn.put(String.valueOf(obj[1]), Long.valueOf(String.valueOf(obj[0])));
                }
            }

            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getList: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="insertList">
    @Override
    public void insertList(List<Material> listMat) {
        Session session = null;
        Transaction tx = null;
        try {
            session = getSession();
            tx = session.beginTransaction();
            int i = 0;
            for (Material material : listMat) {
                session.save(material);
                if (i++ % BATCH_LIMIT == 0) { // Same as the JDBC batch size
                    //flush a batch of inserts and release memory:
                    session.flush();
                    session.clear();
                }
            }
            tx.commit();
            session.close();
        } catch (Exception ex) {
            if (tx != null) {
                tx.rollback();
            }
            log.error("ERROR insertList: ", ex);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="insertListWithParentUseSql">
    @Override
    public Integer insertListWithParentUseSql(final List<MaterialObj> listMat) {
        try {
            return getSession().doReturningWork(new ReturningWork<Integer>() {
                @Override
                public Integer execute(Connection connection) throws SQLException {
                    try {
                        //Thuc hien insert
                        String sql = "INSERT "
                                + "    INTO "
                                + "        material "
                                + "        (code,complete_code, cost, name, unit, parent_id, item_type_id, quantity, location) "
                                + "    VALUES "
                                + "        (?,?,?,?,?,?,?,?,?)";
                        connection.setAutoCommit(false);
                        PreparedStatement ps = connection.prepareStatement(sql);
                        int i = 1;
                        int idx = 0;
                        HashMap<String, String> hsmGet = new HashMap<>();
                        for (MaterialObj material : listMat) {
                            if (material.getParentId() <= 0 && !StringUtils.isBlank(material.getParentCode())) {
                                hsmGet.put(material.getCompleteCode(), material.getCompleteCode());
                                hsmGet.put(material.getParentCode(), material.getParentCode());
                            }
                            i = 1;
                            ps.setString(i++, material.getCode());
                            ps.setString(i++, material.getCompleteCode());
                            ps.setFloat(i++, material.getCost());
                            ps.setString(i++, material.getName());
                            ps.setString(i++, material.getUnit());
                            if (material.getParentId() == null) {
                                ps.setNull(i++, java.sql.Types.BIGINT);
                            } else {
                                ps.setLong(i++, material.getParentId());
                            }
                            if (material.getItemTypeId() == null) {
                                ps.setNull(i++, java.sql.Types.INTEGER);
                            } else {
                                ps.setInt(i++, material.getItemTypeId());
                            }
                            if (material.getQuantity() == null) {
                                ps.setInt(i++, 0);
                            } else {
                                ps.setInt(i++, material.getQuantity());
                            }
                            ps.setString(i++, material.getLocation());
                            ps.addBatch();
                            idx++;
                            if (idx % BATCH_LIMIT == 0) {
                                ps.executeBatch();
                                ps.clearBatch();
                            }
                        }
                        if (idx % BATCH_LIMIT > 0) {
                            ps.executeBatch();
                        }
                        connection.commit();

                        //
                        if (!hsmGet.isEmpty()) {
                            StringBuffer sqlSelect = new StringBuffer();
                            sqlSelect.setLength(0);
                            sqlSelect.append("SELECT id,complete_code from material WHERE complete_code IN (");
                            for (Map.Entry<String, String> entrySet : hsmGet.entrySet()) {
                                String key = entrySet.getKey();
                                sqlSelect.append("'").append(key).append("',");
                            }
                            sqlSelect = sqlSelect.deleteCharAt(sqlSelect.length() - 1);
                            sqlSelect.append(")");

                            log.info("------------sqlSelect: " + sqlSelect.toString());
                            PreparedStatement psSelect = connection.prepareStatement(sqlSelect.toString());
                            ResultSet rs = psSelect.executeQuery();

                            HashMap<String, Long> lstMat = new HashMap<>();
                            while (rs.next()) {
                                log.info("--complete_code: " + rs.getString("complete_code") + " -: " + rs.getLong("id"));
                                lstMat.put(rs.getString("complete_code"), rs.getLong("id"));
                            }

                            String sqlUpdateParent = "UPDATE material SET parent_id=? WHERE id=?";
                            PreparedStatement psUpdate = connection.prepareStatement(sqlUpdateParent);
                            Long parentId, matId;
                            idx = 0;
                            for (MaterialObj material : listMat) {
                                if (material.getParentId() <= 0 && !StringUtils.isBlank(material.getParentCode())) {
                                    matId = lstMat.get(material.getCompleteCode());
                                    parentId = lstMat.get(material.getParentCode());
                                    log.info("--------material.getCompleteCode(): " + material.getCompleteCode() + " - " + material.getParentCode() + ": " + matId + " - " + parentId);
                                    if (matId != null && parentId != null) {
                                        psUpdate.setLong(1, parentId);
                                        psUpdate.setLong(2, matId);
                                        psUpdate.addBatch();
                                        idx++;
                                        if (idx % BATCH_LIMIT == 0) {
                                            psUpdate.executeBatch();
                                            psUpdate.clearBatch();
                                        }
                                    }
                                }
                            }
                            if (idx % BATCH_LIMIT > 0) {
                                psUpdate.executeBatch();
                            }
                        }
                        return idx;
                    } catch (Exception ex) {
                        log.error("ERROR aaa insertListWithParentUseSql: ", ex);
                        connection.rollback();
                        return null;
                    } finally {
                        try {
                            // Make it back to default.
                            connection.setAutoCommit(true);
                        } catch (SQLException ex1) {
                            log.error("ERROR insertListWithParentUseSql setAutoCommit: ", ex1);
                        }

                    }
                }
            });
        } catch (Exception ex) {
            log.error("ERROR insertListWithParentUseSql: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="insertListUseSql">
    @Override
    public Integer insertListUseSql(final List<MaterialObj> listMat) {
        try {
            return getSession().doReturningWork(new ReturningWork<Integer>() {
                @Override
                public Integer execute(Connection connection) throws SQLException {
                    try {
                        //Thuc hien insert
                        String sql = "INSERT "
                                + "    INTO "
                                + "        material "
                                + "        (code,complete_code, cost, name, unit, item_type_id, quantity, location) "
                                + "    VALUES "
                                + "        (?,?,?,?,?,?,?,?)";
                        connection.setAutoCommit(false);
                        PreparedStatement ps = connection.prepareStatement(sql);
                        int i = 1;
                        int idx = 0;
                        for (MaterialObj material : listMat) {
                            i = 1;
                            ps.setString(i++, material.getCode());
                            ps.setString(i++, material.getCompleteCode());
                            ps.setFloat(i++, material.getCost());
                            ps.setString(i++, material.getName());
                            ps.setString(i++, material.getUnit());
                            if (material.getItemTypeId() == null) {
                                ps.setNull(i++, java.sql.Types.INTEGER);
                            } else {
                                ps.setInt(i++, material.getItemTypeId());
                            }
                            if (material.getQuantity() == null) {
                                ps.setInt(i++, 0);
                            } else {
                                ps.setInt(i++, material.getQuantity());
                            }
                            ps.setString(i++, material.getLocation());
                            ps.addBatch();
                            idx++;
                            if (idx % BATCH_LIMIT == 0) {
                                ps.executeBatch();
                                ps.clearBatch();
                            }
                        }
                        if (idx % BATCH_LIMIT > 0) {
                            ps.executeBatch();
                        }
                        connection.commit();
                        return idx;
                    } catch (Exception ex) {
                        log.error("ERROR aaa insertListUseSql: ", ex);
                        connection.rollback();
                        return null;
                    } finally {
                        try {
                            // Make it back to default.
                            connection.setAutoCommit(true);
                        } catch (SQLException ex1) {
                            log.error("ERROR insertListUseSql setAutoCommit: ", ex1);
                        }

                    }
                }
            });
        } catch (Exception ex) {
            log.error("ERROR insertListUseSql: ", ex);
            return null;
        }
    }//</editor-fold>
}
