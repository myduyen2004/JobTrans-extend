<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/20/2025
  Time: 10:52 PM
  To change this template use File | Settings | File Templates.
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="vi">
<head>
    <title>Gửi sản phẩm ofline</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta charset="UTF-8">
    <style>
        /* CSS cho trang Gửi sản phẩm Offline */

        /* Reset và cài đặt cơ bản */

        /* Wrapper chính */
        #wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Dashboard container */
        .dashboard-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            backdrop-filter: blur(10px);
            margin: 20px 0;
        }

        .dashboard-content-container {
            padding: 40px;
        }

        .dashboard-content-inner {
            position: relative;
        }

        /* Dashboard headline */
        .dashboard-headline {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .dashboard-headline::before {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.4) 0%, rgb(43, 61, 159) 20%);
            border-radius: 2px;
        }

        .dashboard-headline h3 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.8) 0%, rgb(43, 61, 159) 50%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
        }

        /* Dashboard box */
        .dashboard-box {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(43, 61, 159, 0.15);
            margin-bottom: 30px;
            overflow: hidden;
            border: 1px solid rgba(103, 135, 254, 0.2);
            animation: slideInUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(30px);
            animation-delay: 0.2s;
        }

        @keyframes slideInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dashboard-box.margin-top-0 {
            margin-top: 0;
        }

        /* Headline trong box */
        .headline {
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.4) 0%, rgb(43, 61, 159) 20%);
            padding: 25px 30px;
            color: white;
            border-bottom: none;
        }

        .headline h3 {
            font-size: 1.3rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .headline h3 i {
            font-size: 1.5rem;
            color: rgba(255, 255, 255, 0.9);
        }

        /* Content area */
        .content.with-padding {
            padding: 35px;
        }

        .content.padding-bottom-10 {
            padding-bottom: 35px;
        }

        /* Section titles */
        h3[style*="color:#2a41e8"] {
            font-size: 1.6rem !important;
            font-weight: 700 !important;
            color: #2b3d9f !important;
            margin: 35px 0 25px 0 !important;
            padding: 15px 0 !important;
            border-bottom: 2px solid rgba(103, 135, 254, 0.2) !important;
            position: relative !important;
        }

        h3[style*="color:#2a41e8"]::before {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.8) 0%, rgb(43, 61, 159) 80%);
        }

        /* Row và columns */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -10px;
            margin-bottom: 20px;
        }

        .col-xl-4 {
            flex: 0 0 33.333333%;
            max-width: 33.333333%;
            padding: 0 10px;
            margin-bottom: 20px;
        }

        .col-xl-12 {
            flex: 0 0 100%;
            max-width: 100%;
            padding: 0 10px;
        }

        /* Submit fields */
        .submit-field {
            margin-bottom: 25px;
            position: relative;
        }

        .submit-field h5 {
            font-size: 1rem;
            font-weight: 600;
            color: #2b3d9f;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }

        .submit-field:focus-within h5 {
            color: rgb(43, 61, 159);
            transform: scale(1.02);
        }

        /* Select và input styles */
        .selectpicker.with-border,
        .keyword-input.with-border {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid rgba(103, 135, 254, 0.3);
            border-radius: 10px;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.95);
            transition: all 0.3s ease;
            color: #333;
            appearance: none;
            outline: none;
        }

        .selectpicker.with-border:focus,
        .keyword-input.with-border:focus {
            border-color: rgb(43, 61, 159);
            box-shadow: 0 0 20px rgba(103, 135, 254, 0.3);
            background: white;
            transform: translateY(-2px);
        }

        .selectpicker.with-border:hover,
        .keyword-input.with-border:hover {
            border-color: rgba(103, 135, 254, 0.6);
            transform: translateY(-1px);
        }

        /* Custom select arrow */
        .selectpicker.with-border {
            background-image: linear-gradient(45deg, transparent 50%, rgb(43, 61, 159) 50%),
            linear-gradient(135deg, rgb(43, 61, 159) 50%, transparent 50%);
            background-position: calc(100% - 20px) calc(50% - 2px), calc(100% - 15px) calc(50% - 2px);
            background-size: 5px 5px, 5px 5px;
            background-repeat: no-repeat;
            padding-right: 45px;
        }

        /* Keywords container */
        .keywords-container {
            position: relative;
        }

        .keyword-input-container {
            position: relative;
        }

        .keyword-input-container::after {
            content: '';
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            width: 6px;
            height: 6px;
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.6) 0%, rgb(43, 61, 159) 50%);
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .keyword-input.with-border:focus ~ .keyword-input-container::after {
            opacity: 1;
        }

        /* Button styles */
        .button.ripple-effect.big {
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.8) 0%, rgb(43, 61, 159) 50%);
            color: white;
            padding: 18px 40px;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 8px 25px rgba(43, 61, 159, 0.3);
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .button.ripple-effect.big:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(43, 61, 159, 0.4);
            background: linear-gradient(300deg, rgba(103, 135, 254, 1) 0%, rgb(43, 61, 159) 30%);
        }

        .button.ripple-effect.big:active {
            transform: translateY(-1px);
        }

        .button.ripple-effect.big i {
            font-size: 1.2rem;
        }

        .button.margin-top-30 {
            margin-top: 40px;
            display: block;
            margin-left: auto;
            margin-right: auto;
            width: fit-content;
        }

        /* Ripple effect */
        .button.ripple-effect {
            position: relative;
            overflow: hidden;
        }

        .button.ripple-effect::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .button.ripple-effect:active::before {
            width: 300px;
            height: 300px;
        }

        /* Loading states */
        .selectpicker.with-border[disabled] {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
            cursor: not-allowed;
        }

        @keyframes loading {
            0% {
                background-position: 200% 0;
            }
            100% {
                background-position: -200% 0;
            }
        }

        /* Clearfix */
        .clearfix::after {
            content: "";
            display: table;
            clear: both;
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(103, 135, 254, 0.1);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.6) 0%, rgb(43, 61, 159) 50%);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(300deg, rgba(103, 135, 254, 0.8) 0%, rgb(43, 61, 159) 30%);
        }

        /* Responsive design */
        @media (max-width: 1200px) {
            .col-xl-4 {
                flex: 0 0 50%;
                max-width: 50%;
            }
        }

        @media (max-width: 768px) {
            .dashboard-content-container {
                padding: 20px;
            }

            .dashboard-headline h3 {
                font-size: 2rem;
            }

            .col-xl-4 {
                flex: 0 0 100%;
                max-width: 100%;
            }

            .content.with-padding {
                padding: 20px;
            }

            .headline {
                padding: 20px;
            }

            .headline h3 {
                font-size: 1.1rem;
            }

            .row {
                margin: 0;
            }

            .col-xl-4,
            .col-xl-12 {
                padding: 0;
            }

            h3[style*="color:#2a41e8"] {
                font-size: 1.3rem !important;
            }
        }

        @media (max-width: 480px) {
            .dashboard-headline h3 {
                font-size: 1.5rem;
            }

            .selectpicker.with-border,
            .keyword-input.with-border {
                padding: 12px 15px;
                font-size: 0.9rem;
            }

            .button.ripple-effect.big {
                padding: 15px 30px;
                font-size: 1rem;
                width: 100%;
                justify-content: center;
            }
        }

        /* Micro interactions */
        .submit-field {
            transition: all 0.3s ease;
        }

        .submit-field:hover {
            transform: translateY(-1px);
        }

        .dashboard-box:hover {
            box-shadow: 0 15px 40px rgba(43, 61, 159, 0.2);
            transform: translateY(-2px);
        }

        /* Focus improvements */
        .selectpicker.with-border:focus,
        .keyword-input.with-border:focus {
            z-index: 10;
            position: relative;
        }

        /* Error states */
        .selectpicker.with-border.error,
        .keyword-input.with-border.error {
            border-color: #ff4757;
            box-shadow: 0 0 20px rgba(255, 71, 87, 0.3);
        }

        /* Success states */
        .selectpicker.with-border.success,
        .keyword-input.with-border.success {
            border-color: #2ed573;
            box-shadow: 0 0 20px rgba(46, 213, 115, 0.3);
        }
    </style>
