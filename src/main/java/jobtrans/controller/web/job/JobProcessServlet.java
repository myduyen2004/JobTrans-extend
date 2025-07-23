package jobtrans.controller.web.job;

import jobtrans.dal.*;
import jobtrans.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet(name="JobProcessServlet", urlPatterns={"/job-manage-process"})
public class JobProcessServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action) {
            case "process-tool":
                processTool(req, resp);
                break;
            case "view-report-form":
                reportForm(req, resp);
                break;
            case "view-report":
                viewReport(req, resp);
                break;
            case "view-report-list-job":
                viewListReport(req, resp);
                break;
            case "confirm-complete":
                confirmComplete(req, resp);
                break;
            case "handle-completion":
                handleCompletion(req, resp);
                break;
            case "submit-product-option":
                submitProductOption(req, resp);
                break;
            case "digital-product":
                digitalProductOption(req, resp);
                break;
            case "view-all-products":
                viewAllFinalProduct(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        // Lấy dữ liệu từ form
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("sessionAccount");
        String jobId = req.getParameter("jobId");
        String accountId = req.getParameter("accountId");
        String violationType = req.getParameter("violationType");
        String content = req.getParameter("content");

        // Xử lý file upload
        Collection<Part> parts = req.getParts();
        String savedFiles = "";

        for (Part part : parts) {
            if (part.getName().equals("evidences") && part.getSize() > 0) {
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + "uploads" + File.separator;
                new File(uploadPath).mkdirs(); // tạo thư mục nếu chưa có

                String filePath = uploadPath + fileName;
                part.write(filePath);

                savedFiles = "uploads/" + fileName;
            }
        }
        Report report = new Report();
        report.setJobId(Integer.parseInt(jobId));
        report.setReportBy(account.getAccountId());
        report.setReportedAccount(Integer.parseInt(accountId));
        report.setContentReport(content);
        report.setAttachment(savedFiles);
        report.setCriteriaId(Integer.parseInt(violationType));
        ReportDAO reportDAO = new ReportDAO();
        Integer reportId = reportDAO.addReport(report);
        report = reportDAO.getReportById(reportId);

        req.setAttribute("report", report);
        req.getRequestDispatcher("/view-report-detail.jsp").forward(req, resp);
    }

    private void processTool(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        req.setAttribute("job", job);
        req.getRequestDispatcher("/job-manage-tool.jsp").forward(req, resp);
    }

    private void reportForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        String accountId = req.getParameter("accountId");
        JobDAO jobDAO = new JobDAO();
        AccountDAO accountDAO = new AccountDAO();
        CriteriaDAO criteriaDAO = new CriteriaDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        Account account = accountDAO.getAccountById(Integer.parseInt(accountId));
        List<Criteria> criteriaList;
        try {
            criteriaList = criteriaDAO.getPointDeductionCriteria();
            criteriaList.addAll(criteriaDAO.getBlockingCriteria());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("job", job);
        req.setAttribute("account", account);
        req.setAttribute("criteriaList", criteriaList);
        req.getRequestDispatcher("report-form.jsp").forward(req, resp);
    }

    private void viewReport(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String reportId = req.getParameter("reportId");
        ReportDAO reportDAO = new ReportDAO();
        Report report = reportDAO.getReportById(Integer.parseInt(reportId));
        req.setAttribute("report", report);
        req.getRequestDispatcher("/view-report-detail.jsp").forward(req, resp);
    }

    private void viewListReport(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobIdParam = req.getParameter("jobId");
        int jobId = Integer.parseInt(jobIdParam);
        ReportDAO reportDAO = new ReportDAO();
        List<Report> reportList = reportDAO.getReportsByJobId(jobId);
        req.setAttribute("jobId", jobId);
        req.setAttribute("reportList", reportList);
        req.getRequestDispatcher("/reports-of-job.jsp").forward(req, resp);
    }

    private void confirmComplete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        ContractDAO contractDAO = new ContractDAO();
        List<Contract> contract = null;
        try {
            contract = contractDAO.getContractListByJobId(Integer.parseInt(jobId));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("contractList", contract);
        req.setAttribute("jobId", jobId);
        req.getRequestDispatcher("payment-job-complete.jsp").forward(req, resp);
    }

