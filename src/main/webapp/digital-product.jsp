<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/20/2025
  Time: 3:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>JobTrans - Nộp Sản Phẩm Số</title>
      <style>
      /** {*/
      /*margin: 0;*/
      /*padding: 0;*/
      /*box-sizing: border-box;*/
      /*}*/

      /*body {*/
      /*font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;*/
      /*background: linear-gradient(300deg, rgba(103, 135, 254, 0.4) 0%, rgb(43, 61, 159) 20%);*/
      /*min-height: 100vh;*/
      /*padding: 20px;*/
      /*}*/

      .container {
      max-width: 800px;
      margin: 0 auto;
      background: rgba(255, 255, 255, 0.95);
      border-radius: 20px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      backdrop-filter: blur(10px);
      }

      .form-header {
      background: linear-gradient(135deg, rgba(103, 135, 254, 0.9), rgb(43, 61, 159));
      color: white;
      padding: 30px;
      text-align: center;
      position: relative;
      }

      .form-header::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="1.5" fill="rgba(255,255,255,0.1)"/><circle cx="40" cy="60" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="70" cy="80" r="2.5" fill="rgba(255,255,255,0.1)"/></svg>');
      }

      .form-header h1 {
      font-size: 28px;
      margin-bottom: 10px;
      position: relative;
      z-index: 1;
      }

      .form-header p {
      font-size: 16px;
      opacity: 0.9;
      position: relative;
      z-index: 1;
      }

      .form-body {
      padding: 40px;
      }

      .form-group {
      margin-bottom: 25px;
      }

      .form-group label {
      display: block;
      font-weight: 600;
      color: #2b3d9f;
      margin-bottom: 8px;
      font-size: 14px;
      }

      .required {
      color: #e74c3c;
      }

      .form-control {
      width: 100%;
      padding: 15px;
      border: 2px solid #e1e8ff;
      border-radius: 12px;
      font-size: 16px;
      transition: all 0.3s ease;
      background: #f8faff;
      }

      .form-control:focus {
      outline: none;
      border-color: #6787fe;
      background: white;
      box-shadow: 0 0 0 4px rgba(103, 135, 254, 0.1);
      transform: translateY(-1px);
      }

      .form-control:hover {
      border-color: #b3c7ff;
      }

      textarea.form-control {
      resize: vertical;
      min-height: 120px;
      font-family: inherit;
      }

      .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      }

      select.form-control {
      cursor: pointer;
      background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
      background-position: right 12px center;
      background-repeat: no-repeat;
      background-size: 16px;
      appearance: none;
      }

      .file-upload-area {
      border: 2px dashed #6787fe;
      border-radius: 12px;
      padding: 30px;
      text-align: center;
      background: linear-gradient(135deg, #f8faff, #e1e8ff);
      transition: all 0.3s ease;
      cursor: pointer;
      position: relative;
      }

      .file-upload-area:hover {
      border-color: #2b3d9f;
      background: linear-gradient(135deg, #e1e8ff, #d1dbff);
      }

      .file-upload-area.dragover {
      border-color: #2b3d9f;
      background: linear-gradient(135deg, #d1dbff, #c1cbff);
      }

      .file-upload-icon {
      font-size: 48px;
      color: #6787fe;
      margin-bottom: 15px;
      }

      .file-upload-text {
      color: #2b3d9f;
      font-weight: 600;
      margin-bottom: 5px;
      }

      .file-upload-hint {
      color: #6b7280;
      font-size: 14px;
      }

      .file-input {
      position: absolute;
      opacity: 0;
      width: 100%;
      height: 100%;
      cursor: pointer;
      }

      .selected-files {
      margin-top: 15px;
      text-align: left;
      }

      .file-item {
      background: white;
      border: 1px solid #e1e8ff;
      border-radius: 8px;
      padding: 10px 15px;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      }

      .file-info {
      display: flex;
      align-items: center;
      }

      .file-icon {
      color: #6787fe;
      margin-right: 10px;
      }

      .remove-file {
      background: none;
      border: none;
      color: #e74c3c;
      cursor: pointer;
      font-size: 18px;
      padding: 5px;
      border-radius: 4px;
      transition: background-color 0.3s ease;
      }

      .remove-file:hover {
      background-color: rgba(231, 76, 60, 0.1);
      }

      .btn-group {
      display: flex;
      gap: 15px;
      margin-top: 30px;
      }

      .btn {
      padding: 15px 30px;
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      flex: 1;
      }

      .btn-primary {
      background: linear-gradient(135deg, #6787fe, #2b3d9f);
      color: white;
      box-shadow: 0 4px 15px rgba(103, 135, 254, 0.4);
      }

      .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(103, 135, 254, 0.6);
      }

      .btn-secondary {
      background: #f8faff;
      color: #2b3d9f;
      border: 2px solid #e1e8ff;
      }

      .btn-secondary:hover {
      background: #e1e8ff;
      transform: translateY(-1px);
      }

      .help-text {
      font-size: 15px;
      color: #6b7280;
      margin-top: 5px;
      line-height: 1.4;
      }

      @media (max-width: 768px) {
      .container {
      margin: 10px;
      border-radius: 15px;
      }

      .form-body {
      padding: 25px;
      }

      .form-row {
      grid-template-columns: 1fr;
      gap: 15px;
      }

      .btn-group {
      flex-direction: column;
      }

      .form-header h1 {
      font-size: 24px;
      }

      .form-header {
      padding: 25px;
      }
      }

      .status-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      }

      .status-pending {
      background: #fff3cd;
      color: #856404;
      }

      .status-completed {
      background: #d4edda;
      color: #155724;
      }

      .status-rejected {
      background: #f8d7da;
      color: #721c24;
      }
      </style>
  </head>
  <body>
  <%@include file="includes/header-01.jsp"%>
  <div class="container">
      <div class="form-header">
          <h1>📋 Nộp Sản Phẩm Số</h1>
          <p>Gửi sản phẩm hoàn thành cho dự án của bạn</p>
      </div>

      <div class="form-body">
          <form action="digital-product" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
              <div class="form-row">
                  <div class="form-group">
                      <label for="jobId">Công việc <span class="required">*</span></label>
                      <input type="hidden" id="jobId" name="jobId" value="${job.jobId}" />
                      <div class="help-text">${job.jobTitle}</div>
                  </div>

                  <div class="form-group">
                      <label for="senderId">Người gửi <span class="required">*</span></label>
                      <input type="hidden" id="senderId" name="senderId" value="${sessionScope.sessionAccount.accountId}" />
                      <div class="help-text">${sessionScope.sessionAccount.accountName}</div>
                  </div>
              </div>
              <div class="form-group">
                  <label for="notes">Ghi chú</label>
                  <textarea id="notes" name="notes" class="form-control" placeholder="Mô tả chi tiết về sản phẩm, hướng dẫn sử dụng, hoặc các lưu ý khác..."></textarea>
                  <div class="help-text">Thông tin bổ sung về sản phẩm của bạn</div>
              </div>

              <div class="form-group">
                  <label>Tải file đính kèm</label>
                  <div class="file-upload-area" id="fileUploadArea">
                      <input type="file" id="fileInput" name="files" class="file-input" multiple accept=".pdf,.doc,.docx,.zip,.rar,.jpg,.png,.mp4,.mov">
                      <div class="file-upload-icon">📎</div>
                      <div class="file-upload-text">Kéo thả file vào đây hoặc nhấn để chọn</div>
                      <div class="file-upload-hint">Hỗ trợ PDF, DOC, ZIP, hình ảnh, video (tối đa 50MB mỗi file)</div>
                  </div>
                  <div id="selectedFiles" class="selected-files"></div>
              </div>

              <div class="btn-group">
                  <button type="submit" class="btn btn-primary">
                      Nộp sản phẩm
                  </button>
              </div>
          </form>
      </div>
  </div>
  <%@include file="includes/footer.jsp"%>
  </body>
</html>
