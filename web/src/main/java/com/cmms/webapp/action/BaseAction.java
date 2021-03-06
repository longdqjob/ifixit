package com.cmms.webapp.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts2.ServletActionContext;
import com.cmms.Constants;
import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.model.Company;
import com.cmms.model.GroupEngineer;
import com.cmms.model.User;
import com.cmms.service.MailEngine;
import com.cmms.service.RoleManager;
import com.cmms.service.UserManager;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.google.gson.Gson;
import java.text.SimpleDateFormat;
import org.springframework.mail.SimpleMailMessage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Implementation of <strong>ActionSupport</strong> that contains convenience
 * methods for subclasses. For example, getting the current user and saving
 * messages/errors. This class is intended to be a base class for all Action
 * classes.
 *
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a>
 */
public class BaseAction extends ActionSupport {

    private static final long serialVersionUID = 3525445612504421307L;
    public static final SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    /**
     * Constant for cancel result String
     */
    public static final String CANCEL = "cancel";

    /**
     * Transient log to prevent session synchronization issues - children can
     * use instance for logging.
     */
    protected final transient Log log = LogFactory.getLog(getClass());

    /**
     * The UserManager
     */
    protected UserManager userManager;

    /**
     * The RoleManager
     */
    protected RoleManager roleManager;

    /**
     * Indicator if the user clicked cancel
     */
    protected String cancel;

    /**
     * Indicator for the page the user came from.
     */
    protected String from;

    /**
     * Set to "delete" when a "delete" request parameter is passed in
     */
    protected String delete;

    /**
     * Set to "save" when a "save" request parameter is passed in
     */
    protected String save;

    /**
     * MailEngine for sending e-mail
     */
    protected MailEngine mailEngine;

    /**
     * A message pre-populated with default data
     */
    protected SimpleMailMessage mailMessage;

    /**
     * Velocity template to use for e-mailing
     */
    protected String templateName;

    /**
     * Page for paging
     */
    protected int page;

    /**
     * Start item for paging
     */
    protected int start;

    /**
     * Limit items for paging
     */
    protected int limit;

    /**
     * Simple method that returns "cancel" result
     *
     * @return "cancel"
     */
    public String cancel() {
        return CANCEL;
    }

    /**
     * Save the message in the session, appending if messages already exist
     *
     * @param msg the message to put in the session
     */
    @SuppressWarnings("unchecked")
    protected void saveMessage(String msg) {
        List messages = (List) getRequest().getSession().getAttribute("messages");
        if (messages == null) {
            messages = new ArrayList();
        }
        messages.add(msg);
        getRequest().getSession().setAttribute("messages", messages);
    }

    /**
     * Convenience method to get the Configuration HashMap from the servlet
     * context.
     *
     * @return the user's populated form from the session
     */
    protected Map getConfiguration() {
        Map config = (HashMap) getSession().getServletContext().getAttribute(Constants.CONFIG);
        // so unit tests don't puke when nothing's been set
        if (config == null) {
            return new HashMap();
        }
        return config;
    }

    /**
     * Convenience method to get the request
     *
     * @return current request
     */
    protected HttpServletRequest getRequest() {
        return ServletActionContext.getRequest();
    }

    /**
     * Convenience method to get the response
     *
     * @return current response
     */
    protected HttpServletResponse getResponse() {
        return ServletActionContext.getResponse();
    }

    /**
     * Convenience method to get the session. This will create a session if one
     * doesn't exist.
     *
     * @return the session from the request (request.getSession()).
     */
    protected HttpSession getSession() {
        return getRequest().getSession();
    }

    /**
     * Convenience method to send e-mail to users
     *
     * @param user the user to send to
     * @param msg the message to send
     * @param url the URL to the application (or where ever you'd like to send
     * them)
     */
    protected void sendUserMessage(User user, String msg, String url) {
        if (log.isDebugEnabled()) {
            log.debug("sending e-mail to user [" + user.getEmail() + "]...");
        }

        mailMessage.setTo(user.getFullName() + "<" + user.getEmail() + ">");

        Map<String, Object> model = new HashMap<String, Object>();
        model.put("user", user);
        // TODO: figure out how to get bundle specified in struts.xml
        // model.put("bundle", getTexts());
        model.put("message", msg);
        model.put("applicationURL", url);
        mailEngine.sendMessage(mailMessage, templateName, model);
    }

    public void setUserManager(UserManager userManager) {
        this.userManager = userManager;
    }

    public void setRoleManager(RoleManager roleManager) {
        this.roleManager = roleManager;
    }

