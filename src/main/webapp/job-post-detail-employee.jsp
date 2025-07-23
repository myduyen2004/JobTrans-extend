<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>=

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JobTrans &#8211; Nền tảng hỗ trợ thuê, làm việc cho freelancer</title>
    <meta name='robots' content='max-image-preview:large'/>
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!--new css -->
    <link rel="stylesheet" href="css/job-post-detail-employee.css">
    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="page"/>
    <jsp:useBean id="accountDAO" class="jobtrans.dal.AccountDAO" scope="page"/>
    <jsp:useBean id="now" class="java.util.Date" />

    <c:set var="accountName" value="${accountDAO.getAccountById(greeting.jobSeekerId).accountName}" />
    <style>
        .btn1 {
            width: 100%;
        }
    </style>
</head>
<body>
<%@include file="includes/header-01.jsp" %>
<div class="container">
    <div class="job-header">
        <h1>${job.jobTitle}</h1>
        <div class="job-meta">
            <div class="job-meta-item">
                <i class="fa-solid fa-tags"></i>
                <c:forEach items="${tagList}" var="o">
                    <span class="tag">${o.tagName} </span>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="job-details-container">
        <div class="job-main">
            <div class="job-stats">
                <div class="stat-item">
                    <div class="stat-value">${budgetRange}</div>
                    <div class="stat-label">VNĐ</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${job.numOfMember}</div>
                    <div class="stat-label">Số lượng cần tuyển</div>
                </div>
            </div>

            <div class="job-stats">
                <div class="stat-item">
                    <div class="stat-value"><fmt:formatDate value="${job.postDate}" pattern="dd-MM-yyyy"/></div>
                    <div class="stat-label">Ngày đăng</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><fmt:formatDate value="${job.dueDatePost}" pattern="dd-MM-yyyy"/></div>
                    <div class="stat-label">Hạn ứng tuyển</div>
                </div>
            </div>

            <div class="card">
                <h2>Mô tả công việc</h2>
                <p>${job.jobDescription}</p>
            </div>

            <div class="card">
                <h2>Yêu cầu</h2>
                <p>${job.requirements}</p>
            </div>

            <div class="card">
                <h2>Quyền lợi</h2>
                <p>${job.benefit}</p>
            </div>

            <div class="card">
                <h2>Kỹ năng yêu cầu</h2>
                <div class="tags-container">
                    <c:forEach items="${tagList}" var="o">
                        <span class="tag">${o.tagName} </span>
                    </c:forEach>
                </div>
            </div>

            <div class="card">
                <h2>Tài liệu đính kèm</h2>
                <div class="file-downloads">
                    <c:if test="${job.attachment != null and not empty job.attachment}">
                        <div class="file-item">
                            <div class="file-info">
                                <div class="file-name">${job.attachment}</div>
                                <div class="file-meta">PDF</div>
                            </div>
                            <a href="job?action=download&file=${job.attachment}&jobId=${job.jobId}"
                               class="file-download-btn">
                                <i class="bi bi-download"></i>
                            </a>
                        </div>
                    </c:if>
                    <c:if test="${job.attachment == null or empty job.attachment}">
                        <div class="null-attachment">
                            <p>Không có file đính kém</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="card">
                <h2>Kiểm tra</h2>
                <div class="file-downloads">
                    <c:choose>
                        <c:when test="${job.haveTested}">
                            <div class="file-item">
                                <div class="file-info">
                                    <div class="file-name">${test.testLink}</div>
                                </div>
                                <c:choose>
                                    <c:when test="${test.haveRequired}">
                                        <a href="job?action=downloadTest&fileName=${job.attachment}"
                                           class="file-download-btn">
                                            <i class="fas fa-flag"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="job?action=downloadTest&fileName=${job.attachment}"
                                           class="file-download-btn">
                                            <i class="far fa-flag"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="null-attachment">
                                <p>Không có bài kiểm tra</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="job-sidebar">
            <div class="card">
                <h2>Thông tin nhà tuyển dụng</h2>
                <div style="display: flex; align-items: center; margin-bottom: 15px;">
                    <div style="width: 60px; height: 60px; border-radius: 50%; background-color: #e9ecef; display: flex; align-items: center; justify-content: center; margin-right: 15px; object-fit: cover;">
                        <img src="${postAcc.avatar}" alt="User avatar"
                             style="width: 60px; height: 60px; border-radius: 50%;">
                    </div>
                    <div>
                        <h3 style="margin: 0; font-size: 16px;">${postAcc.accountName}</h3>
                    </div>
                </div>
                <div style="display: flex; margin-bottom: 10px;">
                    <div style="flex: 1; text-align: center;">
                        <div style="font-weight: 700; color: var(--accent-color);">${jobDAO.countTotalJobsByAccountId(postAcc.accountId)}</div>
                        <div style="font-size: 12px; color: #6c757d;">Dự án</div>
                    </div>
                    <div style="flex: 1; text-align: center;">
                        <div style="font-weight: 700; color: var(--accent-color);">${postAcc.starRate} <i
                                class="fa-solid fa-star" style="color: #FCD53F"></i></div>
                        <div style="font-size: 12px; color: #6c757d;">Đánh giá</div>
                    </div>
                    <div style="flex: 1; text-align: center;">
                        <div style="font-weight: 700; color: var(--accent-color);">${jobDAO.getJobCompletionRateByAccountId(postAcc.accountId)}</div>
                        <div style="font-size: 12px; color: #6c757d;">Hoàn thành</div>
                    </div>
                </div>
            </div>

            <c:if test="${job.postAccountId != sessionScope.sessionAccount.accountId}">
                <div class="card">
                    <div>
                            <%--                        <c:if test="${not empty job.dueDatePost and job.dueDatePost.time gt now.time}">--%>
                        <c:if test="${jobDAO.getJobGreetingByJobSeekerIdAndJobId(sessionScope.sessionAccount.accountId,job.jobId) == null}">
                            <a href="job-greeting?action=show-send-application&jobId=${job.jobId}" class="btn1 btn-gradient"
                               style="color: white;">
                                <i class="bi bi-send me-2"></i>Gửi chào giá
                            </a>
                        </c:if>

                        <c:if test="${jobDAO.getJobGreetingByJobSeekerIdAndJobId(sessionScope.sessionAccount.accountId,job.jobId) != null}">
                            <a href="job-greeting?action=view-details-greeting&greetingId=${jobDAO.getJobGreetingByJobSeekerIdAndJobId(sessionScope.sessionAccount.accountId,job.jobId).greetingId}" class="btn1 btn-gradient"
                               style="color: white;">
                                <i class="bi bi-send me-2"></i>Xem chào giá của tôi
                            </a>
                        </c:if>
                            <%--                        </c:if>--%>

                        <a class="btn1 btn-outline-secondary">
                            <i class="bi bi-bookmark me-2"></i>Lưu công việc
                        </a>
                        <a class="btn1 btn-outline-secondary">
                            <i class="bi bi-flag me-2"></i>Báo cáo vi phạm
                        </a>
                    </div>
                </div>
            </c:if>

            <%--                side bar postUser--%>
            <c:if test="${job.postAccountId == sessionScope.sessionAccount.accountId}">
                <div class="card">
                    <!-- Lấy ngày hiện tại -->
                    <div>
                        <c:if test="${not empty job.dueDatePost and job.dueDatePost.time gt now.time}">
                            <a href="job?action=pre-update&jobId=${job.jobId}" class="btn1 btn-gradient"
                               style="color: white;">
                                <i class="bi bi-send me-2"></i> Cập nhật công việc
                            </a>
                        </c:if>
                        <a href="javascript:void(0)" onclick="openDeleteModal('${job.jobId}')"
                           class="btn-delete" style="width: 100%">
                            <i class="fas fa-trash-alt"></i> Xóa công việc
                        </a>
                    </div>
                </div>
            </c:if>

            <div class="card stats-card">
                <h5 class="section-title">Thống kê công việc</h5>
                <div class="stat-row">
                    <div class="stat-icon">
                        <i class="bi bi-people"></i>
                    </div>
                    <div class="stat-text">Số lượt chào giá</div>
                    <div class="stat-value">${jobDAO.getNumOfJobGreetingByJobId(job.jobId)}</div>
                </div>

                <%--                <div class="stat-row">--%>
                <%--                    <div class="stat-icon">--%>
                <%--                        <i class="bi bi-bookmark"></i>--%>
                <%--                    </div>--%>
                <%--                    <div class="stat-text">Lượt lưu</div>--%>
                <%--                    <div class="stat-value">35</div>--%>
                <%--                </div>--%>
            </div>
            <%--                <div class="card">--%>
            <%--                    <h2>Chào giá cho công việc này</h2>--%>
            <%--                    <form id="jobApplicationForm">--%>
            <%--                        <div class="form-group">--%>
            <%--                            <label for="price">Mức giá (VNĐ)</label>--%>
            <%--                            <input type="number" id="price" class="form-control" placeholder="Nhập mức giá đề xuất" required>--%>
            <%--                        </div>--%>
            <%--                        <div class="form-group">--%>
            <%--                            <label for="expectedDays">Thời gian dự kiến hoàn thành (ngày)</label>--%>
            <%--                            <input type="number" id="expectedDays" class="form-control" placeholder="Số ngày dự kiến" required>--%>
            <%--                        </div>--%>
            <%--                        <div class="form-group">--%>
            <%--                            <label for="cv">Chọn CV</label>--%>
            <%--                            <select id="cv" class="form-control" required>--%>
            <%--                                <option value="">-- Chọn CV --</option>--%>
            <%--                                <option value="1">CV Web Developer</option>--%>
            <%--                                <option value="2">CV UI/UX Designer</option>--%>
            <%--                                <option value="3">CV Frontend Developer</option>--%>
            <%--                            </select>--%>
            <%--                        </div>--%>
            <%--                        <div class="form-group">--%>
            <%--                            <label for="introduction">Giới thiệu chung</label>--%>
            <%--                            <textarea id="introduction" class="form-control" placeholder="Giới thiệu về bản thân và kinh nghiệm của bạn liên quan đến công việc này" required></textarea>--%>
            <%--                        </div>--%>
            <%--                        <div class="form-group">--%>
            <%--                            <label for="attachment">Chọn tệp đính kèm để gửi</label>--%>
            <%--                            <input type="file" id="attachment" class="form-control">--%>
            <%--                        </div>--%>
            <%--                        <button type="submit" class="btn btn-block">Gửi chào giá</button>--%>
            <%--                    </form>--%>
            <%--                </div>--%>
        </div>
    </div>

    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <h2>Danh sách ứng viên (${jobDAO.getNumOfJobGreetingByJobId(job.jobId)})</h2>
            <c:if test="${job.postAccountId == sessionScope.sessionAccount.accountId}">
                <span>
                    <a href="job?action=view-candidates-list&jobId=${job.jobId}" class="btn1 btn-gradient" style="color: white;">
                        Danh sách ứng viên >>
                    </a>
                </span>
            </c:if>
        </div>
        <c:if test="${not empty jobDAO.getJobGreetingsByJobId(job.jobId)}">
            <ul class="applicant-list">
                <c:forEach var="greeting" items="${jobDAO.getJobGreetingsByJobId(job.jobId)}">
                    <li class="applicant-item">
                        <img src="${accountDAO.getAccountById(greeting.jobSeekerId).avatar}"
                             alt=""
                             class="applicant-avatar">
                        <div class="applicant-info">
                            <div class="applicant-name">${accountDAO.getAccountById(greeting.jobSeekerId).accountName}</div>
                            <div class="applicant-meta">
                                <span class="meta-icon"><i class="fas fa-money-bill-wave"></i> <fmt:formatNumber value="${greeting.price}" pattern="#,##0" /> VNĐ</span>
                                <span class="meta-icon"><i class="fas fa-calendar-alt"></i>${greeting.expectedDay} ngày</span>
                            </div>
                        </div>
                        <c:if test="${job.postAccountId == sessionScope.sessionAccount.accountId}">
                            <c:if test="${greeting.status == 'Chờ xét duyệt'}">
                                <div class="status-badge status-pending">${greeting.status}</div>
                            </c:if>
                            <c:if test="${greeting.status == 'Chờ phỏng vấn'}">
                                <div class="status-badge status-interview">${greeting.status}</div>
                            </c:if>
                            <c:if test="${greeting.status == 'Bị từ chối'}">
                                <div class="status-badge status-rejected">${greeting.status}</div>
                            </c:if>
                            <c:if test="${greeting.status == 'Được nhận'}">
                                <div class="status-badge status-accepted">${greeting.status}</div>
                            </c:if>
                        </c:if>
                    </li>
                </c:forEach>
            </ul>
        </c:if>

    </div>
</div>
<%@include file="includes/footer.jsp" %>

<%--Popup--%>
<div id="deleteConfirmModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0,0,0,0.5); justify-content: center; align-items: center; z-index: 9999;">
    <div style="background: white; padding: 20px; border-radius: 8px; width: 500px; text-align: center;">
        <h5 style="margin-bottom: 20px; margin-top: 20px;">Bạn có chắc chắn muốn xóa công việc không?</h5>
        <div class="d-flex justify-content-center">
            <button id="confirmDeleteBtn" class="btn-delete" style="color: white; width: 100%">Xóa</button>
            <button onclick="closeDeleteModal()" class="btn1 btn-outline-secondary">Không</button>
        </div>
    </div>
</div>

<script>
    let jobIdToDelete = null;

    function openDeleteModal(jobId) {
        jobIdToDelete = jobId;
        document.getElementById('deleteConfirmModal').style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteConfirmModal').style.display = 'none';
        jobIdToDelete = null;
    }

    document.getElementById('confirmDeleteBtn').addEventListener('click', function () {
        if (jobIdToDelete) {
            window.location.href = 'job?action=deleteJob&jobId=' + jobIdToDelete;
        }
    });
</script>
</body>
</html>