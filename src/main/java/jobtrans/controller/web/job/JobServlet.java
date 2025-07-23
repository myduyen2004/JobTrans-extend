package jobtrans.controller.web.job;
import jobtrans.dal.*;
import jobtrans.model.*;
import jobtrans.dal.AccountDAO;
import jobtrans.dal.JobDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;


@WebServlet(name="JobServlet", urlPatterns={"/job"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class JobServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "job_attachments";

    public static final int BUFFER_SIZE = 1024 * 1000;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        switch (action) {

            case "view-posted-jobs":
                viewPostedJobList(request, response);
                break;
            case "posted-job-detail":
                viewPostedJobDetail(request, response);
                break;
            case "pre-update":
                loadJobUpdate(request, response);
                break;
            case "deleteJob":
                deleteJob(request, response);
                break;
            case "view-applied":
                viewListApplied(request, response);
                break;
            case "list-job-by-status":
                listJobByStatus(request, response);
                break;
            case "sort":
                sapxep(request, response);
                break;
            case "details-job-posted":
                detailsJobPosted(request, response);
                break;
            case "downloadFile":
                downloadFile(request, response);
                break;
            case "view-candidates-list":
                viewCandidatesList(request, response);
                break;
            case "download":
                downloadFileJob(request, response);
                break;
            case "viewPartnerList":
                viewPartnerList(request, response);
                break;
            case "loadPostFeedback":
                loadPostFeedback(request, response);
                break;
            case "viewFeedback":
                viewFeedback(request, response);
                break;
            default:
                response.getWriter().print("Lỗi rồi má");
                break;
        }
    }

    private void viewPartnerList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            JobDAO jobDAO = new JobDAO();
            AccountDAO accountDAO = new AccountDAO();
            JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
            FeedbackDAO feedbackDAO = new FeedbackDAO();

            //Lấy acc đang đăng nhập
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            request.setAttribute("loggedAccount", account1);

            //Lay job can xem doi tac
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            Job job = jobDAO.getJobById(jobId);
            request.setAttribute("jobId", jobId);

            //Lấy danh sách feedBack của tài khoản "Tôi" đang đăng nhập
            List<Feedback> feedbackList = feedbackDAO.getFeedbackBytoUserIdAndJobId(account1.getAccountId(), jobId);
            request.setAttribute("feedbackList", feedbackList);

            //Lay danh sach partner
            List<Account> partnerList = new ArrayList<>();
            List<JobGreeting> greetingList = jobGreetingDAO.getAcceptedListJobGreetingByJobId(jobId);

            //Nếu tài khoản đang đăng nhập không phải là tài khoản đăng công việc thì thêm tài khoản người đăng vào partner list luôn
            if (account1.getAccountId() != job.getPostAccountId()) {
                partnerList.add(accountDAO.getAccountById(job.getPostAccountId()));
                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                String jobFee = currencyFormatter.format(jobDAO.getJobFeeByJobIdAndApplicantId(jobId, account1.getAccountId()));
                request.setAttribute("jobFee", jobFee);
            }
            for (JobGreeting greeting : greetingList) {
                if (account1.getAccountId() != greeting.getJobSeekerId()) {
                    partnerList.add(accountDAO.getAccountById(greeting.getJobSeekerId()));
                }
            }
            request.setAttribute("partnerList", partnerList);

            request.getRequestDispatcher("partner-list.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    private void viewFeedback(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            AccountDAO accountDAO = new AccountDAO();
            JobDAO jobDAO = new JobDAO();
            FeedbackDAO feedbackDAO = new FeedbackDAO();

            //Lấy acc đang đăng nhập
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            req.setAttribute("loggedAccount", account1);

            //Lay jobId can xem doi tac
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            Job job = jobDAO.getJobById(jobId);
            req.setAttribute("jobId", jobId);

            //Lấy toUserId
            int toUserId = Integer.parseInt(req.getParameter("toUserId"));
            req.setAttribute("toUserId", toUserId);

            //Lấy fromUserId
            int fromUserId = Integer.parseInt(req.getParameter("fromUserId"));
            req.setAttribute("fromUserId", fromUserId);

            Feedback feedback = feedbackDAO.getFeedbackByToUserIdAndJobIdAndFromUserId(toUserId, jobId, fromUserId);
            req.setAttribute("feedback", feedback);
            req.getRequestDispatcher("rating-partner-detail.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("home");
        }
    }

    private void viewCandidatesList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int jobId = Integer.parseInt(request.getParameter("jobId"));
            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobId);

            if (job == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Job not found");
                return;
            }

            AccountDAO accountDAO = new AccountDAO();
            Account poster = accountDAO.getAccountById(job.getPostAccountId());

            JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
            List<JobGreeting> jobGreetingsList = jobGreetingDAO.getJobGreetingsByJobId(jobId);

            // Set job greetings list safely
            job.setJobGreetingList(jobGreetingsList != null ? jobGreetingsList : new ArrayList<>());
            request.setAttribute("numOfApplicants", jobGreetingsList != null ? jobGreetingsList.size() : 0);

            // Format currency
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
            String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
            request.setAttribute("budgetRange", formattedBudgetMin + " - " + formattedBudgetMax);

            // Format dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

            // Handle dueDatePost
            if (job.getDueDatePost() != null) {
                String formattedDueDatePost = dateFormat.format(job.getDueDatePost());
                request.setAttribute("dueDatePostFormatted", formattedDueDatePost);

                // Calculate days left
                long currentTime = System.currentTimeMillis();
                long duePostTime = job.getDueDatePost().getTime();
                long daysLeft = (duePostTime - currentTime) / (1000 * 60 * 60 * 24);
                request.setAttribute("daysLeft", daysLeft);
            } else {
                request.setAttribute("dueDatePostFormatted", "Chưa xác định");
                request.setAttribute("daysLeft", "N/A");
            }

            // Handle postDate
            if (job.getPostDate() != null) {
                java.util.Date postDateUtil = new java.util.Date(job.getPostDate().getTime());
                request.setAttribute("postDateFormatted", dateFormat.format(postDateUtil));
            } else {
                request.setAttribute("postDateFormatted", "Chưa xác định");
            }

            // Handle joinDate
            if (poster != null && poster.getJoinDate() != null) {
                java.util.Date joinDateUtil = java.util.Date.from(poster.getJoinDate().atZone(ZoneId.systemDefault()).toInstant());
                request.setAttribute("joinDateFormatted", dateFormat.format(joinDateUtil));
            } else {
                request.setAttribute("joinDateFormatted", "Chưa xác định");
            }

            // Set attributes for JSP
            request.setAttribute("poster", poster);
            request.setAttribute("job", job);
            request.setAttribute("jobGreetingsList", jobGreetingsList);

            // Forward to JSP
            request.getRequestDispatcher("candidate-list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid job ID");
        } catch (Exception e) {
            // Log the error properly
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
            }
        }
    }

    private void loadPostFeedback(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            AccountDAO accountDAO = new AccountDAO();

            //Lấy acc đang đăng nhập
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            request.setAttribute("loggedAccount", account1);

            //Lay jobId can xem doi tac
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            request.setAttribute("jobId", jobId);

            //Lấy toUserId
            int toUserId = Integer.parseInt(request.getParameter("toUserId"));
            request.setAttribute("toUserId", toUserId);
            request.getRequestDispatcher("rating-partner.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        switch (action) {
            case "post-job":
                postJob(req, resp);
                break;
            case "update-job":
                updateJob(req, resp);
                break;
            case "postFeedback":
                postFeedback(req, resp);
                break;
            default:
                resp.getWriter().print("Lỗi rồi má");
                break;
        }
    }

    private void postFeedback(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            AccountDAO accountDAO = new AccountDAO();
            JobDAO jobDAO = new JobDAO();
            FeedbackDAO feedbackDAO = new FeedbackDAO();

            //Lấy acc đang đăng nhập
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            req.setAttribute("loggedAccount", account1);

            //Lay jobId can xem doi tac
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            Job job = jobDAO.getJobById(jobId);
            req.setAttribute("jobId", jobId);

            //Lấy toUserId
            int toUserId = Integer.parseInt(req.getParameter("toUserId"));
            req.setAttribute("toUserId", toUserId);

            int rating = Integer.parseInt(req.getParameter("rating"));
            String content = req.getParameter("content");

            String type = "";
            if (account1.getAccountId() == job.getPostAccountId()) {
                type = "EmployerToSeeker";
            }

            if (account1.getAccountId() != job.getPostAccountId()) {
                if (toUserId == job.getPostAccountId()) {
                    type = "SeekerToEmployer";
                }
                if (toUserId != job.getPostAccountId()) {
                    type = "SeekerToSeeker";
                }
            }

            Feedback f = new Feedback();
            f.setContent(content);
            f.setJobId(jobId);
            f.setFromUserId(account1.getAccountId());
            f.setToUserId(toUserId);
            f.setType(type);
            f.setRating(rating);
            feedbackDAO.addFeedback(f);
            Feedback feedback = feedbackDAO.getFeedbackByToUserIdAndJobIdAndFromUserId(toUserId, jobId, account1.getAccountId());
            req.setAttribute("feedback", feedback);
            req.getRequestDispatcher("rating-partner-detail.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("home");
        }
    }

    private void detailsJobPosted(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String jobIdStr = request.getParameter("jobId");
        int jobId;
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            jobId = Integer.parseInt(jobIdStr);
            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobId);

            if (job != null) {
                // Lấy thông tin các tag của job
                TagDAO tagDAO = new TagDAO();
                List<Tag> tagList = tagDAO.getTagsByJobId(jobId);
                job.setTagList(tagList);

                // Lấy thông tin greeting (ứng viên) của job
                JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
                List<JobGreeting> greetings = jobGreetingDAO.getJobGreetingsByJobId(jobId);
                job.setJobGreetingList(greetings);
                request.setAttribute("numOfApplicants", greetings.size());

                // Lấy thông tin category của job
                JobCategoryDAO categoryDAO = new JobCategoryDAO();
                JobCategory category = categoryDAO.getCategoryById(job.getCategoryId());
                job.setJobCategory(category);

                // Lấy thông tin người đăng tin
                AccountDAO accountDAO = new AccountDAO();
                Account poster = accountDAO.getAccountById(job.getPostAccountId());

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
                String formattedBudgetMinA = currencyFormat.format(job.getBudgetMin());
                String formattedBudgetMaxA = currencyFormat.format(job.getBudgetMax());
                String formattedBudgetMax = formattedBudgetMaxA.replace("₫", "");
                String formattedBudgetMin = formattedBudgetMinA.replace("₫", "");
                request.setAttribute("budgetRange", formattedBudgetMin + " -  " + formattedBudgetMax);

                // Lấy thông tin thêm nếu có
                if (job.getSecureWallet() == 1) {
                    request.setAttribute("hasSecureWallet", true);
                }

                System.out.println(job);
                System.out.println(poster);
                System.out.println(job.isHaveInterviewed());
                System.out.println(job.isHaveTested());

                // Thêm các thông tin khác cho interface
                session.setAttribute("account", account);
                request.setAttribute("job", job);
                request.setAttribute("poster", poster);
                request.setAttribute("interviewRequired", job.isHaveInterviewed());
                request.setAttribute("testRequired", job.isHaveTested());

                // Xác định loại trang cần hiển thị dựa trên phiên đăng nhập


//                if (account != null) {
//                    // Kiểm tra xem người dùng đăng nhập có phải là người đăng bài không
//                    if (account.getAccountId() == job.getPostAccountId()) {
//                        request.getRequestDispatcher("job-post-detail-employer.jsp").forward(request, response);
//                    } else {
//                        request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
//                    }
//                } else {
                Test test = jobDAO.getTestByJobId(jobId);
                request.setAttribute("test", test);
                request.setAttribute("postAcc", accountDAO.getAccountById(job.getPostAccountId()));
                request.setAttribute("tagList", tagList);
//                request.setAttribute("job", job);
                request.setAttribute("greetings", greetings);
                request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
//                }
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy công việc với ID: " + jobIdStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            System.err.println("Lỗi định dạng jobId: " + jobIdStr);
            e.printStackTrace();
            request.setAttribute("errorMessage", "ID công việc không hợp lệ: " + jobIdStr);
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void viewListApplied(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("sessionAccount");
        int accountId = account.getAccountId();// tạm fix cứng, sau này lấy từ session
        JobDAO jobDAO = new JobDAO();
        List<JobGreeting> jobGreetings = jobDAO.getJobGreetingByJobSeekerId(accountId);

        request.setAttribute("job", jobGreetings);  // "jobGreetings" là key để jsp lấy ra
        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
    }

    private void listJobByStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status"); // Lấy tham số từ request

        int accountId = 1; // Tạm fix cứng, sau này lấy từ session
        JobDAO jobDAO = new JobDAO();

        List<JobGreeting> jobGreetings;
        if (status == null || status.isEmpty() || "tất cả".equals(status)) {
            jobGreetings = jobDAO.getJobGreetingByJobSeekerId(accountId);
        } else {
            jobGreetings = jobDAO.getJobGreetingByStatus(accountId, status);
        }

        request.setAttribute("job", jobGreetings);
        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
    }

    private void sapxep(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sort = request.getParameter("sort"); // Lấy tham số từ request

        int accountId = 1; // Tạm fix cứng, sau này lấy từ session
        JobDAO jobDAO = new JobDAO();

        List<JobGreeting> jobGreetings;
        jobGreetings = jobDAO.search(accountId, sort);

        request.setAttribute("job", jobGreetings);
        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
    }

    public void viewPostedJobList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Login ok thì mở comment
        JobDAO jobDAO = new JobDAO();
        AccountDAO accountDAO = new AccountDAO();
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            int accountId = account1.getAccountId();
            List<Job> jobList = jobDAO.getAllJobByPostAccountId(accountId);
