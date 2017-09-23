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
package com.cmms.webapp.util;

import java.io.File;
import java.lang.reflect.Method;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 *
 * @author thuyetlv
 */
public class WebUtil {

    public static JSONObject toJSONObject(Object o, String excludedProperties) throws JSONException {
        JSONObject map = new JSONObject();
        Class<?> clazz = o.getClass();
        Method[] methods = clazz.getDeclaredMethods();
        for (Method m : methods) {
            String name = m.getName();
            boolean startsWithGet = name.startsWith("get");
            boolean startsWithIs = name.startsWith("is");
            if ((startsWithGet || startsWithIs) && m.getTypeParameters().length == 0) {
                String key = name.replaceFirst(startsWithGet ? "get" : "is", "");
                key = key.substring(0, 1).toLowerCase() + key.substring(1);
                if (excludedProperties.contains(key)) {
                    continue;
                }
                Object value = null;
                try {
                    value = m.invoke(o);
                } catch (Exception e) {
                    System.out.println("---------toJSONObject: " + name);
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }
                map.put(key, value);
            }
        }
        map.put("indexClass", o.hashCode());
        return map;
    }

    public static List<JSONObject> toJSONObject(List<?> c, String excludedProperties) throws JSONException {

        List<JSONObject> result = new ArrayList<JSONObject>();
        for (Object o : c) {
            result.add(toJSONObject(o, excludedProperties));
        }
        return result;
    }

    public static List<JSONObject> toJSONObject(Set<?> c, String excludedProperties) throws JSONException {

        List<JSONObject> result = new ArrayList<JSONObject>();
        for (Object o : c) {
            result.add(toJSONObject(o, excludedProperties));
        }
        return result;
    }

    public static JSONArray toJSONArray(List<?> c) throws JSONException {
        JSONArray result = new JSONArray();
        for (Object o : c) {
            try {
                Map map = BeanUtils.describe(o);
                JSONObject jsonObj = new JSONObject();

                for (Object key : map.keySet()) {
                    jsonObj.put((String) key, map.get(key));
                }
                result.put(jsonObj);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return result;
    }

    public static boolean deleteFile(String path) {
        if (!StringUtils.isBlank(path)) {
            try {
                File originalFile = new File(path);
                return originalFile.delete();
            } catch (Exception ex) {
                return false;
            }
        }
        return true;
    }

    public static String removeAscii(String input) {
        if (StringUtils.isBlank(input)) {
            return input;
        }
        input = Normalizer.normalize(input, Normalizer.Form.NFD);
        return input.replaceAll("[^\\x00-\\x7F]", "");
    }

    public static String addParamToURL(String url, String param, String value,
            boolean replace) {
        if (replace == true) {
            url = removeParamFromURL(url, param);
        }
        return url + ((url.indexOf("?") == -1) ? "?" : "&") + param + "="
                + value;
    }

    public static String removeParamFromURL(String url, String param) {
        String sep = "&";
        int startIndex = url.indexOf(sep + param + "=");
        boolean firstParam = false;
        if (startIndex == -1) {
            startIndex = url.indexOf("?" + param + "=");
            if (startIndex != -1) {
                startIndex++;
                firstParam = true;
            }
        }

        if (startIndex != -1) {
            String startUrl = url.substring(0, startIndex);
            String endUrl = "";
            int endIndex = url.indexOf(sep, startIndex + 1);
            if (firstParam && endIndex != 1) {
                //remove separator from remaining url
                endUrl = url.substring(endIndex + 1);
            }
            return startUrl + endUrl;
        }

        return url;
    }
}
