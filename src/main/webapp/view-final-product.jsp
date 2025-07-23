<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/20/2025
  Time: 9:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="en-US">

<head>
  <jsp:useBean id="j" class="jobtrans.model.Job" scope="page" />
  <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="page" />
  <jsp:useBean id="accountDAO" class="jobtrans.dal.AccountDAO" scope="page" />
  <jsp:useBean id="statusJobDAO" class="jobtrans.dal.StatusJobDAO" scope="page" />

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Xem sản phẩm &#8211; JobTrans </title>
  <link rel="icon" type="image/png" href="img/logo/logo.png">
  <style>
    .task-container {
      max-width: 1000px;
      padding: 15px 40px;
      background-color: white;
      border-radius: 16px;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
      animation: fadeIn 0.6s ease;
      margin-bottom: 80px;
    }

    /* Job Overview Section */
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

    .back-button i {
      margin-right: 8px;
      font-size: 14px;
    }

    /* Products Section */
    .products-section {
      margin-top: 30px;
    }

    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 2px solid rgba(103, 135, 254, 0.1);
    }

    .section-title {
      font-size: 20px;
      color: #1a2b5f;
      font-weight: 600;
      display: flex;
      align-items: center;
      margin: 0;
    }

    .section-title i {
      margin-right: 10px;
      color: #6787fe;
      font-size: 22px;
    }

    .add-product-btn {
      background: linear-gradient(to right, #4CAF50, #2E7D32);
      color: white;
      text-decoration: none;
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      box-shadow: 0 4px 10px rgba(76, 175, 80, 0.2);
    }

    .add-product-btn:hover {
      background: linear-gradient(to right, #45a049, #1b5e20);
      color: white;
      text-decoration: none;
      transform: translateY(-2px);
      box-shadow: 0 6px 15px rgba(76, 175, 80, 0.3);
    }

    .add-product-btn i {
      margin-right: 8px;
    }

    /* Product Cards */
    .products-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 20px;
      margin-top: 20px;
    }

    .product-card {
      background-color: white;
      border-radius: 12px;
      border: 1px solid rgba(0, 0, 0, 0.1);
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
      overflow: hidden;
      transition: all 0.3s ease;
      position: relative;
    }

    .product-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
    }

    .product-header {
      padding: 20px;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }

    .product-type {
      display: inline-flex;
      align-items: center;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      margin-bottom: 10px;
    }

    .type-physical {
      background-color: rgba(76, 217, 100, 0.15);
      color: #4CD964;
    }

    .type-digital {
      background-color: rgba(0, 122, 255, 0.15);
      color: #007AFF;
    }

    .product-name {
      font-size: 18px;
      font-weight: 600;
      color: #1a2b5f;
      margin: 0 0 8px 0;
    }

    .product-description {
      font-size: 14px;
      color: #728095;
      line-height: 1.5;
      margin: 0;
    }

    .product-details {
      padding: 15px 20px;
      background-color: #fafbfc;
    }

    .detail-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
      font-size: 13px;
    }

    .detail-row:last-child {
      margin-bottom: 0;
    }

    .detail-label {
      color: #728095;
      font-weight: 500;
    }

    .detail-value {
      color: #1a2b5f;
      font-weight: 600;
    }

    .product-status {
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 600;
      text-transform: uppercase;
    }

    .status-delivered {
      background-color: rgba(76, 217, 100, 0.15);
      color: #4CD964;
    }

    .status-pending {
      background-color: rgba(255, 149, 0, 0.15);
      color: #FF9500;
    }

    .status-processing {
      background-color: rgba(0, 122, 255, 0.15);
      color: #007AFF;
    }

    .product-actions {
      padding: 15px 20px;
      border-top: 1px solid rgba(0, 0, 0, 0.05);
      display: flex;
      gap: 10px;
    }

    .action-btn {
      flex: 1;
      padding: 8px 12px;
      border: none;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s ease;
      text-align: center;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }

    .btn-primary {
      background-color: #6787fe;
      color: white;
    }

    .btn-primary:hover {
      background-color: #5067c5;
      color: white;
      text-decoration: none;
    }

    .btn-secondary {
      background-color: #e9ecef;
      color: #495057;
    }

    .btn-secondary:hover {
      background-color: #d4dae0;
      color: #495057;
      text-decoration: none;
    }

    .btn-danger {
      background-color: #f44336;
      color: white;
    }

    .btn-danger:hover {
      background-color: #d32f2f;
      color: white;
      text-decoration: none;
    }

    .action-btn i {
      margin-right: 5px;
      font-size: 12px;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #728095;
    }

    .empty-state i {
      font-size: 48px;
      color: #d1d9e6;
      margin-bottom: 20px;
    }

    .empty-state h3 {
      font-size: 18px;
      color: #495057;
      margin-bottom: 10px;
    }

    .empty-state p {
      font-size: 14px;
      margin-bottom: 0;
    }

    /* File Preview */
    .file-preview {
      position: relative;
      margin: 10px 0;
    }

    .file-icon {
      width: 40px;
      height: 40px;
      background-color: #f8f9fa;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
      color: #6c757d;
      font-size: 16px;
    }

    .file-info {
      flex: 1;
    }

    .file-name {
      font-size: 14px;
      font-weight: 500;
      color: #1a2b5f;
      margin: 0 0 4px 0;
    }

    .file-size {
      font-size: 12px;
      color: #728095;
    }

    /* Responsive */
    @media (min-width: 768px) {
      .task-title {
        font-size: 30px;
        margin-bottom: 35px;
      }

      .section-title {
        font-size: 22px;
      }
    }

    @media (max-width: 767px) {
      .task-container {
        margin-top: 100px;
        padding: 25px 15px 30px;
      }

      .products-grid {
        grid-template-columns: 1fr;
        gap: 15px;
      }

      .section-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
      }

      .product-actions {
        flex-direction: column;
      }

      .action-btn {
        width: 100%;
      }
    }
  </style>
