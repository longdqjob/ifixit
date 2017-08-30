package com.cmms.dao.hibernate;

import com.cmms.dao.GroupEngineerDao;
import com.cmms.model.GroupEngineer;

/**
 *
 * @author thuyetlv
 */
public class GroupEngineerDaoHibernate extends GenericDaoHibernate<GroupEngineer, Integer> implements GroupEngineerDao {

    public GroupEngineerDaoHibernate() {
        super(GroupEngineer.class);
    }

}