</head>
<body class="gray">
<div id="wrapper">
    <%@include file="/includes/header-01.jsp" %>
    <div class="clearfix"></div>
    <div class="dashboard-container">

        <div class="dashboard-content-container" data-simplebar>
            <div class="dashboard-content-inner" >

                <div class="dashboard-headline">
                    <h3>Gửi sản phẩm Offline</h3>
                </div>
                <form action="physical-product" method="POST">
                    <div class="row">

                        <input type="hidden" name="command" value="submitOfflineProduct">
                        <input type="hidden" name="jobId" value="${jobId}">
                        <input type="hidden" name="senderId" value="${senderId}">
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
                                                <h5>Tỉnh</h5>
                                                <select class="selectpicker with-border"  onchange="loadPickDistricts(this.value)" name="pick_province">
                                                    <option value="">-- Chọn tỉnh --</option>
                                                    <c:forEach var="province" items="${provinces}">
                                                        <option value="${province.name}" data-id="${province.id}">${province.name}</option>
                                                    </c:forEach>
                                                </select>

                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Quận, huyện</h5>
                                                <select class="selectpicker with-border" onchange="loadPickWards(this.value)" name="pick_district">
                                                    <option value="">-- Chọn huyện --</option>

                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Phường, Xã</h5>
                                                <select class="selectpicker with-border" onchange="loadPickDetailAddress(this.value)" name="pick_ward">
                                                    <option value="">-- Chọn phường xã --</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Địa chỉ chi tiết </h5>
                                                <div class="keywords-container">
                                                    <div class="keyword-input-container">
                                                        <input type="text" class="keyword-input with-border" name="pick_address"/>
                                                    </div>
                                                    <div class="keywords-list"><!-- keywords go here --></div>
                                                    <div class="clearfix"></div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Số điện thoại </h5>
                                                <div class="keywords-container">
                                                    <div class="keyword-input-container">
                                                        <input type="text" class="keyword-input with-border" name="pick_tel"/>
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
                                                        <input type="text" class="keyword-input with-border" name="pick_name"/>
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
                                                <select class="selectpicker with-border" onchange="loadDistricts(this.value)" name="province">
                                                    <option value="">-- Chọn tỉnh --</option>
                                                    <c:forEach var="province" items="${provinces}">
                                                        <option value="${province.name}" data-id="${province.id}">${province.name}</option>
                                                    </c:forEach>
                                                </select>

                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Quận, huyện</h5>
                                                <select class="selectpicker with-border" onchange="loadWards(this.value)" name="district">
                                                    <option value="">-- Chọn huyện --</option>

                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Phường, Xã</h5>
                                                <select class="selectpicker with-border" onchange="loadSpecialAddress(this.value)" name="ward">
                                                    <option value="">-- Chọn phường xã --</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Địa chỉ chi tiết </h5>
                                                <div class="keywords-container">
                                                    <div class="keyword-input-container">
                                                        <input type="text" class="keyword-input with-border" name="address"/>
                                                    </div>
                                                    <div class="keywords-list"><!-- keywords go here --></div>
                                                    <div class="clearfix"></div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Số điện thoại </h5>
                                                <div class="keywords-container">
                                                    <div class="keyword-input-container">
                                                        <input type="text" class="keyword-input with-border" name="tel"/>
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
                                                        <input type="text" class="keyword-input with-border" name="name"/>
                                                    </div>
                                                    <div class="keywords-list"><!-- keywords go here --></div>
                                                    <div class="clearfix"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <h3 style="font-weight: bold; color:#2a41e8 ">Thông tin sản phẩm</h3>
                                    <br>
                                    <div class="row">
                                        <div class="col-xl-4">
                                            <div class="submit-field">
                                                <h5>Tên sản phẩm</h5>
                                                <div class="keywords-container">
                                                    <div class="keyword-input-container">
                                                        <input type="text" class="keyword-input with-border" name="product_name"/>
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
                                                        <input type="text" class="keyword-input with-border" name="product_quantity"/>
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
                                                        <input type="text" class="keyword-input with-border" name="product_weight"/>
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

                    <div class="col-xl-12">
                        <button type="submit" class="button ripple-effect big margin-top-30"><i class="icon-feather-plus"></i> Gửi thông tin giao hàng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</div>

