<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/20/2025
  Time: 4:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jobtrans.dal.DigitalProductDAO" %>
<%@ page import="jobtrans.dal.OrderRequestDAO" %>
<!DOCTYPE html>
<html lang="en-US">

<head>
    <jsp:useBean id="j" class="jobtrans.model.Job" scope="page" />
    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="page" />
    <jsp:useBean id="accountDAO" class="jobtrans.dal.AccountDAO" scope="page" />
    <jsp:useBean id="statusJobDAO" class="jobtrans.dal.StatusJobDAO" scope="page" />
        <jsp:useBean id="digitalProductDAO" class="jobtrans.dal.DigitalProductDAO" scope="page" />
        <jsp:useBean id="orderRequestDAO" class="jobtrans.dal.OrderRequestDAO" scope="page" />


        <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Giao sản phẩm &#8211; JobTrans </title>
    <link rel="icon" type="image/png" href="img/logo/logo.png">
    <!DOCTYPE html>
    <html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giao sản phẩm</title>
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

            .delivery-section {
                background-color: #f8f9ff;
                border-radius: 12px;
                padding: 25px;
                margin: 30px 0;
                border: 1px solid rgba(103, 135, 254, 0.2);
            }

            .delivery-title {
                font-size: 20px;
                color: #1a2b5f;
                margin-bottom: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                text-align: center;
                justify-content: center;
            }

            .product-options {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 20px;
                margin-top: 25px;
            }

            .product-option {
                background-color: white;
                border-radius: 14px;
                border: 2px solid rgba(103, 135, 254, 0.3);
                padding: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;
                box-shadow: 0 4px 15px rgba(103, 135, 254, 0.08);
                position: relative;
                overflow: hidden;
                text-align: center;
            }

            .product-option::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                height: 4px;
                background: linear-gradient(90deg, rgba(103, 135, 254, 0.6), rgba(103, 135, 254, 0.2));
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .product-option:hover, .product-option:focus {
                background-color: #f8f9ff;
                border-color: rgba(103, 135, 254, 0.8);
                color: inherit;
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(103, 135, 254, 0.15);
            }

            .product-option:hover::before, .product-option:focus::before {
                opacity: 1;
            }

            .product-option:active {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(103, 135, 254, 0.12);
            }

            .product-icon {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 0 auto 20px;
                transition: all 0.3s ease;
                font-size: 35px;
            }

            .product-option:hover .product-icon {
                transform: scale(1.1);
            }

            .physical-icon {
                background: linear-gradient(135deg, rgba(76, 217, 100, 0.2), rgba(76, 217, 100, 0.1));
                color: #4CD964;
                border: 2px solid rgba(76, 217, 100, 0.3);
            }

            .digital-icon {
                background: linear-gradient(135deg, rgba(0, 122, 255, 0.2), rgba(0, 122, 255, 0.1));
                color: #007AFF;
                border: 2px solid rgba(0, 122, 255, 0.3);
            }

            .product-title {
                font-size: 20px;
                font-weight: 600;
                color: #1a2b5f;
                margin-bottom: 12px;
            }

            .product-description {
                font-size: 14px;
                color: #728095;
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .product-features {
                text-align: left;
                margin-top: 20px;
            }

            .feature-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .feature-list li {
                font-size: 13px;
                color: #5a6c7d;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                position: relative;
                padding-left: 20px;
            }

            .feature-list li::before {
                content: '✓';
                position: absolute;
                left: 0;
                color: #4CD964;
                font-weight: bold;
                font-size: 14px;
            }

            .back-button {
                display: inline-flex;
                align-items: center;
                background: linear-gradient(to right, #6c757d, #495057);
                color: white;
                text-decoration: none;
                padding: 10px 20px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s ease;
                margin-bottom: 20px;
                box-shadow: 0 4px 10px rgba(108, 117, 125, 0.2);
            }

            .back-button:hover {
                background: linear-gradient(to right, #5a6268, #3d4449);
                color: white;
                text-decoration: none;
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(108, 117, 125, 0.3);
            }

            /* View Products Button Styles */
            .view-products-section {
                background-color: #fff8e1;
                border-radius: 12px;
                padding: 20px;
                margin: 20px 0;
                border: 1px solid rgba(255, 193, 7, 0.3);
                text-align: center;
            }

            .view-products-button {
                display: inline-flex;
                align-items: center;
                background: linear-gradient(135deg, #ffc107, #ffb300);
                color: #1a2b5f;
                text-decoration: none;
                padding: 12px 24px;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
                position: relative;
                overflow: hidden;
            }

            .view-products-button::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                transition: left 0.5s;
            }

            .view-products-button:hover {
                background: linear-gradient(135deg, #ffb300, #ff8f00);
                color: #1a2b5f;
                text-decoration: none;
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 193, 7, 0.4);
            }

            .view-products-button:hover::before {
                left: 100%;
            }

            .view-products-button i {
                margin-right: 8px;
                font-size: 16px;
            }

            .view-products-description {
                margin-bottom: 15px;
                color: #856404;
                font-size: 14px;
                line-height: 1.5;
            }

            /* Button container for better spacing */
            .button-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 20px;
            }

            /* Responsive adjustments */
            @media (min-width: 768px) {
                .task-title {
                    font-size: 30px;
                    margin-bottom: 35px;
                }

                .product-title {
                    font-size: 22px;
                }

                .delivery-title {
                    font-size: 22px;
                }
            }

            @media (max-width: 767px) {
                .task-container {
                    margin-top: 100px;
                    padding: 25px 15px 30px;
                }

                .product-options {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }

                .product-option {
                    padding: 20px;
                }

                .product-icon {
                    width: 70px;
                    height: 70px;
                    font-size: 30px;
                    margin-bottom: 15px;
                }

                .delivery-section {
                    padding: 20px 15px;
                }

                .view-products-section {
                    padding: 15px;
                }

                .button-container {
                    flex-direction: column;
                    align-items: stretch;
                }

                .back-button, .view-products-button {
                    text-align: center;
                    justify-content: center;
                }
            }
        </style>
    </head>

    <%@include file="includes/header-01.jsp"%>
    <body>
    <div class="container task-container">
        <div class="row justify-content-center">
            <div class="col-12">
                <!-- Container for buttons -->
                <div class="button-container">
                    <!-- Nút quay lại -->
                    <a href="job-manage-process?action=view-job-detail&jobId=${job.jobId}" class="back-button">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại quản lý công việc
                    </a>
                </div>

                <h1 class="task-title">GIAO SẢN PHẨM</h1>
            </div>
        </div>

        <!-- Phần tổng quan công việc -->
        <div class="job-overview">
            <div class="overview-header">
                <i class="fas fa-clipboard-check"></i>
                <h2>Thông tin công việc</h2>
            </div>
            <div class="overview-card">
                <div class="overview-item">
                    <div class="overview-label">Mã công việc:</div>
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
                    <div class="overview-value"><!-- Thêm ngày bắt đầu nếu có --></div>
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
                    <div class="overview-value"><!-- Thêm hạn hoàn thành nếu có --></div>
                </div>
            </div>
        </div>

        <!-- Phần xem sản phẩm đã nộp -->
<%--        <div class="view-products-section">--%>
<%--            <div class="view-products-description">--%>
<%--                <strong>Đã nộp sản phẩm?</strong><br>--%>
<%--                Xem lại các sản phẩm đã gửi cho công việc này và kiểm tra trạng thái phê duyệt.--%>
<%--            </div>--%>
<%--            <a href="ViewSubmittedProducts?jobId=${job.jobId}" class="view-products-button">--%>
<%--                <i class="fas fa-eye"></i>--%>
<%--                Xem sản phẩm đã nộp--%>
<%--            </a>--%>
<%--        </div>--%>

        <!-- Phần chọn loại sản phẩm -->
        <div class="delivery-section">
            <h2 class="delivery-title">
                <i class="fas fa-shipping-fast"></i>
                Chọn loại sản phẩm cần giao
            </h2>

            <div class="product-options">
                <c:set var="accountId" value="${sessionScope.sessionAccount.accountId}" />
                <c:if test="${digitalProductDAO.getDigitalProduct(job.jobId, accountId) == null}">

                    <a href="job-manage-process?action=digital-product&jobId=${job.jobId}" class="product-option">
                        <div class="product-icon digital-icon">
                            <i class="fas fa-download"></i>
                        </div>
                        <h3 class="product-title">Sản phẩm số</h3>
                        <p class="product-description">
                            Giao hàng sản phẩm kỹ thuật số như file, phần mềm, tài liệu qua internet
                        </p>
                        <div class="product-features">
                            <ul class="feature-list">
                                <li>Upload file sản phẩm</li>
                                <li>Gửi link download cho khách hàng</li>
                                <li>Thiết lập thời gian hiệu lực</li>
                                <li>Bảo mật với mật khẩu (tùy chọn)</li>
                            </ul>
                        </div>
                    </a>
                </c:if>
                <c:if test="${digitalProductDAO.getDigitalProduct(job.jobId, accountId) != null}">

                    <a href="digital-product?action=view-digital-products&jobId=${job.jobId}&senderId=${accountId}" class="product-option">
                        <div class="product-icon digital-icon">
                            <i class="fas fa-download"></i>
                        </div>
                        <h3 class="product-title">Xem thông tin sản phẩm số</h3>
                        <p class="product-description">
                            Bạn đã giao sản phẩm
                        </p>
                        <div class="product-features">
                            <ul class="feature-list">
                                <li>Upload file sản phẩm</li>
                                <li>Gửi link download cho khách hàng</li>
                                <li>Thiết lập thời gian hiệu lực</li>
                                <li>Bảo mật với mật khẩu (tùy chọn)</li>
                            </ul>
                        </div>
                    </a>
                </c:if>
                <!-- Sản phẩm digital -->
                <c:if test="${orderRequestDAO.getOrderRequestByJobIdAndSenderId(job.jobId, accountId)==null}">
                    <!-- Sản phẩm vật lý -->
                    <a href="physical-product?action=loadForm&jobId=${job.jobId}&senderId=${accountId}" class="product-option">
                        <div class="product-icon physical-icon">
                            <i class="fas fa-box"></i>
                        </div>
                        <h3 class="product-title">Sản phẩm vật lý</h3>
                        <p class="product-description">
                            Giao hàng sản phẩm có thể chạm được, cần vận chuyển qua đường bưu điện hoặc dịch vụ giao hàng
                        </p>
                        <div class="product-features">
                            <ul class="feature-list">
                                <li>Nhập thông tin địa chỉ giao hàng</li>
                                <li>Chọn đơn vị vận chuyển</li>
                                <li>Theo dõi trạng thái giao hàng</li>
                                <li>Xác nhận khi khách hàng nhận được</li>
                            </ul>
                        </div>
                    </a>
                </c:if>
                <c:if test="${orderRequestDAO.getOrderRequestByJobIdAndSenderId(job.jobId, accountId) != null}">
                    <!-- Sản phẩm vật lý -->
                    <a href="physical-product?action=viewOfflineSubmit&jobId=${job.jobId}&senderId=${accountId}" class="product-option">
                        <div class="product-icon physical-icon">
                            <i class="fas fa-box"></i>
                        </div>
                        <h3 class="product-title">Xem thông tin sản phẩm vật lý</h3>
                        <p class="product-description">
                            Bạn đã tạo đơn giao sản phẩm
                        </p>
                        <div class="product-features">
                            <ul class="feature-list">
                                <li>Nhập thông tin địa chỉ giao hàng</li>
                                <li>Chọn đơn vị vận chuyển</li>
                                <li>Theo dõi trạng thái giao hàng</li>
                                <li>Xác nhận khi khách hàng nhận được</li>
                            </ul>
                        </div>
                    </a>
                </c:if>
            </div>
        </div>
    </div>
    </body>
    <%@include file="includes/footer.jsp"%>
    </html>