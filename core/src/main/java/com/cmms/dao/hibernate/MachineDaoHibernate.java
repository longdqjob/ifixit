package com.cmms.dao.hibernate;

import com.cmms.dao.MachineDao;
import com.cmms.model.Machine;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;

/**
 *
 * @author thuyetlv
 */
public class MachineDaoHibernate extends GenericDaoHibernate<Machine, Long> implements MachineDao {

    public MachineDaoHibernate() {
        super(Machine.class);
    }

    @Override
    public Map getList(List<Integer> listParent, String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            HashMap<String, Object> param = new HashMap<>();
            StringBuffer sb = new StringBuffer();
            sb.setLength(0);

            StringBuffer sbCount = new StringBuffer();
            sbCount.setLength(0);

            sb.append("SELECT * FROM machine WHERE 1=1 ");
            sbCount.append("SELECT COUNT(id) FROM machine WHERE 1=1 ");
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
            if (listParent != null && !listParent.isEmpty()) {
                sb.append(" AND item_type_id IN (:item_type_id) ");
                sbCount.append("AND item_type_id IN (:item_type_id) ");
                param.put("item_type_id", listParent);
            }

            //Count
            Long count = 0L;
            Query qCount = getSession().createSQLQuery(sbCount.toString());
            for (Map.Entry<String, Object> entrySet : param.entrySet()) {
                String key = entrySet.getKey();
                Object value = entrySet.getValue();
                if (key.equals("item_type_id")) {
                    qCount.setParameterList(key, (List<Integer>) value);
                } else {
                    qCount.setParameter(key, value);
                }
            }
            List<BigInteger> listCount = qCount.list();
            for (Iterator<BigInteger> iterator = listCount.iterator(); iterator.hasNext();) {
                count = iterator.next().longValue();
            }

            //List
            sb.append(" ORDER BY item_type_id,code LIMIT :start,:limit");
            param.put("start", start);
            param.put("limit", limit);
            Query q = getSession().createSQLQuery(sb.toString())
                    .addEntity(Machine.class);
            for (Map.Entry<String, Object> entrySet : param.entrySet()) {
                String key = entrySet.getKey();
                Object value = entrySet.getValue();
                if (key.equals("item_type_id")) {
                    q.setParameterList(key, (List<Integer>) value);
                } else {
                    q.setParameter(key, value);
                }
            }
            result.put("list", q.list());
            result.put("count", count);
            return result;
        } catch (Exception ex) {
            log.error("ERROR getList: ", ex);
            return null;
        }
    }

}
