package com.cmms.webapp.interceptor;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.webapp.security.LoginSuccessHandler;
import static com.cmms.webapp.security.LoginSuccessHandler.SESSION_USER_ID;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;
import org.apache.struts2.ServletActionContext;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletContext;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Security interceptor checks to see if users are in the specified roles before
 * proceeding. Similar to Spring's UserRoleAuthorizationInterceptor.
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 * @see org.springframework.web.servlet.handler.UserRoleAuthorizationInterceptor
 */
public class UserRoleAuthorizationInterceptor implements Interceptor {

    private static final long serialVersionUID = 5067790608840427509L;
    private String[] authorizedRoles;
    protected final transient Log log = LogFactory.getLog(getClass());

    @Autowired
    private ServletContext context;

    /**
     * Intercept the action invocation and check to see if the user has the
     * proper role.
     *
     * @param invocation the current action invocation
     * @return the method's return value, or null after setting
     * HttpServletResponse.SC_FORBIDDEN
     * @throws Exception when setting the error on the response fails
     */
    public String intercept(ActionInvocation invocation) throws Exception {
        HttpServletRequest request = ServletActionContext.getRequest();

        //System
        if (request.getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID) == null) {
            Integer systemId = 1;
            
            ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(context);
            CompanyDao companyDao = ctx.getBean("companyDao", CompanyDao.class);
            List<Integer> list = companyDao.getListChildren(systemId);
            log.info("------------------getListChildren: " + StringUtils.join(list, ","));
            request.getSession().setAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID, list);
        }
        //Grp ENGINNER
        if (request.getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_GRP_ENGINNER) == null) {
            Integer engineerGrpID = 1;
            ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(context);
            GroupEngineerDao groupEngineerDao = ctx.getBean("groupEngineerDao", GroupEngineerDao.class);
            List<Integer> list = groupEngineerDao.getListChildren(engineerGrpID);
            log.info("------------------get groupEngineerDao: " + StringUtils.join(list, ","));
            request.getSession().setAttribute(LoginSuccessHandler.SESSION_LIST_GRP_ENGINNER, list);
        }
        if (this.authorizedRoles != null) {
            for (String authorizedRole : this.authorizedRoles) {
                if (request.isUserInRole(authorizedRole)) {
                    return invocation.invoke();
                }
            }
        }

        HttpServletResponse response = ServletActionContext.getResponse();
        handleNotAuthorized(request, response);
        return null;
    }

    /**
     * Set the roles that this interceptor should treat as authorized.
     *
     * @param authorizedRoles array of role names
     */
    public final void setAuthorizedRoles(String[] authorizedRoles) {
        this.authorizedRoles = authorizedRoles;
    }

    /**
     * Handle a request that is not authorized according to this interceptor.
     * Default implementation sends HTTP status code 403 ("forbidden").
     *
     * <p>
     * This method can be overridden to write a custom message, forward or
     * redirect to some error page or login page, or throw a ServletException.
     *
     * @param request current HTTP request
     * @param response current HTTP response
     * @throws javax.servlet.ServletException if there is an internal error
     * @throws java.io.IOException in case of an I/O error when writing the
     * response
     */
    protected void handleNotAuthorized(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    protected void handleNotAuthorized2(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_PROXY_AUTHENTICATION_REQUIRED, String.valueOf(HttpServletResponse.SC_PROXY_AUTHENTICATION_REQUIRED));
        response.setStatus(HttpServletResponse.SC_PROXY_AUTHENTICATION_REQUIRED);
    }

    /**
     * This method currently does nothing.
     */
    public void destroy() {
    }

    /**
     * This method currently does nothing.
     */
    public void init() {
    }
}