//        List<Job> jobList = jobDAO.getAllJobByPostAccountId(1); //Sau khi login ok thì bỏ dòng này
            request.setAttribute("jobList", jobList);
            request.getRequestDispatcher("job-posted-list-manage.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    public void viewPostedJobDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        HttpSession session = request.getSession();
        JobDAO jobDAO = new JobDAO();
        AccountDAO accountDAO = new AccountDAO();
        TagDAO tagDAO = new TagDAO();
        if (session.getAttribute("sessionAccount") != null) {
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            int accountId = account1.getAccountId();
            request.setAttribute("loggedAccountId", accountId);
        }
            Job job = jobDAO.getJobById(jobId);
            List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
            Test test = jobDAO.getTestByJobId(job.getJobId());
            Account postAcc = accountDAO.getAccountById(job.getPostAccountId());
            List<Tag> tagList;
            try {
                tagList = tagDAO.getTagsByJobId(jobId);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedBudgetMinA = currencyFormat.format(job.getBudgetMin());
            String formattedBudgetMaxA = currencyFormat.format(job.getBudgetMax());
            String formattedBudgetMax = formattedBudgetMaxA.replace("₫", "");
            String formattedBudgetMin = formattedBudgetMinA.replace("₫", "");
            request.setAttribute("budgetRange", formattedBudgetMin + " -  " + formattedBudgetMax);
            request.setAttribute("test", test);
            request.setAttribute("postAcc", postAcc);
            request.setAttribute("tagList", tagList);
            request.setAttribute("job", job);
            request.setAttribute("greetings", greetings);
            request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
    }

    public void postJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JobDAO jobDAO = new JobDAO();
        AccountDAO accountDAO = new AccountDAO();
        Job job = new Job();
        TagDAO tagDAO = new TagDAO();
        //Login ok thì mở comment
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            int accountId = account1.getAccountId();
            job.setPostAccountId(accountId);
//        job.setPostAccountId(1);
            job.setJobTitle(request.getParameter("title"));
            job.setCategoryId(Integer.parseInt(request.getParameter("category")));
            job.setNumOfMember(Integer.parseInt(request.getParameter("numOfMems")));
            job.setJobDescription(request.getParameter("description"));
            job.setRequirements(request.getParameter("requirement"));
            job.setBenefit(request.getParameter("benefit"));
            job.setBudgetMin(new BigDecimal(request.getParameter("budgetMin")));
            job.setBudgetMax(new BigDecimal(request.getParameter("budgetMax")));
            //Xu li test
            Test testO = new Test();
            String testLink = request.getParameter("kiemtra-content");
            String testRequired = request.getParameter("kiemtra-required");
            if (!testLink.isEmpty()) {
                job.setHaveTested(true);
                testO.setTestLink(testLink);
                if ("yes".equals(testRequired)) {
                    testO.setHaveRequired(true);
                } else {
                    testO.setHaveRequired(false);
                }
            } else {
                job.setHaveTested(false);
            }
            Part p = request.getPart("file");
            String fileName = p.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                // Đường dẫn build cụ thể
                String path = getServletContext().getRealPath("") + "job_docs";
                File file = new File(path);
                if (!file.exists()) {
                    file.mkdirs();
                }
                p.write(path + File.separator + fileName);  // Ghi file vào thư mục build
                response.getWriter().print("File saved at: " + path + File.separator + fileName);
            } else {
                fileName = "";
                response.getWriter().print("No file uploaded.");
            }
            job.setAttachment(fileName);

            //Xu ly Interview