</div>

<!-- Snackbar // documentation: https://www.polonel.com/snackbar/ -->
<script>
    // Snackbar for user status switcher
    $('#snackbar-user-status label').click(function () {
        Snackbar.show({
            text: 'Your status has been changed!',
            pos: 'bottom-center',
            showAction: false,
            actionText: "Dismiss",
            duration: 3000,
            textColor: '#fff',
            backgroundColor: '#383838'
        });
    });
</script>

<!-- Chart.js // documentation: http://www.chartjs.org/docs/latest/ -->
<script>
    Chart.defaults.global.defaultFontFamily = "Nunito";
    Chart.defaults.global.defaultFontColor = '#888';
    Chart.defaults.global.defaultFontSize = '14';

    var ctx = document.getElementById('chart').getContext('2d');

    var chart = new Chart(ctx, {
        type: 'line',

        // The data for our dataset
        data: {
            labels: ["January", "February", "March", "April", "May", "June"],
            // Information about the dataset
            datasets: [{
                label: "Views",
                backgroundColor: 'rgba(42,65,232,0.08)',
                borderColor: '#2a41e8',
                borderWidth: "3",
                data: [196, 132, 215, 362, 210, 252],
                pointRadius: 5,
                pointHoverRadius: 5,
                pointHitRadius: 10,
                pointBackgroundColor: "#fff",
                pointHoverBackgroundColor: "#fff",
                pointBorderWidth: "2",
            }]
        },

        // Configuration options
        options: {

            layout: {
                padding: 10,
            },

            legend: {display: false},
            title: {display: false},

            scales: {
                yAxes: [{
                    scaleLabel: {
                        display: false
                    },
                    gridLines: {
                        borderDash: [6, 10],
                        color: "#d8d8d8",
                        lineWidth: 1,
                    },
                }],
                xAxes: [{
                    scaleLabel: {display: false},
                    gridLines: {display: false},
                }],
            },

            tooltips: {
                backgroundColor: '#333',
                titleFontSize: 13,
                titleFontColor: '#fff',
                bodyFontColor: '#fff',
                bodyFontSize: 13,
                displayColors: false,
                xPadding: 10,
                yPadding: 10,
                intersect: false
            }
        },

    });

