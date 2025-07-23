<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JobTrans</title>
    <link rel="stylesheet" href="css/infor-job-contract.css">
    <jsp:useBean id="jobCategoryDAO" class="jobtrans.dal.JobCategoryDAO" scope="page"/>
    <jsp:useBean id="tagDAO" class="jobtrans.dal.TagDAO" scope="page"/>
    <style>
        /* Buttons */
        .btn-container {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }

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
                    <div class="contract-status status-active">Đang thực hiện</div>
                </div>

                <c:if test="${sessionScope.sessionAccount.accountId == poster.accountId}">
                    <div class="contract-progress">
                        <div class="progress-step active">
                            <div class="step-number">1</div>
                            <div class="step-label">Thông tin dự án</div>
                        </div>
                        <div class="progress-step">
                            <div class="step-number">2</div>
                            <div class="step-label">Điều khoản</div>
                        </div>
                        <div class="progress-step">
                            <div class="step-number">3</div>
                            <div class="step-label">Ký kết</div>
                        </div>
                        <div class="progress-step">
                            <div class="step-number">4</div>
                            <div class="step-label">Hoàn thành</div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${sessionScope.sessionAccount.accountId == jobSeeker.accountId}">
                    <div class="contract-progress">
                        <div class="progress-step active">
                            <div class="step-number">1</div>
                            <div class="step-label">Thông tin dự án</div>
                        </div>
                        <div class="progress-step">
                            <div class="step-number">2</div>
                            <div class="step-label">Ký kết</div>
                        </div>
                        <div class="progress-step">
                            <div class="step-number">3</div>
                            <div class="step-label">Hoàn thành</div>
                        </div>
                    </div>
                </c:if>

                <div class="contract-body">
                    <div class="form-section">
                        <div class="section-title">Thông tin công việc cơ bản</div>
                        <div class="info-group">
                            <div class="info-label">Tên dự án</div>
                            <div class="info-value">${job.jobTitle}</div>
                        </div>

