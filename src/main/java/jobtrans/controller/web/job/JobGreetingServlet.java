package jobtrans.controller.web.job;


import jobtrans.dal.*;
import jobtrans.model.*;
import jobtrans.model.Account;
import jobtrans.model.Job;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;


@WebServlet(name="JobGreetingServlet", urlPatterns={"/job-greeting"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5242880, // 5 MB
        maxRequestSize = 20971520 // 20 MB
)
public class JobGreetingServlet extends HttpServlet {

    // Constants for file upload
    private static final int MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String UPLOAD_DIRECTORY = "uploads/attachments";

    AccountDAO accountDAO = new AccountDAO();
    JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
    JobDAO jobDAO = new JobDAO();
    CvDAO cvDAO = new CvDAO();
    InterviewDAO interviewDAO = new InterviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "view-applied":
                viewListApplied(request, response);
                break;
            case "show-send-application":
                showSendApplication(request, response);
                break;
            case "view-details-greeting":
                viewDetailsGreeting(request, response);
                break;
            case "accept-to-interview":
                acceptToInterview(request, response);
                break;
            case "refuse-candidate":
                refuseCandidate(request, response);
                break;
            case "list-job-by-status":
                listJobByStatus(request, response);
                break;
            case "sort":
                sapxep(request, response);
                break;
            case "detail":
                detail(request, response);
                break;
            default:
                response.getWriter().print("Lỗi rồi má");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("sessionAccount");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        Account account01 = accountDAO.getAccountById(account.getAccountId());

        int jobSeekerId = account01.getAccountId();

        try {
            // Get regular form parameters directly - assumes not multipart
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            int cvId = Integer.parseInt(request.getParameter("cv_id"));
            int price = Integer.parseInt(request.getParameter("price").replaceAll("[^\\d]", ""));
            int expectedDay = Integer.parseInt(request.getParameter("expected_day"));
            String introduction = request.getParameter("introduction");

            // Process attachment (if any) using a separate method
            String attachment = processAttachment(request);

            // Create job greeting object
            JobGreeting jobGreeting = new JobGreeting();
            jobGreeting.setJobSeekerId(jobSeekerId);
            jobGreeting.setJobId(jobId);
            jobGreeting.setCvId(cvId);
            jobGreeting.setPrice(price);
            jobGreeting.setExpectedDay(expectedDay);
            jobGreeting.setIntroduction(introduction);
            jobGreeting.setAttachment(attachment);
            jobGreeting.setHaveRead(false);
            jobGreeting.setStatus("Chờ xét duyệt");

            System.out.println(jobGreeting);

            // Save job greeting to database
            boolean success = jobGreetingDAO.insertJobGreeting(jobGreeting);
            System.out.println(jobGreeting);

            if (success) {
                // Send notification to job poster
                Job job = jobDAO.getJobById(jobId);
                Account applier = accountDAO.getAccountById(jobSeekerId);

//                sendNotification(job.getPostAccountId(), jobId, applier.getAccountName(), job.getJobTitle());

                // Redirect with success message
                request.setAttribute("successMessage", "Gửi chào giá thành công");
//                response.sendRedirect(request.getContextPath() + "/job-greeting?action=view-details-greeting&greetingId=" + jobGreeting.getGreetingId());
                response.sendRedirect(request.getContextPath() + "/job?action=details-job-posted&jobId=" + jobId);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra, vui lòng thử lại sau");
                request.getRequestDispatcher("404.html").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String jobId = request.getParameter("jobId");
            String redirectUrl = jobId != null ? "job-detail?jobId=" + jobId : "browse-jobs";
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher(redirectUrl).forward(request, response);
        }
    }

    private void acceptToInterview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");

            int jobGreetingId = Integer.parseInt(request.getParameter("greetingId"));
            JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
            JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingById(jobGreetingId);
            boolean updated = jobGreetingDAO.updateStatus(jobGreetingId, "Chờ phỏng vấn");

            System.out.println(jobGreeting);

            if (updated) {
                response.sendRedirect("job?action=view-candidates-list&jobId=" + jobGreeting.getJobId());
            } else {
                // Xử lý khi có lỗi

                request.setAttribute("errorMessage", "Không thể cập nhật trạng thái phỏng vấn.");
                request.getRequestDispatcher("404.html").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "ID không đúng định dạng: " + e.getMessage());
            request.getRequestDispatcher("404.html").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("404.html").forward(request, response);
        }
    }

    private void refuseCandidate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");

            int jobGreetingId = Integer.parseInt(request.getParameter("greetingId"));
            JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
            JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingById(jobGreetingId);
            boolean updated = jobGreetingDAO.updateStatus(jobGreetingId, "Bị từ chối");

            System.out.println(jobGreeting);

            if (updated) {
                response.sendRedirect("job?action=view-candidates-list&jobId=" + jobGreeting.getJobId());
            } else {
                // Xử lý khi có lỗi

                request.setAttribute("errorMessage", "Không thể cập nhật trạng thái phỏng vấn.");
                request.getRequestDispatcher("404.html").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "ID không đúng định dạng: " + e.getMessage());
            request.getRequestDispatcher("404.html").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("404.html").forward(request, response);
        }
    }

    private void viewDetailsGreeting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // Kiểm tra phiên đăng nhập
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return; // Thêm return để tránh tiếp tục thực thi code
            }

            int loginId = account.getAccountId();
            request.setAttribute("loginId", loginId);

            // Lấy thông tin greeting
            int greetingId = Integer.parseInt(request.getParameter("greetingId"));
            JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
            JobGreeting jobGreeting = jobGreetingDAO.getJobGreetingById(greetingId);

            if (jobGreeting == null) {
                // Xử lý khi không tìm thấy greeting
                request.setAttribute("errorMessage", "Không tìm thấy thông tin ứng tuyển");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            CV cv = cvDAO.getCvById(jobGreeting.getCvId());
            Account candidateAccount = accountDAO.getAccountById(jobGreeting.getJobSeekerId());

            // Format giá tiền sang định dạng tiền Việt Nam
            NumberFormat vnCurrencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedPriceA = vnCurrencyFormat.format(jobGreeting.getPrice());
            String formattedPrice = formattedPriceA.replace("₫", "");

            // Xử lý hiển thị tên file đính kèm
            if (jobGreeting.getAttachment() != null && !jobGreeting.getAttachment().isEmpty()) {
                String attachmentFullPath = jobGreeting.getAttachment();
                String attachmentFileName = attachmentFullPath.substring(attachmentFullPath.lastIndexOf("/") + 1);
                jobGreeting.setAttachment(attachmentFileName);
            }

            // Đánh dấu là đã đọc
            jobGreeting.setHaveRead(true);
//            jobGreetingDAO.updateJobGreeting(jobGreeting);

            Interview interview = interviewDAO.getInterviewByGreetingId(greetingId);

            // Kiểm tra xem phỏng vấn đã kết thúc chưa
//            boolean isInterviewCompleted = false;
//            if (jobGreeting.getStatus().equals("Chờ phỏng vấn") && interview != null) {
//                // Tạo đối tượng datetime từ interview_date và interview_time
//                Calendar interviewCalendar = Calendar.getInstance();
//                // Giả sử interview có các phương thức getInterviewDate() và getInterviewTime() trả về java.sql.Date và java.sql.Time
//                interviewCalendar.setTime(interview.getInterviewDate());
//
//                Calendar timeCalendar = Calendar.getInstance();
//                timeCalendar.setTime(interview.getInterviewTime());
//
//                // Lấy giờ, phút, giây từ interview_time
//                interviewCalendar.set(Calendar.HOUR_OF_DAY, timeCalendar.get(Calendar.HOUR_OF_DAY));
//                interviewCalendar.set(Calendar.MINUTE, timeCalendar.get(Calendar.MINUTE));
//                interviewCalendar.set(Calendar.SECOND, timeCalendar.get(Calendar.SECOND));
//
//                // Thêm thời gian dự kiến cho buổi phỏng vấn (ví dụ: 1 giờ)
//                interviewCalendar.add(Calendar.HOUR_OF_DAY, 0.1); // Giả sử phỏng vấn kéo dài 1 tiếng
//
//                // So sánh với thời gian hiện tại
//                long currentTime = System.currentTimeMillis();
//                long interviewEndTime = interviewCalendar.getTimeInMillis();
//                isInterviewCompleted = currentTime > interviewEndTime;
//            }

            // Set thuộc tính cho trang JSP
            request.setAttribute("formattedPrice", formattedPrice);
            request.setAttribute("cv", cv);
            request.setAttribute("jobGreeting", jobGreeting);
            request.setAttribute("account", candidateAccount);
            request.setAttribute("interview", interview);
//            request.setAttribute("isInterviewCompleted", isInterviewCompleted);

            // Chuyển hướng đến trang JSP
            request.getRequestDispatcher("details-job-greeting.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // Xử lý khi greetingId không hợp lệ
            request.setAttribute("errorMessage", "Mã ứng tuyển không hợp lệ");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            // Log lỗi và chuyển hướng đến trang lỗi
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    /**
     * Processes the attachment file upload
     */
    private String processAttachment(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("attachment");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Generate unique filename
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

                    // Create upload directory
                    String uploadPath = request.getServletContext().getRealPath("") + UPLOAD_DIRECTORY;
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Save the file
                    filePart.write(uploadPath + java.io.File.separator + uniqueFileName);

                    // Return relative path for database
                    return UPLOAD_DIRECTORY + "/" + uniqueFileName;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
    }

    private void showSendApplication(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            Account account = (Account) session.getAttribute("sessionAccount");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            Account account01 = accountDAO.getAccountById(account.getAccountId());

            int jobId = Integer.parseInt(request.getParameter("jobId"));
            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobId);
            System.out.println(job);

            //Xử lý ngân sách dự án
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedBudgetMin = currencyFormat.format(job.getBudgetMin());
            String formattedBudgetMax = currencyFormat.format(job.getBudgetMax());
            request.setAttribute("formattedBudgetMin", formattedBudgetMin);
            request.setAttribute("formattedBudgetMax", formattedBudgetMax);

            CvDAO cvDAO = new CvDAO();
            List<CV> cvList = cvDAO.getCVsByAccountId(account01.getAccountId());

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

            request.setAttribute("job", job);
            request.setAttribute("cvList", cvList);
            request.setAttribute("account", account01);
            request.getRequestDispatcher("greeting.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void viewListApplied(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("sessionAccount");
        int accountId = account.getAccountId();//
        JobGreetingDAO jobGreetingDAO = new JobGreetingDAO();
        List<JobGreeting> jobGreetings = jobGreetingDAO.getListJobGreetingBySeekerId(accountId);
        request.setAttribute("job", jobGreetings);  // "jobGreetings" là key để jsp lấy ra
        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
    }

    private void listJobByStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String status = request.getParameter("status"); // Lấy tham số từ request


        Account account = (Account) session.getAttribute("sessionAccount");
        int accountId = account.getAccountId();// // Tạm fix cứng, sau này lấy từ session
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


        HttpSession session = request.getSession();
        String status = request.getParameter("status"); // Lấy tham số từ request


        Account account = (Account) session.getAttribute("sessionAccount");
        int accountId = account.getAccountId();// // Tạm fix cứng, sau này lấy từ session
        JobDAO jobDAO = new JobDAO();

        List<JobGreeting> jobGreetings;
        jobGreetings = jobDAO.search(accountId,sort);

        request.setAttribute("job", jobGreetings);
        request.getRequestDispatcher("applied-job-list.jsp").forward(request, response);
    }
     private void detail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String jobGreetingIdParam = request.getParameter("jobGreetingId");
         String jobIdParam = request.getParameter("jobId");
         if (jobGreetingIdParam == null || jobIdParam == null) {
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing jobGreetingId or jobId parameter");
             return;
         }String jobGreetingId = jobGreetingIdParam.trim();
         String jobId = jobIdParam.trim();
         System.out.println("kjdsbchdj"+jobIdParam);
         System.out.println("kjdsbchdj"+jobGreetingIdParam);
        int jgId = Integer.parseInt(jobGreetingId);
        int j = Integer.parseInt(jobId);
        JobDAO jd = new JobDAO();
        JobGreeting jobGreeting = jd.getJobGreetingById(jgId);

        Job job =jd.getJobById(j);
        request.setAttribute("jobGreeting", jobGreeting );
        request.setAttribute("job", job);

        request.getRequestDispatcher("infor-applied-job-detail.jsp").forward(request, response);
    }
}