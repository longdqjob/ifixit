/*
 * Copyright 2017 Pivotal Software, Inc..
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.cmms.webapp.security;

import com.cmms.webapp.util.RequestUtil;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

/**
 *
 * @author thuyetlv
 */
public class CustomLoginUrlAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint {

    private final RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
    private static final String URL_HOME = "/home";

    /**
     * @param loginFormUrl URL where the login page can be found. Should either
     * be relative to the web-app context path (include a leading {@code /}) or
     * an absolute URL.
     */
    public CustomLoginUrlAuthenticationEntryPoint(final String loginFormUrl) {
        super(loginFormUrl);
    }

    public void commence(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException authException) throws IOException, ServletException {

        System.out.println("----------aaaaa---------------");
        if (RequestUtil.isAjaxRequest(request) && authException != null) {
            System.out.println("--------getRequestURI isAjaxRequest: " + request.getRequestURI());
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
        } else {
            String lastRequest = request.getRequestURI().replaceAll(".action", "");
            System.out.println("--------lastRequest: " + lastRequest);
            if (!lastRequest.equalsIgnoreCase(URL_HOME)) {
                request.getSession().setAttribute(LoginSuccessHandler.LAST_REQUEST, lastRequest);
            }
            super.commence(request, response, authException);
        }
    }
}
