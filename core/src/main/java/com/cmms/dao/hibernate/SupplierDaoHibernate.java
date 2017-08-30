package com.cmms.dao.hibernate;

import com.cmms.dao.SupplierDao;
import com.cmms.model.Supplier;

/**
 *
 * @author thuyetlv
 */
public class SupplierDaoHibernate extends GenericDaoHibernate<Supplier, Integer> implements SupplierDao {

    public SupplierDaoHibernate() {
        super(Supplier.class);
    }

}
