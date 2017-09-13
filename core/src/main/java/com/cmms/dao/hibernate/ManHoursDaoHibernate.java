package com.cmms.dao.hibernate;

import com.cmms.dao.ManHoursDao;
import com.cmms.model.ManHours;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author thuyetlv
 */
public class ManHoursDaoHibernate extends GenericDaoHibernate<ManHours, Long> implements ManHoursDao {

    public ManHoursDaoHibernate() {
        super(ManHours.class);
    }

    @Override
    public Map getList(Long workType, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(ManHours.class);

            //Name
            if (workType != null) {
                criteria.add(Restrictions.eq("workOrder.id", workType));
            }
            criteria.addOrder(Order.desc("id"));
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
            Query q = getSession().createSQLQuery("DELETE FROM man_hours WHERE id in (:lstId)")
                    .addEntity(ManHours.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }

    @Override
    public Integer deleteByWorkOrder(List<Long> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM man_hours WHERE work_order_id in (:lstId)")
                    .addEntity(ManHours.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR deleteByWorkOrder: ", ex);
            return null;
        }
    }
}
