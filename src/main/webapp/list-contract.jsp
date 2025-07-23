<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách hợp đồng đã ký kết</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/list-contract.css">
    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="page" />
</head>
<body>
<%@include file="includes/header-01.jsp"%>
<div class="container">
    <div class="header">
        <h1>Danh sách hợp đồng đã ký kết của công việc</h1>
        <div class="date">
            <i class="fas fa-calendar-alt"></i>
            <script>
                const today = new Date();
                document.write(today.toLocaleDateString('vi-VN', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }));
            </script>
        </div>
    </div>
<%--Mở rộng--%>
<%--    <div class="search-filter">--%>
<%--        <div class="search-box">--%>
<%--            <i class="fas fa-search"></i>--%>
<%--            <input type="text" placeholder="Tìm kiếm theo tên dự án, bên A hoặc bên B...">--%>
<%--        </div>--%>
<%--        <select class="filter-select">--%>
<%--            <option value="all">Tất cả hợp đồng</option>--%>
<%--            <option value="recent">Ký kết gần đây</option>--%>
<%--            <option value="old">Ký kết cũ nhất</option>--%>
<%--            <option value="expiring">Sắp hết hạn</option>--%>
<%--        </select>--%>
<%--    </div>--%>

    <c:if test="${not empty contractList}">
        <div class="contracts-list">
        <c:forEach var="contract" items="${contractList}" >
            <div class="contract-card">
                <div class="contract-header">
                    <div style="width: 80%;">
                        <div class="contract-title">${job.jobTitle}</div>
                    </div>
                    <div>
                        <div class="contract-status">Kí kết thành công</div>
                    </div>

                </div>
                <div class="contract-body">
                    <div class="contract-parties">
                        <div class="party">
                            <div class="party-label">Bên A (Chủ dự án)</div>
                            <div class="party-name">${contract.aName}</div>
                        </div>
                        <div class="party">
                            <div class="party-label">Bên B (Người thực hiện)</div>
                            <div class="party-name">${contract.bName}</div>
                        </div>
                    </div>
                    <div class="contract-details">
                        <div class="detail-item">
                            <div class="detail-label">Ngày bắt đầu</div>
                            <div class="detail-value"><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Ngày kết thúc</div>
                            <div class="detail-value"><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Giá trị hợp đồng</div>
                            <div class="detail-value">
                                <fmt:formatNumber value="${contract.jobFee}" type="number" groupingUsed="true" /> VNĐ
                            </div>

                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Ngày ký kết</div>
                            <div class="detail-value"><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="contract-footer">
                    <a href="contract?action=view-details-contract&jobId=${job.jobId}&applicantId=${contract.applicantId}" class="view-btn" style="text-decoration: none">
                        <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                    <button class="download-btn">
                        <i class="fas fa-download"></i> Tải xuống
                    </button>
                </div>
            </div>
        </c:forEach>
    </div>
    </c:if>

    <c:if test="${empty contractList}">
        <div style="padding: 15px; margin: 20px auto; max-width: 100%; background: #f0f4f8; text-align: center; border-radius: 5px; ">
            <p style="color: #555; font-size: 16px; margin: 0;">Hiện tại chưa có hợp đồng nào được kí kết.</p>
        </div>
    </c:if>
    <div class="pagination">
        <button class="page-btn active">1</button>
        <button class="page-btn">2</button>
        <button class="page-btn">3</button>
        <button class="page-btn">
            <i class="fas fa-ellipsis-h"></i>
        </button>
        <button class="page-btn">10</button>
        <button class="page-btn">
            <i class="fas fa-chevron-right"></i>
        </button>
    </div>
</div>
<%@include file="includes/footer.jsp"%>

<script>
    // Animation for cards
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.contract-card');

        cards.forEach((card, index) => {
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100 * index);
        });

        // Search functionality
        const searchInput = document.querySelector('.search-box input');
        searchInput.addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const cards = document.querySelectorAll('.contract-card');

            cards.forEach(card => {
                const title = card.querySelector('.contract-title').textContent.toLowerCase();
                const partyA = card.querySelector('.party-name').textContent.toLowerCase();
                const partyB = card.querySelectorAll('.party-name')[1].textContent.toLowerCase();

                if (title.includes(searchValue) || partyA.includes(searchValue) || partyB.includes(searchValue)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });

        // Filter select change
        const filterSelect = document.querySelector('.filter-select');
        filterSelect.addEventListener('change', function() {
            const contractsList = document.querySelector('.contracts-list');
            contractsList.style.opacity = '0';

            setTimeout(() => {
                contractsList.style.opacity = '1';
                // Here you would normally filter the data based on the selection
            }, 300);
        });
    });
</script>

</body>
</html>