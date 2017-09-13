/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cmms.webapp.security;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.service.UserManager;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.cmms.model.User;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

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
    public static final String SESSION_ENGINNER_GRP = "grpEngineerId";
    public static final String SESSION_LIST_GRP_ENGINNER = "lstEngineerGrp";

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User authUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String userName = authUser.getUsername();
        Long userId = authUser.getId();

        session.setAttribute(SESSION_USER_NAME, userName);
        session.setAttribute(SESSION_USER_ID, userId);

        Integer systemId = 1;
        Integer engineerGrpID = 1;

        //System
        session.setAttribute(SESSION_SYSTEM_ID, systemId);
        List<Integer> lstChild = companyDao.getListChildren(systemId);
        System.out.println("lstChild: " + StringUtils.join(lstChild, " , "));
        session.setAttribute(SESSION_LIST_SYSTEM_ID, lstChild);

        //ENGINNER_GRP
        session.setAttribute(SESSION_ENGINNER_GRP, engineerGrpID);
        List<Integer> lstGrpEng = groupEngineerDao.getListChildren(engineerGrpID);
        System.out.println("lstGrpEng: " + StringUtils.join(lstGrpEng, " , "));
        session.setAttribute(SESSION_LIST_GRP_ENGINNER, lstGrpEng);
        System.out.println("SESSION_SYSTEM_ID: " + session.getAttribute(SESSION_SYSTEM_ID));

        //set our response to OK status
        response.setStatus(HttpServletResponse.SC_OK);
        //since we have created our custom success handler, its up to us to where
        //we will redirect the user after successfully login
        response.sendRedirect("home");
    }
}
