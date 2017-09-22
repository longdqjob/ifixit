package com.cmms.webapp.action;

import com.opensymphony.xwork2.Preparable;
import org.apache.struts2.ServletActionContext;
import com.cmms.Constants;
import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.dao.SearchException;
import com.cmms.model.Company;
import com.cmms.model.GroupEngineer;
import com.cmms.model.Role;
import com.cmms.model.User;
import com.cmms.service.UserExistsException;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.RequestUtil;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
import java.io.ByteArrayInputStream;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.mail.MailException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.authentication.AuthenticationTrustResolverImpl;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for facilitating User Management feature.
 */
public class UserAction extends BaseAction implements Preparable {

    //<editor-fold defaultstate="collapsed" desc="Other">
    private static final long serialVersionUID = 6776558938712115191L;
    private List<User> users;
    private User user;
    private String id;
    private String query;
    private CompanyDao companyDao;
    private GroupEngineerDao groupEngineerDao;

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

    /**
     * Grab the entity from the database before populating with request
     * parameters
     */
    public void prepare() {
        // prevent failures on new
        if (getRequest().getMethod().equalsIgnoreCase("post") && (!"".equals(getRequest().getParameter("user.id")))) {
            user = userManager.getUser(getRequest().getParameter("user.id"));
        }
    }

    public String index() {
        updateSessionSystem();
        return SUCCESS;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getLoadData">
    public InputStream getLoadData() {
        try {
            JSONObject result = new JSONObject();
            String username = getRequest().getParameter("username");
            String name = getRequest().getParameter("name");
            String email = getRequest().getParameter("email");

            //systemId
            String systemIdReq = getRequest().getParameter("systemId");
            Integer systemId = null;
            if (!StringUtils.isBlank(systemIdReq)) {
                systemId = Integer.parseInt(systemIdReq);
            }
            List<Integer> listSystem = null;
            if (systemId == null || systemId <= 0) {
                systemId = getSytemId();
            }
            if (systemId > getSytemId()) {
                listSystem = companyDao.getListChildren(systemId, true);
            } else {
                //Chi list user con, khong load user cung cap
                listSystem = companyDao.getListChildren(getSytemId(), false);
            }

            //groupEngineerDao
            String engineerIdReq = getRequest().getParameter("engineerId");
            Integer engineerId = null;
            if (!StringUtils.isBlank(engineerIdReq)) {
                engineerId = Integer.parseInt(engineerIdReq);
            }
            List<Integer> listEng = null;
            if (engineerId == null || engineerId <= 0) {
                engineerId = null;
                if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP) != null) {
                    engineerId = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP);
                }
            }
            if (engineerId > 0) {
                listEng = groupEngineerDao.getListChildren(engineerId);
            }

            Map pagingMap = userManager.getList(listSystem, listEng, username, name, email, start, limit);

