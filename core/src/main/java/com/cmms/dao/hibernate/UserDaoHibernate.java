package com.cmms.dao.hibernate;

import com.cmms.dao.UserDao;
import com.cmms.model.User;
import java.util.Arrays;
import java.util.HashMap;
import org.hibernate.Query;
import org.hibernate.criterion.Restrictions;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.orm.hibernate4.SessionFactoryUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;

import javax.persistence.Table;
import java.util.List;
import java.util.Map;
import static javafx.scene.input.KeyCode.Y;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;

/**
 * This class interacts with Hibernate session to save/delete and retrieve User
 * objects.
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 * Modified by <a href="mailto:dan@getrolling.com">Dan Kibler</a>
 * Extended to implement Acegi UserDetailsService interface by David Carter
 * david@carter.net Modified by <a href="mailto:bwnoll@gmail.com">Bryan Noll</a>
 * to work with the new BaseDaoHibernate implementation that uses generics.
 * Modified by jgarcia (updated to hibernate 4)
 */
@Repository("userDao")
public class UserDaoHibernate extends GenericDaoHibernate<User, Long> implements UserDao, UserDetailsService {

    /**
     * Constructor that sets the entity to User.class.
     */
    public UserDaoHibernate() {
        super(User.class);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<User> getUsers() {
        Query qry = getSession().createQuery("from User u order by upper(u.username)");
        return qry.list();
    }

    /**
     * {@inheritDoc}
     */
    public User saveUser(User user) {
        if (log.isDebugEnabled()) {
            log.debug("user's id: " + user.getId());
        }
        getSession().saveOrUpdate(user);
        // necessary to throw a DataIntegrityViolation and catch it in UserManager
        getSession().flush();
        return user;
    }

    /**
     * Overridden simply to call the saveUser method. This is happening because
     * saveUser flushes the session and saveObject of BaseDaoHibernate does not.
     *
     * @param user the user to save
     * @return the modified user (with a primary key set if they're new)
     */
    @Override
    public User save(User user) {
        return this.saveUser(user);
    }

    /**
     * {@inheritDoc}
     */
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        List users = getSession().createCriteria(User.class).add(Restrictions.eq("username", username)).list();
        if (users == null || users.isEmpty()) {
            return null;
//            throw new UsernameNotFoundException("user '" + username + "' not found...");
        } else {
            return (UserDetails) users.get(0);
        }
    }

    /**
     * {@inheritDoc}
     */
    public String getUserPassword(Long userId) {
        JdbcTemplate jdbcTemplate
                = new JdbcTemplate(SessionFactoryUtils.getDataSource(getSessionFactory()));
        Table table = AnnotationUtils.findAnnotation(User.class, Table.class);
        return jdbcTemplate.queryForObject(
                "select password from " + table.name() + " where id=?", String.class, userId);
    }

    @Override
    public Map getList(Long id, List<Integer> lstSystem, List<Integer> listEng, String username, String name, String email, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(User.class);

            if (lstSystem != null) {
                if (lstSystem.isEmpty()) {
                    return result;
                }
                log.info("--------lstSystem: " + StringUtils.join(lstSystem, ","));
                if (id == null) {
                    criteria.add(Restrictions.in("system.id", lstSystem));
                } else {
                    Criterion rest1 = Restrictions.and(Restrictions.in("system.id", lstSystem));
                    criteria.add(Restrictions.or(rest1, Restrictions.eq("id", id)));
                }
            }
            if (listEng != null) {
                if (listEng.isEmpty()) {
                    return result;
                }
                log.info("--------listEng: " + StringUtils.join(listEng, ","));
                criteria.add(Restrictions.in("groupEngineer.id", listEng));
            }

//            if (lstSystem != null && rest1 != null) {
//                criteria.add(Restrictions.or(rest1, Restrictions.eq("id", id)));
//            }
            //Name
            if (!StringUtils.isBlank(username)) {
                criteria.add(Restrictions.like("username", "%" + username.trim() + "%").ignoreCase());
            }
            if (!StringUtils.isBlank(email)) {
                criteria.add(Restrictions.like("email", "%" + email.trim() + "%").ignoreCase());
            }

            criteria.addOrder(Order.asc("username"));

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
}