    public void setMailEngine(MailEngine mailEngine) {
        this.mailEngine = mailEngine;
    }

    public void setMailMessage(SimpleMailMessage mailMessage) {
        this.mailMessage = mailMessage;
    }

    public void setTemplateName(String templateName) {
        this.templateName = templateName;
    }

    /**
     * Convenience method for setting a "from" parameter to indicate the
     * previous page.
     *
     * @param from indicator for the originating page
     */
    public void setFrom(String from) {
        this.from = from;
    }

    public void setDelete(String delete) {
        this.delete = delete;
    }

    public void setSave(String save) {
        this.save = save;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public void setStart(int start) {
        this.start = start;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    GroupEngineerDao groupEngineerDao;
    CompanyDao companyDao;

    public CompanyDao getCompanyDao() {
        return companyDao;
    }

    public void setCompanyDao(CompanyDao companyDao) {
        this.companyDao = companyDao;
    }

    public GroupEngineerDao getGroupEngineerDao() {
        return groupEngineerDao;
    }

    public void setGroupEngineerDao(GroupEngineerDao groupEngineerDao) {
        this.groupEngineerDao = groupEngineerDao;
    }

    public void updateSessionSystem() {
        Integer rtn = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID);
        if (rtn == null) {
            rtn = LoginSuccessHandler.updateSessionSystem(getRequest());
            getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID, rtn);
        }
        String systemName = ResourceBundleUtils.getName("company");
        String obj = "";
        if (rtn != null && rtn > 0) {
            if (companyDao == null) {
                ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(getRequest().getServletContext());
                companyDao = ctx.getBean("companyDao", CompanyDao.class);
            }
            Company company = companyDao.get(rtn);
            systemName = company.getName();

            //SESSION_SYSTEM_OBJ
            try {
                Gson gson = new Gson();
                obj = gson.toJson(companyDao.getTree(company));
            } catch (Exception ex) {
                log.error("ERROR getSytemId: ", ex);
            }
        }
        getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_NAME, systemName);
        getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_OBJ, obj);
    }

    public Integer getSytemId() {
        if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID) != null
                && getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_NAME) != null) {
            return (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID);
        } else {
            Integer rtn = LoginSuccessHandler.updateSessionSystem(getRequest());
            getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID, rtn);
            updateSessionSystem();
            return (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID);
        }
    }

    public void updateSessionEng() {
        Integer rtn = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP);
        if (rtn == null) {
            rtn = LoginSuccessHandler.updateSessionEng(getRequest());
            getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP, rtn);
        }
        String engName = ResourceBundleUtils.getName("grpEngineer");
        String obj = "";
        if (rtn > 0) {
            if (groupEngineerDao == null) {
                ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(getRequest().getServletContext());
                groupEngineerDao = ctx.getBean("groupEngineerDao", GroupEngineerDao.class);
            }
            GroupEngineer groupEngineer = groupEngineerDao.get(rtn);
            engName = groupEngineer.getName();

            //SESSION_SYSTEM_OBJ
            try {
                Gson gson = new Gson();
                obj = gson.toJson(groupEngineerDao.getTree(groupEngineer, null));
            } catch (Exception ex) {
                log.error("ERROR getGrpEngineerId: ", ex);
            }
        }
        getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP_NAME, engName);
        getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP_OBJ, obj);
        log.info("----------------SESSION_ENGINNER_GRP_OBJ--------------");
        log.info(getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP_OBJ));
    }

    public Integer getGrpEngineerId() {
        if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP) != null
                && getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP_NAME) != null) {
            return (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP);
        } else {
            Integer rtn = LoginSuccessHandler.updateSessionEng(getRequest());
            getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP, rtn);
            updateSessionEng();
            return (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP);
        }
    }

    //Lay danh sach system thuoc user
    public List<Integer> getListSytem() {
        log.info("-------------SESSION_LIST_SYSTEM_ID: " + getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID));
        if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID) != null) {
            return (List<Integer>) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID);
        }
        return null;
    }

    //Lay danh sach group_engineer thuoc user
    public List<Integer> getListGrpEngineer() {
        if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_GRP_ENGINNER) != null) {
            return (List<Integer>) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_LIST_GRP_ENGINNER);
        }
        return null;
    }

    public static final String PATH_UPLOAD = "upload";
    public static final String PATH_MATERIAL = "material";
    public static final String PATH_MECHANIC = "mechanic";
    public static final String PATH_TEMPLATE = "template";
}
