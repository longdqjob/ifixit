package com.cmms.dao.hibernate;

import com.cmms.dao.GroupEngineerDao;
import com.cmms.model.GroupEngineer;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author thuyetlv
 */
public class GroupEngineerDaoHibernate extends GenericDaoHibernate<GroupEngineer, Integer> implements GroupEngineerDao {

    public GroupEngineerDaoHibernate() {
        super(GroupEngineer.class);
    }

    @Override
    public Boolean checkUnique(Integer id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<GroupEngineer> list = new ArrayList<GroupEngineer>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(GroupEngineer.class);

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
