package com.cmms.dao.hibernate;

import com.cmms.dao.WorkOrderDao;
import com.cmms.model.WorkOrder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.jdbc.ReturningWork;

/**
 *
 * @author thuyetlv
 */
public class WorkOrderDaoHibernate extends GenericDaoHibernate<WorkOrder, Long> implements WorkOrderDao {

    public WorkOrderDaoHibernate() {
        super(WorkOrder.class);
    }

    @Override
    public Map getList(List<Integer> listEng, List<Integer> listWorkType, Long mechanicId, String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(WorkOrder.class);

            //Name
            if (!StringUtils.isBlank(code)) {
                criteria.add(Restrictions.like("code", "%" + code.trim() + "%").ignoreCase());
            }
            if (!StringUtils.isBlank(name)) {
                criteria.add(Restrictions.like("name", "%" + name.trim() + "%").ignoreCase());
            }
            if (mechanicId != null && mechanicId > 0) {
                criteria.add(Restrictions.eq("machine.id", mechanicId));
            }

            if (listEng != null && !listEng.isEmpty()) {
                criteria.add(Restrictions.in("groupEngineer.id", listEng));
            }
            if (listWorkType != null && !listWorkType.isEmpty()) {
                criteria.add(Restrictions.in("workType.id", listWorkType));
            }
            criteria.addOrder(Order.desc("name"));

            Integer total = 0;
            if (limit != null && limit > 0) {
                // get the count
                criteria.setProjection(Projections.rowCount());
                total = ((Long) criteria.uniqueResult()).intValue();
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
    }

    @Override
    public Integer delete(final List<Long> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }

            return getSession().doReturningWork(new ReturningWork<Integer>() {
                @Override
                public Integer execute(Connection connection) throws SQLException {
                    PreparedStatement ps = null;
                    try {
                        Integer rtn = 0;
                        connection.setAutoCommit(false);
                        String lstId = StringUtils.join(list, ",");
                        String sql;

                        //Delete in man_hours
                        sql = "DELETE FROM man_hours WHERE id in (" + lstId + ")";
                        ps = connection.prepareStatement(sql);
                        ps.executeUpdate();
                        //Delete in stock_item
                        sql = "DELETE FROM stock_item WHERE id in (" + lstId + ")";
                        ps = connection.prepareStatement(sql);
                        ps.executeUpdate();

                        //Delete work_order
                        sql = "DELETE FROM work_order WHERE id in (" + lstId + ")";
                        ps = connection.prepareStatement(sql);
                        rtn = ps.executeUpdate();
                        if (rtn > 0) {
                            connection.commit();
                        }
                        return rtn;
                    } catch (Exception ex) {
                        log.error("ERROR delete: ", ex);
                        connection.rollback();
                        return null;
                    } finally {
                        if (ps != null) {
                            ps.close();
                            ps = null;
                        }
                        connection.setAutoCommit(true);
                    }
                }
            });
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }

    @Override
    public Boolean checkUnique(Long id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<WorkOrder> list = new ArrayList<WorkOrder>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(WorkOrder.class);

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
    }
}