//            Interview interview = new Interview();
//            String interDate = request.getParameter("interviewDate");
//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//            if (interDate != null && !interDate.isEmpty()) {
//                // Convert từ String sang java.util.Date
//                job.setHaveInterviewed(true);
//                try {
//                    interview.setStartDate(dateFormat.parse(interDate));
//                } catch (ParseException e) {
//                    throw new RuntimeException(e);
//                }
//            } else {
//                job.setHaveInterviewed(false);
//            }


            String dueDateStr = request.getParameter("dueDate");
            if (dueDateStr != null && !dueDateStr.isEmpty()) {
                // Convert từ String sang java.util.Date
                job.setDueDatePost(Date.valueOf(dueDateStr));
            }

            //Them cong viec moi
            int jobId = jobDAO.addJob(job);

            //Them Interview
//            interview.setJobId(jobId);
//            jobDAO.insertInterview(interview);


            //Them test moi
            testO.setJobId(jobId);
            jobDAO.insertTest(testO);

            //Them JobTag
            String[] tags = request.getParameterValues("tag");
            if (tags != null) {
                for (String tag : tags) {
                    int tagId = Integer.parseInt(tag);
                    jobDAO.addJobTag(jobId, tagId);
                }
            }

            Job jobNew = jobDAO.getJobById(jobId);
            List<Tag> tagList;
            try {
                tagList = tagDAO.getTagsByJobId(jobId);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
            Account postAcc = accountDAO.getAccountById(jobNew.getPostAccountId());
            Test test = jobDAO.getTestByJobId(jobId);
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
            String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
            request.setAttribute("budgetRange", formattedBudgetMin + " - " + formattedBudgetMax);
            request.setAttribute("test", test);
            request.setAttribute("loggedAccountId", accountId);
            request.setAttribute("postAcc", postAcc);
            request.setAttribute("tagList", tagList);
            request.setAttribute("job", jobNew);
            request.setAttribute("greetings", greetings);
            request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    public void loadJobUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobId);
            request.setAttribute("job", job);
            request.getRequestDispatcher("update_job_post.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    public void updateJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            JobDAO jobDAO = new JobDAO();
            AccountDAO accountDAO = new AccountDAO();
            TagDAO tagDAO = new TagDAO();
            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            int accountId = account1.getAccountId();

            Job job = new Job();
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            Job oldJob = jobDAO.getJobById(jobId);
            job.setJobId(jobId);
            job.setPostAccountId(Integer.parseInt(request.getParameter("post-account-id")));
            job.setJobTitle(request.getParameter("title"));
            job.setCategoryId(Integer.parseInt(request.getParameter("category")));
            job.setNumOfMember(Integer.parseInt(request.getParameter("numOfMems")));
            job.setJobDescription(request.getParameter("description"));
            job.setRequirements(request.getParameter("requirement"));
            job.setBenefit(request.getParameter("benefit"));
            job.setBudgetMin(new BigDecimal(request.getParameter("budgetMin")));
            job.setBudgetMax(new BigDecimal(request.getParameter("budgetMax")));
            //Xử lý test
            Test testO = new Test();
            String testLink = request.getParameter("kiemtra-content");
            String testRequired = request.getParameter("kiemtra-required");
            if (!testLink.isEmpty()) {
                job.setHaveTested(true);
                testO.setTestLink(testLink);
                if ("yes".equals(testRequired)) {
                    testO.setHaveRequired(true);
                } else {
                    testO.setHaveRequired(false);
                }
            } else {
                job.setHaveTested(false);
            }
            Part p = request.getPart("file");
            String fileName = p.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                // Đường dẫn build cụ thể
                String path = getServletContext().getRealPath("") + "job_docs";
                File file = new File(path);
                if (!file.exists()) {
                    file.mkdirs();
                }
                p.write(path + File.separator + fileName);  // Ghi file vào thư mục build
                response.getWriter().print("File saved at: " + path + File.separator + fileName);
            } else {
                fileName = oldJob.getAttachment();
                response.getWriter().print("No file uploaded.");
            }
            job.setAttachment(fileName);

            //Xu ly Interview
            Interview interview = new Interview();
            String interDate = request.getParameter("interviewDate");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//            if (interDate != null && !interDate.isEmpty()) {
//                // Convert từ String sang java.util.Date
//                job.setHaveInterviewed(true);
//                try {
//                    interview.setStartDate(dateFormat.parse(interDate));
//                } catch (ParseException e) {
//                    throw new RuntimeException(e);
//                }
//            } else {
//                job.setHaveInterviewed(false);
//            }


            String dueDateStr = request.getParameter("dueDate");
            if (dueDateStr != null && !dueDateStr.isEmpty()) {
                // Convert từ String sang java.util.Date
                job.setDueDatePost(Date.valueOf(dueDateStr));
            }

            job.setHaveInterviewed(false);

            //Them Interview
