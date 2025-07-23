<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="jobtrans.model.JobCategory" %>
<!doctype html>
<html lang="en">
<head>
  <jsp:useBean id="categoryDAO" class="jobtrans.dal.JobCategoryDAO" scope="session"></jsp:useBean>
  <title>Gửi sản phẩm ofline</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <style>



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

    .headline i {
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

    .submit-field p {
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

    .submit-field a {
      color: rgb(21, 42, 105);
      text-decoration: none;
      font-weight: 600;
      padding: 10px 20px;
      background: linear-gradient(135deg, rgba(21, 42, 105, 0.1), rgba(54, 75, 140, 0.1));
      border-radius: 25px;
      border: 2px solid rgb(21, 42, 105);
      transition: all 0.3s ease;
      display: inline-block;
    }

    .submit-field a:hover {
      background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(21, 42, 105, 0.3);
    }

    .keywords-container {
      width: 100%;
    }

    .keyword-input-container {
      width: 100%;
    }

    .keywords-list {
      display: none;
    }

    .clearfix {
      clear: both;
    }

    /* Product section styling */
    .content .row:has(.col-xl-4:first-child .submit-field h5:contains("Tên sản phẩm")) {
      background: linear-gradient(135deg, rgba(21, 42, 105, 0.05), rgba(54, 75, 140, 0.05));
      border-radius: 15px;
      padding: 20px;
      margin: 20px 0;
      border: 1px solid rgba(21, 42, 105, 0.1);
    }

    /* Status section styling */
    .content h3:contains("Tình trạng đơn ship") {
      color: #e74c3c;
    }

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
    }

    /* Animation for page load */
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

    .dashboard-content-inner {
      animation: fadeInUp 0.8s ease-out;
    }

    /* Hover effects for sections */
    .content > div {
      transition: all 0.3s ease;
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

    /* Form styling */
    form {
      width: 100%;
    }

    input[type="hidden"] {
      display: none;
    }

    /* Icon styling */
    .icon-feather-folder-plus {
      color: white;
      font-size: 1.2rem;
    }
  </style>
</head>
<body class="gray">
<div id="wrapper">
  <%@include file="/includes/header-01.jsp" %>
  <div class="clearfix"></div>
  <div class="dashboard-container">

    <div class="dashboard-content-container" data-simplebar>
      <form action="OfflineProductServlet" method="POST">
        <div class="dashboard-content-inner" >

          <div class="dashboard-headline">
            <h3>Gửi sản phẩm Offline</h3>
          </div>
          <div class="row">
            <input type="hidden" name="jobId" value="${jobId}">
            <!-- Dashboard Box -->
            <div class="col-xl-12">
              <div class="dashboard-box margin-top-0">

                <!-- Headline -->
                <div class="headline">
                  <h3><i class="icon-feather-folder-plus"></i>Thông tin sẽ được gửi đến admin để tạo đơn ship cho đối tác của bạn</h3>
                </div>

                <div class="content with-padding padding-bottom-10">
                  <h3 style="font-weight: bold; color:#2a41e8 ">Địa chỉ người gửi</h3>
                  <br>
                  <div class="row">
                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Tỉnh: </h5>
                        <p>${orderRequest.getOrder().getPick_province()}</p>
                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Quận, huyện</h5>
                        <p>${orderRequest.getOrder().getPick_district()}</p>
                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Phường, Xã</h5>
                        <p>${orderRequest.getOrder().getPick_ward()}</p>
                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Địa chỉ chi tiết (Theo GHTK)</h5>

                        <p>${orderRequest.getOrder().getPick_address()}</p>
                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Số điện thoại </h5>
                        <div class="keywords-container">
                          <div class="keyword-input-container">
                            <p>${orderRequest.getOrder().getPick_tel()}</p>
                          </div>
                          <div class="keywords-list"><!-- keywords go here --></div>
                          <div class="clearfix"></div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Họ và tên người gửi </h5>
                        <div class="keywords-container">
                          <div class="keyword-input-container">
                            <p>${orderRequest.getOrder().getPick_name()}</p>
                          </div>
                          <div class="keywords-list"><!-- keywords go here --></div>
                          <div class="clearfix"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <h3 style="font-weight: bold; color:#2a41e8 ">Địa chỉ người nhận</h3>
                  <br>
                  <div class="row">

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Tỉnh</h5>
                        <p>${orderRequest.getOrder().getProvince()}</p>

                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Quận, huyện</h5>
                        <p>${orderRequest.getOrder().getDistrict()}</p>
                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Phường, Xã</h5>
                        <p>${orderRequest.getOrder().getWard()}</p>

                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Địa chỉ chi tiết (Theo GHTK)</h5>
                        <p>${orderRequest.getOrder().getAddress()}</p>

                      </div>
                    </div>

                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Số điện thoại </h5>
                        <div class="keywords-container">
                          <div class="keyword-input-container">
                            <p>${orderRequest.getOrder().getTel()}</p>
                          </div>
                          <div class="keywords-list"><!-- keywords go here --></div>
                          <div class="clearfix"></div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xl-4">
                      <div class="submit-field">
                        <h5>Họ và tên người nhận </h5>
                        <div class="keywords-container">
                          <div class="keyword-input-container">
                            <p>${orderRequest.getOrder().getName()}</p>
                          </div>
                          <div class="keywords-list"><!-- keywords go here --></div>
                          <div class="clearfix"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <h3 style="font-weight: bold; color:#2a41e8 ">Thông tin sản phẩm</h3>
                  <br>
                  <c:forEach var="o" items="${orderRequest.getProducts()}">
                    <div class="row">
                      <div class="col-xl-4">
                        <div class="submit-field">
                          <h5>Tên sản phẩm</h5>
                          <div class="keywords-container">
                            <div class="keyword-input-container">
                              <p>${o.name}</p>
                            </div>
                            <div class="keywords-list"><!-- keywords go here --></div>
                            <div class="clearfix"></div>
                          </div>
                        </div>
                      </div>
                      <div class="col-xl-4">
                        <div class="submit-field">
                          <h5>Số lượng</h5>
                          <div class="keywords-container">
                            <div class="keyword-input-container">
                              <p>${o.quantity}</p>
                            </div>
                            <div class="keywords-list"><!-- keywords go here --></div>
                            <div class="clearfix"></div>
                          </div>
                        </div>
                      </div>
                      <div class="col-xl-4">
                        <div class="submit-field">
                          <h5>Khối lượng</h5>
                          <div class="keywords-container">
                            <div class="keyword-input-container">
                              <p>${o.weight}</p>
                            </div>
                            <div class="keywords-list"><!-- keywords go here --></div>
                            <div class="clearfix"></div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                  <h3 style="font-weight: bold; color:#2a41e8 ">Tình trạng đơn ship: </h3>
                  <br>
                  <div class="row">
                    <div class="col-xl-6">
                      <div class="submit-field">
                        <h5>Tình trạng đơn hàng</h5>
                        <div class="keywords-container">
                          <div class="keyword-input-container">
                            <a href="physical-product?action=viewStatusShipment&tracking_id=${orderRequest.getTrackingId()}">Xem tại đây</a><!-- comment -->
                          </div>
                          <div class="keywords-list"><!-- keywords go here --></div>
                          <div class="clearfix"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>

</div>

</div>
</body>
</html>