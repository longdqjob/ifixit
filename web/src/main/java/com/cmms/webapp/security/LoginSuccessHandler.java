/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cmms.webapp.security;

import com.cmms.dao.CompanyDao;
import com.cmms.service.UserManager;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.cmms.model.User;
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

    public static final String SESSION_LIST_SYSTEM_ID = "lstSystemId";
    public static final String SESSION_SYSTEM_ID = "systemId";
    public static final String SESSION_ENGINNER_GRP = "EngineerGrp";

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User authUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String userName = authUser.getUsername();
        Long userId = authUser.getId();

        session.setAttribute("userName", userName);
        session.setAttribute("userId", userId);

        Integer systemId = 1;
        Integer engineerGrpID = 1;

        session.setAttribute(SESSION_SYSTEM_ID, systemId);
        session.setAttribute(SESSION_LIST_SYSTEM_ID, companyDao.getListChildren(systemId));
        session.setAttribute(SESSION_ENGINNER_GRP, engineerGrpID);
        System.out.println("SESSION_SYSTEM_ID: " + session.getAttribute(SESSION_SYSTEM_ID));

        //set our response to OK status
        response.setStatus(HttpServletResponse.SC_OK);
        //since we have created our custom success handler, its up to us to where
        //we will redirect the user after successfully login
        response.sendRedirect("home");

    }
}
