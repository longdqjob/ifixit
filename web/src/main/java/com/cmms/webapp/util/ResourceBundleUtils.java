/*
 * ResourceBundleUtils.java
 *
 * Created on
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cmms.webapp.util;

import java.util.ResourceBundle;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Your Name Date today
 */
public class ResourceBundleUtils {

    static private ResourceBundle rb = null;

    /**
     * Creates a new instance of ResourceBundleUtils
     */
    public ResourceBundleUtils() {
    }

    /**
     * Common function
     *
     * @yourName
     * @param key
     * @return
     */
    public static String getName(String key) {
        rb = ResourceBundle.getBundle("ApplicationResources");
        String temp = "";
        try {
            temp = rb.getString(key);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return temp;
    }

    public static String getName(String key, String replace) {
        rb = ResourceBundle.getBundle("ApplicationResources");
        String temp = "";
        try {
            temp = rb.getString(key);
            temp = temp.replace("{0}", replace);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return temp;
    }

    public static String getConfig(String key) {
        rb = ResourceBundle.getBundle("config");
        String temp = "";
        try {
            temp = rb.getString(key);

        } catch (Exception e) {
            // TODO: handle exception
        }
        return temp;
    }

    public static String getUrlWebService() {
        String url = "";
        try {
            url = ResourceBundleUtils.getConfig("webserviceCapWap");
        } catch (Exception ex) {
            return "";
        }
        return url;
    }

    public static String getHostServerReport() {
        rb = ResourceBundle.getBundle("config");
        String temp = "";
        try {
            temp = rb.getString("hostServerReport");

        } catch (Exception e) {
            // TODO: handle exception
        }
        return temp;
    }

}
