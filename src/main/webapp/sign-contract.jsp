<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="jobtrans.model.Contract" %>
<%@ page import="jobtrans.model.Job" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JobTrans</title>
    <link rel="stylesheet" href="css/sign-contract.css">
    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="session" />
    <jsp:useBean id="now" class="java.util.Date" />

    <style>
        .btn-a {
            padding: 12px 24px;
            border-radius: var(--radius);
            font-weight: 500;
            font-size: 18px;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            outline: none;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline:hover {
            background-color: rgba(39, 64, 179, 0.05);
        }

        .btn-a:not(.btn-outline) {
            background: var(--primary-gradient);
            color: var(--white);
            box-shadow: 0 4px 10px rgba(39, 64, 179, 0.3);
        }

        .btn-a:not(.btn-outline):hover {
            box-shadow: 0 6px 15px rgba(39, 64, 179, 0.4);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<%@include file="includes/header-01.jsp"%>

<section>
    <div class="container section-padding">
        <div class="justify-content-center">
            <main class="container">
                <div class="contract-header">
                    <div class="contract-title">Hợp Đồng Dịch Vụ JobTrans</div>
                    <div class="contract-status status-signing">Đang ký kết</div>
                </div>

                <div class="contract-progress">
                    <div class="progress-step completed">
                        <div class="step-number"></div>
                        <div class="step-label">Thông tin dự án</div>
                    </div>
                    <div class="progress-step completed">
                        <div class="step-number"></div>
                        <div class="step-label">Điều khoản</div>
                    </div>
                    <div class="progress-step active">
                        <div class="step-number">3</div>
                        <div class="step-label">Ký kết</div>
                    </div>
                    <div class="progress-step">
                        <div class="step-number">4</div>
                        <div class="step-label">Hoàn thành</div>
                    </div>
                </div>

                <div class="contract-body">
                    <form id="contract-signing-form" action="contract" method="post">
                        <input type="hidden" name="action" value="add-contract">

                        <div class="form-section">
                            <div class="section-title">Tóm tắt hợp đồng</div>
                            <%
                                Contract contract = (Contract) session.getAttribute("draftContract");
                                if (contract == null) {
                                    // No contract in session, redirect to form
                                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                                    return;
                                }
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

                                NumberFormat vndFormat = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                            %>
                            <div class="contract-summary">
                                <div class="summary-header">Thông tin chung</div>

                                <div class="summary-section">
                                    <div class="summary-section-title">Thông tin dự án</div>
                                    <div class="summary-item">
                                        <%
                                            Job job = jobDAO.getJobById(contract.getJobId());
                                            request.setAttribute("job", job);
                                        %>
                                        <div class="summary-label">Tên dự án:</div>
                                        <div class="summary-value">${job.jobTitle}</div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Mô tả công việc:</div>
                                        <div class="summary-value"><%= contract.getJobGoal()%></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Yêu cầu cho công việc:</div>
                                        <div class="summary-value"><%= contract.getJobRequirement()%></div>
                                    </div>
                                    <%--                                    <div class="summary-item">--%>
                                    <%--                                        <div class="summary-label">Thời gian thực hiện:</div>--%>
                                    <%--                                        <div class="summary-value">45 ngày</div>--%>
                                    <%--                                    </div>--%>
                                    <div class="summary-item">
                                        <div class="summary-label">Ngày bắt đầu:</div>
                                        <div class="summary-value"><%= dateFormat.format(contract.getStartDate()) %></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Ngày kết thúc:</div>
                                        <div class="summary-value"><%= dateFormat.format(contract.getEndDate())%></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Địa điểm làm việc:</div>
                                        <div class="summary-value"><%= contract.getJobAddress()%></div>
                                    </div>
                                </div>

                                <div class="summary-section">
                                    <div class="summary-section-title">Giá trị hợp đồng</div>
                                    <div class="summary-item">
                                        <div class="summary-label">Tổng giá trị:</div>
                                        <div class="summary-value"><%= vndFormat.format(contract.getJobFee())%> VNĐ</div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Lịch thanh toán:</div>
                                        <div class="summary-value">Đặt cọc + Thanh toán lần cuối sau khi bàn giao dự án</div>
                                    </div>
                                </div>

                                <div class="summary-section">
                                    <div class="summary-section-title">Thanh khoản của 2 bn</div>
                                    <div class="summary-item">
                                        <div class="summary-label">Số tiền bên A đặt cọc (Bằng số):</div>
                                        <div class="summary-value"><%= vndFormat.format(contract.getJobDepositA())%> VNĐ</div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Số tiền A đặt cọc (Bằng chữ):</div>
                                        <div class="summary-value"><%= contract.getJobDepositAText()%></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Ngày bên A đặt cọc:</div>
                                        <div class="summary-value"><%= dateFormat.format(contract.getJobDepositADate())%></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Số tiền bên B đặt cọc (Bằng số):</div>
                                        <div class="summary-value"><%= vndFormat.format(contract.getJobDepositB())%> VNĐ</div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Số tiền B đặt cọc (Bằng chữ):</div>
                                        <div class="summary-value"><%= contract.getJobDepositBText()%></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Ngày bên B đặt cọc:</div>
                                        <div class="summary-value"><%= dateFormat.format(contract.getJobDepositBDate())%></div>
                                    </div>
                                </div>

                                <%--                                <div class="summary-section">--%>
                                <%--                                    <div class="summary-section-title">Các điều khoản quan trọng</div>--%>
                                <%--                                    <div class="summary-item">--%>
                                <%--                                        <div class="summary-label">Thời gian bảo hành:</div>--%>
                                <%--                                        <div class="summary-value">3 tháng</div>--%>
                                <%--                                    </div>--%>
                                <%--                                    <div class="summary-item">--%>
                                <%--                                        <div class="summary-label">Quyền sở hữu:</div>--%>
                                <%--                                        <div class="summary-value">Khách hàng sở hữu toàn bộ</div>--%>
                                <%--                                    </div>--%>
                                <%--                                    <div class="summary-item">--%>
                                <%--                                        <div class="summary-label">Thỏa thuận bảo mật:</div>--%>
                                <%--                                        <div class="summary-value">Áp dụng (2 năm)</div>--%>
                                <%--                                    </div>--%>
                                <%--                                    <div class="summary-item">--%>
                                <%--                                        <div class="summary-label">Giải quyết tranh chấp:</div>--%>
                                <%--                                        <div class="summary-value">Hòa giải qua ProLancer</div>--%>
                                <%--                                    </div>--%>
                                <%--                                </div>--%>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="section-title">Thông tin các bên</div>

                            <div class="contract-parties">
                                <div class="party-info">
                                    <h3 style="font-size: 20px; margin-bottom: 20px">Bên A (Employer - Người sử dụng lao động)</h3>
                                    <p><strong>Tên:</strong> <%= contract.getaName()%></p>
                                    <%
                                        String aRepresentative = contract.getaRepresentative();
                                        if (aRepresentative != null && !aRepresentative.isEmpty()) {
                                    %>
                                    <p><strong>Đại diện:</strong> <%= contract.getaRepresentative() %></p>
                                    <%
                                        }
                                    %>
                                    <p><strong>Số CCCD:</strong> <%= contract.getaIdentity()%></p>
                                    <p><strong>Cấp ngày:</strong> <%= dateFormat.format(contract.getaIdentityDate())%></p>
                                    <p><strong>Cấp tại:</strong> <%= contract.getaIdentityAddress()%></p>
                                    <p><strong>Mã số thuế:</strong> <%= contract.getaTaxCode()%></p>
                                    <p><strong>Sinh ngày:</strong> <%= dateFormat.format(contract.getaBirthday())%></p>
                                    <p><strong>Địa chỉ:</strong> <%= contract.getaAddress()%></p>
                                    <p><strong>Email:</strong> <%= contract.getaEmail()%></p>
                                    <p><strong>Điện thoại:</strong> <%= contract.getaPhoneNumber()%></p>
                                </div>
                                <div class="party-info">
                                    <h3 style="font-size: 20px; margin-bottom: 20px">Bên B (Freelancer - Người lao động)</h3>
                                    <p><strong>Tên:</strong> <%= contract.getbName()%></p>
                                    <%
                                        String bRepresentative = contract.getbRepresentative();
                                        if (bRepresentative != null && !bRepresentative.isEmpty()) {
                                    %>
                                    <p><strong>Đại diện:</strong> <%= contract.getbRepresentative() %></p>
                                    <%
                                        }
                                    %>
                                    <p><strong>Số CCCD:</strong> <%= contract.getbIdentity()%></p>
                                    <p><strong>Cấp ngày:</strong> <%= dateFormat.format(contract.getbIdentityDate())%></p>
                                    <p><strong>Cấp tại:</strong> <%= contract.getbIdentityAddress()%></p>
                                    <p><strong>Sinh ngày:</strong> <%= dateFormat.format(contract.getbBirthday())%></p>
                                    <p><strong>Địa chỉ:</strong> <%= contract.getbAddress()%></p>
                                    <p><strong>Email:</strong> <%= contract.getbEmail()%></p>
                                    <p><strong>Điện thoại:</strong> <%= contract.getbPhoneNumber()%></p>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="section-title">Xem xét nội dung hợp đồng</div>
                            <div class="document-preview">
                                <div class="document-icon">📄</div>
                                <div class="info-value">Hợp đồng dịch vụ ${job.jobTitle}</div>
                                <div style="margin-top: 20px;">
                                    <a class="btn-a btn-outline" id="openPopupBtn" style="text-decoration: none">Xem toàn bộ hợp đồng</a>
                                </div>
                            </div>
                            <div class="checkbox-group">
                                <input type="checkbox" class="checkbox-input" id="agreement" required>
                                <label class="checkbox-label" for="agreement">Tôi đã đọc và đồng ý với các điều khoản trong hợp đồng</label>
                            </div>
                            <div class="checkbox-group">
                                <input type="checkbox" class="checkbox-input" id="confirmation" required>
                                <label class="checkbox-label" for="confirmation">Tôi xác nhận thông tin cung cấp là chính xác và đầy đủ</label>
                            </div>
                        </div>

                        <c:if test="${account.signature != null}">
                            <div class="form-section">
                                <div class="section-title">Chữ ký của các bên</div>
                                <div class="signature-container">

                                        <%--================================Để sau các kì sau mở rộng thêm cho dự án==================================--%>
                                        <%--                                <div class="signature-box">--%>
                                        <%--                                    <h4 class="signature-box-title">Bên A (Bên Thuê)</h4>--%>
                                        <%--                                    <div class="signature-canvas-container" id="employer-signature">--%>
                                        <%--                                        <div class="signature-placeholder">--%>
                                        <%--                                            <p>Nhấp vào đây để ký</p>--%>
                                        <%--                                        </div>--%>
                                        <%--                                        <img class="signature-image" id="employer-signature-image" alt="Chữ ký bên thuê">--%>
                                        <%--                                    </div>--%>
                                        <%--                                    <div style="text-align: center">--%>
                                        <%--                                        <div class="signature-date">Ngày ký: 01/05/2025</div>--%>
                                        <%--                                        <h6 >Họ và tên người kí</h6>--%>
                                        <%--                                        <p style="font-weight: lighter">Võ Thị Mỹ Duyên</p>--%>
                                        <%--                                    </div>--%>
                                        <%--                                    <button type="button" class="clear-signature" id="clear-employer-signature">Xóa chữ ký</button>--%>
                                        <%--                                </div>--%>

                                        <%--                                <div class="popup-overlay" id="signature-popup">--%>
                                        <%--                                    <div class="popup-content">--%>
                                        <%--                                        <h3 class="popup-title">Chưa có chữ ký</h3>--%>
                                        <%--                                        <p class="popup-message">Bạn chưa có chữ ký trong hệ thống. Bạn có muốn tạo chữ ký mới không?</p>--%>
                                        <%--                                        <div class="popup-buttons">--%>
                                        <%--                                            <button class="btn-a" id="create-signature-btn">Tạo chữ ký</button>--%>
                                        <%--                                            <button class="btn-a btn-outline" id="close-popup-btn">Đóng</button>--%>
                                        <%--                                        </div>--%>
                                        <%--                                    </div>--%>
                                        <%--                                </div>--%>

                                        <%--                                <div class="signature-box">--%>
                                        <%--                                    <h4 class="signature-box-title">Bên B (Freelancer)</h4>--%>
                                        <%--                                    <div class="signature-canvas-container" id="freelancer-signature">--%>
                                        <%--                                        <div class="signature-placeholder">--%>
                                        <%--                                            <p>Nhấp vào đây để ký</p>--%>
                                        <%--                                        </div>--%>
                                        <%--                                        <img class="signature-image" id="freelancer-signature-image" src="" alt="Chữ ký freelancer">--%>
                                        <%--                                    </div>--%>
                                        <%--                                    <div style="text-align: center">--%>
                                        <%--                                        <div class="signature-date">Ngày ký: 01/05/2025</div>--%>
                                        <%--                                        <h6 >Họ và tên người kí</h6>--%>
                                        <%--                                        <p style="font-weight: lighter">Võ Thị Mỹ Duyên</p>--%>
                                        <%--                                    </div>--%>
                                        <%--                                    <button type="button" class="clear-signature" id="clear-freelancer-signature">Xóa chữ ký</button>--%>
                                        <%--                                </div>--%>

                                    <div class="signature-box">
                                        <h4 class="signature-box-title">Bên A (Bên Thuê)</h4>
                                        <c:if test="${sessionScope.contract.aSignature != null}">
                                            <div class="signature-canvas-container">
                                                <img class="signature-image" alt="Chữ ký nền tảng JobTrans" src="img/contract/signature-My-Duyen.jpg">
                                            </div>
                                            <div style="text-align: center">
                                                <div class="signature-date">Ngày ký: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${sessionScope.contract.aSignature == null}">
                                            <div class="signature-canvas-container">
                                                <p class="signature-placeholder">Chưa có chữ ký</p>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="signature-box">
                                        <h4 class="signature-box-title">Bên B (Freelancer)</h4>
                                        <c:if test="${sessionScope.contract.bSignature != null}">
                                            <div class="signature-canvas-container">
                                                <img class="signature-image" alt="Chữ ký nền tảng JobTrans" src="img/contract/signature-My-Duyen.jpg">
                                            </div>
                                            <div style="text-align: center">
                                                <div class="signature-date">Ngày ký: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                                                    </div>
                                                <h6 >Họ và tên người kí</h6>
                                                <p style="font-weight: lighter">Võ Thị Mỹ Duyên</p>
                                            </div>
                                        </c:if>
                                        <c:if test="${sessionScope.contract.bSignature == null}">
                                            <div class="signature-canvas-container">
                                                <p class="signature-placeholder">Chưa có chữ ký</p>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="signature-box">
                                        <h4 class="signature-box-title">Bên C (Nền tảng JobTrans)</h4>
                                        <div class="signature-canvas-container">
                                            <img class="signature-image" alt="Chữ ký nền tảng JobTrans" src="img/contract/signature-My-Duyen.jpg">
                                        </div>
                                        <div style="text-align: center">
                                            <div class="signature-date">Ngày ký: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                                            </div>
                                            <h6 >Họ và tên người kí</h6>
                                            <p style="font-weight: lighter">Võ Thị Mỹ Duyên</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="checkbox-group">
                                    <input type="checkbox" class="checkbox-input" id="sign-contract" required>
                                    <label class="checkbox-label" for="sign-contract">Tôi xác nhận đồng ý kí kết hợp đồng và chấp nhận những điều khoản đã nêu ra</label>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${account.signature == null}">
                            <div class="form-section">
                                <div style=" text-align: center; padding: 30px 20px;">
                                    <i class="fas fa-exclamation-circle" style="font-size: 50px; color: #ff9800; margin-bottom: 55px; margin-right: 30px;"></i>
                                    <h3 style="margin-bottom: 10px; color: #555;">Hiện tại bạn chưa có chữ ký</h3>
                                    <p style="color: #777; margin-bottom: 20px;">Hãy tiến hành thêm chữ ký cho tài khoản của mình</p>
                                    <a href="profile?action=showUpdateForm" class="btn-a" style="text-decoration: none ;background: linear-gradient(to right, #ff9800, #ff5722);">
                                        <i class="fas fa-plus"></i> Thêm chữ ký mới
                                    </a>
                                </div>
                            </div>
                        </c:if>
                        <%--================================Để sau các kì sau mở rộng thêm cho dự án==================================--%>
                        <%--                        <div class="form-section">--%>
                        <%--                            <div class="section-title">Xác minh danh tính</div>--%>
                        <%--                            <p class="info-text">--%>
                        <%--                                <i class="fas fa-info-circle"></i>--%>
                        <%--                                Để đảm bảo tính pháp lý của hợp đồng, vui lòng tải lên bản quét/hình chụp CMND/CCCD/Hộ chiếu.--%>
                        <%--                            </p>--%>

                        <%--                            <div class="upload-section">--%>
                        <%--                                <div class="file-upload">--%>
                        <%--                                    <div class="file-input-container">--%>
                        <%--                                        <input type="file" class="file-input" id="id-front" accept="image/*">--%>
                        <%--                                        <button type="button" class="file-upload-btn">--%>
                        <%--                                            <i class="fas fa-upload"></i>--%>
                        <%--                                            Tải lên mặt trước CMND/CCCD--%>
                        <%--                                        </button>--%>
                        <%--                                    </div>--%>
                        <%--                                    <div class="file-name" id="id-front-name"></div>--%>
                        <%--                                </div>--%>

                        <%--                                <div class="file-upload">--%>
                        <%--                                    <div class="file-input-container">--%>
                        <%--                                        <input type="file" class="file-input" id="id-back" accept="image/*">--%>
                        <%--                                        <button type="button" class="file-upload-btn">--%>
                        <%--                                            <i class="fas fa-upload"></i>--%>
                        <%--                                            Tải lên mặt sau CMND/CCCD--%>
                        <%--                                        </button>--%>
                        <%--                                    </div>--%>
                        <%--                                    <div class="file-name" id="id-back-name"></div>--%>
                        <%--                                </div>--%>
                        <%--                            </div>--%>

                        <%--                            <div class="info-text">--%>
                        <%--                                <i class="fas fa-info-circle"></i>--%>
                        <%--                                Thông tin này chỉ được sử dụng để xác minh danh tính và sẽ được bảo mật theo quy định của ProLancer.--%>
                        <%--                            </div>--%>
                        <%--                        </div>--%>

                        <c:if test="${not empty error}">
                            <div class="custom-alert custom-alert-danger">
                                <i class="fas fa-exclamation-circle custom-alert-icon"></i>
                                <div class="custom-alert-content">
                                    <div class="custom-alert-title">${error}</div>

                                    <c:if test="${not empty missingAmount}">
                                        <div class="missing-amount">
                                            <span>Số tiền cần nạp thêm: </span>
                                            <span class="missing-amount-value"><fmt:formatNumber value="${missingAmount}" pattern="#,##0" /> VNĐ</span>
                                        </div>
                                        <div>
                                            <a href="profile?action=wallet" class="action-btn">
                                                <i class="fas fa-coins"></i> Nạp tiền ngay
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                                <button type="button" class="close-btn" onclick="this.parentElement.style.display='none';">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </c:if>

                        <div class="btn-container">
                            <button type="button" class="btn-a btn-outline" id="btn-back">Quay lại</button>
                            <button class="btn-a" id="btn-submit">Hoàn tất ký kết</button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
</section>
<%@include file="includes/footer.jsp"%>

<div class="popup-overlay" id="contractPopup" style="display: none;">
    <div class="popup-container">
        <div class="popup-header">
            <div class="popup-title">Hợp Đồng Dịch Vụ JobTrans</div>
            <div class="popup-buttons">
                <div class="popup-close" id="closePopupBtn">&times;</div>
            </div>
        </div>
        <div class="popup-content">
            <div id="contract-content">
                <div class="container">
                    <div class="contract-header-a">
                        <div class="national-title">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</div>
                        <div class="independence-title">Độc lập - Tự do - Hạnh phúc</div>
                        <div class="contract-title-a">HỢP ĐỒNG DỊCH VỤ</div>
                        <div class="contract-number">Số: ......</div>
                    </div>

                    <div class="legal-basis">
                        <p>Căn cứ Bộ luật Dân sự 2015 số 91/2015/QH13 và các văn bản hướng dẫn thi hành;</p>
                        <p>Căn cứ nhu cầu và thỏa thuận giữa các bên</p>
                        <p>Hôm nay, vào <fmt:formatDate value="${now}" pattern="'ngày' dd 'tháng' MM 'năm' yyyy" /> tại Công ty JobTrans, các bên bao gồm:</p>
                    </div>

                    <div class="party-info-a">
                        <p><strong style="color: #000000; font-size: 22px;">BÊN A: <%= contract.getaName()%>
                            (EMPLOYER)</strong></p>

                        <%
                            String ARepresentative = contract.getaRepresentative();
                            if (ARepresentative != null && !ARepresentative.isEmpty()) {
                        %>
                        <p>Đại diện là Ông/bà (nếu có): <%= contract.getaRepresentative()%></p>

                        <%
                        } else  {
                        %>
                        <p>Đại diện là Ông/bà (nếu có): ............................................</p>
                        <%
                            }
                        %>
                        <p>Số CCCD: <%= contract.getaIdentity()%> Cấp ngày: <%= dateFormat.format(contract.getaIdentityDate())%> Tại: <%= contract.getaIdentityAddress()%></p>
                        <p>Mã số thuế: <%= contract.getaTaxCode()%></p>
                        <p>Sinh ngày: <%= dateFormat.format(contract.getaBirthday())%></p>
                        <p>Địa chỉ thường trú: <%= contract.getaAddress()%></p>
                        <p>Số điện thoại: <%= contract.getaPhoneNumber()%></p>
                        <p>Email: <%= contract.getaEmail()%></p>
                    </div>

                    <div class="party-info-a">
                        <p><strong style="color: #000000; font-size: 22px;">BÊN B: <%= contract.getbName()%>
                            (FREELANCER)</strong></p>
                        <%
                            String BRepresentative = contract.getbRepresentative();
                            if (BRepresentative != null && !BRepresentative.isEmpty()) {
                        %>
                        <p>Đại diện là Ông/bà (nếu có): <%= contract.getbRepresentative()%></p>
                        <%
                        } else  {
                        %>
                        <p>Đại diện là Ông/bà (nếu có): ............................................</p>
                        <%
                            }
                        %>
                        <p>Số CCCD: <%= contract.getaIdentity()%> Cấp ngày: <%= dateFormat.format(contract.getaIdentityDate())%> Tại: <%= contract.getaIdentityAddress()%></p>
                        <p>Sinh ngày: <%= dateFormat.format(contract.getaBirthday())%></p>
                        <p>Địa chỉ thường trú: <%= contract.getaAddress()%></p>
                        <p>Số điện thoại: <%= contract.getaPhoneNumber()%></p>
                        <p>Email: <%= contract.getaEmail()%></p>
                    </div>

                    <div class="party-info-a">
                        <p><strong style="color: #000000; font-size: 22px;">BÊN C: NỀN TẢNG JOBTRANS</strong></p>
                        <p>Công ty: JobTrans - Nền tảng hỗ trợ tuyển dụng và tìm kiếm việc làm.</p>
                        <p>Địa chỉ: Khu đô thị FPT Đà Nẵng - Ngũ Hành Sơn - Đà Nẵng</p>
                        <p>MSDN: 0932551005</p>
                        <p>Điện thoại: 0935280706</p>
                        <p>Đại diện: Võ Thị Mỹ Duyên</p>
                        <p>Chức vụ: Quản trị viên nền tảng</p>
                        <p>Quốc tịch: Việt Nam</p>
                    </div>

                    <p>Sau khi bàn bạc và thỏa thuận, hai bên đã thống nhất những nội dung như sau:</p>

                    <div class="section-title-contract">ĐIỀU 1. NỘI DUNG CÔNG VIỆC</div>
                    <p class="section-subtitle">1.1. Bên B nhận thực hiện cho bên A các công việc sau:<%= contract.getJobGoal()%></p>
                    <p class="section-subtitle">1.2. Yêu cầu về chất lượng công việc:<%= contract.getJobRequirement()%></p>

                    <div class="section-title-contract">ĐIỀU 2. THỜI GIAN, ĐỊA ĐIỂM THỰC HIỆN HỢP ĐỒNG VÀ ĐIỀU KHOẢN
                    </div>
                    <p class="section-subtitle">2.1. Thời gian thực hiện:</p>
                    <p>Bên B thực hiện công việc cho Bên A trong thời hạn từ ngày <%= dateFormat.format(contract.getStartDate())%> đến ngày <%= dateFormat.format(contract.getEndDate())%>.
                    </p>
                    <p class="section-subtitle">2.2. Địa điểm thực hiện: Tự do</p>
                    <p class="section-subtitle">2.3. Ngày thanh lý hợp đồng phải cách ngày dự kiến hoàn thành công
                        việc tối đa sau 5 ngày.
                    </p>
                    <p class="section-subtitle">2.4. Điều khoản:</p>
                    <p>Thời hạn bên B hoàn thành công việc chậm tối đa là 5 ngày kể từ ngày phải hoàn thành (<%= dateFormat.format(contract.getEndDate())%>). Sau ngày thứ 5 chậm hoàn thành
                        công việc, Bên B bồi thường mất toàn bộ tiền đặt cọc và bị trừ điểm trên hệ thống (35 điểm
                        bao gồm những lần nhắc nhở trong quá trình hoàn thành chậm -- <em>chính sách điểm trừ
                            JobTrans</em>). Ngoài ra, bên B phải chịu phạt lãi chậm thanh toán theo mức lãi suất
                        0,1%/ngày (trên thù lao dự tính được nhận cho dự án đó) chậm thanh toán và phải bồi thường
                        thiệt hại (nếu có) theo quy định của pháp luật. Trường hợp chậm tiến độ hoàn thành (đã nêu
                        tại Điều 2.1) sau 15 ngày, Bên A có quyền đơn phương chấm dứt hợp đồng.</p>

                    <div class="section-title-contract">ĐIỀU 3. PHÍ DỊCH VỤ, HÌNH THỨC, THỜI HẠN THANH TOÁN VÀ ĐẶT
                        CỌC TRƯỚC KHI BẮT ĐẦU CÔNG VIỆC
                    </div>

                    <p class="section-subtitle">3.1. Phí dịch vụ:</p>
                    <p>Bên A phải thanh toán cho Bên B phí dịch vụ là <%= vndFormat.format(contract.getJobFee())%> VNĐ. (1000 VNĐ tương đương 1000
                        Coins)</p>
                    <p>Bên A sẽ thực hiện khấu trừ thuế TNCN 10% tại nguồn đối với các khoản thu nhập từ 2.000.000
                        VNĐ (bằng chữ: Hai triệu đồng) trở lên.</p>
                    <p class="section-subtitle">3.2. Hình thức thanh toán: Bằng ví điện tử của nền tảng.</p>
                    <p class="section-subtitle">3.3. Thời hạn thanh toán:</p>
                    <p>Bên A thanh toán cho Bên B theo 02 đợt:</p>
                    <p>- Lần 1: Bên A đặt cọc cho Bên B là: <%= vndFormat.format(contract.getJobDepositA())%> VNĐ (1000 VNĐ tương đương 1000 Coins)
                    </p>
                    <p>- Lần 2: Bên A thanh toán phần giá trị hợp đồng còn lại cho Bên B sau khi đã trừ đi giá trị
                        tạm ứng và thuế thu nhập cá nhân của Bên B vào ngày hoàn thành việc cung cấp dịch vụ ở Điều
                        2.4.</p>
                    <p>Thời hạn bên A thanh toán chậm tối đa là 5 ngày kể từ ngày phải thanh toán. Sau ngày thứ 5
                        chậm thanh toán, Bên A bồi thường mất toàn bộ tiền đặt cọc và bị trừ điểm trên hệ thống (35
                        điểm bao gồm những lần nhắc nhở trong quá trình thanh toán chậm - <em>chính sách điểm trừ
                            JobTrans</em>). Ngoài ra, bên A phải chịu phạt lãi chậm thanh toán theo mức lãi suất
                        0,1%/ngày chậm thanh toán và phải bồi thường thiệt hại (nếu có) theo quy định của pháp luật.
                        Trường hợp chậm thanh toán (đã nêu tại điều 2.3) sau 15 ngày, Bên B có quyền đơn phương chấm
                        dứt hợp đồng.</p>
                    <p class="section-subtitle">3.4. Đặt cọc trước khi bắt đầu công việc:</p>
                    <p>- Bên A và Bên B có nghĩa vụ đặt cọc trước khi bắt đầu công việc với số tiền cụ thể như sau:
                    </p>
                    <p>+ Bên A đặt cọc: <%= vndFormat.format(contract.getJobDepositA())%> VNĐ (bằng chữ:<%= contract.getJobDepositAText()%>) vào ngày <%= dateFormat.format(contract.getJobDepositADate())%>
                    </p>
                    <p>+ Bên B đặt cọc: <%= vndFormat.format(contract.getJobDepositB())%> VNĐ (bằng chữ:<%= contract.getJobDepositBText()%>) vào ngày <%= dateFormat.format(contract.getJobDepositBDate())%>
                    </p>
                    <p>- Sau khi đã đặt cọc, các bên không được phép rút lại tiền đặt cọc với bất kỳ lý do gì trừ
                        khi được quy định trong hợp đồng này.</p>
                    <p>- Việc xử lý tiền đặt cọc sẽ tuân theo các điều khoản liên quan đến việc hoàn thành công
                        việc, vi phạm hợp đồng hoặc chấm dứt hợp đồng như đã quy định tại Điều 2.4, Điều 3.3 và Điều
                        6 của hợp đồng này.</p>
                    <p>- Bên C có nghĩa vụ phải đảm bảo số tiền đã đặt cọc của Bên A và Bên B. Bên C sẽ phải chịu
                        hoàn toàn trách nhiệm nếu số tiền xảy ra mất mát.</p>
                    <p>- Bên C có nghĩa vụ phải đảm bảo số tiền đã đặt cọc của Bên A và Bên B. Bên C sẽ phải chịu
                        hoàn toàn trách nhiệm nếu số tiền xảy ra mất mát.</p>

                    <p class="section-subtitle">3.5. Sau khi công việc hoàn thành:</p>
                    <p>+ Số tiền đặt cọc của Bên A sẽ được dùng để trả tiền lương cho Bên B sau khi Bên B hoàn tất
                        công việc theo đúng yêu cầu công việc đã nêu ở Điều 1.</p>
                    <p>+ Số tiền đặt cọc của Bên B sẽ được hoàn trả lại cho Bên B.</p>
                    <p>- Trường hợp không hoàn thành công việc hoặc vi phạm hợp đồng:</p>
                    <p>+ Nếu Bên B không hoàn thành công việc theo đúng yêu cầu và thời hạn, số tiền đặt cọc của Bên
                        B sẽ bị xử lý theo quy định tại Điều 2.4.</p>
                    <p>+ Nếu Bên A không thanh toán đúng hạn sau khi công việc hoàn thành, số tiền đặt cọc của Bên A
                        sẽ bị xử lý theo quy định tại Điều 3.3.</p>

                    <div class="section-title-contract">ĐIỀU 4. QUYỀN VÀ NGHĨA VỤ CỦA CÁC BÊN</div>
                    <p class="section-subtitle">4.1. Quyền và nghĩa vụ của Bên A:</p>
                    <p>- Quyền của Bên A:</p>
                    <p>+ Yêu cầu Bên B thực hiện đúng công việc đã thỏa thuận theo đúng thời gian trong hợp đồng;
                    </p>
                    <p>+ Đơn phương chấm dứt hợp đồng và yêu cầu bồi thường thiệt hại theo quy định của pháp luật và
                        thỏa thuận trong hợp đồng này (Điều 2.4);</p>
                    <p>+ Các quyền khác theo quy định của pháp luật.</p>
                    <p>- Nghĩa vụ của Bên A:</p>
                    <p>+ Thanh toán đầy đủ và đúng hạn cho Bên B theo đúng thỏa thuận trong hợp đồng này;</p>
                    <p>+ Tạo điều kiện để Bên B hoàn thành công việc theo thỏa thuận;</p>
                    <p>+ Khấu trừ 10% phí dịch vụ của Bên B để đóng thuế TNCN đối với các khoản thu nhập từ
                        2.000.000 VNĐ trở lên;</p>
                    <p>+ Kê khai, đóng thuế TNCN cho Bên B trong phạm vi liên quan đến hợp đồng này;</p>
                    <p>+ Là người chịu trách nhiệm kê khai, nộp thuế TNCN đã khấu trừ cho cơ quan thuế theo quy
                        định, và cung cấp cho Bên B chứng từ khấu trừ thuế TNCN (nếu Bên B yêu cầu);</p>
                    <p>+ Các nghĩa vụ khác theo quy định của pháp luật.</p>

                    <p class="section-subtitle">4.2. Quyền và nghĩa vụ của Bên B:</p>
                    <p>- Quyền của Bên B:</p>
                    <p>+ Yêu cầu Bên A thanh toán đầy đủ và đúng hạn cho Bên B;</p>
                    <p>+ Yêu cầu Bên A trích phí dịch vụ để đóng thuế TNCN cho Bên B;</p>
                    <p>+ Đơn phương chấm dứt hợp đồng và yêu cầu bồi thường thiệt hại theo quy định của pháp luật và
                        thỏa thuận trong hợp đồng này;</p>
                    <p>+ Các quyền lợi khác theo quy định của pháp luật.</p>
                    <p>- Nghĩa vụ của Bên B:</p>
                    <p>+ Thực hiện các công việc đúng yêu cầu, thời gian, địa điểm và chất lượng theo thỏa thuận;
                    </p>
                    <p>+ Chịu sự kiểm tra của Bên A và phải báo cáo thường xuyên công việc cho Bên A;</p>
                    <p>+ Có trách nhiệm bảo mật thông tin trong thời gian thực hiện công việc;</p>
                    <p>+ Bảo quản, giao lại cho bên A tài liệu, phương tiện được giao để hoàn thành công việc;</p>
                    <p>+ Bồi thường thiệt hại trong trường hợp làm mất, hư hỏng tài liệu, phương tiện được giao để
                        thực hiện công việc hoặc khi tiết lộ thông tin bí mật của bên A.</p>
                    <p>+ Các nghĩa vụ khác theo quy định của pháp luật.</p>

                    <div class="section-title-contract">ĐIỀU 5. THANH LÝ HỢP ĐỒNG</div>
                    <p class="section-subtitle">5.1. Hợp đồng chấm dứt khi hết thời hạn hợp đồng hoặc khi các bên
                        hoàn thành quyền và nghĩa
                        vụ với nhau và không có thỏa thuận gia hạn khác;</p>
                    <p class="section-subtitle">5.2. Nếu trong quá trình thực hiện hợp đồng, hai bên thỏa thuận được
                        với nhau về việc chấm
                        dứt hợp đồng, hợp đồng này sẽ chấm dứt kể từ thời điểm đạt được thỏa thuận giữa hai bên.</p>
                    <p class="section-subtitle">5.3. Hợp đồng chấm dứt khi một trong hai bên đơn phương chấm dứt hợp
                        đồng theo quy định của
                        pháp luật và hợp đồng này.</p>

                    <div class="section-title-contract">ĐIỀU 6. ĐƠN PHƯƠNG CHẤM DỨT HỢP ĐỒNG</div>
                    <p class="section-subtitle">6.1. Các bên không được đơn phương chấm dứt hợp đồng trừ những
                        trường hợp do pháp luật quy
                        định. Bên đơn phương chấm dứt hợp đồng phải bồi thường số tiền đã đặt cọc cho công việc bao
                        gồm 3% tiền chiết khấu cho hệ thống và số tiền còn lại cho bên còn lại.</p>
                    <p class="section-subtitle">6.2. Một bên được quyền đơn phương chấm dứt hợp đồng mà không phải
                        bồi thường thiệt hại nếu
                        bên còn lại vi phạm nghiêm trọng nghĩa vụ trong hợp đồng tại Điều 2.4 và Điều 3.3 hoặc những
                        trường hợp pháp luật có quy định. Bên đơn phương chấm dứt hợp đồng có trách nhiệm chứng minh
                        được lỗi của bên kia. Chi phí kiểm tra, chứng minh lỗi vi phạm và thiệt hại gây ra do bên có
                        vi phạm nghĩa vụ chi trả.</p>
                    <p>Trường hợp đơn phương chấm dứt hợp đồng, bên đã thực hiện nghĩa vụ có quyền yêu cầu bên kia
                        thanh toán hoặc hoàn trả phần nghĩa vụ đã thực hiện.</p>

                    <div class="section-title-contract">ĐIỀU 7. BẢO MẬT THÔNG TIN</div>
                    <p class="section-subtitle">7.1. Hai bên không được tiết lộ cho bên thứ ba những thông tin, tài
                        liệu liên quan đến hợp
                        đồng này, trừ trường hợp được sự chấp thuận bằng văn bản của bên còn lại hoặc theo yêu cầu
                        của cơ quan nhà nước có thẩm quyền.</p>
                    <p class="section-subtitle">7.2. Trong khi thực hiện và sau khi hợp đồng này chấm dứt hoặc nếu
                        xảy ra tranh chấp, điều
                        khoản này vẫn sẽ còn hiệu lực pháp lý.</p>
                    <p>- Trường hợp một bên vi phạm điều khoản này, bên còn lại có quyền đơn phương chấm dứt hợp
                        đồng và yêu cầu bồi thường thiệt hại (nếu có).</p>

                    <div class="section-title-contract">ĐIỀU 8. PHÍ DỊCH VỤ NỀN TẢNG</div>
                    <p class="section-subtitle">8.1. Phí dịch vụ nền tảng: Bên C (Nền tảng JobTrans) trong bất kì
                        trường hợp nào được quyền
                        trích 3% tổng giá trị hợp đồng làm phí dịch vụ sử dụng nền tảng.</p>
                    <p class="section-subtitle">8.2. Trách nhiệm thanh toán phí dịch vụ: Bên A và Bên B đồng ý thanh
                        toán phí dịch vụ nền
                        tảng như sau:</p>
                    <p>- Bên A và Bên B chịu trách nhiệm thanh toán 3% tổng giá trị hợp đồng (bao gồm các phí như
                        sau: thù lao bên A trả cho B và số tiền bên B đã cọc cho công việc)</p>
                    <p class="section-subtitle">8.3. Phương thức thanh toán: Phí dịch vụ nền tảng sẽ được khấu trừ
                        trực tiếp từ các khoản
                        thanh toán khi thực hiện giao dịch qua nền tảng JobTrans.</p>
                    <p class="section-subtitle">8.4. Phí dịch vụ nền tảng được áp dụng cho tất cả các giao dịch được
                        thực hiện thông qua nền
                        tảng JobTrans, bao gồm cả các khoản thanh toán ban đầu và các khoản thanh toán bổ sung (nếu
                        có).</p>

                    <div class="section-title-contract">ĐIỀU 9. QUYỀN SỞ HỮU TRÍ TUỆ VÀ BẢN QUYỀN</div>
                    <p class="section-subtitle">9.1. Quyền sở hữu sản phẩm:</p>
                    <p>- Tất cả các sản phẩm, kết quả, tài liệu được tạo ra bởi Bên B trong quá trình thực hiện hợp
                        đồng này (bao gồm nhưng không giới hạn ở: mã nguồn, thiết kế, hình ảnh, văn bản, ý tưởng,
                        thuật toán...) sẽ thuộc quyền sở hữu của Bên A sau khi Bên A hoàn tất thanh toán đầy đủ.</p>
                    <p>- Bên B cam kết không sử dụng, sao chép, phân phối, chuyển nhượng hoặc khai thác thương mại
                        các sản phẩm này sau khi đã chuyển giao cho Bên A.</p>
                    <p class="section-subtitle">9.2. Chuyển giao quyền sở hữu:</p>
                    <p>- Việc chuyển giao quyền sở hữu trí tuệ từ Bên B sang Bên A sẽ được thực hiện tự động sau khi
                        Bên A hoàn tất thanh toán đầy đủ theo Điều 3 của hợp đồng.</p>
                    <p>- Bên B có trách nhiệm bàn giao đầy đủ tất cả các tài liệu, mã nguồn, thiết kế và các tài
                        liệu liên quan khác cho Bên A trong vòng 03 ngày làm việc sau khi hoàn thành công việc.</p>
                    <p>- Bên B cam kết xóa hoặc không sử dụng các tài liệu này sau khi đã chuyển giao cho Bên A, trừ
                        trường hợp được Bên A đồng ý bằng văn bản.</p>
                    <p class="section-subtitle">9.3. Cam kết về tính nguyên gốc:</p>
                    <p>- Bên B cam kết rằng tất cả các sản phẩm, kết quả được tạo ra trong quá trình thực hiện hợp
                        đồng là nguyên gốc, không vi phạm quyền sở hữu trí tuệ của bất kỳ bên thứ ba nào.</p>
                    <p>- Trong trường hợp phát sinh khiếu nại, khiếu kiện từ bên thứ ba về vấn đề quyền sở hữu trí
                        tuệ đối với các sản phẩm do Bên B tạo ra, Bên B có trách nhiệm giải quyết và bồi thường mọi
                        thiệt hại phát sinh cho Bên A.</p>
                    <p class="section-subtitle">9.4. Quyền giữ lại của Bên B:</p>
                    <p>- Bên B được phép đưa các sản phẩm đã tạo ra vào portfolio cá nhân chỉ với mục đích tham
                        khảo, sau khi được sự đồng ý bằng văn bản của Bên A.</p>
                    <p>- Việc sử dụng các sản phẩm này trong portfolio phải tuân thủ các điều khoản bảo mật được quy
                        định tại Điều 7 của hợp đồng này. </p>

                    <div class="section-title-contract">ĐIỀU 10. BẤT KHẢ KHÁNG VÀ RỦI RO CÔNG NGHỆ</div>
                    <p class="section-subtitle">10.1. Định nghĩa sự kiện bất khả kháng:</p>
                    <p>- Sự kiện bất khả kháng bao gồm nhưng không giới hạn ở: chiến tranh, nổi loạn, bạo động, đình
                        công, thiên tai (bão, lũ lụt, động đất, cháy nổ...), dịch bệnh, phong tỏa, các quyết định
                        của cơ quan nhà nước có thẩm quyền hoặc các sự kiện khác nằm ngoài tầm kiểm soát hợp lý của
                        các bên.</p>
                    <p class="section-subtitle">10.2. Xử lý khi xảy ra sự kiện bất khả kháng:</p>
                    <p>- Khi xảy ra sự kiện bất khả kháng, bên bị ảnh hưởng phải thông báo bằng văn bản cho bên còn
                        lại trong vòng 03 ngày làm việc kể từ khi sự kiện xảy ra.</p>
                    <p>- Thời gian thực hiện hợp đồng sẽ được gia hạn tương ứng với thời gian kéo dài của sự kiện
                        bất khả kháng.</p>
                    <p>- Nếu sự kiện bất khả kháng kéo dài trên 30 ngày, các bên có quyền đàm phán lại các điều
                        khoản hợp đồng hoặc chấm dứt hợp đồng mà không phải bồi thường thiệt hại.</p>
                    <p class="section-subtitle">10.3. Rủi ro công nghệ và sự cố kỹ thuật:</p>
                    <p>- Rủi ro công nghệ bao gồm: sự cố máy chủ, sự cố hệ thống của nền tảng JobTrans, mất kết nối
                        internet, mất điện kéo dài, tấn công mạng, và các sự cố kỹ thuật khác ảnh hưởng đến khả năng
                        hoàn thành công việc.</p>
                    <p>- Khi xảy ra sự cố kỹ thuật trên nền tảng JobTrans, Bên C có trách nhiệm:</p>
                    <p>+ Thông báo ngay cho Bên A và Bên B về tình trạng sự cố.</p>
                    <p>+ Nỗ lực khắc phục sự cố trong thời gian sớm nhất.</p>
                    <p>+ Gia hạn thời gian thực hiện hợp đồng tương ứng với thời gian khắc phục sự cố.</p>
                    <p>- Trường hợp mất dữ liệu do lỗi của nền tảng, Bên C có trách nhiệm khôi phục dữ liệu và bồi
                        thường thiệt hại (nếu có) cho các bên liên quan theo quy định của pháp luật.</p>
                    <p class="section-subtitle">10.4. Xử lý lỗi giao dịch thanh toán:</p>
                    <p>- Khi phát sinh lỗi giao dịch thanh toán, các bên có trách nhiệm thông báo ngay cho Bên C.
                    </p>
                    <p>- Bên C có trách nhiệm xác minh và xử lý các lỗi giao dịch trong vòng 48 giờ làm việc kể từ
                        khi nhận được thông báo.</p>
                    <p>- Trong trường hợp thanh toán bị chậm trễ do lỗi hệ thống của Bên C, các bên được miễn trừ
                        trách nhiệm về việc chậm thanh toán và không bị áp dụng các điều khoản phạt liên quan.</p>

                    <div class="section-title-contract">ĐIỀU 11. CƠ CHẾ GIẢI QUYẾT KHIẾU NẠI</div>
                    <p class="section-subtitle">11.1. Vai trò của nền tảng JobTrans:</p>
                    <p>- Bên C (Nền tảng JobTrans) đóng vai trò trung gian trong việc giải quyết các tranh chấp phát
                        sinh giữa Bên A và Bên B liên quan đến việc thực hiện hợp đồng.</p>
                    <p>- Bên C có quyền can thiệp và đưa ra quyết định cuối cùng trong trường hợp Bên A và Bên B
                        không thể đạt được thỏa thuận, dựa trên các điều khoản của hợp đồng và chính sách của nền
                        tảng.</p>
                    <p>- Quyết định của Bên C có hiệu lực ràng buộc đối với các bên, trừ trường hợp các bên có bằng
                        chứng rõ ràng về việc quyết định đó vi phạm pháp luật hoặc các điều khoản hợp đồng.</p>

                    <p class="section-subtitle">11.2. Quy trình khiếu nại và phản hồi:</p>
                    <p>- Bên khiếu nại phải gửi văn bản khiếu nại đến Bên C trong vòng 07 ngày làm việc kể từ khi
                        phát sinh vấn đề, nêu rõ nội dung khiếu nại và các bằng chứng liên quan.</p>
                    <p>- Bên C sẽ xác nhận đã nhận khiếu nại trong vòng 24 giờ và thông báo cho bên còn lại.</p>
                    <p>- Bên bị khiếu nại có quyền phản hồi trong vòng 03 ngày làm việc kể từ khi nhận thông báo từ
                        Bên C.</p>
                    <p>- Bên C sẽ xem xét các bằng chứng và đưa ra quyết định trong vòng 07 ngày làm việc kể từ khi
                        nhận đủ thông tin từ cả hai bên.</p>

                    <p class="section-subtitle">11.3. Xử lý khiếu nại về chất lượng công việc:</p>
                    <p>- Trong trường hợp Bên A khiếu nại về chất lượng công việc của Bên B, Bên C sẽ đánh giá dựa
                        trên các yêu cầu đã nêu của khiếu nại.</p>
                    <p>- Nếu khiếu nại được xác nhận là hợp lý, Bên B có trách nhiệm chỉnh sửa, hoàn thiện công việc
                        trong thời hạn do Bên C quy định, hoặc hoàn trả tiền cọc hoặc toàn bộ phí dịch vụ tùy theo
                        mức độ vi phạm kèm theo bị trừ điểm trên nền tảng.</p>
                    <p>- Nếu khiếu nại không được xác nhận, Bên A vẫn phải thực hiện đầy đủ nghĩa vụ thanh toán theo
                        hợp đồng.</p>
                    <p>- Tiêu chí đánh giá chất lượng công việc được xác định dựa trên:</p>
                    <ul>
                        <li>Sự phù hợp với yêu cầu cụ thể đã nêu tại Điều 1.2 của hợp đồng.</li>
                        <li>Sự tuân thủ các thông số kỹ thuật, tiêu chuẩn ngành và quy định pháp luật liên quan.
                        </li>
                        <li>Tính đầy đủ của các thành phần, chức năng theo yêu cầu.</li>
                        <li>Độ hoàn thiện và chất lượng kỹ thuật của sản phẩm.</li>
                        <li>Khả năng đáp ứng mục tiêu sử dụng của Bên A.</li>
                    </ul>
                    <p>- Bên C sẽ thành lập hội đồng đánh giá gồm ít nhất 2 chuyên gia trong lĩnh vực liên quan để
                        đánh giá khách quan khi có khiếu nại về chất lượng.</p>

                    <p class="section-subtitle">11.4. Xử lý khiếu nại về thanh toán:</p>
                    <p>- Trong trường hợp Bên B khiếu nại về việc thanh toán của Bên A, Bên C sẽ xác minh tình trạng
                        thanh toán và thông báo kết quả cho các bên.</p>
                    <p>- Nếu Bên A chậm thanh toán mà không có lý do chính đáng, Bên C có quyền áp dụng các biện
                        pháp xử lý theo quy định tại Điều 3.3 của hợp đồng.</p>
                    <p>- Bên C có thể sử dụng số tiền đặt cọc để thanh toán cho Bên B trong trường hợp xác định Bên
                        A vi phạm nghĩa vụ thanh toán.</p>

                    <div class="section-title-contract">ĐIỀU 12. ÁP DỤNG QUY CHẾ ĐIỂM CỘNG TRÊN NỀN TẢNG</div>
                    <p class="section-subtitle">12.1. Tuân thủ quy chế điểm:</p>
                    <p>- Các bên xác nhận đã đọc, hiểu rõ và đồng ý tuân thủ "Quy chế Điểm Uy tín" hiện hành trên
                        nền tảng JobTrans.</p>
                    <p>- Quy chế này là một phần không tách rời của hợp đồng này và có hiệu lực ràng buộc đối với
                        các bên.</p>

                    <p class="section-subtitle">12.2. Phạm vi áp dụng:</p>
                    <p>- Việc tích lũy, trừ điểm và các quyền lợi liên quan sẽ được thực hiện theo đúng Quy chế Điểm
                        Uy tín của nền tảng.</p>
                    <p>- Trong trường hợp có sự khác biệt giữa điều khoản trong hợp đồng này và Quy chế Điểm Uy tín,
                        quy định trong hợp đồng sẽ được ưu tiên áp dụng.</p>

                    <p class="section-subtitle">12.3. Cập nhật quy chế:</p>
                    <p>- Quy chế Điểm Uy tín có thể được Bên C cập nhật theo thời gian, việc cập nhật sẽ được thông
                        báo cho các bên và có hiệu lực sau 07 ngày kể từ ngày thông báo.</p>
                    <p>- Các thay đổi trong Quy chế không áp dụng hồi tố đối với các hợp đồng đã ký kết trước thời
                        điểm thay đổi có hiệu lực.</p>

                    <p class="section-subtitle">12.4. Tra cứu và xác nhận điểm:</p>
                    <p>- Các bên có thể tra cứu số điểm hiện tại của mình thông qua tài khoản cá nhân trên nền tảng
                        JobTrans.</p>
                    <p>- Bên C có trách nhiệm đảm bảo tính chính xác và minh bạch của hệ thống điểm.</p>

                    <div class="section-title-contract">ĐIỀU 13. ĐIỀU KHOẢN CHUNG</div>
                    <p>- Hai bên cam kết thực hiện đầy đủ các điều khoản của hợp đồng này. Nếu tranh chấp phát sinh
                        trong quá trình thực hiện hợp đồng sẽ được giải quyết bằng thương lượng và hòa giải. Trường
                        hợp các bên thương lượng, hòa giải không thành, tranh chấp sẽ được giải quyết tại Tòa án
                        nhân dân.</p>
                    <!-- Tôi đã cắt bớt nội dung cho ngắn gọn, bạn có thể thêm đầy đủ nội dung từ file gốc -->

                    <div class="signature-area-contract-a">
                        <div class="signature-box-a">
                            <div class="signature-title">NGƯỜI LAO ĐỘNG</div>
                            <div class="signature-note">(Ký, ghi rõ họ tên)</div>
                            <div class="signature-date-a"><fmt:formatDate value="${now}" pattern="'Ngày' dd 'Tháng' MM 'Năm' yyyy" /></div>
                            <%
                                String bSignature = contract.getbSignature();
                                if (bSignature != null && !bSignature.isEmpty()) {
                            %>
                            <div class="signature-img">
                            </div>
                            <%
                                }
                            %>
                            <div class="signature-name"><strong><%= contract.getbName()%></strong></div>
                        </div>
                        <br>
                        <div class="signature-box-a">
                            <div class="signature-title">NGƯỜI SỬ DỤNG LAO ĐỘNG</div>
                            <div class="signature-note">(Ký, ghi rõ họ tên)</div>
                            <div class="signature-date-a"><fmt:formatDate value="${now}" pattern="'Ngày' dd 'Tháng' MM 'Năm' yyyy" /></div>
                            <%
                                String aSignature = contract.getaSignature();
                                if (aSignature != null && !aSignature.isEmpty()) {
                            %>
                            <div class="signature-img">
                            </div>
                            <%
                                }
                            %>
                            <div class="signature-name"><strong><%= contract.getaName()%></strong></div>
                        </div>
                        <div class="signature-box-a">
                            <div class="signature-title">ĐẠI DIỆN NỀN TẢNG</div>
                            <div class="signature-note">(Ký, ghi rõ họ tên)</div>
                            <div class="signature-date-a"><fmt:formatDate value="${now}" pattern="'Ngày' dd 'Tháng' MM 'Năm' yyyy" /></div>

                            <div class="signature-img">
                                <img src="img/contract/signature-My-Duyen.jpg" alt="Chữ ký">
                            </div>
                            <div class="signature-JobTrans">
                                <img src="img/contract/signature-JobTrans.jpg" alt="Con dấu">
                            </div>
                            <div class="signature-name"><strong>Võ Thị Mỹ Duyên</strong></div>
                        </div>
                    </div>
                    <div class="footer-pdf">
                        <p>Hợp đồng dịch vụ JobTrans - Mã hợp đồng: CON-2025-0001</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Mở popup khi nhấn nút
    document.getElementById('openPopupBtn').addEventListener('click', function() {
        document.getElementById('contractPopup').style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Ngăn không cho cuộn trang khi popup đang mở
    });

    // Đóng popup
    document.getElementById('closePopupBtn').addEventListener('click', function() {
        document.getElementById('contractPopup').style.display = 'none';
        document.body.style.overflow = 'auto'; // Cho phép cuộn trang trở lại
    });

    // Đóng popup khi nhấn ra ngoài
    window.addEventListener('click', function(event) {
        if (event.target === document.getElementById('contractPopup')) {
            document.getElementById('contractPopup').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    });
</script>

<%--<script>--%>
<%--    // Giả lập database chữ ký--%>
<%--    const signatureDatabase = {--%>
<%--        // Đây là nơi giả lập việc lưu trữ chữ ký--%>
<%--        // Trong trường hợp thực tế, bạn sẽ lấy từ API hoặc database thực--%>
<%--        'employer': null, // Null nghĩa là chưa có chữ ký--%>
<%--        'freelancer': 'https://api.placeholder.com/400/150?text=Chu+ky+Freelancer'--%>
<%--    };--%>

<%--    // Các phần tử DOM--%>
<%--    const employerSignatureContainer = document.getElementById('employer-signature');--%>
<%--    const freelancerSignatureContainer = document.getElementById('freelancer-signature');--%>
<%--    const employerSignatureImage = document.getElementById('employer-signature-image');--%>
<%--    const freelancerSignatureImage = document.getElementById('freelancer-signature-image');--%>
<%--    const employerPlaceholder = employerSignatureContainer.querySelector('.signature-placeholder');--%>
<%--    const freelancerPlaceholder = freelancerSignatureContainer.querySelector('.signature-placeholder');--%>
<%--    const clearEmployerBtn = document.getElementById('clear-employer-signature');--%>
<%--    const clearFreelancerBtn = document.getElementById('clear-freelancer-signature');--%>
<%--    const popup = document.getElementById('signature-popup');--%>
<%--    const createSignatureBtn = document.getElementById('create-signature-btn');--%>
<%--    const closePopupBtn = document.getElementById('close-popup-btn');--%>

<%--    // Function để lấy chữ ký từ database--%>
<%--    function getSignatureFromDatabase(role) {--%>
<%--        return signatureDatabase[role];--%>
<%--    }--%>

<%--    // Function để hiển thị chữ ký--%>
<%--    function displaySignature(role, imageElement, placeholderElement) {--%>
<%--        const signatureUrl = getSignatureFromDatabase(role);--%>

<%--        if (signatureUrl) {--%>
<%--            // Nếu có chữ ký, hiển thị nó--%>
<%--            imageElement.src = signatureUrl;--%>
<%--            imageElement.style.display = 'block';--%>
<%--            placeholderElement.style.display = 'none';--%>
<%--            return true;--%>
<%--        }--%>

<%--        // Nếu không có chữ ký, giữ nguyên placeholder--%>
<%--        imageElement.style.display = 'none';--%>
<%--        placeholderElement.style.display = 'flex';--%>
<%--        return false;--%>
<%--    }--%>

<%--    // Function để hiển thị popup--%>
<%--    function showPopup() {--%>
<%--        popup.style.display = 'flex';--%>
<%--    }--%>

<%--    // Function để ẩn popup--%>
<%--    function hidePopup() {--%>
<%--        popup.style.display = 'none';--%>
<%--    }--%>

<%--    // Function để xử lý việc tạo chữ ký mới--%>
<%--    function createNewSignature() {--%>
<%--        // Trong thực tế, bạn sẽ chuyển hướng đến trang tạo chữ ký--%>
<%--        // Đây chỉ là ví dụ--%>
<%--        alert('Đang chuyển hướng đến trang tạo chữ ký...');--%>
<%--        window.location.href = '/create-signature'; // Thay đổi URL này theo ứng dụng của bạn--%>
<%--    }--%>

<%--    // Xử lý sự kiện khi người dùng nhấp vào phần chữ ký--%>
<%--    employerSignatureContainer.addEventListener('click', function() {--%>
<%--        // Kiểm tra xem có chữ ký trong database không--%>
<%--        if (!displaySignature('employer', employerSignatureImage, employerPlaceholder)) {--%>
<%--            // Nếu không có, hiển thị popup--%>
<%--            showPopup();--%>
<%--        }--%>
<%--    });--%>

<%--    freelancerSignatureContainer.addEventListener('click', function() {--%>
<%--        if (!displaySignature('freelancer', freelancerSignatureImage, freelancerPlaceholder)) {--%>
<%--            showPopup();--%>
<%--        }--%>
<%--    });--%>

<%--    // Xử lý sự kiện khi người dùng nhấp vào nút xóa chữ ký--%>
<%--    clearEmployerBtn.addEventListener('click', function() {--%>
<%--        employerSignatureImage.style.display = 'none';--%>
<%--        employerPlaceholder.style.display = 'flex';--%>
<%--        // Trong thực tế, bạn sẽ gọi API để xóa chữ ký--%>
<%--        signatureDatabase['employer'] = null;--%>
<%--    });--%>

<%--    clearFreelancerBtn.addEventListener('click', function() {--%>
<%--        freelancerSignatureImage.style.display = 'none';--%>
<%--        freelancerPlaceholder.style.display = 'flex';--%>
<%--        // Trong thực tế, bạn sẽ gọi API để xóa chữ ký--%>
<%--        signatureDatabase['freelancer'] = null;--%>
<%--    });--%>

<%--    // Xử lý sự kiện khi người dùng nhấp vào nút trong popup--%>
<%--    createSignatureBtn.addEventListener('click', function() {--%>
<%--        hidePopup();--%>
<%--        createNewSignature();--%>
<%--    });--%>

<%--    closePopupBtn.addEventListener('click', function() {--%>
<%--        hidePopup();--%>
<%--    });--%>

<%--    // Khởi tạo trang - kiểm tra và hiển thị chữ ký nếu có--%>
<%--    document.addEventListener('DOMContentLoaded', function() {--%>
<%--        displaySignature('employer', employerSignatureImage, employerPlaceholder);--%>
<%--        displaySignature('freelancer', freelancerSignatureImage, freelancerPlaceholder);--%>
<%--    });--%>
<%--</script>--%>

<%--<script>--%>
<%--    // Xử lý hiển thị tên file khi upload--%>
<%--    document.getElementById('id-front').addEventListener('change', function(e) {--%>
<%--        if (e.target.files.length > 0) {--%>
<%--            document.getElementById('id-front-name').textContent = e.target.files[0].name;--%>
<%--        }--%>
<%--    });--%>

<%--    document.getElementById('id-back').addEventListener('change', function(e) {--%>
<%--        if (e.target.files.length > 0) {--%>
<%--            document.getElementById('id-back-name').textContent = e.target.files[0].name;--%>
<%--        }--%>
<%--    });--%>

<%--    // Xử lý canvas chữ ký--%>
<%--    document.addEventListener('DOMContentLoaded', function() {--%>
<%--        const employerCanvas = document.getElementById('employer-signature');--%>
<%--        const freelancerCanvas = document.getElementById('freelancer-signature');--%>

<%--        // Khởi tạo canvas chữ ký cho Bên A--%>
<%--        const setupSignature = (container, clearButton) => {--%>
<%--            let isDrawing = false;--%>
<%--            let lastX = 0;--%>
<%--            let lastY = 0;--%>

<%--            // Tạo canvas element--%>
<%--            const canvas = document.createElement('canvas');--%>
<%--            canvas.width = container.offsetWidth;--%>
<%--            canvas.height = container.offsetHeight;--%>
<%--            canvas.style.display = 'none';--%>
<%--            canvas.style.position = 'absolute';--%>
<%--            canvas.style.top = '0';--%>
<%--            canvas.style.left = '0';--%>
<%--            canvas.style.width = '100%';--%>
<%--            canvas.style.height = '100%';--%>
<%--            canvas.style.cursor = 'crosshair';--%>

<%--            container.appendChild(canvas);--%>
<%--            const ctx = canvas.getContext('2d');--%>

<%--            // Sự kiện mousedown/touchstart--%>
<%--            const startDrawing = (e) => {--%>
<%--                isDrawing = true;--%>
<%--                container.querySelector('.signature-placeholder').style.display = 'none';--%>
<%--                canvas.style.display = 'block';--%>

<%--                const rect = canvas.getBoundingClientRect();--%>
<%--                const x = (e.clientX || e.touches[0].clientX) - rect.left;--%>
<%--                const y = (e.clientY || e.touches[0].clientY) - rect.top;--%>

<%--                lastX = x;--%>
<%--                lastY = y;--%>
<%--            };--%>

<%--            // Sự kiện mousemove/touchmove--%>
<%--            const draw = (e) => {--%>
<%--                if (!isDrawing) return;--%>
<%--                e.preventDefault();--%>

<%--                const rect = canvas.getBoundingClientRect();--%>
<%--                const x = (e.clientX || e.touches[0].clientX) - rect.left;--%>
<%--                const y = (e.clientY || e.touches[0].clientY) - rect.top;--%>

<%--                ctx.beginPath();--%>
<%--                ctx.moveTo(lastX, lastY);--%>
<%--                ctx.lineTo(x, y);--%>
<%--                ctx.strokeStyle = '#152070';--%>
<%--                ctx.lineWidth = 2;--%>
<%--                ctx.lineCap = 'round';--%>
<%--                ctx.stroke();--%>

<%--                lastX = x;--%>
<%--                lastY = y;--%>
<%--            };--%>

<%--            // Sự kiện mouseup/touchend--%>
<%--            const stopDrawing = () => {--%>
<%--                isDrawing = false;--%>
<%--            };--%>

<%--            // Gán sự kiện cho canvas--%>
<%--            container.addEventListener('mousedown', startDrawing);--%>
<%--            container.addEventListener('touchstart', startDrawing);--%>
<%--            document.addEventListener('mousemove', draw);--%>
<%--            document.addEventListener('touchmove', draw, { passive: false });--%>
<%--            document.addEventListener('mouseup', stopDrawing);--%>
<%--            document.addEventListener('touchend', stopDrawing);--%>

<%--            // Xóa chữ ký--%>
<%--            document.getElementById(clearButton).addEventListener('click', function() {--%>
<%--                ctx.clearRect(0, 0, canvas.width, canvas.height);--%>
<%--                container.querySelector('.signature-placeholder').style.display = 'flex';--%>
<%--                canvas.style.display = 'none';--%>
<%--            });--%>
<%--        };--%>

<%--        // Khởi tạo chữ ký cho cả hai bên--%>
<%--        setupSignature(employerCanvas, 'clear-employer-signature');--%>
<%--        setupSignature(freelancerCanvas, 'clear-freelancer-signature');--%>

<%--        // Xử lý form submit--%>
<%--        document.getElementById('contract-signing-form').addEventListener('submit', function(e) {--%>
<%--            e.preventDefault();--%>

<%--            // Kiểm tra chữ ký và các trường bắt buộc--%>
<%--            // Sau đó chuyển đến màn hình hoàn thành--%>

<%--            alert('Hợp đồng đã được ký kết thành công!');--%>
<%--            // Chuyển hướng đến trang hoàn thành--%>
<%--            // window.location.href = 'contract-complete.jsp';--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>
</body>
</html>