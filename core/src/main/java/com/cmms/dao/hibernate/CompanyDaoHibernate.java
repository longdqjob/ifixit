package com.cmms.dao.hibernate;

import com.cmms.dao.CompanyDao;
import com.cmms.model.Company;

/**
 *
 * @author thuyetlv
 */
public class CompanyDaoHibernate extends GenericDaoHibernate<Company, Integer> implements CompanyDao {

    public CompanyDaoHibernate() {
        super(Company.class);
    }

}
