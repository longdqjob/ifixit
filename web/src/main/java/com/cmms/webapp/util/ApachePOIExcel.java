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
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author thuyetlv
 */
public class ApachePOIExcel {

    private static final String FILE_NAME = "D:\\tmp\\MyFirstExcel.xlsx";

    public static void main(String[] args) {
//        write();
        List rtn = readFile("D:\\tmp\\tmp\\MaterialTemplate.xlsx", 7);
        String[] tmp;
        for (Object rtn1 : rtn) {
            tmp = (String[]) rtn1;
            System.out.println(Arrays.toString(tmp));
        }

        System.out.println("Done");
    }

    public static void write() {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Datatypes in Java");
        Object[][] datatypes = {
            {"Datatype", "Type", "Size(in bytes)", "Date"},
            {"int", "Primitive", 2, "09/26/207"},
            {"float", "Primitive", 4, "09/26/207"},
            {"double", "Primitive", 8, "09/26/207"},
            {"char", "Primitive", 1, "09/30/207"},
            {"String", "Non-Primitive", "No fixed size", ""}
        };

        int rowNum = 0;
        System.out.println("Creating excel");

        for (Object[] datatype : datatypes) {
            Row row = sheet.createRow(rowNum++);
            int colNum = 0;
            for (Object field : datatype) {
                Cell cell = row.createCell(colNum++);
                if (field instanceof String) {
                    cell.setCellValue((String) field);
                } else if (field instanceof Integer) {
                    cell.setCellValue((Integer) field);
                }
            }
        }

        try {
            FileOutputStream outputStream = new FileOutputStream(FILE_NAME);
            workbook.write(outputStream);
            workbook.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("Done");
    }

    public static List readFile(String fileName, int lenghData) {
        try {
            List rtn = new ArrayList();
            FileInputStream excelFile = new FileInputStream(new File(fileName));
            Workbook workbook = new XSSFWorkbook(excelFile);
            Sheet datatypeSheet = workbook.getSheetAt(0);
            Iterator<Row> iterator = datatypeSheet.iterator();

            String[] data = new String[lenghData];
            int i = 0;
            while (iterator.hasNext()) {
                data = new String[lenghData];
                i = 0;
                Row currentRow = iterator.next();
                Iterator<Cell> cellIterator = currentRow.iterator();
                while (cellIterator.hasNext()) {
                    Cell currentCell = cellIterator.next();
                    if (currentCell.getCellType() == Cell.CELL_TYPE_STRING) {
                        data[i++] = currentCell.getStringCellValue().trim();
                    } else if (currentCell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                        data[i++] = String.valueOf(currentCell.getNumericCellValue()).trim();
                    }
                }
                rtn.add(data);
            }

            return rtn;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
