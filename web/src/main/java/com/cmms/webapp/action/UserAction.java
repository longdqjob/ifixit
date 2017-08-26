package com.cmms.webapp.action;

import com.opensymphony.xwork2.Preparable;
import org.apache.struts2.ServletActionContext;
import com.cmms.Constants;
import com.cmms.dao.SearchException;
import com.cmms.model.Role;
import com.cmms.model.User;
import com.cmms.service.UserExistsException;
import com.cmms.webapp.util.RequestUtil;
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
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for facilitating User Management feature.
 */
public class UserAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = 6776558938712115191L;
    private List<User> users;
    private User user;
    private String id;
    private String query;

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
    }

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
    }

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
    }

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
    }

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
    }

}
