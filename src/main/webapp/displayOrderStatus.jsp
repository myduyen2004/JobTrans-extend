<%--&lt;%&ndash;--%>
<%--  Created by IntelliJ IDEA.--%>
<%--  User: admin--%>
<%--  Date: 7/20/2025--%>
<%--  Time: 11:59 PM--%>
<%--  To change this template use File | Settings | File Templates.--%>
<%--&ndash;%&gt;--%>
<%--&lt;%&ndash;--%>
<%--    Document   : viewProduct-employer--%>
<%--    Created on : 25 thg 10, 2024, 15:31:48--%>
<%--    Author     : mac--%>
<%--&ndash;%&gt;--%>

<%--<%@page import="jobtrans.model.Product"%>--%>
<%--<%@page import="jobtrans.dal.JobProductDAO"%>--%>
<%--<%@page import="jobtrans.model.User"%>--%>
<%--<%@page import="jobtrans.dal.UserDAO"%>--%>
<%--<%@page import="jobtrans.dal.JobDAO"%>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>--%>
<%--<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ page import="jobtrans.model.Job" %>--%>
<%--<%@ page import="jobtrans.model.JobGreeting" %>--%>
<%--<%@ page import="jobtrans.model.Transaction" %>--%>

<%--<%@ page import="java.time.LocalDateTime, java.time.Duration" %>--%>
<%--<!doctype html>--%>
<%--<!doctype html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <meta charset="utf-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">--%>
<%--    <title>Sản phẩm của tôi</title>--%>
<%--    <!-- CSS -->--%>
<%--    <link rel="stylesheet" href="css/style.css">--%>
<%--    <link rel="stylesheet" href="css/colors/blue.css">--%>
<%--    <link rel="stylesheet" href="css/popup.css">--%>
<%--</head>--%>

<%--<body class="gray">--%>
<%--<div id="wrapper">--%>
<%--    <!-- Include Header -->--%>
<%--    <%@include file="/includes/header.jsp" %>--%>
<%--    <div class="clearfix"></div>--%>
<%--    <div class="dashboard-container">--%>
<%--        <!-- Include Sidebar -->--%>
<%--        <%@include file="/includes/sidebar.jsp" %>--%>

<%--        <div class="dashboard-content-container" data-simplebar>--%>
<%--            <div class="dashboard-content-inner">--%>

<%--                <h2 style="margin-bottom: 40px;">Trạng thái đơn Ship sản phẩm Offline</h2>--%>


<%--                <div class="row">--%>
<%--                    <div class="col-xl-12">--%>
<%--                        <div class="dashboard-box margin-top-0 ">--%>
<%--                            <div class="container">--%>
<%--                                <div class="col-md-12">--%>
<%--                                    <!-- Styling container -->--%>
<%--                                    <div style="max-width: 1500px; margin: auto; padding: 20px; background-color: #f4f4f9; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); font-family: Arial, sans-serif; color: #333;">--%>

<%--                                        <div style="margin-bottom: 15px;">--%>
<%--                                            <label style="font-weight: bold; font-size: 20px;">Trạng thái:</label>--%>
<%--                                            <p style="margin-top: 5px; font-size: 18px; color: #333;">${statusText}</p>--%>
<%--                                        </div>--%>

<%--                                        <div style="margin-bottom: 15px;">--%>
<%--                                            <label style="font-weight: bold; font-size: 18px;">Ngày tạo:</label>--%>
<%--                                            <p style="margin-top: 5px; font-size: 16px; color: #333;">${createdDate}</p>--%>
<%--                                        </div>--%>


<%--                                    </div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- Footer -->--%>
<%--            <%@include file="includes/subfooter.jsp" %>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>
<%--<div id="popup" class="popup">--%>
<%--    <div id="overlay">--%>
<%--        <button class="closebtn" onclick="closePopup()">--%>
<%--            <i class="icon-feather-log-out"></i>--%>
<%--        </button>--%>
<%--        <!-- Nội dung trong Popup -->--%>
<%--        <center>--%>
<%--            <div class="overlay-content">--%>
<%--                <h4>Nộp sản phẩm</h4>--%>
<%--                <hr>--%>
<%--                <h4 style="margin-top: 30px;">--%>
<%--                    <i class="icon-feather-alert-circle" style="color: blue;"></i>--%>
<%--                    Bạn muốn nộp sản phẩm theo loại nào--%>
<%--                </h4>--%>
<%--                <br>--%>

<%--                <table>--%>
<%--                    <tr>--%>
<%--                        <td>--%>
<%--                            <!-- Sử dụng nút Bootstrap -->--%>
<%--                            <a id="confirmOfflineButton" href="#">--%>
<%--                                <button class="btn btn-secondary btn-custom"">Offline--%>
<%--                                </button>--%>
<%--                            </a>--%>
<%--                        </td>--%>
<%--                        <td>--%>
<%--                            <a id="confirmOnlineButton" href="#">--%>
<%--                                <button class="btn btn-danger btn-custom">Online--%>
<%--                                </button>--%>
<%--                            </a>--%>
<%--                        </td>--%>
<%--                    </tr>--%>
<%--                </table>--%>
<%--            </div>--%>
<%--        </center>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- JS -->--%>
<%--<script src="js/jquery-3.4.1.min.js"></script>--%>
<%--<script src="js/jquery-migrate-3.1.0.min.js"></script>--%>
<%--<script src="js/mmenu.min.js"></script>--%>
<%--<script src="js/custom.js"></script>--%>
<%--<script>--%>
<%--    function openPopup(element) { // Click vào button thì gán style cho Popup là display:block để hiển thị lên--%>
<%--        var jobId = element.getAttribute("data-jobid");--%>
<%--        console.log("Job ID: " + jobId);--%>

<%--        // Cập nhật URL của nút "Xác Nhận"--%>
<%--        var confirmButton = document.getElementById("confirmOnlineButton");--%>
<%--        confirmButton.href = "product-seeker.jsp?jobId=" + jobId;--%>
<%--        document.getElementById("popup").style.display = "block";--%>
<%--    }--%>


<%--</script>--%>

<%--<script>--%>
<%--    function closePopup() { // Click vào close thì gán style cho Popup là display:none để ẩn đi--%>
<%--        document.getElementById("popup").style.display = "none";--%>
<%--    }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>