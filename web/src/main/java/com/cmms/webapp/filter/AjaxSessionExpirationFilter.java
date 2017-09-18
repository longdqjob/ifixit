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
package com.cmms.webapp.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author thuyetlv
 */
public class AjaxSessionExpirationFilter implements Filter {

    protected final transient Log logger = LogFactory.getLog(getClass());

    private int customSessionExpiredErrorCode = 901;

    @Override
    public void init(FilterConfig arg0) throws ServletException {
        // Property check here
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filerChain) throws IOException, ServletException {
        HttpSession currentSession = ((HttpServletRequest) request).getSession(false);
        if (currentSession == null) {
            String ajaxHeader = ((HttpServletRequest) request).getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader)) {
                logger.info("Ajax call detected, send {} error code: " + this.customSessionExpiredErrorCode);
                HttpServletResponse resp = (HttpServletResponse) response;
                resp.sendError(this.customSessionExpiredErrorCode);
            } else {
                // Redirect to login page
            }
        } else {
            // Redirect to login page
        }
    }

    @Override
    public void destroy() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
