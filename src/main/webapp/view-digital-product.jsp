<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="jobtrans.dal.AccountDAO" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <jsp:useBean id="accountDAO" class="jobtrans.dal.AccountDAO" scope="page" />
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chi tiết Sản phẩm Số</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f5f7fa;
      color: #333;
      line-height: 1.6;
    }

    .dashboard-content-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
    }

    .dashboard-content-inner {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 20px;
      padding: 30px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      animation: fadeInUp 0.8s ease-out;
    }

    .dashboard-headline {
      text-align: center;
      margin-bottom: 40px;
    }

    .dashboard-headline h3 {
      font-size: 2.5rem;
      font-weight: 700;
      background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      margin-bottom: 10px;
    }

    .dashboard-headline p {
      font-size: 1.1rem;
      color: #666;
      opacity: 0.9;
    }

    .dashboard-box {
      background: white;
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 10px 30px rgba(21, 42, 105, 0.1);
      margin-bottom: 30px;
      border: 2px solid rgba(21, 42, 105, 0.1);
      transition: all 0.3s ease;
    }

    .dashboard-box:hover {
      transform: translateY(-5px);
      box-shadow: 0 20px 40px rgba(21, 42, 105, 0.15);
    }

    .headline {
      background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
      padding: 20px 30px;
      color: white;
    }

    .headline h3 {
      font-size: 1.4rem;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .headline i, .headline::before {
      font-size: 1.6rem;
    }

    .content {
      padding: 30px;
    }

    .content h3 {
      font-size: 1.5rem;
      color: rgb(21, 42, 105);
      margin-bottom: 20px;
      position: relative;
      padding-bottom: 10px;
      font-weight: bold;
    }

    .content h3:after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 50px;
      height: 3px;
      background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
      border-radius: 2px;
    }

    .row {
      display: flex;
      flex-wrap: wrap;
      margin: 0 -15px;
    }

    .col-xl-4, .col-xl-6, .col-xl-12 {
      padding: 0 15px;
      margin-bottom: 25px;
    }

    .col-xl-4 {
      flex: 0 0 33.333333%;
      max-width: 33.333333%;
    }

    .col-xl-6 {
      flex: 0 0 50%;
      max-width: 50%;
    }

    .col-xl-12 {
      flex: 0 0 100%;
      max-width: 100%;
    }

    .submit-field {
      background: #f8f9fc;
      border-radius: 10px;
      padding: 20px;
      height: 100%;
      border: 1px solid #e3e6f0;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .submit-field:before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 3px;
      background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
    }

    .submit-field:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(21, 42, 105, 0.1);
      border-color: rgb(54, 75, 140);
    }

    .submit-field h5 {
      color: rgb(21, 42, 105);
      font-weight: 600;
      margin-bottom: 10px;
      font-size: 1rem;
    }

    .submit-field p, .submit-field .info-value {
      color: #495057;
      font-size: 0.95rem;
      line-height: 1.5;
      background: white;
      padding: 10px 15px;
      border-radius: 8px;
      border: 1px solid #dee2e6;
      min-height: 40px;
      display: flex;
      align-items: center;
    }

    .badge {
      display: inline-block;
      padding: 5px 12px;
      border-radius: 15px;
      font-size: 0.85rem;
      font-weight: 500;
    }

    .badge-success {
      background: #d4edda;
      color: #155724;
    }

    .badge-info {
      background: #d1ecf1;
      color: #0c5460;
    }

    .badge-primary {
      background: #cce5ff;
      color: #004085;
    }

    .notes-section {
      background: linear-gradient(135deg, #fff3cd, #ffeaa7);
      border-left: 4px solid #ffc107;
      padding: 20px;
      border-radius: 8px;
      margin-top: 20px;
    }

    .notes-section h4 {
      color: #856404;
      margin-bottom: 10px;
    }

    .file-list {
      display: grid;
      gap: 15px;
    }

    .file-item {
      background: #f8f9fa;
      border: 2px solid #e9ecef;
      border-radius: 10px;
      padding: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .file-item:before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 3px;
      background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
    }

    .file-item:hover {
      background: #e3f2fd;
      border-color: #2196f3;
      transform: translateY(-2px) scale(1.02);
      box-shadow: 0 8px 25px rgba(21, 42, 105, 0.1);
    }

    .file-info {
      display: flex;
      align-items: center;
    }

    .file-icon {
      font-size: 2.5rem;
      margin-right: 20px;
    }

    .file-icon.pdf { color: #dc3545; }
    .file-icon.word { color: #0d6efd; }
    .file-icon.image { color: #198754; }
    .file-icon.archive { color: #fd7e14; }
    .file-icon.default { color: #6c757d; }

    .file-details h4 {
      margin-bottom: 5px;
      color: #2c3e50;
    }

    .file-details small {
      color: #6c757d;
    }

    .file-actions {
      display: flex;
      gap: 10px;
    }

    .btn {
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: 500;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 5px;
    }

    .btn-download {
      background: #28a745;
      color: white;
    }

    .btn-download:hover {
      background: #218838;
      transform: translateY(-1px);
    }

    .btn-view {
      background: #007bff;
      color: white;
    }

    .btn-view:hover {
      background: #0056b3;
      transform: translateY(-1px);
    }

    .no-files {
      text-align: center;
      padding: 40px;
      color: #6c757d;
      background: #f8f9fa;
      border-radius: 10px;
      border: 2px dashed #dee2e6;
    }

    .no-files::before {
      content: "📄";
      font-size: 3rem;
      display: block;
      margin-bottom: 15px;
    }

    .clearfix {
      clear: both;
    }

    /* Icon styles for headlines */
    .headline-job::before { content: "💼"; margin-right: 10px; }
    .headline-product::before { content: "💻"; margin-right: 10px; }
    .headline-files::before { content: "📁"; margin-right: 10px; }

    /* Responsive design */
    @media (max-width: 1200px) {
      .col-xl-4 {
        flex: 0 0 50%;
        max-width: 50%;
      }
    }

    @media (max-width: 768px) {
      .col-xl-4, .col-xl-6 {
        flex: 0 0 100%;
        max-width: 100%;
      }

      .dashboard-content-inner {
        padding: 20px;
      }

      .dashboard-headline h3 {
        font-size: 2rem;
      }

      .content {
        padding: 20px;
      }

      .row {
        margin: 0 -10px;
      }

      .col-xl-4, .col-xl-6, .col-xl-12 {
        padding: 0 10px;
      }

      .file-item {
        flex-direction: column;
        gap: 15px;
        text-align: center;
      }

      .file-info {
        flex-direction: column;
        text-align: center;
      }

      .file-icon {
        margin: 0 0 10px 0;
      }
    }

    /* Animation */
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Custom scrollbar */
    ::-webkit-scrollbar {
      width: 8px;
    }

    ::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb {
      background: linear-gradient(to bottom, rgb(21, 42, 105), rgb(54, 75, 140));
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: linear-gradient(to bottom, rgb(54, 75, 140), rgb(21, 42, 105));
    }
  </style>
</head>
<body class="gray">
<!-- Header -->
<%@include file="includes/header-01.jsp"%>

<div id="wrapper">
  <div class="dashboard-container">
    <div class="dashboard-content-container">
      <div class="dashboard-content-inner">

        <div class="dashboard-headline">
          <h3>Sản phẩm Số đã nộp</h3>
          <p>Chi tiết sản phẩm và tệp tin đã gửi</p>
        </div>

        <!-- Thông tin công việc -->
        <div class="col-xl-12">
          <div class="dashboard-box margin-top-0">
            <div class="headline headline-job">
              <h3>Thông tin Công việc</h3>
            </div>
            <div class="content with-padding padding-bottom-10">
              <div class="row">
                <div class="col-xl-4">
                  <div class="submit-field">
                    <h5>ID Công việc:</h5>
                    <p>#${job.jobId}</p>
                  </div>
                </div>
                <div class="col-xl-4">
                  <div class="submit-field">
                    <h5>Ngày bắt đầu:</h5>
                    <p><fmt:formatDate value="${job.postDate}" pattern="dd/MM/yyyy" /></p>
                  </div>
                </div>
                <div class="col-xl-4">
                  <div class="submit-field">
                    <h5>Ngày kết thúc:</h5>
                    <p><fmt:formatDate value="${job.dueDateJob}" pattern="dd/MM/yyyy" /></p>
                  </div>
                </div>
                <div class="col-xl-12">
                  <div class="submit-field">
                    <h5>Tên công việc:</h5>
                    <p>${job.jobTitle}</p>
                  </div>
                </div>
                <div class="col-xl-12">
                  <div class="submit-field">
                    <h5>Mô tả:</h5>
                    <p>${job.jobDescription}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Thông tin sản phẩm số -->
        <div class="col-xl-12">
          <div class="dashboard-box">
            <div class="headline headline-product">
              <h3>Chi tiết Sản phẩm Số</h3>
            </div>
            <div class="content with-padding padding-bottom-10">
              <div class="row">
                <div class="col-xl-6">
                  <div class="submit-field">
                    <h5>Người gửi:</h5>
                    <c:if test="${account != null}">
                      <p>${account.accountName}</p>
                    </c:if>
                    <c:if test="${account == null}">
                      <p>${accountDAO.getAccountById(digitalProduct.senderId).accountName}</p>
                    </c:if>
                  </div>
                </div>
                <div class="col-xl-3">
                  <div class="submit-field">
                    <h5>Trạng thái:</h5>
                    <p><span class="badge badge-success">${digitalProduct.status}</span></p>
                  </div>
                </div>
                <div class="col-xl-3">
                  <div class="submit-field">
                    <h5>Số lượng file:</h5>
                    <c:set var="fileCount" value="${fn:length(fn:split(digitalProduct.digitalProductUrl, ';'))}" />
                    <p><span class="badge badge-primary">${fileCount} tệp tin</span></p>
                  </div>
                </div>
              </div>

              <!-- Ghi chú -->
              <c:if test="${not empty digitalProduct.notes}">
                <div class="notes-section">
                  <h4>📝 Ghi chú</h4>
                  <p>${digitalProduct.notes}</p>
                </div>
              </c:if>
            </div>
          </div>
        </div>

        <!-- Danh sách file -->
        <div class="col-xl-12">
          <div class="dashboard-box">
            <div class="headline headline-files">
              <h3>Tệp tin đính kèm</h3>
            </div>
            <div class="content with-padding padding-bottom-10">
              <c:choose>
                <c:when test="${not empty digitalProduct.digitalProductUrl}">
                  <div class="file-list">
                    <c:set var="files" value="${fn:split(digitalProduct.digitalProductUrl, ';')}" />
                    <c:forEach var="fileName" items="${files}" varStatus="status">
                      <c:if test="${not empty fileName}">
                        <div class="file-item">
                          <div class="file-info">
                            <div class="file-icon
                                          <c:choose>
                                              <c:when test="${fn:endsWith(fileName, '.pdf')}">pdf</c:when>
                                              <c:when test="${fn:endsWith(fileName, '.doc') || fn:endsWith(fileName, '.docx')}">word</c:when>
                                              <c:when test="${fn:endsWith(fileName, '.jpg') || fn:endsWith(fileName, '.jpeg') || fn:endsWith(fileName, '.png') || fn:endsWith(fileName, '.gif')}">image</c:when>
                                              <c:when test="${fn:endsWith(fileName, '.zip') || fn:endsWith(fileName, '.rar')}">archive</c:when>
                                              <c:otherwise>default</c:otherwise>
                                          </c:choose>">
                              <c:choose>
                                <c:when test="${fn:endsWith(fileName, '.pdf')}">📄</c:when>
                                <c:when test="${fn:endsWith(fileName, '.doc') || fn:endsWith(fileName, '.docx')}">📝</c:when>
                                <c:when test="${fn:endsWith(fileName, '.jpg') || fn:endsWith(fileName, '.jpeg') || fn:endsWith(fileName, '.png') || fn:endsWith(fileName, '.gif')}">🖼️</c:when>
                                <c:when test="${fn:endsWith(fileName, '.zip') || fn:endsWith(fileName, '.rar')}">📦</c:when>
                                <c:otherwise>📎</c:otherwise>
                              </c:choose>
                            </div>
                            <div class="file-details">
                              <h4>${fn:substringAfter(fileName, '_')}</h4>
                              <small>Tên file: ${fileName}</small>
                            </div>
                          </div>
                          <div class="file-actions">
                            <a href="${pageContext.request.contextPath}/uploaded-products/${fileName}"
                               class="btn btn-download" download>
                              ⬇️ Tải xuống
                            </a>
                            <a href="${pageContext.request.contextPath}/uploaded-products/${fileName}"
                               class="btn btn-view" target="_blank">
                              👁️ Xem
                            </a>
                          </div>
                        </div>
                      </c:if>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="no-files">
                    <strong>Không có tệp tin nào được tải lên.</strong>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</div>

<script>
  // Animation khi load trang
  document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll behavior
    document.documentElement.style.scrollBehavior = 'smooth';

    // File item hover effects
    const fileItems = document.querySelectorAll('.file-item');
    fileItems.forEach(item => {
      item.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-3px) scale(1.02)';
      });

      item.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0) scale(1)';
      });
    });

    // Submit field hover effects
    const submitFields = document.querySelectorAll('.submit-field');
    submitFields.forEach(field => {
      field.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-2px)';
        this.style.boxShadow = '0 8px 25px rgba(21, 42, 105, 0.1)';
      });

      field.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
        this.style.boxShadow = 'none';
      });
    });
  });

  // Print styling
  window.addEventListener('beforeprint', function() {
    document.body.style.background = 'white';
  });
</script>

<%@include file="includes/footer.jsp"%>
</body>
</html>