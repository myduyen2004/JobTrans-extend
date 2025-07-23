package jobtrans.controller.web.job;

import jobtrans.dal.AccountDAO;
import jobtrans.dal.DigitalProductDAO;
import jobtrans.dal.JobDAO;
import jobtrans.model.Account;
import jobtrans.model.DigitalProduct;
import jobtrans.model.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.File;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 * @author MyDuyen
 */
@WebServlet(name="DigitalProductServlet", urlPatterns={"/digital-product"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
        maxFileSize = 1024 * 1024 * 50,       // 50MB
        maxRequestSize = 1024 * 1024 * 100    // 100MB
)
public class DigitalProductServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploaded-products";
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action){
            case "view-digital-products":
                try {
                    viewDigitalProduct(req, resp);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
                break;
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            int jobId = Integer.parseInt(request.getParameter("jobId"));
            int senderId = Integer.parseInt(request.getParameter("senderId"));
            String notes = request.getParameter("notes");

            // Tạo thư mục lưu file
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            // Xử lý file upload
            StringBuilder uploadedFiles = new StringBuilder();
            for (Part part : request.getParts()) {
                if (part.getName().equals("files") && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    String uniqueName = UUID.randomUUID() + "_" + fileName;
                    part.write(uploadPath + File.separator + uniqueName);
                    uploadedFiles.append(uniqueName).append(";");
                }
            }
            DigitalProduct digitalProduct = new DigitalProduct();
            digitalProduct.setJobId(jobId);
            digitalProduct.setSenderId(senderId);
            digitalProduct.setNotes(notes);
            digitalProduct.setDigitalProductUrl(uploadedFiles.toString());
            digitalProduct.setStatus("Đã nộp");  // trạng thái tùy chỉnh

            // Gọi DAO để lưu vào DB
            DigitalProductDAO dao = new DigitalProductDAO();
            dao.insertDigitalProduct(digitalProduct);

            request.setAttribute("digitalProduct", digitalProduct);
            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobId);
            request.setAttribute("job", job);
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.getAccountById(senderId);
            request.setAttribute("account", account);
            request.getRequestDispatcher("view-digital-product.jsp").forward(request, response);
        }catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
    private void viewDigitalProduct(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String jobId = req.getParameter("jobId");
        int senderId = Integer.parseInt(req.getParameter("senderId"));
        DigitalProductDAO dao = new DigitalProductDAO();
        DigitalProduct digitalProduct = dao.getDigitalProduct(Integer.parseInt(jobId), senderId);
        req.setAttribute("digitalProduct", digitalProduct);
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        req.setAttribute("job", job);
        req.getRequestDispatcher("view-digital-product.jsp").forward(req, resp);
    }

}
