package com.cmms.dao.hibernate;

import com.cmms.dao.WorkOrderDao;
import com.cmms.model.WorkOrder;
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

/**
 *
 * @author thuyetlv
 */
public class WorkOrderDaoHibernate extends GenericDaoHibernate<WorkOrder, Long> implements WorkOrderDao {

    public WorkOrderDaoHibernate() {
        super(WorkOrder.class);
    }

    @Override
    public Map getList(List<Integer> listEng, List<Integer> listWorkType, String code, String name, Integer start, Integer limit) {
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
    public Integer delete(List<Long> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM work_order WHERE id in (:lstId)")
                    .addEntity(WorkOrder.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
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