</head>

<%@include file="includes/header-01.jsp"%>
<body>
<div class="container task-container">
  <div class="row justify-content-center">
    <div class="col-12">
      <!-- Nút quay lại -->
      <a href="delivery?action=select-product-type&jobId=${job.jobId}" class="back-button">
        <i class="fas fa-arrow-left"></i>
        Quay lại chọn loại sản phẩm
      </a>

      <h1 class="task-title">XEM SẢN PHẨM</h1>
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

  <!-- Phần danh sách sản phẩm -->
  <div class="products-section">
    <div class="section-header">
      <h2 class="section-title">
        <i class="fas fa-box-open"></i>
        Danh sách sản phẩm đã giao
      </h2>
    </div>

    <!-- Grid sản phẩm -->
    <div class="products-grid">

      <!-- SẢN PHẨM VẬT LÝ -->
      <c:forEach var="order" items="${orderRequest}">
        <div class="product-card">
          <div class="product-header">
            <div class="product-type type-physical">
              <i class="fas fa-box"></i>
              Sản phẩm vật lý
            </div>
            <h3 class="product-name">${order.order.name}</h3>
            <p class="product-description">${order.order.note}</p>
          </div>
          <div class="product-details">
            <div class="detail-row">
              <span class="detail-label">Ngày giao:</span>
              <span class="detail-value">
                    <fmt:formatDate value="${order.order.pick_date}" pattern="dd/MM/yyyy"/>
                </span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Địa chỉ giao:</span>
              <span class="detail-value">${order.order.address}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Đơn vị vận chuyển:</span>
              <span class="detail-value">${order.order.transport}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Trạng thái:</span>
              <span class="product-status
                    <c:choose>
                        <c:when test="${order.status == 'Đã giao'}">status-delivered</c:when>
                        <c:when test="${order.status == 'Đang giao'}">status-shipping</c:when>
                        <c:otherwise>status-processing</c:otherwise>
                    </c:choose>">
                  ${order.status}
              </span>
            </div>
          </div>
          <div class="product-actions">
            <a href="physical-product?action=viewOfflineSubmit&jobId=${order.jobId}&senderId=${order.senderId}" class="action-btn btn-primary">
              <i class="fas fa-eye"></i>
              Chi tiết
            </a>
            <a href="physical-product?action=viewStatusShipment&tracking_id=${order.getTrackingId()}" class="action-btn btn-secondary">
              <i class="fas fa-truck"></i>
              Tracking
            </a>
          </div>
        </div>
      </c:forEach>


      <!-- SẢN PHẨM SỐ -->
      <c:forEach var="dp" items="${digitalProductList}">
        <div class="product-card">
          <div class="product-header">
            <div class="product-type type-digital">
              <i class="fas fa-download"></i>
              Sản phẩm số
            </div>
            <h3 class="product-name">File nộp số #${dp.digitalProductId}</h3>
            <p class="product-description">${dp.notes}</p>
          </div>
          <div class="product-details">
<%--            <div class="detail-row">--%>
<%--              <span class="detail-label">Ngày upload:</span>--%>
<%--              <span class="detail-value">--%>
<%--                        <fmt:formatDate value="${dp.uploadDate}" pattern="dd/MM/yyyy"/>--%>
<%--                    </span>--%>
<%--            </div>--%>
            <div class="detail-row">
              <span class="detail-label">File:</span>
              <span class="detail-value">
                        <a href="${pageContext.request.contextPath}/uploaded-products/${dp.digitalProductUrl}" target="_blank">
                            Tải xuống
                        </a>
                    </span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Trạng thái:</span>
              <span class="product-status
                        <c:choose>
                            <c:when test="${dp.status == 'Đã duyệt'}">status-delivered</c:when>
                            <c:otherwise>status-processing</c:otherwise>
                        </c:choose>">
                  ${dp.status}
              </span>
            </div>
          </div>
          <div class="product-actions">
            <a href="view-digital-detail?productId=${dp.digitalProductId}" class="action-btn btn-primary">
              <i class="fas fa-eye"></i>
              Chi tiết
            </a>
            <a href="${pageContext.request.contextPath}/uploaded-products/${dp.digitalProductUrl}" class="action-btn btn-secondary" download>
              <i class="fas fa-download"></i>
              Download
            </a>
          </div>
        </div>
      </c:forEach>

    </div>


    <!-- Empty State (hiển thị khi không có sản phẩm) -->
    <!--
    <div class="empty-state">
        <i class="fas fa-box-open"></i>
        <h3>Chưa có sản phẩm nào</h3>
        <p>Bạn chưa thêm sản phẩm nào cho công việc này. Hãy bắt đầu bằng cách thêm sản phẩm mới.</p>
    </div>
    -->
  </div>
</div>
</body>
<%@include file="includes/footer.jsp"%>
</html>
