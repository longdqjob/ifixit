package com.cmms.webapp.action;

import static com.cmms.webapp.action.BaseAction.PATH_UPLOAD;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import org.apache.struts2.ServletActionContext;

/**
 * Action for DownloadAction
 */
public class DownloadAction extends BaseAction {

    private String fileName;
    private FileInputStream fileInputStream;

    public FileInputStream getFileInputStream() {
        return fileInputStream;
    }

    public void setFileInputStream(FileInputStream fileInputStream) {
        this.fileInputStream = fileInputStream;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String download() throws Exception {
        String folder = "";
        String fileType = getRequest().getParameter("file");
        try {
            folder = ServletActionContext.getServletContext().getRealPath("/");
            folder += File.separator + PATH_UPLOAD + File.separator + PATH_TEMPLATE + File.separator;

            if (fileType.equalsIgnoreCase("eec34d804c9ce6c89cff596be555e6a4")) {
                //md5("material")
                fileName = "MaterialTemplate.xlsx";
            } else if (fileType.equalsIgnoreCase("bcd8b14bbfc1b0ae7a5aa060af713d6e")) {
                //md5("mechanic")
                fileName = "MaterialTemplate.xlsx";
            }

            fileInputStream = new FileInputStream(new File(folder + fileName));
        } catch (FileNotFoundException ex) {
            log.error(this.getClass().getSimpleName() + ": File in " + folder + fileName + " cannot be found.");
            return ERROR;
        }

        return SUCCESS;
    }
}
