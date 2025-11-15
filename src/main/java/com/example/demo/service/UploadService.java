package com.example.demo.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;

@Service
public class UploadService {
    private final ServletContext servletContext;

    public UploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

   public String handleSaveUploadFile(MultipartFile file, String targetFolder){
        if(file.isEmpty()){
            return "";
        }
        String rootPath = this.servletContext.getRealPath("/resources/images");  // Lấy đường dẫn thực tế đến thư mục "resources/images"
        String finalName = "";
         try {
                                // private final ServletContext servletContext; // Biến này thường được sử dụng để lấy thông tin về context của servlet
            byte[] bytes = file.getBytes(); // Đọc file thành một mảng byte
            File dir = new File(rootPath + File.separator + targetFolder); // Tạo một đối tượng File đại diện cho thư mục "avatar"
            if (!dir.exists()) // Nếu thư mục "avatar" chưa tồn tại
            dir.mkdirs(); // Tạo thư mục "avatar"
            // Create the file on server

            finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName); // Tạo một đối tượng File đại diện cho file sẽ lưu trên server, với tên file được tạo ngẫu nhiên dựa trên thời gian hiện tại
            BufferedOutputStream stream = new BufferedOutputStream(
                                    new FileOutputStream(serverFile)); // Tạo một luồng để ghi dữ liệu vào file
            stream.write(bytes); // Ghi mảng byte vào file
            stream.close(); // Đóng luồng
        } catch (Exception e) {
            // TODO: handle exception
        }

        return finalName;
    }
}
