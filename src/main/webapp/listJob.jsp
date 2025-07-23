<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>

    <jsp:useBean id="jobDAO" class="jobtrans.dal.JobDAO" scope="session"></jsp:useBean>
    <jsp:useBean id="JobCategoryDAO" class="jobtrans.dal.JobCategoryDAO" scope="session"></jsp:useBean>
    <jsp:useBean id="AccountDAO" class="jobtrans.dal.AccountDAO" scope="session"></jsp:useBean>
    <meta charset="UTF-8">
    <title>JobTrans-Danh sách công việc</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listJob.css">

</head>

<body>
<%@include file="includes/header-01.jsp"%>
    <div class="container" style="margin-top: 50px; margin-bottom: 50px">
        <div class="search-bar" >
            <form action="viec-lam/" method="GET"> <input type="text" id="searchInput" name="keyword"  placeholder="Nhập từ khóa tìm kiếm...">
                <button type="submit" id="searchButton">Tìm kiếm</button>
            </form>
        </div>

        <div id="searchResults">
        </div>

        <div class="hamburger-menu col-xl-1">
            <button class="hamburger-button" onclick="toggleMenu()">
                <div class="hamburger-icon">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </button>

            <%--            //xét url động--%>
            <c:set var="encodedPriceFilter" value="${fn:replace(priceFilter, '-', '-den-')}"/>
            <c:set var="encodedPriceFilter" value="${fn:replace(encodedPriceFilter, 'm', '-trieu')}"/>
            <c:if test="${empty priceFilter}">
                <c:set var="encodedPriceFilter" value="tat-ca"/>
            </c:if>

            <div id="sortMenu" style="left: 40px" class="dropdown-menu-01">
                <c:url var="sortByRecentUrl" value="/viec-lam/sap-xep-theo-moi-nhat/gia-${encodedPriceFilter}/trang-1"/>
                <a href="${sortByRecentUrl}">Sắp xếp theo đăng gần nhất</a>

                <c:url var="sortByPriceDescUrl" value="/viec-lam/sap-xep-theo-gia-giam/gia-${encodedPriceFilter}/trang-1"/>
                <a href="${sortByPriceDescUrl}">Giá giảm dần</a>

                <c:url var="sortByPriceAscUrl" value="/viec-lam/sap-xep-theo-gia-tang/gia-${encodedPriceFilter}/trang-1"/>
                <a href="${sortByPriceAscUrl}">Giá tăng dần</a>
            </div>
        </div>
        <div class="row">
            <div class="col-xl-12">
                <div class="row">
                    <div class="col-xl-3">
                        <div class="filter-container price">
                            <div class="filter-header price">
                                Lọc theo giá
                            </div>
                            <ul class="filter-list price">
                                <li class="filter-item visible"><a href="viec-lam/?price=under1m&page=1">Giá dưới 1 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=1-2m&sort=${sortType}&page=1">Giá từ 1-2 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=3-4m&sort=${sortType}&page=1">Giá từ 3-4 triệu</a></li>
                                <li class="filter-item visible"><a href="/JobTrans/viec-lam/?price=4-5m&sort=${sortType}&page=1">Giá từ 4-5 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=5-10m&sort=${sortType}&page=1">Giá từ 5-10 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=10-20m&sort=${sortType}&page=1">Giá từ 10-20 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=20-30m&sort=${sortType}&page=1">Giá từ 20-30 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=30-50m&sort=${sortType}&page=1">Giá từ 30-50 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=above50m&sort=${sortType}&page=1">Giá trên 50 triệu</a></li>
                                <li class="filter-item visible"><a href="viec-lam/?price=tat-ca&sort=${sortType}&page=1">Tất cả giá</a></li>
                            </ul>
                            <div class="filter-more price" onclick="showMorePrices()">
                                Xem thêm
                                <svg viewBox="0 0 24 24">
                                    <path d="M7 10l5 5 5-5H7z"/>
                                </svg>
                            </div>
                        </div>

                        <div class="filter-container job">
                            <div class="filter-header job">
                                Lọc theo công việc
                                <svg viewBox="0 0 24 24">
                                    <path d="M7 14l5-5 5 5H7z"/>
                                </svg>
                            </div>
                            <ul class="filter-list job">
                                <li class="filter-item visible"><a href="/JobTrans/viec-lam/?jobType=tuvan,coaching&sort=${sortType}&page=1">Tư vấn-Coaching</a></li>
                                <li class="filter-item visible"><a href="/JobTrans/viec-lam/?jobType=dichthuat&sort=${sortType}&page=1">Dịch thuật</a></li>
                                <li class="filter-item visible"><a href="/JobTrans/viec-lam/?jobType=congnghe%26it&sort=${sortType}&page=1">Công nghệ & IT</a></li>
                                <li class="filter-item visible"><a href="/JobTrans/viec-lam/?jobType=marketing&sort=${sortType}&page=1">Marketing</a></li>
                                <li class="filter-item visible"><a href="/JobTrans/viec-lam/?jobType=khac&sort=${sortType}&page=1">Khác</a></li>
                            </ul>
                            <div class="filter-more job" onclick="showMoreCViec()">
                                Xem thêm
                                <svg viewBox="0 0 24 24">
                                    <path d="M7 10l5 5 5-5H7z"/>
                                </svg>
                            </div>
                        </div>
                    </div>



                    <div class="col-xl-9">
                        <!-- Danh sách công việc -->


                        <c:if test="${not empty jobList && fn:length(jobList) > 0}">
                            <c:forEach var="job" items="${jobList}">
                                <div class="card mb-3" onclick="window.location.href='${pageContext.request.contextPath}/job?action=details-job-posted&jobId=${job.jobId}'">
                                    <div class="card-body">
                                        <!-- Avatar của người đăng bài -->
                                        <c:choose>
                                            <c:when test="${not empty AccountDAO.getAccountById(job.postAccountId).avatar}">
                                                <c:set var="avatarPath" value="${AccountDAO.getAccountById(job.postAccountId).avatar}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="avatarPath" value="img/default-avatar.jpg" />
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="${pageContext.request.contextPath}/${avatarPath}" class="user-avatar-01">
                                        <div class="job-info-container">
                                            <div class="job-info-left">
                                                <h5 class="card-title">${job.jobTitle}</h5>
                                                <p class="card-category">
                                                    <i class="fas fa-tags"></i>
                                                    <strong>Phân loại:&nbsp;</strong> ${job.jobCategory.categoryName}
                                                </p>
                                                <p class="card-text">
                                                    <i class="far fa-calendar-alt"></i>
                                                    <strong>Hạn tuyển:&nbsp; </strong> ${job.dueDatePost}
                                                </p>
                                            </div>
                                            <div class="job-info-right">
                                                <p class="job-salary">${job.getFormattedBudgetMax()}</p>
                                                <div class="job-details">
                                                    <a href="/JobTrans/job?action=details-job-posted&jobId=${job.jobId}"
                                                       class="details-link">
                                                        <i class="fas fa-info-circle"></i> Chi tiết
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty jobList || fn:length(jobList) == 0}">
                            <div class="alert alert-info text-center">Không có công việc nào để hiển thị.</div>
                        </c:if>
                    </div>



            </div>




            </div>
        </div>
    </div>
