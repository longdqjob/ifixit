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
package com.cmms.webapp.action;

import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MaterialDao;
import java.io.InputStream;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author thuyetlv
 */
public class MaterialActionTest {
    
    public MaterialActionTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of getItemTypeDao method, of class MaterialAction.
     */
    @Test
    public void testGetItemTypeDao() {
        System.out.println("getItemTypeDao");
        MaterialAction instance = new MaterialAction();
        ItemTypeDao expResult = null;
        ItemTypeDao result = instance.getItemTypeDao();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setItemTypeDao method, of class MaterialAction.
     */
    @Test
    public void testSetItemTypeDao() {
        System.out.println("setItemTypeDao");
        ItemTypeDao itemTypeDao = null;
        MaterialAction instance = new MaterialAction();
        instance.setItemTypeDao(itemTypeDao);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getMaterialDao method, of class MaterialAction.
     */
    @Test
    public void testGetMaterialDao() {
        System.out.println("getMaterialDao");
        MaterialAction instance = new MaterialAction();
        MaterialDao expResult = null;
        MaterialDao result = instance.getMaterialDao();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setMaterialDao method, of class MaterialAction.
     */
    @Test
    public void testSetMaterialDao() {
        System.out.println("setMaterialDao");
        MaterialDao materialDao = null;
        MaterialAction instance = new MaterialAction();
        instance.setMaterialDao(materialDao);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of prepare method, of class MaterialAction.
     */
    @Test
    public void testPrepare() throws Exception {
        System.out.println("prepare");
        MaterialAction instance = new MaterialAction();
        instance.prepare();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of index method, of class MaterialAction.
     */
    @Test
    public void testIndex() {
        System.out.println("index");
        MaterialAction instance = new MaterialAction();
        String expResult = "";
        String result = instance.index();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getTree method, of class MaterialAction.
     */
    @Test
    public void testGetTree() {
        System.out.println("getTree");
        MaterialAction instance = new MaterialAction();
        InputStream expResult = null;
        InputStream result = instance.getTree();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getLoadData method, of class MaterialAction.
     */
    @Test
    public void testGetLoadData() {
        System.out.println("getLoadData");
        MaterialAction instance = new MaterialAction();
        InputStream expResult = null;
        InputStream result = instance.getLoadData();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getSave method, of class MaterialAction.
     */
    @Test
    public void testGetSave() {
        System.out.println("getSave");
        MaterialAction instance = new MaterialAction();
        InputStream expResult = null;
        InputStream result = instance.getSave();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getSaveChange method, of class MaterialAction.
     */
    @Test
    public void testGetSaveChange() {
        System.out.println("getSaveChange");
        MaterialAction instance = new MaterialAction();
        InputStream expResult = null;
        InputStream result = instance.getSaveChange();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getIds method, of class MaterialAction.
     */
    @Test
    public void testGetIds() {
        System.out.println("getIds");
        MaterialAction instance = new MaterialAction();
        String[] expResult = null;
        String[] result = instance.getIds();
        assertArrayEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setIds method, of class MaterialAction.
     */
    @Test
    public void testSetIds() {
        System.out.println("setIds");
        String[] ids = null;
        MaterialAction instance = new MaterialAction();
        instance.setIds(ids);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getDelete method, of class MaterialAction.
     */
    @Test
    public void testGetDelete() {
        System.out.println("getDelete");
        MaterialAction instance = new MaterialAction();
        InputStream expResult = null;
        InputStream result = instance.getDelete();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