//            interview.setJobId(jobId);
//            jobDAO.updateInterviewByJobId(interview);


            //add test moi
            testO.setJobId(jobId);
            jobDAO.updateTest(testO);

            //Them JobTag moi
            String[] tags = request.getParameterValues("tag");
            if (tags != null) {
                //Delete JobTag Cũ
                jobDAO.deleteJobTagByJobId(jobId);
                for (String tag : tags) {
                    int tagId = Integer.parseInt(tag);
                    jobDAO.addJobTag(jobId, tagId);
                }
            }

            Job jobNew = jobDAO.getJobById(jobId);
            List<Tag> tagList;
            try {
                tagList = tagDAO.getTagsByJobId(jobId);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
            Account postAcc = accountDAO.getAccountById(jobNew.getPostAccountId());
            Test test = jobDAO.getTestByJobId(jobId);
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
            String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
            request.setAttribute("budgetRange", formattedBudgetMin + " - " + formattedBudgetMax);
            request.setAttribute("test", test);
            request.setAttribute("loggedAccountId", accountId);
            request.setAttribute("postAcc", postAcc);
            request.setAttribute("tagList", tagList);
            request.setAttribute("job", jobNew);
            request.setAttribute("greetings", greetings);
            request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    public void deleteJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("sessionAccount") != null) {
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            JobDAO jobDAO = new JobDAO();
            AccountDAO accountDAO = new AccountDAO();

            Account account = (Account) session.getAttribute("sessionAccount");
            Account account1 = accountDAO.getAccountById(account.getAccountId());
            int accountId = account1.getAccountId();

            boolean check = jobDAO.deleteJobByJobId(jobId);

            if (check) {
                request.setAttribute("toastMessage", "Xóa công việc thành công");
                List<Job> jobList = jobDAO.getAllJobByPostAccountId(accountId);
                request.setAttribute("jobList", jobList);
                request.getRequestDispatcher("job-posted-list-manage.jsp").forward(request, response);
            } else {
                request.setAttribute("toastMessage", "Xóa công việc thất bại - có lỗi xảy ra!");
                request.setAttribute("toastType", "error");

                Job job = jobDAO.getJobById(jobId);
                List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
                request.setAttribute("job", job);
                request.setAttribute("greetings", greetings);
                request.getRequestDispatcher("job-post-detail.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("home");
        }
    }

//    private void downloadFile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        HttpSession session = req.getSession();
//        if (session.getAttribute("sessionAccount") != null) {
//            String fileName = req.getParameter("fileName");
//            if (fileName != null) {
//                String path = getServletContext().getRealPath("") + "job_docs" + File.separator + fileName;

    /// /        System.out.println(path);
    /// /        response.getWriter().print(path);
//
//            JobDAO jobDAO = new JobDAO();
//            Job job = jobDAO.getJobById(jobId);
//
//            AccountDAO accountDAO = new AccountDAO();
//            Account poster = accountDAO.getAccountById(job.getPostAccountId());
//
//            JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
//            List<JobGreeting> jobGreetingsList = jobGreetingDAO.getJobGreetingsByJobId(jobId);
//
//            job.setJobGreetingList(jobGreetingsList);
//            request.setAttribute("numOfApplicants", jobGreetingsList.size());
//
//            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
//            String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
//            String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
//            request.setAttribute("budgetRange", formattedBudgetMin + " - " + formattedBudgetMax);
//
//            // Xử lý thông tin deadline
//            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
//
//            // Xử lý dueDatePost
//            if (job.getDueDatePost() != null) {
//                String formattedDueDatePost = dateFormat.format(job.getDueDatePost());
//                request.setAttribute("dueDatePostFormatted", formattedDueDatePost);
//            } else {
//                request.setAttribute("dueDatePostFormatted", "Chưa xác định");
//            }
//
//            // Xử lý postDate (java.sql.Timestamp)
//            if (job.getPostDate() != null) {
//                // Convert Timestamp to java.util.Date
//                java.util.Date postDateUtil = new java.util.Date(job.getPostDate().getTime());
//                String formattedPostDate = dateFormat.format(postDateUtil);
//                request.setAttribute("postDateFormatted", formattedPostDate);
//            } else {
//                request.setAttribute("postDateFormatted", "Chưa xác định");
//            }
//
//            // Xử lý joinDate (java.time.LocalDateTime)
//            if (poster.getJoinDate() != null) {
//                // Convert LocalDateTime to java.util.Date
//                java.util.Date joinDateUtil = java.util.Date.from(poster.getJoinDate().atZone(ZoneId.systemDefault()).toInstant());
//                String formattedJoinDate = dateFormat.format(joinDateUtil);
//                request.setAttribute("joinDateFormatted", formattedJoinDate);
//            } else {
//                request.setAttribute("joinDateFormatted", "Chưa xác định");
//            }
//
//            // Tính thời gian còn lại đến deadline
//            try {
//                if (job.getDueDatePost() != null) {
//                    long currentTime = System.currentTimeMillis();
//                    long duePostTime = job.getDueDatePost().getTime();
//                    long daysLeft = (duePostTime - currentTime) / (1000 * 60 * 60 * 24);
//                    request.setAttribute("daysLeft", daysLeft);
//                } else {
//                    request.setAttribute("daysLeft", "N/A");
//                }
//            } catch (Exception e) {
//                System.err.println("Lỗi khi tính ngày còn lại: " + e.getMessage());
//                request.setAttribute("daysLeft", "N/A");
//            }
//        } else {
//            resp.sendRedirect("home");
//        }
//    }
    protected void downloadFile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get file path from request parameter
        String filePath = request.getParameter("filePath");


        try {
            if (filePath == null || filePath.isEmpty()) {
                // Check if response is committed before sending error
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File path is required");
                }
                return;
            }

            File file = new File(filePath);

            // Verify file exists
            if (!file.exists()) {
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                }
                return;
            }

            // Set response headers before writing content
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
            response.setContentLength((int) file.length());

            // Stream the file content
            try (InputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

        } catch (Exception e) {
            // Log the error
            e.printStackTrace();

            // Only send error if response isn't committed yet
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading file");
            }
        }
    }

    // Phương thức trợ giúp để lấy đường dẫn upload
    private String getUploadPath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
    }

    private void downloadFileJob(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tên tệp từ request parameter
        String fileName = request.getParameter("file");
        String jobIdStr = request.getParameter("jobId");

        if (fileName == null || fileName.isEmpty() || jobIdStr == null || jobIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tên tệp hoặc ID công việc không hợp lệ");
            return;
        }

        try {
            int jobId = Integer.parseInt(jobIdStr);

            // Kiểm tra quyền truy cập tệp (xác thực người dùng có quyền truy cập công việc này)
            // Ví dụ: người dùng đã đăng nhập và là người đăng công việc hoặc ứng viên đã được chấp nhận
            HttpSession session = request.getSession();
            Account loggedInUser = (Account) session.getAttribute("sessionAccount");

            if (loggedInUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobId);

            // Kiểm tra xem tệp có thuộc về công việc này không
            if (job == null || job.getAttachment() == null || !job.getAttachment().contains(fileName)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tệp không tồn tại hoặc không thuộc về công việc này");
                return;
            }

            // Tạo đường dẫn tệp
            String filePath = getServletContext().getRealPath("") + "job_docs" + File.separator + fileName;
            File file = new File(filePath);

            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tệp không tồn tại");
                return;
            }

            // Thiết lập thông tin phản hồi
            String mimeType = getServletContext().getMimeType(file.getName());
            if (mimeType == null) {
                // Nếu kiểu MIME không được xác định, sử dụng kiểu mặc định
                mimeType = "application/octet-stream";
            }

            response.setContentType(mimeType);
            response.setContentLength((int) file.length());

            // Thiết lập header Content-Disposition để khuyến khích tải xuống
            String headerKey = "Content-Disposition";
            String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
            response.setHeader(headerKey, headerValue);

            // Ghi tệp vào phản hồi
            try (FileInputStream inStream = new FileInputStream(file);
                 OutputStream outStream = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = inStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID công việc không hợp lệ");
        }
    }
}
//
//    // Phương thức trợ giúp để lấy kích thước tệp
//    private long getFileSize(String filePath) {
//        File file = new File(filePath);
//        return file.exists() ? file.length() : 0;
//    }
//
//    // Phương thức trợ giúp để định dạng kích thước tệp
//    private String formatFileSize(long size) {
//        final double KB = 1024.0;
//        final double MB = KB * KB;
//        final double GB = MB * KB;
//
//            System.out.println(jobGreetingsList);
//            System.out.println(job);
//            System.out.println(poster);
//            System.out.println(jobGreetingsList.size());
//
//            request.setAttribute("poster", poster);
//            request.setAttribute("job", job);
//            request.setAttribute("jobGreetingsList", jobGreetingsList);
//            request.getRequestDispatcher("candidate-list.jsp").forward(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        req.setCharacterEncoding("UTF-8");
//        resp.setCharacterEncoding("UTF-8");
//        resp.setContentType("text/html;charset=UTF-8");
//
//        String action = req.getParameter("action");
//        switch (action) {
//            case "post-job":
//                postJob(req, resp);
//                break;
//            case "update-job":
//                updateJob(req, resp);
//                break;
//            default:
//                resp.getWriter().print("Lỗi rồi má");
//                break;
//        }
//    }
//
//    private void detailsJobPosted(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String jobIdStr = request.getParameter("jobId");
//        int jobId;
////        HttpSession session = request.getSession();
////        Account account = (Account) session.getAttribute("account");
//        try {
//            jobId = Integer.parseInt(jobIdStr);
//
//            JobDAO jobDAO = new JobDAO();
//            Job job = jobDAO.getJobById(jobId);
//
//            if (job != null) {
//                // Lấy thông tin các tag của job
//                TagDAO tagDAO = new TagDAO();
//                List<Tag> tagList = tagDAO.getTagsByJobId(jobId);
//                job.setTagList(tagList);
//
//                // Lấy thông tin greeting (ứng viên) của job
//                JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
//                List<JobGreeting> greetings = jobGreetingDAO.getJobGreetingsByJobId(jobId);
//                job.setJobGreetingList(greetings);
//                request.setAttribute("numOfApplicants", greetings.size());
//
//                // Lấy thông tin category của job
//                JobCategoryDAO categoryDAO = new JobCategoryDAO();
//                JobCategory category = categoryDAO.getCategoryById(job.getCategoryId());
//                job.setJobCategory(category);
//
//                // Lấy thông tin người đăng tin
//                AccountDAO accountDAO = new AccountDAO();
//                Account poster = accountDAO.getAccountById(job.getPostAccountId());
//
//                // Xử lý thông tin deadline
//                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
//
//                // Xử lý dueDatePost
//                if (job.getDueDatePost() != null) {
//                    String formattedDueDatePost = dateFormat.format(job.getDueDatePost());
//                    request.setAttribute("dueDatePostFormatted", formattedDueDatePost);
//                } else {
//                    request.setAttribute("dueDatePostFormatted", "Chưa xác định");
//                }
//
//                // Xử lý postDate (java.sql.Timestamp)
//                if (job.getPostDate() != null) {
//                    // Convert Timestamp to java.util.Date
//                    java.util.Date postDateUtil = new java.util.Date(job.getPostDate().getTime());
//                    String formattedPostDate = dateFormat.format(postDateUtil);
//                    request.setAttribute("postDateFormatted", formattedPostDate);
//                } else {
//                    request.setAttribute("postDateFormatted", "Chưa xác định");
//                }
//
//                // Xử lý joinDate (java.time.LocalDateTime)
//                if (poster.getJoinDate() != null) {
//                    // Convert LocalDateTime to java.util.Date
//                    java.util.Date joinDateUtil = java.util.Date.from(poster.getJoinDate().atZone(ZoneId.systemDefault()).toInstant());
//                    String formattedJoinDate = dateFormat.format(joinDateUtil);
//                    request.setAttribute("joinDateFormatted", formattedJoinDate);
//                } else {
//                    request.setAttribute("joinDateFormatted", "Chưa xác định");
//                }
//
//                // Tính thời gian còn lại đến deadline
//                try {
//                    if (job.getDueDatePost() != null) {
//                        long currentTime = System.currentTimeMillis();
//                        long duePostTime = job.getDueDatePost().getTime();
//                        long daysLeft = (duePostTime - currentTime) / (1000 * 60 * 60 * 24);
//                        request.setAttribute("daysLeft", daysLeft);
//                    } else {
//                        request.setAttribute("daysLeft", "N/A");
//                    }
//                } catch (Exception e) {
//                    System.err.println("Lỗi khi tính ngày còn lại: " + e.getMessage());
//                    request.setAttribute("daysLeft", "N/A");
//                }
//
//                // Tính thời gian còn lại đến deadline
//                try {
//                    if (job.getDueDatePost() != null) {
//                        long currentTime = System.currentTimeMillis();
//                        long duePostTime = job.getDueDatePost().getTime();
//                        long daysLeft = (duePostTime - currentTime) / (1000 * 60 * 60 * 24);
//                        request.setAttribute("daysLeft", daysLeft);
//                    } else {
//                        request.setAttribute("daysLeft", "N/A");
//                    }
//                } catch (Exception e) {
//                    System.err.println("Lỗi khi tính ngày còn lại: " + e.getMessage());
//                    request.setAttribute("daysLeft", "N/A");
//                }
//
//                // Format ngân sách hiển thị
//                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
//                String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
//                String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
//                request.setAttribute("budgetRange", formattedBudgetMin + " - " + formattedBudgetMax);
//
//                // Lấy thông tin thêm nếu có
//                if (job.getSecureWallet() == 1) {
//                    request.setAttribute("hasSecureWallet", true);
//                }
//
//                System.out.println(job);
//                System.out.println(poster);
//                System.out.println( job.isHaveInterviewed());
//                System.out.println(job.isHaveTested());
//
//                // Thêm các thông tin khác cho interface
//                request.setAttribute("job", job);
//                request.setAttribute("poster", poster);
//                request.setAttribute("interviewRequired", job.isHaveInterviewed());
//                request.setAttribute("testRequired", job.isHaveTested());
//
//                // Xác định loại trang cần hiển thị dựa trên phiên đăng nhập
//
//
////                if (account != null) {
////                    // Kiểm tra xem người dùng đăng nhập có phải là người đăng bài không
////                    if (account.getAccountId() == job.getPostAccountId()) {
////                        request.getRequestDispatcher("job-post-detail-employer.jsp").forward(request, response);
////                    } else {
////                        request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
////                    }
////                } else {
//                request.getRequestDispatcher("job-post-detail-employee.jsp").forward(request, response);
////                }
//            } else {
//                request.setAttribute("errorMessage", "Không tìm thấy công việc với ID: " + jobIdStr);
//                request.getRequestDispatcher("error.jsp").forward(request, response);
//            }
//        } catch (NumberFormatException e) {
//            System.err.println("Lỗi định dạng jobId: " + jobIdStr);
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "ID công việc không hợp lệ: " + jobIdStr);
//            request.getRequestDispatcher("error.jsp").forward(request, response);
//        } catch (Exception e) {
//            System.err.println("Lỗi không xác định: " + e.getMessage());
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Đã xảy ra lỗi không xác định: " + e.getMessage());
//            request.getRequestDispatcher("error.jsp").forward(request, response);
//        }
//    }
//
//    private void viewListApplied(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        Account account = (Account) session.getAttribute("sessionAccount");
//        int accountId = account.getAccountId();// tạm fix cứng, sau này lấy từ session
//        JobDAO jobDAO = new JobDAO();
//        List<JobGreeting> jobGreetings = jobDAO.getJobGreetingByJobSeekerId(accountId);
//
//        request.setAttribute("job", jobGreetings);  // "jobGreetings" là key để jsp lấy ra
//        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
//    }
//
//    private void listJobByStatus(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String status = request.getParameter("status"); // Lấy tham số từ request
//
//        int accountId = 1; // Tạm fix cứng, sau này lấy từ session
//        JobDAO jobDAO = new JobDAO();
//
//        List<JobGreeting> jobGreetings;
//        if (status == null || status.isEmpty() || "tất cả".equals(status)) {
//            jobGreetings = jobDAO.getJobGreetingByJobSeekerId(accountId);
//        } else {
//            jobGreetings = jobDAO.getJobGreetingByStatus(accountId, status);
//        }
//
//        request.setAttribute("job", jobGreetings);
//        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
//    }
//
//    private void sapxep(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String sort = request.getParameter("sort"); // Lấy tham số từ request
//
//        int accountId = 1; // Tạm fix cứng, sau này lấy từ session
//        JobDAO jobDAO = new JobDAO();
//
//        List<JobGreeting> jobGreetings;
//        jobGreetings = jobDAO.search(accountId, sort);
//
//        request.setAttribute("job", jobGreetings);
//        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
//    }
//
//    public void viewPostedJobList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        //Login ok thì mở comment
//        JobDAO jobDAO = new JobDAO();
//        AccountDAO accountDAO = new AccountDAO();
//        HttpSession session = request.getSession();
//        if(session.getAttribute("sessionAccount") != null) {
//            Account account = (Account) session.getAttribute("sessionAccount");
//            Account account1 = accountDAO.getAccountById(account.getAccountId());
//            int accountId = account1.getAccountId();
//            List<Job> jobList = jobDAO.getAllJobByPostAccountId(accountId);
////        List<Job> jobList = jobDAO.getAllJobByPostAccountId(1); //Sau khi login ok thì bỏ dòng này
//            request.setAttribute("jobList", jobList);
//            request.getRequestDispatcher("job-posted-list-manage.jsp").forward(request, response);
//        } else {
//            response.sendRedirect("home");
//        }
//    }
//
//    public void viewPostedJobDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int jobId = Integer.parseInt(request.getParameter("jobId"));
//        HttpSession session = request.getSession();
//        JobDAO jobDAO = new JobDAO();
//        if (session.getAttribute("sessionAccount") != null) {
//            Job job = jobDAO.getJobById(jobId);
//            List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
//            request.setAttribute("job", job);
//            request.setAttribute("greetings", greetings);
////        response.getWriter().print(job);
//            request.getRequestDispatcher("job-post-detail.jsp").forward(request, response);
//        }else {
//            response.sendRedirect("home");
//        }
//    }
//
//    public void postJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        JobDAO jobDAO = new JobDAO();
//        AccountDAO accountDAO = new AccountDAO();
//        Job job = new Job();
//        //Login ok thì mở comment
//        HttpSession session = request.getSession();
//        if(session.getAttribute("sessionAccount") != null) {
//            Account account = (Account) session.getAttribute("sessionAccount");
//            Account account1 = accountDAO.getAccountById(account.getAccountId());
//            int accountId = account1.getAccountId();
//            job.setPostAccountId(accountId);
////        job.setPostAccountId(1);
//            job.setJobTitle(request.getParameter("title"));
//            job.setCategoryId(Integer.parseInt(request.getParameter("category")));
//            job.setNumOfMember(Integer.parseInt(request.getParameter("numOfMems")));
//            job.setJobDescription(request.getParameter("description"));
//            job.setRequirements(request.getParameter("requirement"));
//            job.setBenefit(request.getParameter("benefit"));
//            job.setBudgetMin(new BigDecimal(request.getParameter("budgetMin")));
//            job.setBudgetMax(new BigDecimal(request.getParameter("budgetMax")));
//            //Xu li test
//            Test testO = new Test();
//            String test = request.getParameter("kiemtra");
//            String testLink = request.getParameter("kiemtra-content");
//            String testRequired = request.getParameter("kiemtra-required");
//            if ("yes".equals(test)) {
//                // Người dùng chọn "Có"
//                job.setHaveTested(true);
//                testO.setTestLink(testLink);
//                if ("yes".equals(testRequired)) {
//                    testO.setHaveRequired(true);
//                } else {
//                    testO.setHaveRequired(false);
//                }
//            } else if ("no".equals(test)) {
//                // Người dùng chọn "Không"
//                job.setHaveTested(false);
//            } else {
//                // Không chọn gì
//                job.setHaveTested(false);
//            }
//            Part p = request.getPart("file");
//            String fileName = p.getSubmittedFileName();
//            if (fileName != null && !fileName.isEmpty()) {
//                // Đường dẫn build cụ thể
//                String path = getServletContext().getRealPath("") + "job_docs";
//                File file = new File(path);
//                if (!file.exists()) {
//                    file.mkdirs();
//                }
//                p.write(path + File.separator + fileName);  // Ghi file vào thư mục build
//                response.getWriter().print("File saved at: " + path + File.separator + fileName);
//            } else {
//                fileName = "";
//                response.getWriter().print("No file uploaded.");
//            }
//            job.setAttachment(fileName);
//
//            //Xu ly Interview
//            Interview interview = new Interview();
//            String interDate = request.getParameter("interviewDate");
//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//            if (interDate != null && !interDate.isEmpty()) {
//                // Convert từ String sang java.util.Date
//                job.setHaveInterviewed(true);
//                try {
//                    interview.setStartDate(dateFormat.parse(interDate));
//                } catch (ParseException e) {
//                    throw new RuntimeException(e);
//                }
//            } else {
//                job.setHaveInterviewed(false);
//            }
//
//            String dueDateStr = request.getParameter("dueDate");
//            if (dueDateStr != null && !dueDateStr.isEmpty()) {
//                // Convert từ String sang java.util.Date
//                job.setDueDatePost(Date.valueOf(dueDateStr));
//            }
//
//            //Them cong viec moi
//            int jobId = jobDAO.addJob(job);
//
//            //Them Interview
//            interview.setJobId(jobId);
//            jobDAO.insertInterview(interview);
//
//            //Them test moi
//            testO.setJobId(jobId);
//            jobDAO.insertTest(testO);
//
//            //Them JobTag
//            String[] tags = request.getParameterValues("tag");
//            if (tags != null) {
//                for (String tag : tags) {
//                    int tagId = Integer.parseInt(tag);
//                    jobDAO.addJobTag(jobId, tagId);
//                }
//            }
//
//            Job jobNew = jobDAO.getJobById(jobId);
//            List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
//            request.setAttribute("job", jobNew);
//            request.setAttribute("greetings", greetings);
//            request.getRequestDispatcher("job-post-detail.jsp").forward(request, response);
//        }else {
//            response.sendRedirect("home");
//        }
//    }
//
//    public void loadJobUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        if (session.getAttribute("sessionAccount") != null) {
//            int jobId = Integer.parseInt(request.getParameter("jobId"));
//            JobDAO jobDAO = new JobDAO();
//            Job job = jobDAO.getJobById(jobId);
//            request.setAttribute("job", job);
//            request.getRequestDispatcher("update_job_post.jsp").forward(request, response);
//        }else {
//            response.sendRedirect("home");
//        }
//    }
//
//    public void updateJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        if (session.getAttribute("sessionAccount") != null) {
//            JobDAO jobDAO = new JobDAO();
//            Job job = new Job();
//            int jobId = Integer.parseInt(request.getParameter("jobId"));
//            Job oldJob = jobDAO.getJobById(jobId);
//            job.setJobId(jobId);
//            job.setPostAccountId(Integer.parseInt(request.getParameter("post-account-id")));
//            job.setJobTitle(request.getParameter("title"));
//            job.setCategoryId(Integer.parseInt(request.getParameter("category")));
//            job.setNumOfMember(Integer.parseInt(request.getParameter("numOfMems")));
//            job.setJobDescription(request.getParameter("description"));
//            job.setRequirements(request.getParameter("requirement"));
//            job.setBenefit(request.getParameter("benefit"));
//            job.setBudgetMin(new BigDecimal(request.getParameter("budgetMin")));
//            job.setBudgetMax(new BigDecimal(request.getParameter("budgetMax")));
//            //Xu li test
//            Test testO = new Test();
//            String test = request.getParameter("kiemtra");
//            String testLink = request.getParameter("kiemtra-content");
//            String testRequired = request.getParameter("kiemtra-required");
//            if ("yes".equals(test)) {
//                // Người dùng chọn "Có"
//                job.setHaveTested(true);
//                testO.setTestLink(testLink);
//                if ("yes".equals(testRequired)) {
//                    testO.setHaveRequired(true);
//                } else {
//                    testO.setHaveRequired(false);
//                }
//            } else if ("no".equals(test)) {
//                // Người dùng chọn "Không"
//                job.setHaveTested(false);
//            } else {
//                // Không chọn gì
//                job.setHaveTested(false);
//            }
//            Part p = request.getPart("file");
//            String fileName = p.getSubmittedFileName();
//            if (fileName != null && !fileName.isEmpty()) {
//                // Đường dẫn build cụ thể
//                String path = getServletContext().getRealPath("") + "job_docs";
//                File file = new File(path);
//                if (!file.exists()) {
//                    file.mkdirs();
//                }
//                p.write(path + File.separator + fileName);  // Ghi file vào thư mục build
//                response.getWriter().print("File saved at: " + path + File.separator + fileName);
//            } else {
//                fileName = oldJob.getAttachment();
//                response.getWriter().print("No file uploaded.");
//            }
//            job.setAttachment(fileName);
//
//            //Xu ly Interview
//            Interview interview = new Interview();
//            String interDate = request.getParameter("interviewDate");
//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//            if (interDate != null && !interDate.isEmpty()) {
//                // Convert từ String sang java.util.Date
//                job.setHaveInterviewed(true);
//                try {
//                    interview.setStartDate(dateFormat.parse(interDate));
//                } catch (ParseException e) {
//                    throw new RuntimeException(e);
//                }
//            } else {
//                job.setHaveInterviewed(false);
//            }
//
//            String dueDateStr = request.getParameter("dueDate");
//            if (dueDateStr != null && !dueDateStr.isEmpty()) {
//                // Convert từ String sang java.util.Date
//                job.setDueDatePost(Date.valueOf(dueDateStr));
//            }
//
//            jobDAO.updateJobByJobId(job);
//
//            //Them Interview
//            interview.setJobId(jobId);
//            jobDAO.updateInterviewByJobId(interview);
//
//            //Them test moi
//            testO.setJobId(jobId);
//            jobDAO.insertTest(testO);
//
//            //Them JobTag moi
//            String[] tags = request.getParameterValues("tag");
//            if (tags != null) {
//                //Delete JobTag Cũ
//                jobDAO.deleteJobTagByJobId(jobId);
//                for (String tag : tags) {
//                    int tagId = Integer.parseInt(tag);
//                    jobDAO.addJobTag(jobId, tagId);
//                }
//            }
//
//            Job jobNew = jobDAO.getJobById(jobId);
//            List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
//            request.setAttribute("job", jobNew);
//            request.setAttribute("greetings", greetings);
//            request.getRequestDispatcher("job-post-detail.jsp").forward(request, response);
//        }else{
//            response.sendRedirect("home");
//        }
//    }
//
//    public void deleteJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        if (session.getAttribute("sessionAccount") != null) {
//            int jobId = Integer.parseInt(request.getParameter("jobId"));
//            JobDAO jobDAO = new JobDAO();
//            AccountDAO accountDAO = new AccountDAO();
//
//            Account account = (Account) session.getAttribute("sessionAccount");
//            Account account1 = accountDAO.getAccountById(account.getAccountId());
//            int accountId = account1.getAccountId();
//
//            boolean check = jobDAO.deleteJobByJobId(jobId);
//
//            if(check){
//                request.setAttribute("toastMessage", "Xóa công việc thành công");
//                List<Job> jobList = jobDAO.getAllJobByPostAccountId(accountId);
//                request.setAttribute("jobList", jobList);
//                request.getRequestDispatcher("job-posted-list-manage.jsp").forward(request, response);
//            } else {
//                request.setAttribute("toastMessage", "Xóa công việc thất bại - có lỗi xảy ra!");
//                request.setAttribute("toastType", "error");
//
//                Job job = jobDAO.getJobById(jobId);
//                List<JobGreeting> greetings = jobDAO.getJobGreetingsByJobId(jobId);
//                request.setAttribute("job", job);
//                request.setAttribute("greetings", greetings);
//                request.getRequestDispatcher("job-post-detail.jsp").forward(request, response);
//            }
//        }else{
//            response.sendRedirect("home");
//        }
//    }
//
////    private void downloadFile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
////        HttpSession session = req.getSession();
////        if (session.getAttribute("sessionAccount") != null) {
////            String fileName = req.getParameter("fileName");
////            if (fileName != null) {
////                String path = getServletContext().getRealPath("") + "job_docs" + File.separator + fileName;
//////        System.out.println(path);
//////        response.getWriter().print(path);
////
////                File file = new File(path);
////                OutputStream os = null;
////                FileInputStream fis = null;
////
////                resp.setHeader("Content-Disposition", String.format("attachment;filename=\"%s\"", file.getName()));
////                resp.setContentType("application/octet-stream");
////
////                if (file.exists()) {
////                    os = resp.getOutputStream();
////                    fis = new FileInputStream(file);
////                    byte[] bf = new byte[BUFFER_SIZE];
////                    int byteRead = -1;
////                    while ((byteRead = fis.read(bf)) != -1) {
////                        os.write(bf, 0, byteRead);
////                    }
////                } else {
////                    System.out.println("File Not Found: " + fileName);
////                }
////            }
////        } else {
////            resp.sendRedirect("home");
////        }
////    }
//
//    private void downloadFile(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // Lấy tên tệp từ request parameter
//        String fileName = request.getParameter("file");
//        String jobIdStr = request.getParameter("jobId");
//
//        if (fileName == null || fileName.isEmpty() || jobIdStr == null || jobIdStr.isEmpty()) {
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tên tệp hoặc ID công việc không hợp lệ");
//            return;
//        }
//
//        try {
//            int jobId = Integer.parseInt(jobIdStr);
//
//            // Kiểm tra quyền truy cập tệp (xác thực người dùng có quyền truy cập công việc này)
//            // Ví dụ: người dùng đã đăng nhập và là người đăng công việc hoặc ứng viên đã được chấp nhận
//            HttpSession session = request.getSession();
//            Account loggedInUser = (Account) session.getAttribute("account");
//
//            if (loggedInUser == null) {
//                response.sendRedirect(request.getContextPath() + "/login.jsp");
//                return;
//            }
//
//            JobDAO jobDAO = new JobDAO();
//            Job job = jobDAO.getJobById(jobId);
//
//            // Kiểm tra xem tệp có thuộc về công việc này không
//            if (job == null || job.getAttachment() == null || !job.getAttachment().contains(fileName)) {
//                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tệp không tồn tại hoặc không thuộc về công việc này");
//                return;
//            }
//
//            // Tạo đường dẫn tệp
//            String filePath = getUploadPath(request) + File.separator + fileName;
//            File file = new File(filePath);
//
//            if (!file.exists()) {
//                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tệp không tồn tại");
//                return;
//            }
//
//            // Thiết lập thông tin phản hồi
//            String mimeType = getServletContext().getMimeType(file.getName());
//            if (mimeType == null) {
//                // Nếu kiểu MIME không được xác định, sử dụng kiểu mặc định
//                mimeType = "application/octet-stream";
//            }
//
//            response.setContentType(mimeType);
//            response.setContentLength((int) file.length());
//
//            // Thiết lập header Content-Disposition để khuyến khích tải xuống
//            String headerKey = "Content-Disposition";
//            String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
//            response.setHeader(headerKey, headerValue);
//
//            // Ghi tệp vào phản hồi
//            try (FileInputStream inStream = new FileInputStream(file);
//                 OutputStream outStream = response.getOutputStream()) {
//
//                byte[] buffer = new byte[4096];
//                int bytesRead;
//
//                while ((bytesRead = inStream.read(buffer)) != -1) {
//                    outStream.write(buffer, 0, bytesRead);
//                }
//            }
//        } catch (NumberFormatException e) {
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID công việc không hợp lệ");
//        }
//    }
//
//    // Phương thức trợ giúp để lấy đường dẫn upload
//    private String getUploadPath(HttpServletRequest request) {
//        return request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
//    }
////
////    // Phương thức trợ giúp để lấy kích thước tệp
////    private long getFileSize(String filePath) {
////        File file = new File(filePath);
////        return file.exists() ? file.length() : 0;
////    }
////
////    // Phương thức trợ giúp để định dạng kích thước tệp
////    private String formatFileSize(long size) {
////        final double KB = 1024.0;
////        final double MB = KB * KB;
////        final double GB = MB * KB;
////
////        DecimalFormat df = new DecimalFormat("#.##");
////
////        if (size < KB) {
////            return size + " B";
////        } else if (size < MB) {
////            return df.format(size / KB) + " KB";
////        } else if (size < GB) {
////            return df.format(size / MB) + " MB";
////        } else {
////            return df.format(size / GB) + " GB";
////        }
////    }
////
////    // Phương thức trợ giúp để xác định loại tệp dựa trên phần mở rộng
////    private String getFileType(String extension) {
////        switch (extension.toLowerCase()) {
////            case "pdf":
////                return "PDF";
////            case "doc":
////            case "docx":
////                return "DOCX";
////            case "xls":
////            case "xlsx":
////                return "Excel";
////            case "zip":
////            case "rar":
////                return "ZIP";
////            case "jpg":
////            case "jpeg":
////            case "png":
////                return "Image";
////            default:
////                return extension.toUpperCase();
////        }
////    }
////
////    // Lớp trợ giúp để đại diện cho tệp đính kèm trong giao diện
////    public static class JobAttachment {
////        private String fileName;
////        private String fileType;
////        private String fileSize;
////
////        public JobAttachment(String fileName, String fileType, String fileSize) {
////            this.fileName = fileName;
////            this.fileType = fileType;
////            this.fileSize = fileSize;
////        }
////
////        public String getFileName() { return fileName; }
////        public String getFileType() { return fileType; }
////        public String getFileSize() { return fileSize; }
////    }
//
//
////    private void viewListApplied(HttpServletRequest request, HttpServletResponse response)
////            throws ServletException, IOException {
////        HttpSession session = request.getSession();
////        Account account = (Account) session.getAttribute("sessionAccount");
////        int accountId = account.getAccountId();// tạm fix cứng, sau này lấy từ session
////        JobDAO jobDAO = new JobDAO();
////        List<JobGreeting> jobGreetings = jobDAO.getJobGreetingByJobSeekerId(accountId);
////
////        request.setAttribute("job", jobGreetings);  // "jobGreetings" là key để jsp lấy ra
////        request.getRequestDispatcher("applied-job-list-01.jsp").forward(request, response);
////    }
////    private void listJobByStatus(HttpServletRequest request, HttpServletResponse response)
////            throws ServletException, IOException {
////        String status = request.getParameter("status"); // Lấy tham số từ request
////
////        int accountId = 1; // Tạm fix cứng, sau này lấy từ session
////        JobDAO jobDAO = new JobDAO();
////
////        List<JobGreeting> jobGreetings;
////        if (status == null || status.isEmpty() || "tất cả".equals(status)) {
////            jobGreetings = jobDAO.getJobGreetingByJobSeekerId(accountId);
////        } else {
////            jobGreetings = jobDAO.getJobGreetingByStatus(accountId, status);
////        }
////
////        request.setAttribute("job", jobGreetings);
////        request.getRequestDispatcher("applied-job-list-01.jsp").forward(request, response);
////    }
////    private void sapxep(HttpServletRequest request, HttpServletResponse response)
////            throws ServletException, IOException {
////        String sort = request.getParameter("sort"); // Lấy tham số từ request
////
////        int accountId = 1; // Tạm fix cứng, sau này lấy từ session
////        JobDAO jobDAO = new JobDAO();
////
////        List<JobGreeting> jobGreetings;
////        jobGreetings = jobDAO.search(accountId,sort);
////
////        request.setAttribute("job", jobGreetings);
////        request.getRequestDispatcher("applied-job-list-01.jsp").forward(request, response);
////    }
//////    private void detail(HttpServletRequest request, HttpServletResponse response)
//////            throws ServletException, IOException {
//////        String jobGreetingId  = request.getParameter("jobGreetingId").trim();
//////        String jobId = request.getParameter("jobId").trim();
//////        int jgId = Integer.parseInt(jobGreetingId);
//////        int j = Integer.parseInt(jobId);
//////        JobDAO jd = new JobDAO();
//////        JobGreeting jobGreeting = jd.getJobGreetingById(jgId);
//////        Job job =jd.getJobById(j);
//////        request.setAttribute("jobGreeting ", jobGreeting );
//////        request.setAttribute("job", job);
//////
//////        request.getRequestDispatcher("infor-applied-job-detail.jsp").forward(request, response);
//////    }
////
////        request.setAttribute("job", jobGreetings);  // "jobGreetings" là key để jsp lấy ra
////        request.getRequestDispatcher("applied-job-list-01.jsp").forward(request, response);
////    }
////}
//}