<c:if test="${totalPages > 1}">
    <div class="pagination" style="margin-bottom: 50px">
        <!-- Pagination will be dynamically generated by JavaScript -->
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Function to generate pagination with limited visible numbers and navigation
            function setupPagination() {
                const paginationDiv = document.querySelector('.pagination');
                if (!paginationDiv) return;

                const currentPage = ${currentPage}; // Current page from server
                const totalPages = ${totalPages}; // Total pages from server

                // Clear existing pagination
                paginationDiv.innerHTML = '';

                // Add previous button
                if (currentPage > 1) {
                    const prevLink = document.createElement('a');
                    prevLink.classList.add('prev');
                    prevLink.href = createPageUrl(currentPage - 1);
                    prevLink.setAttribute('aria-label', 'Previous page');
                    paginationDiv.appendChild(prevLink);
                }

                // Calculate which page numbers to show
                let startPage = Math.max(1, currentPage - 2);
                let endPage = Math.min(totalPages, startPage + 4);

                // Adjust if we're near the end
                if (endPage - startPage < 4) {
                    startPage = Math.max(1, endPage - 4);
                }

                // Add first page and ellipsis if needed
                if (startPage > 1) {
                    const firstLink = document.createElement('a');
                    firstLink.textContent = '1';
                    firstLink.href = createPageUrl(1);
                    paginationDiv.appendChild(firstLink);

                    if (startPage > 2) {
                        const ellipsis = document.createElement('a');
                        ellipsis.textContent = '...';
                        ellipsis.classList.add('ellipsis');
                        paginationDiv.appendChild(ellipsis);
                    }
                }

                // Add page numbers
                for (let i = startPage; i <= endPage; i++) {
                    const pageLink = document.createElement('a');
                    pageLink.textContent = i;
                    pageLink.href = createPageUrl(i);
                    if (i === currentPage) {
                        pageLink.classList.add('active');
                    }
                    paginationDiv.appendChild(pageLink);
                }

                // Add ellipsis and last page if needed
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
                        const ellipsis = document.createElement('a');
                        ellipsis.textContent = '...';
                        ellipsis.classList.add('ellipsis');
                        paginationDiv.appendChild(ellipsis);
                    }

                    const lastLink = document.createElement('a');
                    lastLink.textContent = totalPages;
                    lastLink.href = createPageUrl(totalPages);
                    paginationDiv.appendChild(lastLink);
                }

                // Add next button
                if (currentPage < totalPages) {
                    const nextLink = document.createElement('a');
                    nextLink.classList.add('next');
                    nextLink.href = createPageUrl(currentPage + 1);
                    nextLink.setAttribute('aria-label', 'Next page');
                    paginationDiv.appendChild(nextLink);
                }
            }

            // Helper function to create page URLs with all current parameters
            function createPageUrl(pageNum) {
                <c:set var="encodedPriceFilter" value="${fn:replace(priceFilter, '-', '-den-')}"/>
                <c:set var="encodedPriceFilter" value="${fn:replace(encodedPriceFilter, 'm', '-trieu')}"/>
                <c:if test="${empty priceFilter}">
                <c:set var="encodedPriceFilter" value="tat-ca"/>
                </c:if>

                let url = 'viec-lam/';

                // Add sort parameter if exists
                <c:if test="${not empty sortType}">
                url += 'sap-xep-theo-${sortType}/';
                </c:if>

                // Add price filter if exists
                url += 'gia-${encodedPriceFilter}/';

                // Add page number
                url += 'trang-' + pageNum;

                return url;
            }

            // Initialize pagination
            setupPagination();
        });
    </script>
