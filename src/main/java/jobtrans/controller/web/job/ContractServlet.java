package jobtrans.controller.web.job;

import jobtrans.dal.*;
import jobtrans.model.*;
import jobtrans.utils.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.text.Document;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.*;
import java.util.List;

@WebServlet(name="ContractServlet", urlPatterns={"/contract"})
public class ContractServlet extends HttpServlet {

    AccountDAO accountDAO = new AccountDAO();
    JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
    JobDAO jobDAO = new JobDAO();
    ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "view-infor-project-contract":
                viewInforProjectContract(request, response);
                break;
            case "show-form-terms-of-agreement":
                showFormTermsOfAgreement(request, response);
                break;
            case "view-contract-of-job":
                viewContractOfJob(request,response);
                break;
            case "reject-contract":
                rejectContract(request,response);
                break;
            case "list-contract-of-job":
                listContractOfJob(request,response);
                break;
            case "view-details-contract":
                viewDetailsContract(request,response);
                break;
            default:
                response.getWriter().print("????????");
                break;
        }
    }

    private void viewDetailsContract(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            int applicantId = Integer.parseInt(request.getParameter("applicantId"));
            Contract contract = contractDAO.getContractByJobIdAndApplicantId(jobId,applicantId);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("contract.jsp").forward(request, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void viewContractOfJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int jobId = Integer.parseInt(request.getParameter("jobId"));
            Contract contract = contractDAO.getContractByJobIdAndApplicantId(jobId,account.getAccountId());
            Job job = jobDAO.getJobById(jobId);

            request.setAttribute("account", account);
            request.setAttribute("job", job);
            request.setAttribute("contract", contract);
            request.setAttribute("now", new Date());
            request.getRequestDispatcher("sign-contract-candidate.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập encoding UTF-8 cho request
        request.setCharacterEncoding("UTF-8");

        // Thiết lập encoding UTF-8 cho response
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add-terms".equals(action)) {
            addTerms(request, response);
        } else if ("add-contract".equals(action)) {
            try {
                addContract(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if ("b-add-signature".equals(action)) {
            try {
                bAddSignature(request, response);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else {
            // Action không hợp lệ
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    protected void rejectContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            int contractId;
            try {
                contractId = Integer.parseInt(request.getParameter("contractId"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID hợp đồng không hợp lệ");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            Contract contract = contractDAO.getContractById(contractId);
            if (contract == null) {
                request.setAttribute("error", "Không tìm thấy hợp đồng");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            String rejectionReason = request.getParameter("rejectionReason");
            if (rejectionReason == null) rejectionReason = "Không có lý do";

            // Cập nhật trạng thái hợp đồng
            boolean success = contractDAO.updateContractStatus(
                    contractId,
                    "Đã từ chối"
            );

            if (success) {
                // 8. Trả kết quả
                request.setAttribute("successMessage", "Đã từ chối hợp đồng thành công");
                request.getRequestDispatcher("contract-details.jsp").forward(request, response);
            } else {
                throw new SQLException("Cập nhật database thất bại");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi từ chối hợp đồng");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    protected void addTerms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int greetingId = Integer.parseInt(request.getParameter("greetingId"));
            JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingById(greetingId);
            // Create a new Contract object
            Contract contract = new Contract();
            contract.setJobId(jobGreeting.getJobId());
            contract.setApplicantId(jobGreeting.getJobSeekerId());
            contract.setEmployerId(account.getAccountId());
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            // Extract and set employer (Bên A) information
            contract.setaName(request.getParameter("employer_name"));
            contract.setaAddress(request.getParameter("employer_contact_address"));
            contract.setaRepresentative(request.getParameter("employer_representative"));
            contract.setaIdentity(request.getParameter("employer_id_number"));

            String employerIdDate = request.getParameter("employer_id_date");
            if (employerIdDate != null && !employerIdDate.isEmpty()) {
                java.util.Date parsedDate = dateFormat.parse(employerIdDate);
                contract.setaIdentityDate(new java.sql.Date(parsedDate.getTime()));
            }


            contract.setaIdentityAddress(request.getParameter("employer_id_place"));
            contract.setaTaxCode(request.getParameter("employer_tax_code"));


            String employerBirthDate = request.getParameter("employer_birth_date");
            if (employerBirthDate != null && !employerBirthDate.isEmpty()) {
                java.util.Date parsedDate = dateFormat.parse(employerBirthDate);
                contract.setaBirthday(new java.sql.Date(parsedDate.getTime()));
            }

            contract.setaPhoneNumber(request.getParameter("employer_phone"));
            contract.setaEmail(request.getParameter("employer_email"));

            // Extract and set freelancer (Bên B) information
            contract.setbName(request.getParameter("freelancer_name"));
            contract.setbRepresentative(request.getParameter("freelancer_representative"));
            contract.setbIdentity(request.getParameter("freelancer_id_number"));

            String freelancerIdDate = request.getParameter("freelancer_id_date");
            if (freelancerIdDate != null && !freelancerIdDate.isEmpty()) {
                java.util.Date parsedDate = dateFormat.parse(freelancerIdDate);
                contract.setbIdentityDate(new java.sql.Date(parsedDate.getTime()));
            }

            contract.setbIdentityAddress(request.getParameter("freelancer_id_place"));

            String freelancerBirthDate = request.getParameter("freelancer_birth_date");
            if (freelancerBirthDate != null && !freelancerBirthDate.isEmpty()) {
                java.util.Date parsedDate = dateFormat.parse(freelancerBirthDate);
                contract.setbBirthday(new java.sql.Date(parsedDate.getTime()));
            }

            contract.setbAddress(request.getParameter("freelancer_contact_address"));
            contract.setbPhoneNumber(request.getParameter("freelancer_phone"));
            contract.setbEmail(request.getParameter("freelancer_email"));

            // Extract and set job details
            contract.setJobGoal(request.getParameter("job_goal"));
            contract.setJobRequirement(request.getParameter("job_requirement"));

            String startDate = request.getParameter("start_date");
            if (startDate != null && !startDate.isEmpty()) {
                java.util.Date parsedStart = dateFormat.parse(startDate);
                contract.setStartDate(new java.sql.Date(parsedStart.getTime()));
            }

            String endDate = request.getParameter("end_date");
            if (endDate != null && !endDate.isEmpty()) {
                java.util.Date parsedEnd = dateFormat.parse(endDate);
                contract.setEndDate(new java.sql.Date(parsedEnd.getTime()));
            }


            contract.setJobAddress(request.getParameter("work_location"));

            String serviceFee = request.getParameter("service_fee");
            if (serviceFee != null && !serviceFee.isEmpty()) {
                contract.setJobFee(new BigDecimal(serviceFee));
            }

            String employerDeposit = request.getParameter("employer_deposit");
            if (employerDeposit != null && !employerDeposit.isEmpty()) {
                contract.setJobDepositA(new BigDecimal(employerDeposit));
            }

            contract.setJobDepositAText(request.getParameter("employer_deposit_text"));


            String freelancerDeposit = request.getParameter("freelancer_deposit");
            if (freelancerDeposit != null && !freelancerDeposit.isEmpty()) {
                contract.setJobDepositB(new BigDecimal(freelancerDeposit));
            }

            contract.setJobDepositBText(request.getParameter("freelancer_deposit_text"));

            String employerDepositDate = request.getParameter("employer_deposit_date");
            if (employerDepositDate != null && !employerDepositDate.isEmpty()) {
                java.util.Date parsedDate = dateFormat.parse(employerDepositDate);
                contract.setJobDepositADate(new java.sql.Date(parsedDate.getTime()));
            }

            String freelancerDepositDate = request.getParameter("freelancer_deposit_date");
            if (freelancerDepositDate != null && !freelancerDepositDate.isEmpty()) {
                java.util.Date parsedDate = dateFormat.parse(freelancerDepositDate);
                contract.setJobDepositBDate(new java.sql.Date(parsedDate.getTime()));
            }

            System.out.println(account);
            System.out.println(contract);

            // Store contract in session for review
            request.setAttribute("account", account);
            session.setAttribute("draftContract", contract);
            // Redirect to review page
//            response.sendRedirect(request.getContextPath() + "/sign-contract.jsp");
            request.getRequestDispatcher("sign-contract.jsp").forward(request, response);

        } catch (ParseException e) {
            // Handle date parsing errors
            request.setAttribute("errorMessage", "Error processing dates: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other errors
            request.setAttribute("errorMessage", "Error processing form: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void addContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Connection conn = null;
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Contract contract = (Contract) session.getAttribute("draftContract");

            contract.setaSignature(account.getSignature());
            contract.setStatus("Chờ bên B xác nhận kí kết");

            BigDecimal depositB = contract.getJobDepositB();
            BigDecimal balance = accountDAO.getAccountBalance(account.getAccountId());

            System.out.println(balance);
            System.out.println(depositB);
            System.out.println(account.getSignature());

            if (balance == null || balance.compareTo(depositB) < 0) {
                BigDecimal missingAmount = depositB.subtract(balance != null ? balance : BigDecimal.ZERO);
                request.setAttribute("contract", contract);
                request.setAttribute("account", account);
                request.setAttribute("missingAmount", missingAmount);
                request.setAttribute("error", "Số dư trong ví không đủ để đặt cọc theo hợp đồng"); // Thêm dòng này
                request.getRequestDispatcher("sign-contract.jsp").forward(request, response);
                return;
            }

            // Bắt đầu transaction
            conn = DBConnection.openConnection();
            conn.setAutoCommit(false);

            try {
                // 4.2. Trừ tiền từ ví người dùng
                Account updatedAccount = accountDAO.deductFromWallet(account.getAccountId(), depositB);
                if (updatedAccount == null) {
                    throw new SQLException("Không thể trừ tiền từ ví, số dư không đủ hoặc tài khoản không tồn tại");
                }

                // 4.3. Thêm tiền vào secure_wallet của job
                int jobId = contract.getJobId();
                boolean secureWalletUpdated = jobDAO.addToSecureWallet(jobId, depositB);
                if (!secureWalletUpdated) {
                    throw new SQLException("Không thể cập nhật ví bảo mật của công việc");
                }

                jobDAO.updateStatusJobId(jobId,2);

                // 4.4. Thêm hợp đồng vào database
                boolean contractInserted = contractDAO.insertContract(contract);
                if (!contractInserted) {
                    throw new SQLException("Không thể thêm hợp đồng vào database");
                }

                // 4.5. Commit transaction nếu tất cả các bước đều thành công
                conn.commit();

                // Cập nhật thông tin phiên
                session.setAttribute("sessionAccount", updatedAccount);

                // Chuyển hướng đến trang thành công
                request.setAttribute("account", updatedAccount);
                request.setAttribute("contract", contract);
                request.setAttribute("successMessage", "Chờ ký kết hoàn tất");
                request.getRequestDispatcher("contract-complete.jsp").forward(request, response);

            } catch (SQLException e) {
                // Rollback transaction nếu có lỗi
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi xử lý giao dịch: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Xử lý các lỗi khác
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý form: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            // Đảm bảo đóng kết nối trong mọi trường hợp
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    protected void bAddSignature(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession(false);
        Connection conn = null;

        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null || session == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=" +
                        URLEncoder.encode(request.getRequestURI(), "UTF-8"));
                return;
            }

            int contractId;
            try {
                contractId = Integer.parseInt(request.getParameter("contractId"));
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID hợp đồng không hợp lệ");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            Contract contract = contractDAO.getContractById(contractId);
            if (contract == null) {
                request.setAttribute("errorMessage", "Không tìm thấy hợp đồng");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }


            BigDecimal depositB = contract.getJobDepositB();
            BigDecimal balance = account.getAmountWallet();

            if (balance == null || balance.compareTo(depositB) < 0) {
                BigDecimal missingAmount = depositB.subtract(balance != null ? balance : BigDecimal.ZERO);
                request.setAttribute("contract", contract);
                request.setAttribute("account", account);
                request.setAttribute("missingAmount", missingAmount);
                request.setAttribute("error", "Số dư trong ví không đủ để đặt cọc theo hợp đồng"); // Thêm dòng này
                request.getRequestDispatcher("sign-contract-candidate.jsp").forward(request, response);
                return;
            }

            conn = DBConnection.openConnection();
            conn.setAutoCommit(false);

            try {
                boolean signatureUpdated = contractDAO.updateBSignatureContract(account.getSignature(), contractId);
                if (!signatureUpdated) {
                    throw new SQLException("Không thể cập nhật chữ ký cho hợp đồng");
                }

                Account updatedAccount = accountDAO.deductFromWallet(account.getAccountId(), depositB);
                if (updatedAccount == null) {
                    throw new SQLException("Không thể trừ tiền từ ví, số dư không đủ hoặc tài khoản không tồn tại");
                }

                int jobId = contract.getJobId();
                boolean secureWalletUpdated = jobDAO.addToSecureWallet(jobId, depositB);
                Job job = jobDAO.getJobById(jobId);
                job.setStatusJobId(3);
                jobDAO.updateStatusJobId(jobId, 3);
                if (!secureWalletUpdated) {
                    throw new SQLException("Không thể cập nhật ví bảo mật của công việc");
                }

                int jobSeekerId = contract.getApplicantId();
                JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingByJobIdAndJobSeekerId(jobId, jobSeekerId);
                if (jobGreeting == null) {
                    throw new SQLException("Không thể tìm được JobGreeting");
                }

                boolean jg = jobGreetingDAO.updateStatus(jobGreeting.getGreetingId(),"Được nhận");
                if (!jg) {
                    throw new SQLException("Không thể tìm được JobGreeting");
                }

                boolean contractUpdate = contractDAO.updateContractStatus(contractId,"Kí kết thành công");
                if (!contractUpdate) {
                    throw new SQLException("Không thể tìm được Contract Update");
                }

                conn.commit();

                request.setAttribute("account", account);
                request.setAttribute("contract", contract);
                request.setAttribute("successMessage", "Ký hợp đồng thành công!");
                request.getRequestDispatcher("contract-complete.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } finally {

        }
    }

    private void viewInforProjectContract(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int greetingId = Integer.parseInt(request.getParameter("greetingId"));
            JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingById(greetingId);
            Account account02 = accountDAO.getAccountById(jobGreeting.getJobSeekerId());
            Job job = jobDAO.getJobById(jobGreeting.getJobId());
            Account poster = accountDAO.getAccountById(job.getPostAccountId());

            if (job != null) {
                // Lấy thông tin các tag của job
                TagDAO tagDAO = new TagDAO();
                List<Tag> tagList = tagDAO.getTagsByJobId(job.getJobId());
                job.setTagList(tagList);

                // Lấy thông tin category của job
                JobCategoryDAO categoryDAO = new JobCategoryDAO();
                JobCategory category = categoryDAO.getCategoryById(job.getCategoryId());
                job.setJobCategory(category);

                // Lấy thông tin người đăng tin
                AccountDAO accountDAO = new AccountDAO();

                // Xử lý thông tin deadline
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

                // Xử lý dueDatePost
                if (job.getDueDatePost() != null) {
                    String formattedDueDatePost = dateFormat.format(job.getDueDatePost());
                    request.setAttribute("dueDatePostFormatted", formattedDueDatePost);
                } else {
                    request.setAttribute("dueDatePostFormatted", "Chưa xác định");
                }

                // Xử lý postDate (java.sql.Timestamp)
                if (job.getPostDate() != null) {
                    // Convert Timestamp to java.util.Date
                    java.util.Date postDateUtil = new java.util.Date(job.getPostDate().getTime());
                    String formattedPostDate = dateFormat.format(postDateUtil);
                    request.setAttribute("postDateFormatted", formattedPostDate);
                } else {
                    request.setAttribute("postDateFormatted", "Chưa xác định");
                }

                // Xử lý joinDate (java.time.LocalDateTime)
                if (poster.getJoinDate() != null) {
                    // Convert LocalDateTime to java.util.Date
                    java.util.Date joinDateUtil = java.util.Date.from(poster.getJoinDate().atZone(ZoneId.systemDefault()).toInstant());
                    String formattedJoinDate = dateFormat.format(joinDateUtil);
                    request.setAttribute("joinDateFormatted", formattedJoinDate);
                } else {
                    request.setAttribute("joinDateFormatted", "Chưa xác định");
                }

                // Tính thời gian còn lại đến deadline
                try {
                    if (job.getDueDatePost() != null) {
                        long currentTime = System.currentTimeMillis();
                        long duePostTime = job.getDueDatePost().getTime();
                        long daysLeft = (duePostTime - currentTime) / (1000 * 60 * 60 * 24);
                        request.setAttribute("daysLeft", daysLeft);
                    } else {
                        request.setAttribute("daysLeft", "N/A");
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi khi tính ngày còn lại: " + e.getMessage());
                    request.setAttribute("daysLeft", "N/A");
                }

                // Tính thời gian còn lại đến deadline
                try {
                    if (job.getDueDatePost() != null) {
                        long currentTime = System.currentTimeMillis();
                        long duePostTime = job.getDueDatePost().getTime();
                        long daysLeft = (duePostTime - currentTime) / (1000 * 60 * 60 * 24);
                        request.setAttribute("daysLeft", daysLeft);
                    } else {
                        request.setAttribute("daysLeft", "N/A");
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi khi tính ngày còn lại: " + e.getMessage());
                    request.setAttribute("daysLeft", "N/A");
                }

                // Format ngân sách hiển thị
                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
                String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
                request.setAttribute("budgetRange", formattedBudgetMin + " - " + formattedBudgetMax);

                // Lấy thông tin thêm nếu có
                if (job.getSecureWallet() == 1) {
                    request.setAttribute("hasSecureWallet", true);
                }

                // Thêm các thông tin khác cho interface
                session.setAttribute("account", account);
                request.setAttribute("job", job);
                request.setAttribute("poster", poster);
                request.setAttribute("interviewRequired", job.isHaveInterviewed());
                request.setAttribute("testRequired", job.isHaveTested());

            } else {
                request.setAttribute("errorMessage", "Không tìm thấy công việc với ID: " + job.getJobId());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }

            request.setAttribute("jobGreeting", jobGreeting);
            request.setAttribute("poster", poster);
            request.setAttribute("jobSeeker", account02);
            request.setAttribute("job", job);
            request.getRequestDispatcher("infor-job-contract.jsp").forward(request, response);
//            response.sendRedirect("infor-job-contract.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void showFormTermsOfAgreement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int greetingId = Integer.parseInt(request.getParameter("greetingId"));
            JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingById(greetingId);

            System.out.println(jobGreeting);

            request.setAttribute("jobGreeting", jobGreeting);
            request.setAttribute("account", account);
            request.getRequestDispatcher("terms-of-agreement.jsp").forward(request, response);
//            response.sendRedirect("terms-of-agreement.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void listContractOfJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            List<Contract> contractList = contractDAO.getContractListByJobIdWasSuccess(jobId);
            Job job = jobDAO.getJobById(jobId);
            System.out.println(contractList);
            request.setAttribute("job", job);
            request.setAttribute("contractList", contractList);
            request.getRequestDispatcher("list-contract.jsp").forward(request, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