<%--                        <div class="form-row">--%>
<%--                            <div class="form-col">--%>
<%--                                <div class="info-group">--%>
<%--                                    <div class="info-label">Loại dự án</div>--%>
<%--                                    <div class="info-value">${jobCategoryDAO.getCategoryById(job.categoryId)}</div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                            <div class="form-col">--%>
<%--                                <div class="info-group">--%>
<%--                                    <div class="info-label">Danh mục</div>--%>
<%--                                    <div class="info-value">${tagDAO.getTagsByJobId(job.jobId)}</div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

                        <div class="info-group">
                            <div class="info-label">Mô tả dự án</div>
                            <div class="info-value">${job.jobDescription}
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Thông tin người tuyển dụng<strong>(Bên A)</strong></div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Tên công ty</div>
                                    <div class="info-value">${poster.accountName}</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Địa chỉ</div>
                                    <div class="info-value">${poster.address}</div>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">${poster.email}</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value">${poster.phone}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Thông tin người làm việc<strong>(Bên B)</strong></div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Tên công ty</div>
                                    <div class="info-value">${jobSeeker.accountName}</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Địa chỉ</div>
                                    <div class="info-value">${jobSeeker.address}</div>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">${jobSeeker.email}</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value">${jobSeeker.phone}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Thông tin nền tảng JobTrans<strong>(Bên C)</strong></div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Tên công ty</div>
                                    <div class="info-value">Công ty TNHH JobTrans</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Người đại diện</div>
                                    <div class="info-value">Võ Thị Mỹ Duyên</div>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">jobtranship@gmail.com</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value">0900000000</div>
                                </div>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Địa chỉ</div>
                            <div class="info-value">Khu đô thị FPT City, Quận Ngũ Hành Sơn, TP. Đà Nẵng</div>
                        </div>
                    </div>

                    <%--                    <div class="form-section">--%>
                    <%--                        <div class="section-title">Yêu cầu kỹ năng</div>--%>
                    <%--                        <div class="info-group">--%>
                    <%--                            <div class="info-label">Kỹ năng yêu cầu</div>--%>
                    <%--                            <div class="skill-tags">--%>
                    <%--                                <div class="skill-tag">HTML/CSS</div>--%>
                    <%--                                <div class="skill-tag">JavaScript</div>--%>
                    <%--                                <div class="skill-tag">Responsive Design</div>--%>
                    <%--                                <div class="skill-tag">PHP</div>--%>
                    <%--                                <div class="skill-tag">MySQL</div>--%>
                    <%--                                <div class="skill-tag">WordPress/WooCommerce</div>--%>
                    <%--                            </div>--%>
                    <%--                        </div>--%>

                    <%--                        <div class="info-group">--%>
                    <%--                            <div class="info-label">Mức độ kinh nghiệm</div>--%>
                    <%--                            <div class="info-value">Cao cấp (3-5 năm)</div>--%>
                    <%--                        </div>--%>
                    <%--                    </div>--%>

                    <div class="form-section">
                        <div class="section-title">Thời gian và ngân sách</div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Ngày bắt đầu dự kiến</div>
                                    <div class="info-value">${joinDateFormatted}</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Ngày kết thúc dự kiến</div>
                                    <div class="info-value">${joinDateFormatted}</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Ngân sách</div>
                                    <div class="info-value">${budgetRange}</div>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="info-group">
                                    <div class="info-label">Hình thức thanh toán</div>
                                    <div class="info-value">Đặt cọc + Thanh toán lần cuối sau khi bàn giao dự án</div>
                                </div>
                            </div>
                        </div>

                        <div class="info-group">
                            <div class="info-label">Các giai đoạn thanh toán</div>
                            <div class="milestone-list">
                                <div class="milestone-item">
                                    <div class="milestone-header">
                                        <div class="milestone-name">Đặt cọc dự kiến (10%)</div>
                                        <div class="milestone-amount">15,000,000 VNĐ</div>
                                    </div>
                                    <div class="milestone-description">Thanh toán trước khi bắt đầu dự án</div>
                                    <div class="milestone-status pending">Đang thực hiện</div>
                                </div>

                                <%--================================Để sau các kì sau mở rộng thêm cho dự án==================================--%>
                                <%--                                <div class="milestone-item">--%>
                                <%--                                    <div class="milestone-header">--%>
                                <%--                                        <div class="milestone-name">Bàn giao giao diện</div>--%>
                                <%--                                        <div class="milestone-amount">15,000,000 VNĐ</div>--%>
                                <%--                                    </div>--%>
                                <%--                                    <div class="milestone-description">Sau khi hoàn thành và duyệt giao diện</div>--%>
                                <%--                                    <div class="milestone-status completed">Đã hoàn thành</div>--%>
                                <%--                                </div>--%>

                                <div class="milestone-item">
                                    <div class="milestone-header">
                                        <div class="milestone-name">Bàn giao hoàn thiện dự kiến (90%)</div>
                                        <div class="milestone-amount">15,000,000 VNĐ</div>
                                    </div>
                                    <div class="milestone-description">Sau khi hoàn thành toàn bộ chức năng và test</div>
                                    <div class="milestone-status active">Chưa bắt đầu</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Tài liệu đính kèm</div>
                        <div class="info-group">
                            <div class="info-label">Tài liệu liên quan</div>
                            <div class="uploaded-files">
                                <div class="file-item">
                                    <i class="fas fa-file-pdf"></i>
                                    <span class="file-name">${job.attachment}</span>
                                    <span class="download-file"><i class="fas fa-download"></i></span>
                                </div>

                                <%--                                <div class="file-item">--%>
                                <%--                                    <i class="fas fa-file-word"></i>--%>
                                <%--                                    <span class="file-name">yeu-cau-chi-tiet.docx</span>--%>
                                <%--                                    <span class="download-file"><i class="fas fa-download"></i></span>--%>
                                <%--                                </div>--%>
                            </div>
                        </div>
                    </div>

                    <%--================================Để sau các kì sau mở rộng thêm cho dự án==================================--%>
                    <%--                    <div class="form-section">--%>
                    <%--                        <div class="section-title">Điều khoản bổ sung</div>--%>
                    <%--                        <div class="info-group">--%>
                    <%--                            <div class="info-label">Các điều khoản khác</div>--%>
                    <%--                            <div class="info-value">Freelancer đồng ý cung cấp dịch vụ hỗ trợ kỹ thuật trong thời gian 3--%>
                    <%--                                tháng sau khi bàn giao sản phẩm. Mọi thay đổi về yêu cầu trong quá trình thực hiện cần--%>
                    <%--                                được thảo luận và đồng thuận từ cả hai bên. Freelancer có trách nhiệm đào tạo cơ bản cho--%>
                    <%--                                nhân viên của khách hàng về cách sử dụng và quản trị website.--%>
                    <%--                            </div>--%>
                    <%--                        </div>--%>
                    <%--                        <div class="info-group">--%>
                    <%--                            <div class="info-label">Thỏa thuận bảo mật</div>--%>
                    <%--                            <div class="info-value"><i class="fas fa-check-circle"></i> Dự án này yêu cầu ký--%>
                    <%--                                thỏa thuận bảo mật (NDA)--%>
                    <%--                            </div>--%>
                    <%--                        </div>--%>
                    <%--                    </div>--%>

                    <%--================================Để sau các kì sau mở rộng thêm cho dự án==================================--%>
                    <%--                    <div class="form-section">--%>
                    <%--                        <div class="section-title">Trạng thái dự án</div>--%>
                    <%--                        <div class="info-group">--%>
                    <%--                            <div class="project-status">--%>
                    <%--                                <div class="status-bar">--%>
                    <%--                                    <div class="status-progress" style="width: 40%;"></div>--%>
                    <%--                                </div>--%>
                    <%--                                <div class="status-text">Đang thực hiện (40% hoàn thành)</div>--%>
                    <%--                            </div>--%>
                    <%--                        </div>--%>
                    <%--                    </div>--%>

                    <div class="btn-container">
                        <button type="button" class="btn-a btn-outline">Trở lại</button>

                            <c:if test="${sessionScope.sessionAccount.accountId == poster.accountId}">
                                <a href="contract?action=show-form-terms-of-agreement&greetingId=${jobGreeting.greetingId}" type="button" class="btn-a" style="text-decoration: none">Cập nhật Điều khoản thỏa thuận</a>
                            </c:if>

                            <c:if test="${sessionScope.sessionAccount.accountId == jobSeeker.accountId}">
                                <a href="contract?action=view-contract-of-job&jobId=${job.jobId}" type="button" class="btn-a" style="text-decoration: none">Xem hợp đồng từ nhà tuyển dụng</a>
                            </c:if>
                    </div>
                </div>
            </main>
        </div>
    </div>
</section>
<%@include file="includes/footer.jsp"%>
<script>
    // Animation khi cuộn trang
    document.addEventListener('DOMContentLoaded', function() {
        const sections = document.querySelectorAll('.form-section');

        // Thêm animation cho các phần khi trang được tải
        setTimeout(() => {
            sections.forEach((section, index) => {
                setTimeout(() => {
                    section.style.opacity = '0';
                    section.style.animation = `slideUpFade 0.6s ease-out ${index * 0.1}s forwards`;
                }, 300);
            });
        }, 500);

        // Hover effect cho milestones
        const milestoneItems = document.querySelectorAll('.milestone-item');
        milestoneItems.forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.boxShadow = '0 8px 15px rgba(39, 64, 179, 0.15)';
            });

            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = '';
            });
        });

        // Animation cho skill tags
        const skillTags = document.querySelectorAll('.skill-tag');
        skillTags.forEach((tag, index) => {
            tag.style.opacity = '0';
            tag.style.transform = 'translateY(10px)';

            setTimeout(() => {
                tag.style.transition = 'all 0.3s ease';
                tag.style.opacity = '1';
                tag.style.transform = 'translateY(0)';
            }, 1000 + (index * 100));
        });
    });
</script>
</body>
</html>