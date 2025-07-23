<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en-US">

<head>
    <jsp:useBean id="j" class="jobtrans.model.Job" scope="page" />
    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="page" />
        <jsp:useBean id="accountDAO" class="jobtrans.dal.AccountDAO" scope="page" />
        <jsp:useBean id="statusJobDAO" class="jobtrans.dal.StatusJobDAO" scope="page" />

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lí Công việc &#8211; JobTrans </title>
    <link rel="icon" type="image/png" href="img/logo/logo.png">
    <!DOCTYPE html>
    <html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lí công việc</title>
        <style>
            .task-container {
                max-width: 800px;
                padding: 15px 40px;
                background-color: white;
                border-radius: 16px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
                animation: fadeIn 0.6s ease;
                margin-bottom: 80px;
            }

            /* Styling for Job Overview Section */
            .job-overview {
                margin-bottom: 30px;
                background-color: #f9fbff;
                border-radius: 12px;
                padding: 5px 20px 20px;
                border: 1px solid rgba(103, 135, 254, 0.15);
            }

            .overview-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid rgba(103, 135, 254, 0.2);
            }

            .overview-header i {
                color: #6787fe;
                font-size: 20px;
                margin-right: 10px;
            }

            .overview-header h2 {
                font-family: 'Poppins', sans-serif;
                font-size: 18px;
                font-weight: 600;
                color: #1a2b5f;
                margin: 0;
            }

            .overview-card {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
            }

            .overview-item {
                padding: 10px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                transition: all 0.3s ease;
            }

            .overview-item:hover {
                box-shadow: 0 4px 12px rgba(103, 135, 254, 0.1);
                transform: translateY(-2px);
            }

            .overview-label {
                font-size: 12px;
                color: #728095;
                margin-bottom: 5px;
            }

            .overview-value {
                font-size: 14px;
                font-weight: 500;
                color: #1a2b5f;
            }

            .status-item {
                grid-column: span 2;
            }

            .status-processing {
                color: #ff9500;
                display: flex;
                align-items: center;
            }

            .status-dot {
                width: 10px;
                height: 10px;
                background-color: #ff9500;
                border-radius: 50%;
                display: inline-block;
                margin-right: 6px;
                position: relative;
            }

            .status-dot:after {
                content: '';
                position: absolute;
                width: 14px;
                height: 14px;
                background-color: rgba(255, 149, 0, 0.3);
                border-radius: 50%;
                top: -2px;
                left: -2px;
                animation: pulse 1.5s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(0.95);
                    opacity: 0.7;
                }
                50% {
                    transform: scale(1.2);
                    opacity: 0.3;
                }
                100% {
                    transform: scale(0.95);
                    opacity: 0.7;
                }
            }

            .priority-high {
                color: #f44336;
                font-weight: 600;
            }

            .priority-medium {
                color: #ff9500;
                font-weight: 600;
            }

            .priority-low {
                color: #4CAF50;
                font-weight: 600;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .task-title {
                font-family: 'Poppins', sans-serif;
                font-weight: 700;
                font-size: 26px;
                letter-spacing: 0.5px;
                margin-bottom: 30px;
                color: #1a2b5f;
                text-align: center;
                position: relative;
                padding-bottom: 15px;
            }

            .task-title:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 60px;
                height: 3px;
                background: linear-gradient(90deg, #6787fe, #9dabff);
                border-radius: 3px;
            }

            .row.justify-content-center {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .task-card {
                background-color: #FFFFFF;
                border-radius: 14px;
                border: 2px solid rgba(103, 135, 254, 0.4);
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                padding: 18px 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;
                box-shadow: 0 3px 12px rgba(103, 135, 254, 0.06);
                position: relative;
                overflow: hidden;
            }

            .task-card::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                width: 5px;
                height: 100%;
                background: linear-gradient(180deg, rgba(103, 135, 254, 0.6), rgba(103, 135, 254, 0.2));
                border-radius: 3px 0 0 3px;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .task-card:hover, .task-card:focus {
                background-color: #f8f9ff;
                border-color: rgba(103, 135, 254, 0.8);
                color: inherit;
                transform: translateY(-3px);
                box-shadow: 0 8px 16px rgba(103, 135, 254, 0.12);
            }

            .task-card:hover::before, .task-card:focus::before {
                opacity: 1;
            }

            .task-card:active {
                transform: translateY(0);
                box-shadow: 0 4px 8px rgba(103, 135, 254, 0.1);
                background-color: #f0f4ff;
            }

            .icon-container {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                justify-content: center;
                align-items: center;
                margin-right: 18px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
            }

            .task-card:hover .icon-container {
                transform: scale(1.1);
            }

            .contract-icon {
                background-color: rgba(76, 217, 100, 0.15);
                color: #4CD964;
            }

            .ship-icon {
                background-color: rgba(0, 122, 255, 0.15);
                color: #007AFF;
            }

            .chat-icon {
                background-color: rgba(255, 149, 0, 0.15);
                color: #FF9500;
            }

            .partner-icon {
                background-color: rgba(175, 82, 222, 0.15);
                color: #AF52DE;
            }

            .report-icon {
                background-color: rgba(88, 86, 214, 0.15);
                color: #5856D6;
            }

            .calendar-icon {
                background-color: rgba(52, 199, 89, 0.15);
                color: #34C759;
            }

            .section-title {
                font-size: 18px;
                color: #1a2b5f;
                margin: 0 0 15px 0;
                width: 100%;
                font-weight: 500;
                display: flex;
                align-items: center;
            }

            .section-title i {
                margin-right: 8px;
                color: #6787fe;
            }

            .task-card-title {
                font-weight: 500;
                font-size: 16px;
                color: #333;
                margin: 0;
                transition: all 0.3s ease;
            }

            .task-card:hover .task-card-title {
                transform: translateX(5px);
                color: #1a2b5f;
            }

            /* Nút xác nhận và các nút bổ sung */
            .action-buttons {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
                margin-top: 35px;
            }

            .confirm-button {
                background: linear-gradient(to right, #0B1741, #2a3b70);
                border-radius: 25px;
                border: none;
                color: white;
                font-weight: 500;
                font-size: 16px;
                text-align: center;
                padding: 12px 30px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 6px 15px rgba(11, 23, 65, 0.2);
                position: relative;
                overflow: hidden;
                min-width: 180px;
            }

            .create-button {
                background: linear-gradient(to right, #4CAF50, #2E7D32);
            }

            .cancel-button {
                background: linear-gradient(to right, #f44336, #c62828);
            }

            .button-icon {
                margin-right: 8px;
            }

            .confirm-button::after {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: rgba(255, 255, 255, 0.1);
                transform: rotate(45deg);
                transition: transform 0.6s ease;
                pointer-events: none;
            }

            .confirm-button:hover {
                box-shadow: 0 8px 20px rgba(11, 23, 65, 0.3);
                transform: translateY(-2px);
            }

            .confirm-button:hover::after {
                transform: rotate(45deg) translate(50%, 50%);
            }

            .confirm-button:active {
                transform: translateY(1px);
                box-shadow: 0 4px 10px rgba(11, 23, 65, 0.25);
            }

            /* Thanh tiến trình */
            .progress-section {
                margin: 30px 0;
                padding: 0 10px;
            }

            .progress-title {
                font-weight: 500;
                font-size: 16px;
                color: #1a2b5f;
                margin-bottom: 15px;
                display: flex;
                justify-content: space-between;
            }

            .progress-percentage {
                color: #6787fe;
                font-weight: 700;
            }

            .progress {
                height: 12px;
                border-radius: 10px;
                background-color: #e9ecef;
                overflow: hidden;
                box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .progress-bar {
                background: linear-gradient(to right, #6787fe, #9dabff);
                border-radius: 10px;
                transition: width 1.5s ease;
                position: relative;
            }

            .progress-milestones {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
                position: relative;
                padding: 0 1%;
            }

            .milestone {
                display: flex;
                flex-direction: column;
                align-items: center;
                position: relative;
                width: 18%;
                text-align: center;
            }

            .milestone-dot {
                width: 12px;
                height: 12px;
                background-color: #c6d0f5;
                border-radius: 50%;
                margin-bottom: 6px;
                position: relative;
                z-index: 2;
                transition: all 0.3s ease;
            }

            .milestone.active .milestone-dot {
                background-color: #6787fe;
                box-shadow: 0 0 0 3px rgba(103, 135, 254, 0.2);
            }

            .milestone-label {
                font-size: 12px;
                color: #728095;
                transition: all 0.3s ease;
            }

            .milestone.active .milestone-label {
                color: #1a2b5f;
                font-weight: 500;
            }

            /* Bảng ghi chú công việc */
            .task-notes {
                background-color: #f8f9ff;
                border-radius: 10px;
                padding: 20px;
                margin-top: 30px;
                border: 1px solid rgba(103, 135, 254, 0.2);
            }

            .notes-title {
                font-weight: 600;
                font-size: 18px;
                color: #1a2b5f;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .notes-title i {
                margin-right: 10px;
                color: #6787fe;
            }

            .notes-content {
                position: relative;
            }

            .note-input {
                width: 100%;
                border: 1px solid #d9e2ef;
                border-radius: 8px;
                padding: 12px 15px;
                font-size: 14px;
                color: #495057;
                resize: none;
                transition: all 0.3s ease;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
            }

            .note-input:focus {
                border-color: #6787fe;
                box-shadow: 0 0 0 3px rgba(103, 135, 254, 0.15);
                outline: none;
            }

            .add-note-btn {
                position: absolute;
                right: 10px;
                bottom: 10px;
                background-color: #6787fe;
                color: white;
                border: none;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .add-note-btn:hover {
                background-color: #5067c5;
                transform: scale(1.05);
            }

            /* Styling for existing notes */
            .existing-notes {
                margin-top: 20px;
                max-height: 200px;
                overflow-y: auto;
            }

            .note-item {
                background-color: white;
                border-radius: 8px;
                padding: 12px 15px;
                margin-bottom: 10px;
                border-left: 3px solid #6787fe;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            }

            .note-info {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
                font-size: 12px;
            }

            .note-author {
                font-weight: 600;
                color: #1a2b5f;
            }

            .note-date {
                color: #8896ab;
            }

            .note-text {
                font-size: 14px;
                color: #495057;
                line-height: 1.4;
            }

            /* Responsive adjustments */
            @media (min-width: 768px) {
                .task-title {
                    font-size: 30px;
                    margin-bottom: 35px;
                }

                .task-card-title {
                    font-size: 18px;
                }

                .confirm-button {
                    font-size: 17px;
                }
            }

            @media (max-width: 767px) {
                .task-container {
                    margin-top: 100px;
                    padding: 25px 15px 30px;
                }

                .row.justify-content-center {
                    grid-template-columns: 1fr;
                }

                .task-card {
                    margin-bottom: 15px;
                }

                .action-buttons {
                    flex-direction: column;
                    align-items: center;
                }

                .milestone-label {
                    font-size: 10px;
                }
            }
        </style>

    </head>
    <%@include file="includes/header-01.jsp"%>
    <body>
    <div class="container task-container">
        <div class="row justify-content-center">
            <div class="col-12">
                <h1 class="task-title">QUẢN LÍ CÔNG VIỆC</h1>
            </div>
        </div>

        <!-- Phần tổng quan công việc -->
        <div class="job-overview">
            <div class="overview-header">
                <i class="fas fa-clipboard-check"></i>
                <h2>Tổng quan công việc</h2>
            </div>
            <div class="overview-card">
                <div class="overview-item">
                    <div class="overview-label">Tên công việc:</div>
                    <div class="overview-value">${job.jobId}</div>
                </div>
                <div class="overview-item">
                    <div class="overview-label">Tên công việc:</div>
                    <div class="overview-value">${job.jobTitle}</div>
                </div>
                <div class="overview-item">
                    <div class="overview-label">Người thuê:</div>
                    <div class="overview-value">${accountDAO.getAccountById(job.postAccountId).accountName}</div>
                </div>
                <div class="overview-item">
                    <div class="overview-label">Ngày bắt đầu:</div>
                    <div class="overview-value"></div>
                </div>
                <div class="overview-item status-item">
                    <div class="overview-label">Trạng thái:</div>
                    <div class="overview-value status-processing">
                        <span class="status-dot"></span>
                        ${statusJobDAO.getStatusJobById(job.statusJobId).statusJobName}
                    </div>
                </div>
                <div class="overview-item">
                    <div class="overview-label">Hạn hoàn thành:</div>
                    <div class="overview-value"></div>
                </div>
            </div>
        </div>

        <!-- Thanh tiến trình -->
        <div class="progress-section">
            <div class="progress-title">
                <span>Tiến độ công việc hiện tại</span>
                <c:if test="${job.statusJobId == 1}">
                    <span class="progress-percentage">16%</span>
                </c:if>
                <c:if test="${job.statusJobId == 2}">
                    <span class="progress-percentage">32%</span>
                </c:if>
                <c:if test="${job.statusJobId == 3}">
                    <span class="progress-percentage">48%</span>
                </c:if>
                <c:if test="${job.statusJobId == 4}">
                    <span class="progress-percentage">65%</span>
                </c:if>
                <c:if test="${job.statusJobId == 5}">
                    <span class="progress-percentage">65%</span>
                </c:if>
                <c:if test="${job.statusJobId == 6}">
                    <span class="progress-percentage">100%</span>
                </c:if>
                <c:if test="${job.statusJobId == 7}">
                    <span class="progress-percentage">80%</span>
                </c:if>


            </div>

            <div class="progress">
                <c:if test="${job.statusJobId == 1}">
                <div class="progress-bar" role="progressbar" style="width: 16%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>
                <c:if test="${job.statusJobId == 2}">
                    <div class="progress-bar" role="progressbar" style="width: 32%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>
                <c:if test="${job.statusJobId == 3}">
                    <div class="progress-bar" role="progressbar" style="width: 48%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>
                <c:if test="${job.statusJobId == 4}">
                    <div class="progress-bar" role="progressbar" style="width: 64%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>
                <c:if test="${job.statusJobId == 5}">
                    <div class="progress-bar" role="progressbar" style="width: 64%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>
                <c:if test="${job.statusJobId == 6}">
                    <div class="progress-bar" role="progressbar" style="width: 100%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>
                <c:if test="${job.statusJobId == 7}">
                    <div class="progress-bar" role="progressbar" style="width: 80%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                </c:if>

            </div>
            <div class="progress-milestones">
                <div class="milestone active">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Đang tuyển</div>
                </div>
                <div class="milestone active">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Chờ kí hợp đồng</div>
                </div>
                <div class="milestone active">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Đang làm việc</div>
                </div>
                <c:if test="${job.statusJobId == 4}">
                <div class="milestone">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Có khiếu nại</div>
                </div>
                </c:if>
                <div class="milestone">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Chờ thanh toán</div>
                </div>
                <div class="milestone">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Hoàn thành</div>
                </div>
                <c:if test="${job.statusJobId == 7}">
                <div class="milestone">
                    <div class="milestone-dot"></div>
                    <div class="milestone-label">Đã hủy</div>
                </div>
                </c:if>
            </div>
        </div>
        <h3 class="section-title">
            <i class="fas fa-tasks"></i>
            Công cụ quản lý
        </h3>
        <div class="row justify-content-center">

            <!-- First row -->
            <a href="contract?action=list-contract-of-job&jobId=${job.jobId}" class="task-card">
                <div class="icon-container contract-icon">
                    <i class="fas fa-file-contract"></i>
                </div>
                <span class="task-card-title">Xem hợp đồng</span>
            </a>
            <c:set var="accountId" value="${sessionScope.sessionAccount.accountId}" />
            <c:if test="${accountId ne job.postAccountId}">
            <a href="job-manage-process?action=submit-product-option&jobId=${job.jobId}" class="task-card">
                <div class="icon-container ship-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <span class="task-card-title">Giao sản phẩm</span>
            </a>
            </c:if>
            <c:if test="${accountId eq job.postAccountId}">
                <a href="job-manage-process?action=view-all-products&jobId=${job.jobId}" class="task-card">
                    <div class="icon-container ship-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <span class="task-card-title">Xem sản phẩm</span>
                </a>
            </c:if>

            <a href="chat-app?action=open-conversation&jobId=${job.jobId}" class="task-card">
                <div class="icon-container chat-icon">
                    <i class="fas fa-comment-dots"></i>
                </div>
                <span class="task-card-title">Chat</span>
            </a>


            <a href="job?action=viewPartnerList&jobId=${job.jobId}" class="task-card">
                <div class="icon-container partner-icon">
                    <i class="fas fa-user-friends"></i>
                </div>
                <span class="task-card-title">Đối tác</span>
            </a>
            <a href="job-manage-process?action=view-report-list-job&jobId=${job.jobId}" class="task-card">
                <div class="icon-container report-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <span class="task-card-title">Báo cáo</span>
            </a>
        </div>

        <!-- Bảng ghi chú công việc -->
        <div class="task-notes">
            <div class="notes-title">
                <i class="fas fa-clipboard-list"></i>
                <span>Ghi chú công việc (EXTEND CHO SAU NÀY)</span>
            </div>
            <div class="notes-content">
                <textarea class="note-input" rows="3" placeholder="Thêm ghi chú về công việc này..."></textarea>
                <button class="add-note-btn">
                    <i class="fas fa-plus"></i>
                </button>
            </div>
            <div class="existing-notes">
                <div class="note-item">
                    <div class="note-info">
                        <span class="note-author">Nguyễn Văn A</span>
                        <span class="note-date">03/05/2025 14:30</span>
                    </div>
                    <div class="note-text">Đã liên hệ với khách hàng và xác nhận thời gian giao hàng vào ngày 07/05.</div>
                </div>
                <div class="note-item">
                    <div class="note-info">
                        <span class="note-author">Hệ thống</span>
                        <span class="note-date">02/05/2025 09:15</span>
                    </div>
                    <div class="note-text">Công việc đã được chuyển sang trạng thái "Đang xử lý".</div>
                </div>
            </div>
        </div>
        <c:if test="${job.statusJobId >=3 && sessionScope.sessionAccount.accountId == job.postAccountId}">
        <!-- Các nút hành động -->
        <div class="action-buttons">
            <c:if test="${job.statusJobId != 6 && job.statusJobId != 7}">
                <button class="confirm-button" onclick="location.href='job-manage-process?action=confirm-complete&jobId=${job.jobId}'">
                    <i class="fas fa-check-circle button-icon"></i>
                    Xác nhận hoàn thành
                </button>
            </c:if>
            <c:if test="${job.statusJobId == 6}">
                <button class="confirm-button">
                    <i class="fas fa-check-circle button-icon"></i>
                    Công việc đã hoàn thành
                </button>
            </c:if>
            <c:if test="${job.statusJobId == 7}">
                <button class="confirm-button cancel-button">
                    <i class="fas fa-times-circle button-icon"></i>
                    Công việc đã bị hủy
                </button>
            </c:if>
            <button class="confirm-button cancel-button">
                <i class="fas fa-times-circle button-icon"></i>
                Yêu cầu hủy công việc
            </button>
        </div>
        </c:if>
    </div>
    </body>
    <%@include file="includes/footer.jsp"%>>
    </html>