</script>
<script>
    let selectedPickProvinceId;
    let selectedPickDistrictId;
    let selectedPickWardId;

    function loadPickDistricts(provinceName) {
        const provinceSelect = document.querySelector('select[name="pick_province"]');
        const selectedOption = provinceSelect.options[provinceSelect.selectedIndex];
        selectedPickProvinceId = selectedOption.getAttribute('data-id');
        if (selectedPickProvinceId) {
            fetch('/JobTrans/physical-product?action=getDistricts&provinceId=' + selectedPickProvinceId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(districts => {
                    console.log(districts); // Kiểm tra cấu trúc dữ liệu
                    const districtSelect = document.querySelector('select[name="pick_district"]');
                    districtSelect.innerHTML = '<option value="">-- Chọn huyện --</option>';
                    if (Array.isArray(districts) && districts.length > 0) { // Kiểm tra nếu mảng không rỗng
                        districts.forEach(district => {
                            districtSelect.innerHTML += '<option value="' + district.name + '" data-id="' + district.id + '">' + district.name + '</option>';
                            console.log(district);
                            console.log(districtSelect.innerHTML);
                        });

                    } else {
                        console.error("No districts found or invalid data structure:", districts);
                    }
                    $('.selectpicker').selectpicker('refresh'); // Cập nhật nếu bạn đang sử dụng Selectpicker
                })
                .catch(error => console.error('Error fetching districts:', error));
        }
    }

    function loadPickWards(districtName) {
        const districtSelect = document.querySelector('select[name="pick_district"]');
        const selectedOption = districtSelect.options[districtSelect.selectedIndex];
        selectedPickDistrictId = selectedOption.getAttribute('data-id');
        if (selectedPickDistrictId) {
            fetch('/JobTrans/physical-product?action=getWards&districtId=' + selectedPickDistrictId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(wards => {
                    console.log(wards); // Kiểm tra cấu trúc dữ liệu
                    const wardSelect = document.querySelector('select[name="pick_ward"]');
                    wardSelect.innerHTML = '<option value="">-- Chọn phường xã --</option>';
                    if (Array.isArray(wards) && wards.length > 0) { // Kiểm tra nếu mảng không rỗng
                        wards.forEach(ward => {
                            wardSelect.innerHTML += '<option value="' + ward.name + '" data-id="' + ward.id + '">' + ward.name + '</option>';
                            console.log(ward);
                            console.log(wardSelect.innerHTML);
                        });

                    } else {
                        console.error("No districts found or invalid data structure:", districts);
                    }
                    $('.selectpicker').selectpicker('refresh'); // Cập nhật nếu bạn đang sử dụng Selectpicker
                })
                .catch(error => console.error('Error fetching districts:', error));
        }
    }


    function loadPickDetailAddress(wardName) {
        const wardSelect = document.querySelector('select[name="pick_ward"]');
        const selectedOption = wardSelect.options[wardSelect.selectedIndex];
        selectedPickWardId = selectedOption.getAttribute('data-id');
        if (selectedPickWardId) {
            fetch('/JobTrans/physical-product?action=getSpecialAddress&provinceId=' + selectedPickProvinceId + '&districtId=' + selectedPickDistrictId + '&wardId=' + selectedPickWardId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(resultList => {
                    console.log(resultList); // Kiểm tra cấu trúc dữ liệu
                    const resultSelect = document.querySelector('select[name="pick_address"]');
                    resultSelect.innerHTML = '<option value="">-- Địa chỉ chi tiết --</option>';
                    if (Array.isArray(resultList) && resultList.length > 0) { // Kiểm tra nếu mảng không rỗng
                        resultList.forEach(result => {
                            resultSelect.innerHTML += '<option value="' + result + '">' + result + '</option>';
                            console.log(result);
                            console.log(resultSelect.innerHTML);
                        });

                    } else {
                        console.error("No districts found or invalid data structure:", districts);
                    }
                    $('.selectpicker').selectpicker('refresh'); // Cập nhật nếu bạn đang sử dụng Selectpicker
                })
                .catch(error => console.error('Error fetching districts:', error));
        }
    }

</script>

<script>
    let selectedProvinceId;
    let selectedDistrictId;
    let selectedWardId;

    function loadDistricts(provinceName) {
        const provinceSelect = document.querySelector('select[name="province"]');
        const selectedOption = provinceSelect.options[provinceSelect.selectedIndex];
        selectedProvinceId = selectedOption.getAttribute('data-id');
        if (selectedProvinceId) {
            fetch('/JobTrans/physical-product?action=getDistricts&provinceId=' + selectedProvinceId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(districts => {
                    console.log(districts); // Kiểm tra cấu trúc dữ liệu
                    const districtSelect = document.querySelector('select[name="district"]');
                    districtSelect.innerHTML = '<option value="">-- Chọn huyện --</option>';
                    if (Array.isArray(districts) && districts.length > 0) { // Kiểm tra nếu mảng không rỗng
                        districts.forEach(district => {
                            districtSelect.innerHTML += '<option value="' + district.name + '" data-id="' + district.id + '">' + district.name + '</option>';
                            console.log(district);
                            console.log(districtSelect.innerHTML);
                        });

                    } else {
                        console.error("No districts found or invalid data structure:", districts);
                    }
                    $('.selectpicker').selectpicker('refresh'); // Cập nhật nếu bạn đang sử dụng Selectpicker
                })
                .catch(error => console.error('Error fetching districts:', error));
        }
    }



    function loadWards(districtId) {
        const districtSelect = document.querySelector('select[name="district"]');
        const selectedOption = districtSelect.options[districtSelect.selectedIndex];
        selectedDistrictId = selectedOption.getAttribute('data-id');
        if (selectedDistrictId) {
            fetch('/JobTrans/physical-product?action=getWards&districtId=' + selectedDistrictId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(wards => {
                    console.log(wards); // Kiểm tra cấu trúc dữ liệu
                    const wardSelect = document.querySelector('select[name="ward"]');
                    wardSelect.innerHTML = '<option value="">-- Chọn phường xã --</option>';
                    if (Array.isArray(wards) && wards.length > 0) { // Kiểm tra nếu mảng không rỗng
                        wards.forEach(ward => {
                            wardSelect.innerHTML += '<option value="' + ward.name + '" data-id="' + ward.id + '">' + ward.name + '</option>';
                            console.log(ward);
                            console.log(wardSelect.innerHTML);
                        });

                    } else {
                        console.error("No districts found or invalid data structure:", districts);
                    }
                    $('.selectpicker').selectpicker('refresh'); // Cập nhật nếu bạn đang sử dụng Selectpicker
                })
                .catch(error => console.error('Error fetching districts:', error));
        }
    }


    function loadSpecialAddress(wardName) {
        const wardSelect = document.querySelector('select[name="ward"]');
        const selectedOption = wardSelect.options[wardSelect.selectedIndex];
        selectedWardId = selectedOption.getAttribute('data-id');
        if (selectedWardId) {
            fetch('/JobTrans/physical-product?action=getSpecialAddress&provinceId=' + selectedProvinceId + '&districtId=' + selectedDistrictId + '&wardId=' + selectedWardId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(resultList => {
                    console.log(resultList); // Kiểm tra cấu trúc dữ liệu
                    const resultSelect = document.querySelector('select[name="address"]');
                    resultSelect.innerHTML = '<option value="">-- Địa chỉ chi tiết --</option>';
                    if (Array.isArray(resultList) && resultList.length > 0) { // Kiểm tra nếu mảng không rỗng
                        resultList.forEach(result => {
                            resultSelect.innerHTML += '<option value="' + result + '">' + result + '</option>';
                            console.log(result);
                            console.log(resultSelect.innerHTML);
                        });

                    } else {
                        console.error("No districts found or invalid data structure:", districts);
                    }
                    $('.selectpicker').selectpicker('refresh'); // Cập nhật nếu bạn đang sử dụng Selectpicker
                })
                .catch(error => console.error('Error fetching districts:', error));
        }
    }
</script>

<!-- Geting an API Key: https://developers.google.com/maps/documentation/javascript/get-api-key -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAaoOT9ioUE4SA8h-anaFyU4K63a7H-7bc&amp;libraries=places"></script>


</body>
</html>