            ArrayList<User> list = new ArrayList<User>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<User>) pagingMap.get("list");
            }

            Integer count = 0;
            if (pagingMap.get("count") != null) {
                count = (Integer) pagingMap.get("count");
            }

            JSONArray jSONArray = new JSONArray();
            JSONObject tmp;
            Company company;
            GroupEngineer groupEngineer;
            for (User user : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(user, "groupEngineer,system");
                groupEngineer = user.getGroupEngineer();
                if (groupEngineer != null) {
                    tmp.put("grpEngineerId", groupEngineer.getId());
                    tmp.put("grpEngineerName", groupEngineer.getName());
                } else {
                    tmp.put("grpEngineerId", "");
                    tmp.put("grpEngineerName", "");
                }
                company = user.getSystem();
                if (company != null) {
                    tmp.put("systemId", company.getId());
                    tmp.put("systemName", company.getName());
                } else {
                    tmp.put("systemId", "");
                    tmp.put("systemName", "");
                }
                jSONArray.put(tmp);
            }

            //Add current user
            User authUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            boolean add = true;
            if (!StringUtils.isBlank(username)) {
                if (!authUser.getUsername().trim().toLowerCase().contains(username.trim().toLowerCase())) {
                    add = false;
                }
            }
            if (add) {
                if (!StringUtils.isBlank(email)) {
                    if (!authUser.getEmail().trim().toLowerCase().contains(email.trim().toLowerCase())) {
                        add = false;
                    }
                }
            }
            if (add) {
                if (Objects.equals(systemId, authUser.getSystemId())) {
                    //Truong hop khong tim kiem theo system
                    add = true;
                } else {
                    if (listSystem != null) {
                        boolean found = false;
                        for (Integer system : listSystem) {
                            if (Objects.equals(authUser.getSystemId(), system)) {
                                found = true;
                                break;
                            }
                        }
                        add = found;
                    }
                }
            }
            if (add) {
                if (listEng != null) {
                    boolean found = false;
                    for (Integer system : listEng) {
                        if (Objects.equals(authUser.getGroupEngineerId(), system)) {
                            found = true;
                            break;
                        }
                    }
                    add = found;
                }
            }

            if (add) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(authUser, "groupEngineer,system");
                groupEngineer = authUser.getGroupEngineer();
                if (groupEngineer != null) {
                    tmp.put("grpEngineerId", groupEngineer.getId());
                    tmp.put("grpEngineerName", groupEngineer.getName());
                } else {
                    tmp.put("grpEngineerId", "");
                    tmp.put("grpEngineerName", "");
                }
                company = authUser.getSystem();
                if (company != null) {
                    tmp.put("systemId", company.getId());
                    tmp.put("systemName", company.getName());
                } else {
                    tmp.put("systemId", "");
                    tmp.put("systemName", "");
                }
                jSONArray.put(tmp);
                count++;
            }

            result.put("list", jSONArray);
            result.put("totalCount", count);
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getLoadData: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSave">
    public InputStream getSave() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Long id = null;
            String username = getRequest().getParameter("username");
            String name = getRequest().getParameter("name");
            String email = getRequest().getParameter("email");
            String systemId = getRequest().getParameter("systemId");
            String engineerId = getRequest().getParameter("engineerId");

            User user;
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
                user = userManager.get(id);
            } else {
                user = new User();
                user.setUsername(username);
                User userCheck = userManager.getUserByUsername(username);
                if (userCheck != null) {
                    result.put("success", "usernameExits");
                    result.put("message", ResourceBundleUtils.getName("usernameExits"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
            }
            user.setLastName(name);
            user.setEmail(email);

            if (!StringUtils.isBlank(systemId)) {
                Company company = companyDao.get(Integer.parseInt(systemId));
                user.setSystem(company);
            } else {
                if (getSytemId() > 0) {
                    result.put("success", "userSystemRequired");
                    result.put("message", ResourceBundleUtils.getName("userSystemRequired"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
            }

            if (!StringUtils.isBlank(engineerId)) {
                GroupEngineer groupEngineer = groupEngineerDao.get(Integer.parseInt(engineerId));
                user.setGroupEngineer(groupEngineer);
            } else {
                if (getGrpEngineerId() > 0) {
                    result.put("success", "userEngRequired");
                    result.put("message", ResourceBundleUtils.getName("userEngRequired"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
            }

            user = userManager.save(user);
            if (user != null) {
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("saveSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("saveFail"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSave: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getDelete">
    private String[] ids;

    public String[] getIds() {
        return ids;
    }

    public void setIds(String[] ids) {
        this.ids = ids;
    }

    public InputStream getDelete() {
        try {
            JSONObject result = new JSONObject();
            if (ids != null && ids.length > 0) {
                User authUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
                Boolean check = false;
                for (String id : ids) {
                    if (authUser.getId() == Long.parseLong(id)) {
                        check = true;
                    }
                    userManager.remove(Long.parseLong(id));
                }
                if (check) {
                    result.put("success", true);
                    result.put("message", ResourceBundleUtils.getName("deleteCurrent"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("deleteSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("notSelect"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getDelete: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="linh tinh">
    /**
     * Holder for users to display on list screen
     *
     * @return list of users
     */
    public List<User> getUsers() {
        return users;
    }

    public void setId(String id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setQ(String q) {
        this.query = q;
    }

    /**
     * Delete the user passed in.
     *
     * @return success
     */
    public String delete() {
        userManager.removeUser(user.getId().toString());
        List<Object> args = new ArrayList<Object>();
        args.add(user.getFullName());
        saveMessage(getText("user.deleted", args));

        return SUCCESS;
    }

    /**
     * Grab the user from the database based on the "id" passed in.
     *
     * @return success if user found
     * @throws IOException can happen when sending a "forbidden" from
     * response.sendError()
     */
    public String edit() throws IOException {
        HttpServletRequest request = getRequest();
        boolean editProfile = request.getRequestURI().contains("editProfile");

        // if URL is "editProfile" - make sure it's the current user
        if (editProfile && ((request.getParameter("id") != null) || (request.getParameter("from") != null))) {
            ServletActionContext.getResponse().sendError(HttpServletResponse.SC_FORBIDDEN);
            log.warn("User '" + request.getRemoteUser() + "' is trying to edit user '"
                    + request.getParameter("id") + "'");
            return null;
        }

        // if a user's id is passed in
        if (id != null) {
            // lookup the user using that id
            user = userManager.getUser(id);
        } else if (editProfile) {
            user = userManager.getUserByUsername(request.getRemoteUser());
        } else {
            user = new User();
            user.addRole(new Role(Constants.USER_ROLE));
        }

        if (user.getUsername() != null) {
            user.setConfirmPassword(user.getPassword());

            // if user logged in with remember me, display a warning that they can't change passwords
            log.debug("checking for remember me login...");

            AuthenticationTrustResolver resolver = new AuthenticationTrustResolverImpl();
            SecurityContext ctx = SecurityContextHolder.getContext();

            if (ctx != null) {
                Authentication auth = ctx.getAuthentication();

                if (resolver.isRememberMe(auth)) {
                    getSession().setAttribute("cookieLogin", "true");
                    saveMessage(getText("userProfile.cookieLogin"));
                }
            }
        }

        return SUCCESS;
    }

    /**
     * Default: just returns "success"
     *
     * @return "success"
     */
    public String execute() {
        return SUCCESS;
    }

    /**
     * Sends users to "home" when !from.equals("list"). Sends everyone else to
     * "cancel"
     *
     * @return "home" or "cancel"
     */
    public String cancel() {
        if (!"list".equals(from)) {
            return "home";
        }
        return "cancel";
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="save">
    /**
     * Save user
     *
     * @return success if everything worked, otherwise input
     * @throws Exception when setting "access denied" fails on response
     */
    public String save() throws Exception {

        Integer originalVersion = user.getVersion();

        boolean isNew = ("".equals(getRequest().getParameter("user.version")));
        // only attempt to change roles if user is admin
        // for other users, prepare() method will handle populating
        if (getRequest().isUserInRole(Constants.ADMIN_ROLE)) {
            user.getRoles().clear(); // APF-788: Removing roles from user doesn't work
            String[] userRoles = getRequest().getParameterValues("userRoles");

            for (int i = 0; userRoles != null && i < userRoles.length; i++) {
                String roleName = userRoles[i];
                try {
                    user.addRole(roleManager.getRole(roleName));
                } catch (DataIntegrityViolationException e) {
                    return showUserExistsException(originalVersion);
                }
            }
        }

        try {
            userManager.saveUser(user);
        } catch (AccessDeniedException ade) {
            // thrown by UserSecurityAdvice configured in aop:advisor userManagerSecurity
            log.warn(ade.getMessage());
            getResponse().sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        } catch (UserExistsException e) {
            return showUserExistsException(originalVersion);
        }

        if (!"list".equals(from)) {
            // add success messages
            saveMessage(getText("user.saved"));
            return "home";
        } else {
            // add success messages
            List<Object> args = new ArrayList<Object>();
            args.add(user.getFullName());
            if (isNew) {
                saveMessage(getText("user.added", args));
                // Send an account information e-mail
                mailMessage.setSubject(getText("signup.email.subject"));
                try {
                    sendUserMessage(user, getText("newuser.email.message", args), RequestUtil.getAppURL(getRequest()));
                } catch (MailException me) {
                    addActionError(me.getCause().getLocalizedMessage());
                }
                return SUCCESS;
            } else {
                user.setConfirmPassword(user.getPassword());
                saveMessage(getText("user.updated.byAdmin", args));
                return INPUT;
            }
        }
    }

    private String showUserExistsException(Integer originalVersion) {
        List<Object> args = new ArrayList<Object>();
        args.add(user.getUsername());
        args.add(user.getEmail());
        addActionError(getText("errors.existing.user", args));

        // reset the version # to what was passed in
        user.setVersion(originalVersion);
        // redisplay the unencrypted passwords
        user.setPassword(user.getConfirmPassword());
        return INPUT;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="list">
    /**
     * Fetch all users from database and put into local "users" variable for
     * retrieval in the UI.
     *
     * @return "success" if no exceptions thrown
     */
    public String list() {
        try {
            users = userManager.search(query);
        } catch (SearchException se) {
            addActionError(se.getMessage());
            users = userManager.getUsers();
        }
        return SUCCESS;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getAllUser">
    public InputStream getAllUser() throws JSONException, UnsupportedEncodingException {

//        HttpServletRequest request = getRequest();
//        String page = request.getParameter("page");
        System.out.println("page: " + page);
        System.out.println("start: " + start);
        System.out.println("limit: " + limit);

        List<User> userList = new ArrayList<User>();
        try {
            userList = userManager.getAll();
        } catch (SearchException se) {
            return null;
        }
        JSONArray deviceList = new JSONArray();
        for (int i = 0; i < 4; i++) {
            for (User tmp : userList) {
                JSONObject obj = new JSONObject();
                obj.put("Email", tmp.getEmail());
                obj.put("UserName", tmp.getUsername());
                obj.put("Phone", tmp.getPhoneNumber());
                deviceList.put(obj);
            }
        }
        JSONObject result = new JSONObject();
        result.put("list", deviceList);
        result.put("totalCount", 60);
        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getAllTask">
    public InputStream getAllTask() throws JSONException, UnsupportedEncodingException {
        String result = "";
        result = "{\n"
                + "    'text': '.',\n"
                + "    'children': [\n"
                + "        {\n"
                + "            'task': 'Project: Shopping',\n"
                + "            'duration': 13.25,\n"
                + "            'user': 'Tommy Maintz',\n"
                + "            'iconCls': 'task-folder',\n"
                + "            'expanded': true,\n"
                + "            'children': [\n"
                + "                {\n"
                + "                    'task': 'Housewares',\n"
                + "                    'duration': 1.25,\n"
                + "                    'user': 'Tommy Maintz',\n"
                + "                    'iconCls': 'task-folder',\n"
                + "                    'children': [\n"
                + "                        {\n"
                + "                            'task': 'Kitchen supplies',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task'\n"
                + "                        }, {\n"
                + "                            'task': 'Groceries',\n"
                + "                            'duration': .4,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task',\n"
                + "                            'done': true\n"
                + "                        }, {\n"
                + "                            'task': 'Cleaning supplies',\n"
                + "                            'duration': .4,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task'\n"
                + "                        }, {\n"
                + "                            'task': 'Office supplies',\n"
                + "                            'duration': .2,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task'\n"
                + "                        }\n"
                + "                    ]\n"
                + "                }, {\n"
                + "                    'task': 'Remodeling',\n"
                + "                    'duration': 12,\n"
                + "                    'user': 'Tommy Maintz',\n"
                + "                    'iconCls': 'task-folder',\n"
                + "                    'expanded': true,\n"
                + "                    'children': [\n"
                + "                        {\n"
                + "                            'task': 'Retile kitchen',\n"
                + "                            'duration': 6.5,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task'\n"
                + "                        }, {\n"
                + "                            'task': 'Paint bedroom',\n"
                + "                            'duration': 2.75,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'iconCls': 'task-folder',\n"
                + "                            'children': [\n"
                + "                                {\n"
                + "                                    'task': 'Ceiling',\n"
                + "                                    'duration': 1.25,\n"
                + "                                    'user': 'Tommy Maintz',\n"
                + "                                    'iconCls': 'task',\n"
                + "                                    'leaf': true\n"
                + "                                }, {\n"
                + "                                    'task': 'Walls',\n"
                + "                                    'duration': 1.5,\n"
                + "                                    'user': 'Tommy Maintz',\n"
                + "                                    'iconCls': 'task',\n"
                + "                                    'leaf': true\n"
                + "                                }\n"
                + "                            ]\n"
                + "                        }, {\n"
                + "                            'task': 'Decorate living room',\n"
                + "                            'duration': 2.75,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task',\n"
                + "                            'done': true\n"
                + "                        }, {\n"
                + "                            'task': 'Fix lights',\n"
                + "                            'duration': .75,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task',\n"
                + "                            'done': true\n"
                + "                        }, {\n"
                + "                            'task': 'Reattach screen door',\n"
                + "                            'duration': 2,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'leaf': true,\n"
                + "                            'iconCls': 'task'\n"
                + "                        }\n"
                + "                    ]\n"
                + "                }\n"
                + "            ]\n"
                + "        }, {\n"
                + "            'task': 'Project: Testing',\n"
                + "            'duration': 2,\n"
                + "            'user': 'Core Team',\n"
                + "            'iconCls': 'task-folder',\n"
                + "            'children': [\n"
                + "                {\n"
                + "                    'task': 'Mac OSX',\n"
                + "                    'duration': 0.75,\n"
                + "                    'user': 'Tommy Maintz',\n"
                + "                    'iconCls': 'task-folder',\n"
                + "                    'children': [\n"
                + "                        {\n"
                + "                            'task': 'FireFox',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }, {\n"
                + "                            'task': 'Safari',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }, {\n"
                + "                            'task': 'Chrome',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Tommy Maintz',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }\n"
                + "                    ]\n"
                + "                }, {\n"
                + "                    'task': 'Windows',\n"
                + "                    'duration': 3.75,\n"
                + "                    'user': 'Darrell Meyer',\n"
                + "                    'iconCls': 'task-folder',\n"
                + "                    'children': [\n"
                + "                        {\n"
                + "                            'task': 'FireFox',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Darrell Meyer',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }, {\n"
                + "                            'task': 'Safari',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Darrell Meyer',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }, {\n"
                + "                            'task': 'Chrome',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Darrell Meyer',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }, {\n"
                + "                            'task': 'Internet Explorer',\n"
                + "                            'duration': 3,\n"
                + "                            'user': 'Darrell Meyer',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }\n"
                + "                    ]\n"
                + "                }, {\n"
                + "                    'task': 'Linux',\n"
                + "                    'duration': 0.5,\n"
                + "                    'user': 'Aaron Conran',\n"
                + "                    'iconCls': 'task-folder',\n"
                + "                    'children': [\n"
                + "                        {\n"
                + "                            'task': 'FireFox',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Aaron Conran',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }, {\n"
                + "                            'task': 'Chrome',\n"
                + "                            'duration': 0.25,\n"
                + "                            'user': 'Aaron Conran',\n"
                + "                            'iconCls': 'task',\n"
                + "                            'leaf': true\n"
                + "                        }\n"
                + "                    ]\n"
                + "                }\n"
                + "            ]\n"
                + "        }\n"
                + "    ]\n"
                + "}";

        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
    }//</editor-fold>

}
