/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cmms.webapp.security;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.model.Company;
import com.cmms.model.GroupEngineer;
import com.cmms.service.UserManager;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.cmms.model.User;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 *
 * @author thuyetlv
 */
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    protected UserManager userManager;
    protected CompanyDao companyDao;
    protected GroupEngineerDao groupEngineerDao;

    public GroupEngineerDao getGroupEngineerDao() {
        return groupEngineerDao;
    }

    public void setGroupEngineerDao(GroupEngineerDao groupEngineerDao) {
        this.groupEngineerDao = groupEngineerDao;
    }

    public CompanyDao getCompanyDao() {
        return companyDao;
    }

    public void setCompanyDao(CompanyDao companyDao) {
        this.companyDao = companyDao;
    }

    public UserManager getUserManager() {
        return userManager;
    }

    public void setUserManager(UserManager userManager) {
        this.userManager = userManager;
    }

    public static final String SESSION_USER_NAME = "USERNAME_HANDLE";
    public static final String SESSION_USER_ID = "USER_HANDLE";
    public static final String SESSION_LIST_SYSTEM_ID = "lstSystemId";
    public static final String SESSION_SYSTEM_ID = "systemId";
    public static final String SESSION_SYSTEM_OBJ = "userSystemObj";
    public static final String SESSION_SYSTEM_NAME = "systemName";
    public static final String SESSION_ENGINNER_GRP = "grpEngineerId";
    public static final String SESSION_ENGINNER_GRP_OBJ = "userGrpEngineerObj";
    public static final String SESSION_ENGINNER_GRP_NAME = "grpEngineerName";
    public static final String SESSION_LIST_GRP_ENGINNER = "lstEngineerGrp";

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        updateSession(request);
        HttpSession session = request.getSession();

        Integer systemId = (Integer) session.getAttribute(SESSION_SYSTEM_ID);
        Integer engineerGrpID = (Integer) session.getAttribute(SESSION_ENGINNER_GRP);

        //System
        List<Integer> lstChild = companyDao.getListChildren(systemId);
        System.out.println("lstChild: " + StringUtils.join(lstChild, " , "));
        session.setAttribute(SESSION_LIST_SYSTEM_ID, lstChild);

        //ENGINNER_GRP
        List<Integer> lstGrpEng = groupEngineerDao.getListChildren(engineerGrpID);
        System.out.println("lstGrpEng: " + StringUtils.join(lstGrpEng, " , "));
        session.setAttribute(SESSION_LIST_GRP_ENGINNER, lstGrpEng);
        System.out.println("SESSION_SYSTEM_ID: " + session.getAttribute(SESSION_SYSTEM_ID));

        //set our response to OK status
        response.setStatus(HttpServletResponse.SC_OK);
        //since we have created our custom success handler, its up to us to where
        //we will redirect the user after successfully login
        response.sendRedirect("admin/workOrder");
    }

    public static void updateSession(HttpServletRequest request) {
        updateSessionSystem(request);
        updateSessionEng(request);
    }

    public static Integer updateSessionSystem(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute(SESSION_SYSTEM_ID) == null) {
            User authUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            String userName = authUser.getUsername();
            Long userId = authUser.getId();

            session.setAttribute(SESSION_USER_NAME, userName);
            session.setAttribute(SESSION_USER_ID, userId);

            ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
            //System
            Integer systemId = 3;
            if (userId < 0) {
                systemId = 0;
            }
            session.setAttribute(SESSION_SYSTEM_ID, systemId);
            CompanyDao companyDao = ctx.getBean("companyDao", CompanyDao.class);
            List<Integer> list = companyDao.getListChildren(systemId);
            request.getSession().setAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID, list);

            //SESSION_SYSTEM_OBJ
            if (systemId > 0) {
                try {
                    Company company = companyDao.get(systemId);
                    request.getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_OBJ, companyDao.getTree(company).toString());
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            } else {
                request.getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_OBJ, "");
            }
            return systemId;
        }
        return (Integer) session.getAttribute(SESSION_SYSTEM_ID);
    }

    public static Integer updateSessionEng(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute(SESSION_ENGINNER_GRP) == null) {
            User authUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            String userName = authUser.getUsername();
            Long userId = authUser.getId();

            session.setAttribute(SESSION_USER_NAME, userName);
            session.setAttribute(SESSION_USER_ID, userId);

            ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
            //ENGINNER_GRP
            Integer engineerGrpID = 2;
            if (userId < 0) {
                engineerGrpID = 0;
            }
            session.setAttribute(SESSION_ENGINNER_GRP, engineerGrpID);
            GroupEngineerDao groupEngineerDao = ctx.getBean("groupEngineerDao", GroupEngineerDao.class);
            List<Integer> listEng = groupEngineerDao.getListChildren(engineerGrpID);
            request.getSession().setAttribute(LoginSuccessHandler.SESSION_LIST_GRP_ENGINNER, listEng);
            
            //SESSION_SYSTEM_OBJ
            if (engineerGrpID > 0) {
                try {
                    GroupEngineer groupEngineer = groupEngineerDao.get(engineerGrpID);
                    request.getSession().setAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP_OBJ, groupEngineerDao.getTree(groupEngineer).toString());
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            } else {
                request.getSession().setAttribute(LoginSuccessHandler.SESSION_SYSTEM_OBJ, "");
            }
        }
        return (Integer) session.getAttribute(SESSION_ENGINNER_GRP);
    }
}