</c:if>
<%@include file="includes/footer.jsp"%>
<script>
    function toggleFilter() {
        const filterContainer = document.querySelector('.filter-container');
        filterContainer.classList.toggle('collapsed');
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Xử lý Lọc theo giá
        const priceFilterList = document.querySelector('.filter-list.price');
        const priceFilterItems = document.querySelectorAll('.filter-list.price .filter-item');
        const filterMorePrices = document.querySelector('.filter-more.price');
        const filterHeaderPrices = document.querySelector('.filter-header.price');
        const priceFilterContainer = document.querySelector('.filter-container.price');

        function toggleFilterPrice() {
            priceFilterContainer.classList.toggle('collapsed');
        }

        function showMorePrices() {
            priceFilterItems.forEach(item => {
                item.classList.remove('hidden');
            });
            filterMorePrices.style.display = 'none';
        }

// Gán sự kiện cho phần tiêu đề lọc giá
        if (filterHeaderPrices) {
            filterHeaderPrices.addEventListener('click', toggleFilterPrice);
        }
        if (filterMorePrices) {
            filterMorePrices.addEventListener('click', showMorePrices);
        }

// Ẩn các mục giá vượt quá 3 mục đầu tiên
        if (priceFilterItems) {
            priceFilterItems.forEach((item, index) => {
                if (index > 0 && index > 3) { // Bỏ qua tiêu đề (index 0) và hiển thị 3 mục đầu
                    item.classList.add('hidden');
                }
            });

            // Ẩn nút "Xem thêm" nếu không có mục nào bị ẩn
            let hiddenPriceCount = 0;
            priceFilterItems.forEach((item, index) => {
                if (index > 3 && item.classList.contains('hidden')) {
                    hiddenPriceCount++;
                }
            });
            if (filterMorePrices && hiddenPriceCount === 0) {
                filterMorePrices.style.display = 'none';
            }
        }


        // Xử lý Lọc theo công việc
        const jobFilterList = document.querySelector('.filter-list.job');
        const jobFilterItems = document.querySelectorAll('.filter-list.job .filter-item');
        const filterMoreCViec = document.querySelector('.filter-more.job');
        const filterHeaderCViec = document.querySelector('.filter-header.job');
        const jobFilterContainer = document.querySelector('.filter-container.job');

        function toggleFilterCViec() {
            jobFilterContainer.classList.toggle('collapsed');
        }

        function showMoreCViec() {
            jobFilterItems.forEach(item => {
                item.classList.remove('hidden');
            });
            filterMoreCViec.style.display = 'none';
        }

        // Gán sự kiện cho phần tiêu đề lọc công việc
        if (filterHeaderCViec) {
            filterHeaderCViec.addEventListener('click', toggleFilterCViec);
        }
        if (filterMoreCViec) {
            filterMoreCViec.addEventListener('click', showMoreCViec);
        }

        // Ẩn các mục công việc vượt quá 3 mục đầu tiên
        if (jobFilterItems) {
            jobFilterItems.forEach((item, index) => {
                if (index > 0 && index > 3) { // Bỏ qua tiêu đề (index 0) và hiển thị 3 mục đầu
                    item.classList.add('hidden');
                }
            });

            // Ẩn nút "Xem thêm" nếu không có mục nào bị ẩn
            let hiddenJobCount = 0;
            jobFilterItems.forEach((item, index) => {
                if (index > 3 && item.classList.contains('hidden')) {
                    hiddenJobCount++;
                }
            });
            if (filterMoreCViec && hiddenJobCount === 0) {
                filterMoreCViec.style.display = 'none';
            }
        }
    });
