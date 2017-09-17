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

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

/**
 *
 * @author thuyetlv
 */
public class ImageUtil {

    private static final int IMG_WIDTH = 330;
    private static final int IMG_HEIGHT = 213;

    public static void main(String[] args) {

        try {

            resize("D:\\tmp\\ifixit\\img\\mkyong.jpg", "D:\\tmp\\ifixit\\img\\mkyong_jpg.jpg");

//            BufferedImage originalImage = ImageIO.read(new File("D:\\tmp\\ifixit\\img\\mkyong.jpg"));
//            int type = originalImage.getType() == 0 ? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
//
//            BufferedImage resizeImageJpg = resizeImage(originalImage, type);
//            ImageIO.write(resizeImageJpg, "jpg", new File("D:\\tmp\\ifixit\\img\\mkyong_jpg.jpg"));
//
//            BufferedImage resizeImagePng = resizeImage(originalImage, type);
//            ImageIO.write(resizeImagePng, "png", new File("D:\\tmp\\ifixit\\img\\mkyong_png.jpg"));
//
//            BufferedImage resizeImageHintJpg = resizeImageWithHint(originalImage, type);
//            ImageIO.write(resizeImageHintJpg, "jpg", new File("D:\\tmp\\ifixit\\img\\mkyong_hint_jpg.jpg"));
//
//            BufferedImage resizeImageHintPng = resizeImageWithHint(originalImage, type);
//            ImageIO.write(resizeImageHintPng, "png", new File("D:\\tmp\\ifixit\\img\\mkyong_hint_png.jpg"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

    }

    public static void resize(String path, String out) throws Exception {
        File originalFile = null;
        boolean success = false;
        try {
            originalFile = new File(path);
            BufferedImage originalImage = ImageIO.read(originalFile);
            int type = originalImage.getType() == 0 ? BufferedImage.TYPE_INT_ARGB : originalImage.getType();

            BufferedImage resizeImageJpg = resizeImage(originalImage, type);
            ImageIO.write(resizeImageJpg, "jpg", new File(out));
            success = true;
        } finally {
            if (success && originalFile != null) {
                originalFile.delete();
            }
        }
    }

    private static BufferedImage resizeImage(BufferedImage originalImage, int type) {
        BufferedImage resizedImage = new BufferedImage(IMG_WIDTH, IMG_HEIGHT, type);
        Graphics2D g = resizedImage.createGraphics();
        g.drawImage(originalImage, 0, 0, IMG_WIDTH, IMG_HEIGHT, null);
        g.dispose();

        return resizedImage;
    }

    private static BufferedImage resizeImageWithHint(BufferedImage originalImage, int type) {

        BufferedImage resizedImage = new BufferedImage(IMG_WIDTH, IMG_HEIGHT, type);
        Graphics2D g = resizedImage.createGraphics();
        g.drawImage(originalImage, 0, 0, IMG_WIDTH, IMG_HEIGHT, null);
        g.dispose();
        g.setComposite(AlphaComposite.Src);

        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g.setRenderingHint(RenderingHints.KEY_RENDERING,
                RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        return resizedImage;
    }
}
