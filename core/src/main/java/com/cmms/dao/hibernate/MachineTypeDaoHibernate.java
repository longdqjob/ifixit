package com.cmms.dao.hibernate;

import com.cmms.dao.MachineTypeDao;
import com.cmms.model.MachineType;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author thuyetlv
 */
public class MachineTypeDaoHibernate extends GenericDaoHibernate<MachineType, Integer> implements MachineTypeDao {

    public MachineTypeDaoHibernate() {
        super(MachineType.class);
    }

    @Override
    public Map getList(String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            HashMap<String, Object> param = new HashMap<>();
            StringBuffer sb = new StringBuffer();
            sb.setLength(0);

            StringBuffer sbCount = new StringBuffer();
            sbCount.setLength(0);

            sb.append("SELECT * FROM machine_type WHERE 1=1 ");
            sbCount.append("SELECT COUNT(id) FROM machine_type WHERE 1=1 ");
            if (!StringUtils.isBlank(code)) {
                sb.append(" AND code LIKE :code ");
                sbCount.append(" AND code LIKE :code ");
                param.put("code", "%" + code.trim() + "%");
            }
            if (!StringUtils.isBlank(name)) {
                sb.append(" AND name LIKE :name ");
                sbCount.append(" AND name LIKE :name ");
                param.put("name", "%" + name.trim() + "%");
            }

            //Count
            Long count = 0L;
            Query qCount = getSession().createSQLQuery(sbCount.toString());
            for (Map.Entry<String, Object> entrySet : param.entrySet()) {
                String key = entrySet.getKey();
                Object value = entrySet.getValue();
                qCount.setParameter(key, value);
            }
            List<BigInteger> listCount = qCount.list();
            for (Iterator<BigInteger> iterator = listCount.iterator(); iterator.hasNext();) {
                count = iterator.next().longValue();
            }

            //List
            sb.append(" ORDER BY name,code LIMIT :start,:limit");
            param.put("start", start);
            param.put("limit", limit);
            Query q = getSession().createSQLQuery(sb.toString())
                    .addEntity(MachineType.class);
            for (Map.Entry<String, Object> entrySet : param.entrySet()) {
                String key = entrySet.getKey();
                Object value = entrySet.getValue();
                q.setParameter(key, value);
            }
            result.put("list", q.list());
            result.put("count", count);
            return result;
        } catch (Exception ex) {
            log.error("ERROR getList: ", ex);
            return null;
        }
    }

    @Override
    public Integer delete(List<Integer> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM machine_type WHERE id in (:lstId)")
                    .addEntity(MachineType.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }

    @Override
    public Boolean checkUnique(Integer id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<MachineType> list = new ArrayList<MachineType>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(MachineType.class);

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
    
    /**
     *
     * @param lstId
     * @return true neu duoc su dung tren WO
     */
    @Override
    public Boolean checkUseMechanic(List<Integer> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            Query query = getSession().createSQLQuery("SELECT * FROM machine WHERE machine_type_id in (:lstId)")
                    .setParameterList("lstId", lstId);
            return (query.list().size() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUseMechanic: " + StringUtils.join(lstId, ","), ex);
            return null;
        }
    }
}