</script>
<script>
    function toggleMenu() {
        document.getElementById("sortMenu").classList.toggle("show");
    }

    // Đóng dropdown khi click ra ngoài
    window.onclick = function (event) {
        if (!event.target.matches('.hamburger-button') &&
            !event.target.matches('.hamburger-icon') &&
            !event.target.matches('.hamburger-icon span')) {
            var dropdown = document.getElementById("sortMenu");
            if (dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        }
    }
</script>
<script>
    // Add this script to your JSP file to handle the improved pagination
    document.addEventListener("DOMContentLoaded", function() {
        // Function to generate pagination with limited visible numbers and navigation
        function setupPagination() {
            const paginationDiv = document.querySelector('.pagination');
            if (!paginationDiv) return;

            const currentPage = parseInt(document.querySelector('.pagination a.active')?.textContent) || 1;
            const totalPages = ${totalPages}; // This should be replaced with your actual totalPages value

            // Clear existing pagination
            paginationDiv.innerHTML = '';

            // Add previous button
            if (currentPage > 1) {
                const prevLink = document.createElement('a');
                prevLink.classList.add('prev');
                prevLink.href = createPageUrl(currentPage - 1);
                prevLink.setAttribute('aria-label', 'Previous page');
                paginationDiv.appendChild(prevLink);
            }

            // Calculate which page numbers to show
            let startPage = Math.max(1, currentPage - 2);
            let endPage = Math.min(totalPages, startPage + 4);

            // Adjust if we're near the end
            if (endPage - startPage < 4) {
                startPage = Math.max(1, endPage - 4);
            }

            // Add first page and ellipsis if needed
            if (startPage > 1) {
                const firstLink = document.createElement('a');
                firstLink.textContent = '1';
                firstLink.href = createPageUrl(1);
                paginationDiv.appendChild(firstLink);

                if (startPage > 2) {
                    const ellipsis = document.createElement('a');
                    ellipsis.textContent = '...';
                    ellipsis.classList.add('ellipsis');
                    paginationDiv.appendChild(ellipsis);
                }
            }

            // Add page numbers
            for (let i = startPage; i <= endPage; i++) {
                const pageLink = document.createElement('a');
                pageLink.textContent = i;
                pageLink.href = createPageUrl(i);
                if (i === currentPage) {
                    pageLink.classList.add('active');
                }
                paginationDiv.appendChild(pageLink);
            }

            // Add ellipsis and last page if needed
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    const ellipsis = document.createElement('a');
                    ellipsis.textContent = '...';
                    ellipsis.classList.add('ellipsis');
                    paginationDiv.appendChild(ellipsis);
                }

                const lastLink = document.createElement('a');
                lastLink.textContent = totalPages;
                lastLink.href = createPageUrl(totalPages);
                paginationDiv.appendChild(lastLink);
            }

            // Add next button
            if (currentPage < totalPages) {
                const nextLink = document.createElement('a');
                nextLink.classList.add('next');
                nextLink.href = createPageUrl(currentPage + 1);
                nextLink.setAttribute('aria-label', 'Next page');
                paginationDiv.appendChild(nextLink);
            }
        }

        // Helper function to create page URLs with all current parameters
        function createPageUrl(pageNum) {
            // Create base URL
            let url = 'viec-lam/trang-' + pageNum;

            // Add query parameters based on current filters
            const params = new URLSearchParams(window.location.search);

            if (params.has('keyword')) {
                url += '?keyword=' + params.get('keyword');
            }

            if (params.has('sort')) {
                url += (url.includes('?') ? '&' : '?') + 'sort=' + params.get('sort');
            }

            if (params.has('jobType')) {
                url += (url.includes('?') ? '&' : '?') + 'jobType=' + params.get('jobType');
            }

            if (params.has('price')) {
                url += (url.includes('?') ? '&' : '?') + 'price=' + params.get('price');
            }

            return url;
        }

        // Initialize pagination
        setupPagination();
    });
</script>
</body>
</html>