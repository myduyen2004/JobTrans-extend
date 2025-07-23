<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn ứng tuyển</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="session" />
    <style>
        :root {
            --primary-gradient: linear-gradient(to right, rgb(21, 32, 112), rgb(39, 64, 179));
            --dark-blue: rgb(21, 32, 112);
            --light-blue: rgb(39, 64, 179);
            --text-light: #f8f9fa;
            --text-dark: #343a40;
            --border-radius: 12px;
            --box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #f8f9fa;
            color: var(--text-dark);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: var(--primary-gradient);
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
            border-radius: 0 0 var(--border-radius) var(--border-radius);
            box-shadow: var(--box-shadow);
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .page-title {
            font-size: 28px;
            margin-bottom: 20px;
            color: var(--text-light);
            animation: fadeInDown 1s;
        }

        .card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 30px;
            overflow: hidden;
            animation: fadeIn 0.8s;
        }

        .card-header-a {
            background: var(--primary-gradient);
            color: white;
            padding: 20px;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-body-a {
            padding: 20px 40px;
        }

        .applicant-info {
            display: flex;
            margin-bottom: 30px;
            animation: fadeInUp 1s;
        }

        .avatar-container-a {
            width: 120px;
            height: 120px;
            margin-right: 20px;
            position: relative;
            flex-shrink: 0;
        }

        .avatar {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .verification-badge {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background-color: #28a745;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .applicant-details {
            flex-grow: 1;
        }

        .applicant-name {
            font-size: 24px;
            margin-bottom: 5px;
            color: var(--dark-blue);
        }

        .applicant-rating {
            color: #ffc107;
            margin-bottom: 10px;
        }

        .info-row {
            display: flex;
            margin-bottom: 10px;
        }

        .info-label {
            width: 180px;
            font-weight: 500;
            color: #6c757d;
        }

        .info-value {
            flex-grow: 1;
        }

        .tags {
            margin-top: 15px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .tag {
            background: linear-gradient(135deg, rgba(39, 64, 179, 0.1), rgba(21, 32, 112, 0.2));
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            color: var(--dark-blue);
            display: inline-block;
            transition: var(--transition);
        }

        .tag:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        }

        .job-details {
            margin-bottom: 30px;
            animation: fadeInUp 1.2s;
        }

        .job-title, .intro-title, .cv-title {
            font-size: 22px;
            margin-bottom: 15px;
            color: var(--dark-blue);
        }

        .job-params {
            display: flex;
            flex-wrap: wrap;
            gap: 60px;
            margin-bottom: 20px;
        }

        .job-param {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .icon-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .introduction {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--light-blue);
            animation: fadeInUp 1.4s;
        }

        .cv-preview {
            margin-bottom: 30px;
            animation: fadeInUp 1.6s;
        }

        .cv-container {
            height: 600px;
            background-color: #f8f9fa;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            border: 1px solid #dee2e6;
        }

        .cv-placeholder {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .cv-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: var(--transition);
        }

        .cv-container:hover .cv-overlay {
            opacity: 1;
        }

        .btn-a {
            padding: 12px 24px;
            border-radius: 30px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary {
            background: var(--primary-gradient);
            color: white;
        }

        .btn-outline {
            background: transparent;
            border: 2px solid var(--light-blue);
            color: var(--light-blue);
        }

        .btn-a:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .btn-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .attachment {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
            animation: fadeInUp 1.8s;
        }

        .attachment-icon {
            width: 45px;
            height: 45px;
            background: var(--primary-gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .attachment-details {
            flex-grow: 1;
        }

        .attachment-name {
            font-weight: 500;
            margin-bottom: 5px;
        }

        .attachment-size {
            font-size: 14px;
            color: #6c757d;
        }

        .actions {
            padding: 20px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            animation: fadeInUp 2s;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }

        .status-interview {
            background-color: #17a2b8;
            color: white;
        }

        .status-rejected {
            background-color: #dc3545;
            color: white;
        }

        .status-approved {
            background-color: #28a745;
            color: white;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: white;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            animation: zoomIn 0.3s;
        }

        .modal-header {
            background: var(--primary-gradient);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
        }

        .modal-close {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            padding: 15px 20px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            border-top: 1px solid #dee2e6;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: var(--border-radius);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--light-blue);
            box-shadow: 0 0 0 3px rgba(39, 64, 179, 0.2);
        }

        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }

        /* Animation keyframes */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes zoomIn {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        /* Responsive styles */
        @media (max-width: 768px) {
            .applicant-info {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .avatar-container-a {
                margin-right: 0;
                margin-bottom: 20px;
            }

            .info-row {
                flex-direction: column;
                margin-bottom: 15px;
            }

            .info-label {
                width: 100%;
                margin-bottom: 5px;
            }

            .job-params {
                flex-direction: column;
                gap: 10px;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn-a {
                width: 100%;
                justify-content: center;
            }

            .actions {
                flex-direction: column;
            }
        }

        .info-value {
            color: #333;
        }
    </style>
</head>
<body>
<%@include file="includes/header-01.jsp"%>
<div class="container">
    <div class="card">
        <div class="card-header-a">
            <span>Thông tin ứng viên</span>
            <div class="status-badge status-interview">${jobGreeting.status}</div>
        </div>
        <div class="card-body-a">
            <div class="applicant-info">
                <div class="avatar-container-a">
                    <img src="${account.avatar}" alt="Ảnh đại diện" class="avatar">
                    <div class="verification-badge">
                        <i class="fas fa-check"></i>
                    </div>
                </div>
                <div class="applicant-details">
                    <h2 class="applicant-name">${account.accountName}</h2>
                    <div class="applicant-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span>4.5</span>
                    </div>
                    <div class="" style="display: grid; grid-template-columns: auto auto;">
                        <div class="info-row">
                            <div class="info-label">Điểm:</div>
                            <div class="info-value">${account.point}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Số điện thoại:</div>
                            <div class="info-value">${account.phone}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Chuyên môn:</div>
                            <div class="info-value">${account.speciality}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Số năm kinh nghiệm:</div>
                            <div class="info-value">${account.experienceYears}</div>
                        </div>
                    </div>
                    <%--                    <div class="tags">--%>
                    <%--                        <span class="tag">JavaScript</span>--%>
                    <%--                        <span class="tag">ReactJS</span>--%>
                    <%--                        <span class="tag">NodeJS</span>--%>
                    <%--                        <span class="tag">SQL Server</span>--%>
                    <%--                        <span class="tag">UI/UX</span>--%>
                    <%--                    </div>--%>
                </div>
            </div>

            <div class="job-details">
                <h3 class="job-title" style="margin-bottom: 20px">Chi tiết báo giá</h3>
                <div class="job-params">
                    <div class="job-param">
                        <div class="icon-circle">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div>
                            <div class="param-label">Báo giá</div>
                            <div class="param-value">${formattedPrice}VNĐ</div>
                        </div>
                    </div>
                    <div class="job-param">
                        <div class="icon-circle">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div>
                            <div class="param-label">Thời gian hoàn thành dự kiến</div>
                            <div class="param-value">${jobGreeting.expectedDay} ngày</div>
                        </div>
                    </div>
                    <%--                    <div class="job-param">--%>
                    <%--                        <div class="icon-circle">--%>
                    <%--                            <i class="fas fa-clock"></i>--%>
                    <%--                        </div>--%>
                    <%--                        <div>--%>
                    <%--                            <div class="param-label">Ngày ứng tuyển</div>--%>
                    <%--                            <div class="param-value">${jobGreeting.introduction}</div>--%>
                    <%--                        </div>--%>
                    <%--                    </div>--%>
                </div>
            </div>

            <div class="introduction">
                <h3 class="intro-title" style="margin-bottom: 10px">Thư giới thiệu</h3>
                <p>${jobGreeting.introduction}</p>
            </div>

            <div class="cv-preview">
                <h3 class="cv-title" style="margin-bottom: 20px">CV</h3>
                <div class="cv-container">
<%--                    <img src="" alt="CV Preview" class="cv-placeholder">--%>
                    <div class="cv-overlay">
                        <div class="btn-group">
                            <a href="cv?action=view&cvId=${jobGreeting.cvId}" class="btn-a btn-primary"
                            <%--                               id="viewCvBtn"--%>
                               style="text-decoration: none">
                                <i class="fas fa-eye"></i> Xem CV
                            </a>
                            <a class="btn-a btn-outline"
                            <%--                               id="downloadCvBtn" --%>
                               style="background-color: #FFFFFF; text-decoration: none">
                                <i class="fas fa-download"></i> Tải xuống
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="attachment">

                <c:if test="${jobGreeting.attachment == null}">
                    <div style="text-align: center;margin: auto;font-style: italic;">
                        <p>Không có tệp đính kèm</p>
                    </div>
                </c:if>
                <c:if test="${jobGreeting.attachment != null}">
                    <div class="attachment-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="attachment-details">
                        <div class="attachment-name">${jobGreeting.attachment}</div>
                            <%--                    <div class="attachment-size">5.2 MB</div>--%>
                    </div>
                    <a href="uploads/attachments/${jobGreeting.attachment}" download class="btn-a btn-outline">
                        <i class="fas fa-download"></i>
                    </a>
                </c:if>
            </div>
            <c:if test="${sessionScope.sessionAccount.accountId != jobGreeting.jobSeekerId}">
                <c:if test="${jobGreeting.status == 'Chờ phỏng vấn'}">
                    <!-- Thông báo cập nhật lịch phỏng vấn chỉ hiển thị khi chưa có lịch phỏng vấn -->
                    <c:if test="${interview == null}">
                        <div>
                            <p style="color: red; font-style: italic; font-size: 16px; margin-bottom: 10px;text-align: right; margin-right: 40px;">
                                Vui lòng cập nhật lịch phỏng vấn tới ứng viên
                            </p>
                        </div>
                    </c:if>
                    <c:if test="${interview != null}">
                        <div>
                            <p style="color: green; font-style: italic; font-size: 16px; margin-bottom: 10px;text-align: right; margin-right: 40px;">
                                Đã cập nhật lịch phỏng vấn tới ứng viên
                            </p>
                        </div>
                    </c:if>
                </c:if>
                <div class="actions">
                    <c:if test="${jobGreeting.status == 'Chờ xét duyệt'}">
                        <button class="btn-a btn-outline" id="rejectBtn">
                            <i class="fas fa-times"></i> Từ chối
                        </button>
                        <a href="job-greeting?action=accept-to-interview&greetingId=${jobGreeting.greetingId}" class="btn-a btn-primary" style="text-decoration: none">
                            <i class="fas fa-check"></i> Duyệt CV
                        </a>
                    </c:if>
                    <c:if test="${jobGreeting.status == 'Chờ phỏng vấn'}">
                        <button class="btn-a btn-outline" id="rejectBtn">
                            <i class="fas fa-times"></i> Từ chối
                        </button>
                        <c:if test="${interview == null}">
                            <button class="btn-a btn-outline" id="interviewBtn">
                                <i class="fas fa-calendar-check"></i> Cập nhật phỏng vấn
                            </button>
                        </c:if>

                        <!-- Nút chấp nhận ứng viên chỉ hiển thị sau khi phỏng vấn kết thúc -->
                        <c:if test="${interview != null}">
                            <a href="contract?action=view-infor-project-contract&greetingId=${jobGreeting.greetingId}" class="btn-a btn-primary" style="text-decoration: none">
                                <i class="fas fa-check"></i> Chấp nhận ứng viên
                            </a>
                        </c:if>
                    </c:if>
                    <c:if test="${jobGreeting.status == 'Được nhận'}">
                        <a href="contract?action=view-details-contract&jobId=${jobGreeting.jobId}&applicantId=${jobGreeting.jobSeekerId}" class="btn-a btn-primary" style="text-decoration: none">
                            <i class="fas fa-check"></i> Xem hợp đồng đã ký kết
                        </a>
                    </c:if>
                </div>
            </c:if>
            <c:if test="${sessionScope.sessionAccount.accountId == jobGreeting.jobSeekerId}">
                <div class="actions">
                    <c:if test="${interview != null}">
                            <button class="btn-a btn-outline" id="viewInterviewBtn">
                                <i class="fas fa-calendar-check"></i> Xem thông tin buổi phỏng vấn
                            </button>
                    </c:if>
                    <c:if test="${jobDAO.getJobById(jobGreeting.jobId).statusJobId == 2}">
                        <a href="contract?action=view-infor-project-contract&greetingId=${jobGreeting.greetingId}" class="btn-a btn-primary" style="text-decoration: none">
                            <i class="fas fa-check"></i> Ký kết hợp đồng
                        </a>
                    </c:if>
                    <c:if test="${jobGreeting.status == 'Được nhận'}">
                            <a href="contract?action=view-details-contract&jobId=${jobGreeting.jobId}&applicantId=${jobGreeting.jobSeekerId}" class="btn-a btn-primary" style="text-decoration: none">
                                <i class="fas fa-check"></i> Xem hợp đồng đã ký kết
                            </a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Modal hiển thị thông tin phỏng vấn -->
<%--<div class="modal" id="interviewModal">--%>
<%--    <div class="modal-content">--%>
<%--        <div class="modal-header">--%>
<%--            <h4 class="modal-title">Thông tin buổi phỏng vấn</h4>--%>
<%--            <button class="modal-close" id="closeInterviewModalA">&times;</button>--%>
<%--&lt;%&ndash;            <button type="button" class="btn-a btn-outline" id="cancelInterviewModalA">Đóng</button>&ndash;%&gt;--%>
<%--        </div>--%>
<%--        <div class="modal-body">--%>
<%--            <div class="info-group" style="display: flex; align-items: center">--%>
<%--                <label class="info-label">Ngày phỏng vấn:</label>--%>
<%--                <div class="info-value">${interview.interviewDate}</div>--%>
<%--            </div>--%>
<%--            <div class="info-group" style="display: flex; align-items: center">--%>
<%--                <label class="info-label">Thời gian:</label>--%>
<%--                <div class="info-value">${interview.interviewTime}</div>--%>
<%--            </div>--%>
<%--            <div class="info-group" style="display: flex; align-items: center">--%>
<%--                <label class="info-label">Hình thức:</label>--%>
<%--                <div class="info-value">${interview.interviewForm}</div>--%>
<%--            </div>--%>

<%--            <c:if test="${interview.interviewForm == 'Offline'}">--%>
<%--                <div class="info-group" style="display: flex; align-items: center">--%>
<%--                    <label class="info-label">Địa chỉ phỏng vấn:</label>--%>
<%--                    <div class="info-value">${interview.interviewAddress}</div>--%>
<%--                </div>--%>
<%--            </c:if>--%>

<%--            <c:if test="${interview.interviewForm == 'Online'}">--%>
<%--                <div class="info-group" style="display: flex; align-items: center">--%>
<%--                    <label class="info-label">Link phỏng vấn:</label>--%>
<%--                    <div class="info-value">--%>
<%--                        <a href="${interview.interviewLink}" target="_blank">${interview.interviewLink}</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </c:if>--%>

<%--            <div class="info-group" style="display: flex; align-items: center">--%>
<%--                <label class="info-label" >Ghi chú:</label>--%>
<%--                <div class="info-value">${interview.interviewNote}</div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<script>
    /// JavaScript để hiển thị modal khi nhấn vào nút "Xem thông tin buổi phỏng vấn"
    document.addEventListener('DOMContentLoaded', function() {
        // Lấy phần tử nút và modal
        const viewInterviewBtn = document.getElementById('viewInterviewBtn');
        const viewInterviewModal = document.getElementById('viewInterviewModal');
        const closeViewInterviewModal = document.getElementById('closeViewInterviewModal');
        const cancelViewInterviewModal = document.getElementById('cancelViewInterviewModal');

        // Hiển thị modal khi nhấn nút
        if (viewInterviewBtn) {
            viewInterviewBtn.addEventListener('click', function() {
                viewInterviewModal.style.display = 'flex'; // Hiển thị modal
            });
        }

        // Đóng modal khi nhấn nút đóng
        if (closeViewInterviewModal) {
            closeViewInterviewModal.addEventListener('click', function() {
                viewInterviewModal.style.display = 'none';
            });
        }

        // Đóng modal khi nhấn nút hủy
        if (cancelViewInterviewModal) {
            cancelViewInterviewModal.addEventListener('click', function() {
                viewInterviewModal.style.display = 'none';
            });
        }

        // Đóng modal khi nhấn bên ngoài modal
        window.addEventListener('click', function(event) {
            if (event.target === viewInterviewModal) {
                viewInterviewModal.style.display = 'none';
            }
        });
    });
</script>

<!-- Modal phỏng vấn -->
<c:if test="${sessionScope.sessionAccount.accountId != jobGreeting.jobSeekerId}">
<div class="modal" id="interviewModal">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">Đặt lịch phỏng vấn</h4>
            <button class="modal-close" id="closeInterviewModal">&times;</button>
        </div>
        <form action="interview?action=create" method="post">
            <div class="modal-body">
                <input type="hidden" name="greetingId" value="${jobGreeting.greetingId}">
                <c:if test="${interview != null}">
                    <input type="hidden" name="interviewId" value="${interview.interviewId}">
                </c:if>

                <div class="form-group">
                    <label class="form-label">Ngày phỏng vấn</label>
                    <input type="date" name="interviewDate" class="form-control" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                           value="${interview != null ? interview.interviewDate : ''}" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Thời gian</label>
                    <input type="time" name="interviewTime" class="form-control"
                           value="${interview != null ? interview.interviewTime : ''}" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Hình thức</label>
                    <select name="interviewForm" class="form-control" id="interviewForm" required>
                        <option value="Offline" ${interview != null && interview.interviewForm == 'Offline' ? 'selected' : ''}>Offline</option>
                        <option value="Online" ${interview != null && interview.interviewForm == 'Online' ? 'selected' : ''}>Online</option>
                    </select>
                </div>

                <!-- Địa chỉ phỏng vấn - hiển thị nếu hình thức là Offline -->
                <div class="form-group" id="addressGroup">
                    <label class="form-label">Địa chỉ phỏng vấn</label>
                    <input type="text" name="interviewAddress" id="interviewAddress" class="form-control"
                           value="${interview != null ? interview.interviewAddress : ''}"
                           pattern="^(?=.*[a-zA-Z])([a-zA-Z0-9\s,./-]*)$"
                           title="Địa chỉ không thể chỉ chứa số và không được chứa ký tự đặc biệt (ngoại trừ dấu phẩy, dấu chấm, dấu gạch ngang và dấu gạch chéo)">
                    <div class="invalid-feedback" id="addressFeedback">
                        Địa chỉ không hợp lệ! Địa chỉ phải chứa ít nhất một chữ cái và không chứa ký tự đặc biệt.
                    </div>
                </div>

                <!-- Link phỏng vấn - hiển thị nếu hình thức là Online -->
                <div class="form-group" id="linkGroup" style="display:none;">
                    <label class="form-label">Link phỏng vấn</label>
                    <input type="text" name="interviewLink" class="form-control"
                           value="${interview != null ? interview.interviewLink : ''}">
                </div>

                <div class="form-group">
                    <label class="form-label">Ghi chú</label>
                    <textarea name="interviewNote" class="form-control" placeholder="Nhập thông tin chi tiết về buổi phỏng vấn...">${interview != null ? interview.interviewNote : ''}</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-a btn-outline" id="cancelInterviewModal">Hủy</button>
                <button type="submit" class="btn-a btn-primary">Xác nhận</button>
            </div>
        </form>
    </div>
</div>
</c:if>
<c:if test="${sessionScope.sessionAccount.accountId == jobGreeting.jobSeekerId}">
    <div class="modal" id="viewInterviewModal">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Lịch phỏng vấn</h4>
                <button class="modal-close" id="closeViewInterviewModal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Ngày phỏng vấn</label>
                    <p class="form-control-plaintext" style="text-align: center">${interview != null ? interview.interviewDate : ''}</p>
                </div>
                <div class="form-group">
                    <label class="form-label">Thời gian</label>
                    <p class="form-control-plaintext" style="text-align: center">${interview != null ? interview.interviewTime : ''}</p>
                </div>
                <div class="form-group">
                    <label class="form-label">Hình thức</label>
                    <p class="form-control-plaintext" style="text-align: center">${interview != null ? interview.interviewForm : ''}</p>
                </div>

                <div class="form-group" >
                    <label class="form-label">Địa chỉ phỏng vấn</label>
                    <p class="form-control-plaintext" style="text-align: center">${interview != null ? interview.interviewAddress : ''}</p>
                </div>

                <div class="form-group"  style="display:none;">
                    <label class="form-label">Link phỏng vấn</label>
                    <p class="form-control-plaintext" style="text-align: center">${interview != null ? interview.interviewLink : ''}</p>
                </div>

                <div class="form-group">
                    <label class="form-label">Ghi chú</label>
                    <p class="form-control-plaintext" style="white-space: pre-line; text-align: center">${interview != null ? interview.interviewNote : ''}</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-a btn-outline" id="cancelViewInterviewModal">Đóng</button>
            </div>
        </div>
    </div>
</c:if>

<!-- Script validate form phỏng vấn-->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const interviewForm = document.getElementById('interviewForm');
        const addressGroup = document.getElementById('addressGroup');
        const linkGroup = document.getElementById('linkGroup');
        const interviewAddress = document.getElementById('interviewAddress');
        const addressFeedback = document.getElementById('addressFeedback');

        // Thiết lập ban đầu - nếu là form mới (Offline mặc định)
        const isOnline = '${interview != null ? interview.interviewForm : ""}' === 'Online';

        // Ẩn/hiện các trường phù hợp dựa trên hình thức phỏng vấn
        if (isOnline) {
            addressGroup.style.display = 'none';
            linkGroup.style.display = 'block';
            interviewAddress.removeAttribute('required');
            document.querySelector('input[name="interviewLink"]').setAttribute('required', 'required');
        } else {
            addressGroup.style.display = 'block';
            linkGroup.style.display = 'none';
            interviewAddress.setAttribute('required', 'required');
            document.querySelector('input[name="interviewLink"]').removeAttribute('required');
        }

        // Xử lý khi thay đổi hình thức phỏng vấn
        interviewForm.addEventListener('change', function() {
            if (this.value === 'Online') {
                addressGroup.style.display = 'none';
                linkGroup.style.display = 'block';
                interviewAddress.removeAttribute('required');
                document.querySelector('input[name="interviewLink"]').setAttribute('required', 'required');
            } else {
                addressGroup.style.display = 'block';
                linkGroup.style.display = 'none';
                interviewAddress.setAttribute('required', 'required');
                document.querySelector('input[name="interviewLink"]').removeAttribute('required');
            }
        });

        // Validate địa chỉ phỏng vấn
        interviewAddress.addEventListener('input', function() {
            validateAddress(this);
        });

        // Validation khi submit form
        document.querySelector('form').addEventListener('submit', function(event) {
            if (interviewForm.value === 'Offline' && !validateAddress(interviewAddress)) {
                event.preventDefault();
            }
        });

        function validateAddress(input) {
            // Kiểm tra địa chỉ không chỉ chứa số và không chứa ký tự đặc biệt (ngoại trừ dấu phẩy, dấu chấm, dấu gạch ngang và dấu gạch chéo)
            const addressRegex = /^(?=.*[a-zA-Z])([a-zA-Z0-9\s,./-]*)$/;
            const isValid = addressRegex.test(input.value);

            if (!isValid) {
                input.classList.add('is-invalid');
                addressFeedback.style.display = 'block';
                return false;
            } else {
                input.classList.remove('is-invalid');
                addressFeedback.style.display = 'none';
                return true;
            }
        }
    });
</script>
<!-- JavaScript để xử lý form -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Hiển thị modal phỏng vấn
        const interviewBtn = document.getElementById('interviewBtn');
        const interviewModal = document.getElementById('interviewModal');
        const closeInterviewModal = document.getElementById('closeInterviewModal');
        const cancelInterviewModal = document.getElementById('cancelInterviewModal');

        interviewBtn.addEventListener('click', function() {
            interviewModal.style.display = 'block';
        });

        closeInterviewModal.addEventListener('click', function() {
            interviewModal.style.display = 'none';
        });

        cancelInterviewModal.addEventListener('click', function() {
            interviewModal.style.display = 'none';
        });

        // Xử lý thay đổi hình thức phỏng vấn
        const interviewForm = document.getElementById('interviewForm');
        const addressGroup = document.getElementById('addressGroup');
        const linkGroup = document.getElementById('linkGroup');

        interviewForm.addEventListener('change', function() {
            if (this.value === 'Offline') {
                addressGroup.style.display = 'block';
                linkGroup.style.display = 'none';
            } else {
                addressGroup.style.display = 'none';
                linkGroup.style.display = 'block';
            }
        });

        // Đóng modal khi click bên ngoài
        window.addEventListener('click', function(event) {
            if (event.target === interviewModal) {
                interviewModal.style.display = 'none';
            }
        });
    });
</script>

<!-- Modal từ chối -->
<div class="modal" id="rejectModal">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">Từ chối ứng viên</h4>
            <button class="modal-close" id="closeRejectModal">&times;</button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label class="form-label">Lý do từ chối</label>
                <select class="form-control">
                    <option>Không đáp ứng yêu cầu kỹ năng</option>
                    <option>Thiếu kinh nghiệm</option>
                    <option>Mức lương đề xuất không phù hợp</option>
                    <option>Thời gian dự kiến không phù hợp</option>
                    <option>Khác</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Ghi chú</label>
                <textarea class="form-control" placeholder="Nhập thông tin phản hồi cho ứng viên..."></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-a btn-outline" id="cancelRejectModal">Hủy</button>
            <a href="job-greeting?action=refuse-candidate&greetingId=${jobGreeting.greetingId}" class="btn-a btn-primary" style="text-decoration: none">Xác nhận</a>
        </div>
    </div>
</div>

<!-- Modal xác nhận chấp nhận -->
<div class="modal" id="approveModal">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">Xác nhận chấp nhận ứng viên</h4>
            <button class="modal-close" id="closeApproveModal">&times;</button>
        </div>
        <div class="modal-body">
            <p>Bạn có chắc chắn muốn chấp nhận ứng viên <strong>Nguyễn Văn A</strong> với mức giá <strong>5.000.000 VNĐ</strong> và thời gian dự kiến <strong>15 ngày</strong>?</p>
            <div class="form-group">
                <label class="form-label">Ghi chú</label>
                <textarea class="form-control" placeholder="Nhập thông tin bổ sung (nếu có)..."></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-a btn-outline" id="cancelApproveModal">Hủy</button>
            <button class="btn-a btn-primary">Xác nhận</button>
        </div>
    </div>
</div>

<!-- Modal xem CV -->
<div class="modal" id="viewCvModal">
    <div class="modal-content" style="width: 95%; max-width: 800px; height: 90vh;">
        <div class="modal-header">
            <h4 class="modal-title">CV của Nguyễn Văn A</h4>
            <button class="modal-close" id="closeViewCvModal">&times;</button>
        </div>
        <div class="modal-body" style="padding: 0; height: calc(90vh - 130px);">
            <iframe src="/api/placeholder/800/1000" style="width: 100%; height: 100%; border: none;"></iframe>
        </div>
        <div class="modal-footer">
            <button class="btn-a btn-outline" id="cancelViewCvModal">Đóng</button>
            <button class="btn-a btn-primary">
                <i class="fas fa-download"></i> Tải xuống
            </button>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Animation for tags
        $('.tag').hover(function() {
            $(this).addClass('animate__animated animate__pulse');
        }, function() {
            $(this).removeClass('animate__animated animate__pulse');
        });

        // Modal handling
        $('#interviewBtn').click(function() {
            $('#interviewModal').css('display', 'flex');
        });

        $('#closeInterviewModal, #cancelInterviewModal').click(function() {
            $('#interviewModal').css('display', 'none');
        });

        $('#rejectBtn').click(function() {
            $('#rejectModal').css('display', 'flex');
        });

        $('#closeRejectModal, #cancelRejectModal').click(function() {
            $('#rejectModal').css('display', 'none');
        });

        $('#approveBtn').click(function() {
            $('#approveModal').css('display', 'flex');
        });

        $('#closeApproveModal, #cancelApproveModal').click(function() {
            $('#approveModal').css('display', 'none');
        });

        $('#viewCvBtn').click(function() {
            $('#viewCvModal').css('display', 'flex');
        });

        $('#closeViewCvModal, #cancelViewCvModal').click(function() {
            $('#viewCvModal').css('display', 'none');
        });

        // Close modals when clicking outside
        $('.modal').click(function(e) {
            if ($(e.target).hasClass('modal')) {
                $(this).css('display', 'none');
            }
        });

        // Animation for buttons
        $('.btn').hover(function() {
            $(this).addClass('animate__animated animate__pulse');
        }, function() {
            $(this).removeClass('animate__animated animate__pulse');
        });
    });
</script>
<%@include file="includes/footer.jsp"%>
</body>
</html>