    //    private void completePayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String jobIdParam = req.getParameter("jobId");
//        int jobId = Integer.parseInt(jobIdParam);
//        String contractIdParam = req.getParameter("contractId");
//        int contractId = Integer.parseInt(contractIdParam);
//        JobDAO jobDAO = new JobDAO();
//        Job job = jobDAO.getJobById(jobId);
//        ContractDAO contractDAO = new ContractDAO();
//        Contract contract = contractDAO.getContractById(contractId);
//
//    }
    private void handleCompletion(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Đọc request bằng UTF-8
        resp.setContentType("text/html; charset=UTF-8"); // Gửi response dưới dạng HTML với UTF-8
        resp.setCharacterEncoding("UTF-8"); // Set encoding cho response writer

        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("sessionAccount");
        String jobId = req.getParameter("jobId");
        int contractId = Integer.parseInt(req.getParameter("contractId"));
        String paymentAmountStr = req.getParameter("paymentAmount");
        // Chuyển đổi từ chuỗi thành BigDecimal
        BigDecimal percentSystem = new BigDecimal("0.03");
        BigDecimal percent = new BigDecimal("0.97");
        BigDecimal paymentAmount = new BigDecimal(paymentAmountStr);
        resp.getWriter().print(account);
        // Lấy thông tin hợp đồng hiện tại
        ContractDAO contractDAO = new ContractDAO();
        Contract contract = contractDAO.getContractById(contractId);
        AccountDAO accountDAO = new AccountDAO();
        Account acountRecieve = accountDAO.getAccountById(contract.getApplicantId());
        resp.getWriter().print(acountRecieve);
        Account admin = accountDAO.getAdmin();
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        TransactionDAO transactionDAO = new TransactionDAO();
        Transaction transaction = new Transaction();
        Transaction transaction1= new Transaction();
        Transaction transaction2= new Transaction();
        if (account.getAmountWallet().compareTo(paymentAmount) < 0) {
            req.getRequestDispatcher("profile?action=wallet").forward(req, resp);
        } else {
            account.setAmountWallet(account.getAmountWallet().subtract(paymentAmount));
            accountDAO.updateAccountById(account);
            acountRecieve.setAmountWallet(acountRecieve.getAmountWallet().add(paymentAmount.multiply(percent)));
            accountDAO.updateAccountById(acountRecieve);
            admin.setAmountWallet(admin.getAmountWallet().add(paymentAmount.multiply(percentSystem)));
            accountDAO.updateAccountById(admin);
            //Của người trả
            transaction1.setSenderId(account.getAccountId());
            transaction1.setReceiverId(contract.getApplicantId());
            transaction1.setJob(job);
            transaction1.setAmount(paymentAmount);
            transaction1.setDescription("Thanh toán hợp đồng");
            transaction1.setTransactionType("Trừ tiền");
            transaction1.setStatus(true);
            transactionDAO.addTransaction(transaction1);
            resp.getWriter().print(transaction1);

            //Của người nhận
            transaction2.setSenderId(account.getAccountId());
            transaction2.setReceiverId(contract.getApplicantId());
            transaction2.setJob(job);
            transaction2.setAmount(paymentAmount.multiply(percent).add(contract.getJobDepositB()));
            transaction2.setDescription("Thanh toán hợp đồng");
            transaction2.setTransactionType("Thêm tiền");
            transaction2.setStatus(true);
            transactionDAO.addTransaction(transaction2);
            //
            //Của admin
            transaction.setSenderId(account.getAccountId());
            transaction.setReceiverId(admin.getAccountId());
            transaction.setJob(job);
            transaction.setAmount(paymentAmount.multiply(percentSystem));
            transaction.setDescription("Hoa hồng từ công việc hoàn thành");
            transaction.setTransactionType("Thêm tiền");
            transaction.setStatus(true);
            transactionDAO.addTransaction(transaction);
            //
            job.setSecureWallet(job.getSecureWallet() - paymentAmount.intValue());
            job.setStatusJobId(5);
            jobDAO.updateJobById(job);

            contractDAO.updateContractStatus(contractId,"Hoàn tất thanh lí");

        }
        req.getRequestDispatcher("profile?action=wallet").forward(req, resp);

    }

    private void submitProductOption(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        req.setAttribute("job", job);
        req.getRequestDispatcher("choose-product-option.jsp").forward(req, resp);
    }

    private void digitalProductOption(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        req.setAttribute("job", job);
        req.getRequestDispatcher("digital-product.jsp").forward(req, resp);
    }
    private void viewAllFinalProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        DigitalProductDAO digitalProductDAO = new DigitalProductDAO();
        List<DigitalProduct> digitalProductList = digitalProductDAO.getAllDigitalProductByJobId(Integer.parseInt(jobId));
        OrderRequestDAO orderRequestDAO = new OrderRequestDAO();
        List<OrderRequest> orderRequestList = orderRequestDAO.getAllOrderRequestByJobId(Integer.parseInt(jobId));
        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(Integer.parseInt(jobId));
        req.setAttribute("digitalProductList", digitalProductList);
        req.setAttribute("orderRequest", orderRequestList);
        req.setAttribute("job", job);
        req.getRequestDispatcher("view-final-product.jsp").forward(req, resp);
    }
}
