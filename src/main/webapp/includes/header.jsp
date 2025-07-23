<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jobtrans.model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Account account = (Account) session.getAttribute("sessionAccount");
%>

<jsp:useBean id="notiDao" class="jobtrans.dal.NotificationDAO" scope="session"/>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<meta http-equiv="Content-Security-Policy" content="img-src 'self' https://lh3.googleusercontent.com;">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">


<!-- Inter Font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<style>
    /* Custom styles to enhance Bootstrap navbar */


    body {
        padding-top: 10000px; /* Tăng giá trị nếu muốn header cao hơn */
        overflow-x: hidden;
    }
    .navbar-custom {
        background: linear-gradient(300deg, rgba(103, 135, 254, 0.4) 0%, #2B3D9F 20%);
        position: fixed;
        top: 0;
        left: 0;
        width: 99%;
        z-index: 1000;
        transition: all 0.4s ease;
        height: 100px; /* Tăng chiều cao tổng thể */
        padding: 10px 0; /* Tăng khoảng cách bên trong */
        margin-bottom: 20px;
    }

    .navbar-brand {
        display: flex;
        align-items: center;
        padding: 0;
    }

    .navbar-brand img {
        height: 60px;
        margin-right: 10px;
    }

    .navbar-brand span {
        color: #fff;
        font-weight: 800;
        font-size: 26px;
        font-family: 'Arial', sans-serif;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        letter-spacing: 0.5px;
    }

    .navbar-container {
        padding: 0 30px;
        max-width: 1400px;
        margin: 0 auto;
    }

    .navbar-nav .nav-item {
        margin: 0 8px;
    }

    .navbar-nav .nav-link {
        color: rgba(255, 255, 255, 0.95);
        font-weight: 600;
        font-size: 17px;
        font-family: 'Arial', sans-serif;
        padding: 12px 18px;
        border-radius: 8px;
        white-space: nowrap;
        letter-spacing: 0.3px;
        transition: all 0.3s ease;
    }

    .navbar-nav .nav-link:hover {
        color: #fff;
        background-color: rgba(255, 255, 255, 0.15);
        transform: translateY(-2px);
    }

    .navbar-nav .nav-link.active {
        color: #fff;
        background-color: rgba(255, 255, 255, 0.2);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    /* Style cho menu dropdown */
    /* CSS nâng cao cho dropdown menu hiện đại với tone màu #6584fa */


    /* Container menu dropdown */
    .dropdown-menu {
        border: none;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(74, 102, 216, 0.15),
        0 2px 10px rgba(74, 102, 216, 0.12);
        padding: 12px;
        margin-top: 12px;
        min-width: 220px;
        background: #ffffff;
        backdrop-filter: blur(10px);
        transform-origin: top center;
    }

    /* Hiệu ứng khi hiển thị dropdown */
    @keyframes scaleIn {
        from { opacity: 0; transform: scale(0.95) translateY(-10px); }
        to { opacity: 1; transform: scale(1) translateY(0); }
    }

    .dropdown-menu.show {
        animation: scaleIn 0.25s cubic-bezier(0.19, 1, 0.22, 1) forwards;
    }

    /* Style cho các item trong dropdown */
    .dropdown-item {
        padding: 10px 14px;
        border-radius: 8px;
        margin-bottom: 4px;
        font-weight: 500;
        display: flex;
        align-items: center;
        color: #444;
        transition: all 0.2s;
    }

    .dropdown-item i {
        color: #6584fa;
        margin-right: 10px;
        font-size: 16px;
        width: 24px;
        height: 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        transition: all 0.3s;
    }

    .dropdown-item:hover {
        background-color: rgba(101, 132, 250, 0.1);
        color: #6584fa;
    }

    .dropdown-item:hover i {
        transform: scale(1.1);
        background-color: rgba(101, 132, 250, 0.15);
    }

    .dropdown-item:active,
    .dropdown-item:focus {
        background-color: rgba(101, 132, 250, 0.15);
        color: #4a66d8;
    }

    /* Style cho divider */
    .dropdown-divider {
        border-top: 1px solid rgba(101, 132, 250, 0.15);
        margin: 10px 0;
    }

    /* Style đặc biệt cho item cuối cùng (công cụ tạo CV) */
    .dropdown-menu li:last-child .dropdown-item {
        font-weight: 600;
        background: linear-gradient(135deg, rgba(101, 132, 250, 0.1), rgba(101, 132, 250, 0.2));
        border-left: 3px solid #6584fa;
    }

    .dropdown-menu li:last-child .dropdown-item:hover {
        background: linear-gradient(135deg, rgba(101, 132, 250, 0.15), rgba(101, 132, 250, 0.25));
        transform: translateX(2px);
    }

    .dropdown-menu li:last-child .dropdown-item i {
        color: #fff;
        background-color: #6584fa;
    }

    /* Thêm hiệu ứng pseudo-element tạo điểm nhấn cho dropdown menu */
    .dropdown-menu::before {
        content: '';
        position: absolute;
        top: -8px;
        left: 20px;
        width: 16px;
        height: 16px;
        background: white;
        transform: rotate(45deg);
        border-radius: 2px;
        box-shadow: -2px -2px 5px rgba(74, 102, 216, 0.04);
    }

    /* Hiệu ứng hover cho toàn bộ dropdown */
    .nav-item.dropdown:hover .nav-link {
        box-shadow: 0 2px 8px rgba(101, 132, 250, 0.12);
    }

    /* Thêm hiệu ứng viền khi focus cho vấn đề accessibility */
    .dropdown-item:focus-visible {
        outline: 2px solid #6584fa;
        outline-offset: 1px;
    }


    /* Custom buttons */
    .btn-login {
        border: 2px solid rgba(255, 255, 255, 0.9);
        color: #fff;
        border-radius: 30px;
        padding: 10px 24px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s ease;
        margin-left: 15px;
        font-family: 'Arial', sans-serif;
        font-size: 16px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        background: transparent;
    }

    .btn-signup {
        background: #fff;
        color: #2B3D9F;
        border-radius: 30px;
        padding: 12px 28px;
        font-weight: 700;
        text-decoration: none;
        transition: all 0.3s ease;
        margin-left: 15px;
        font-family: 'Arial', sans-serif;
        font-size: 16px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        border: none;
    }

    .btn-login:hover {
        background: rgba(255, 255, 255, 0.15);
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(255, 255, 255, 0.2);
        color: #fff;
    }

    .btn-signup:hover {
        background: #f8f9ff;
        transform: translateY(-3px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        color: #2B3D9F;
    }

    /* Animation */
    @keyframes fadeInDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .navbar-custom {
        animation: fadeInDown 0.5s ease forwards;
    }

    /* Burger menu color */
    .navbar-toggler {
        border: none;
        padding: 8px 12px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        transition: all 0.3s;
    }

    .navbar-toggler:hover {
        background: rgba(255, 255, 255, 0.2);
    }

    .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.9%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }

    /* Body padding to account for fixed navbar */
    body {
        padding-top: 85px;
    }

    /* Responsive adjustments for small screens */
    @media (max-width: 480px) {
        .navbar-brand span {
            font-size: 22px;
        }

        .navbar-brand img {
            height: 50px;
        }
    }
</style>
<style>
    /* Notification and Message Icons Styling */
    .icon-buttons {
        display: flex;
        align-items: center;
        margin-right: 15px;
    }

    .icon-btn {
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.15);
        color: #fff;
        margin-left: 10px;
        transition: all 0.3s;
        cursor: pointer;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .icon-btn:hover {
        background: rgba(255, 255, 255, 0.25);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .icon-btn i {
        font-size: 18px;
    }

    /* Badge for unread notifications/messages */
    .icon-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #ff5555;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: bold;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        border: 2px solid #6584fa;
        animation: pulse-red 1.5s infinite;
    }

    @keyframes pulse-red {
        0% {
            box-shadow: 0 0 0 0 rgba(255, 85, 85, 0.7);
        }
        70% {
            box-shadow: 0 0 0 5px rgba(255, 85, 85, 0);
        }
        100% {
            box-shadow: 0 0 0 0 rgba(255, 85, 85, 0);
        }
    }

    /* Notification Dropdown */
    .notification-dropdown,
    .message-dropdown {
        width: 350px;
        max-height: 400px;
        overflow-y: auto;
        padding: 0;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    /* Header for dropdowns */
    .dropdown-header {
        background: linear-gradient(135deg, #6584fa, #2B3D9F);
        color: white;
        padding: 15px 20px;
        font-weight: 600;
        font-size: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-radius: 12px 12px 0 0;
    }

    .dropdown-header .badge {
        background: white;
        color: #2B3D9F;
        font-size: 12px;
        font-weight: 700;
        padding: 4px 8px;
    }

    /* Notification/Message Items */
    .notification-item,
    .message-item {
        padding: 15px 20px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        transition: all 0.2s;
        display: flex;
        align-items: center;
    }

    .notification-item:hover,
    .message-item:hover {
        background: rgba(101, 132, 250, 0.08);
    }

    .notification-item.unread,
    .message-item.unread {
        background: rgba(101, 132, 250, 0.05);
    }

    /* Icon containers */
    .icon-container {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        flex-shrink: 0;
    }

    .notification-icon {
        background: rgba(101, 132, 250, 0.15);
        color: #6584fa;
    }

    .notification-icon.alert {
        background: rgba(255, 85, 85, 0.15);
        color: #ff5555;
    }

    .notification-icon.success {
        background: rgba(46, 204, 113, 0.15);
        color: #2ecc71;
    }

    /* Message specific styles */
    .avatar-container {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 15px;
        flex-shrink: 0;
        border: 2px solid #6584fa;
    }

    .avatar-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .message-content,
    .notification-header-content {
        flex-grow: 1;
        min-width: 0;
    }

    .message-sender,
    .notification-header-title {
        font-weight: 600;
        margin-bottom: 3px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .message-preview,
    .notification-text {
        color: #666;
        font-size: 13px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 100%;
    }

    .message-time,
    .notification-time {
        font-size: 11px;
        color: #999;
        white-space: nowrap;
        margin-left: 5px;
    }

    /* Footer for dropdowns */
    .dropdown-footer {
        padding: 12px;
        text-align: center;
        background: #f9f9f9;
        border-radius: 0 0 12px 12px;
    }

    .dropdown-footer a {
        color: #6584fa;
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
    }

    .dropdown-footer a:hover {
        text-decoration: underline;
    }

    /* Scrollbar styling */
    .notification-dropdown::-webkit-scrollbar,
    .message-dropdown::-webkit-scrollbar {
        width: 5px;
    }

    .notification-dropdown::-webkit-scrollbar-track,
    .message-dropdown::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.05);
    }

    .notification-dropdown::-webkit-scrollbar-thumb,
    .message-dropdown::-webkit-scrollbar-thumb {
        background: rgba(101, 132, 250, 0.5);
        border-radius: 10px;
    }

    /* Status indicator for messages */
    .status-indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        display: inline-block;
        margin-right: 5px;
    }

    .status-online {
        background: #2ecc71;
    }

    .status-offline {
        background: #95a5a6;
    }

    .status-busy {
        background: #e74c3c;
    }

    /* Responsive styles */
    @media (max-width: 992px) {
        .notification-dropdown,
        .message-dropdown {
            width: 320px;
            left: auto !important;
            right: 0 !important;
        }
    }

    @media (max-width: 576px) {
        .notification-dropdown,
        .message-dropdown {
            width: 280px;
        }

        .icon-btn {
            width: 36px;
            height: 36px;
        }
    }
</style>
<style>
    /* Enhanced User Profile Styles */
    .user-profile-container {
        margin-left: 15px;
        position: relative;
    }

    /* User information display */
    .user-info {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(5px);
        padding: 8px 18px;
        border-radius: 30px;
        margin-right: 12px;
        color: #fff;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1),
        inset 0 1px 1px rgba(255, 255, 255, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.2);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .user-info:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15),
        inset 0 1px 1px rgba(255, 255, 255, 0.3);
    }

    .user-name {
        font-weight: 600;
        font-size: 15px;
        white-space: nowrap;
        letter-spacing: 0.3px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        padding-left: 8px;
        position: relative;
    }

    .user-name::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        height: 15px;
        width: 1px;
        background: rgba(255, 255, 255, 0.3);
        transform: translateY(-50%);
    }

    /* User points styling */
    .user-points {
        display: flex;
        flex-direction: column;
        align-items: center;
        line-height: 1;
        position: relative;
        padding-right: 8px;
    }

    .point-value {
        font-weight: 700;
        font-size: 16px;
        color: #fff;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        background: linear-gradient(135deg, #fff, #f0f0f0);
        background-clip: text;
        -webkit-background-clip: text;
        color: transparent;
        filter: drop-shadow(0 1px 1px rgba(0, 0, 0, 0.2));
    }

    .point-label {
        font-size: 11px;
        opacity: 0.85;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        font-weight: 500;
        margin-top: 1px;
    }

    /* Avatar styling */
    .user-avatar {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        position: relative;
        display: inline-block;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2),
        0 0 0 3px rgba(255, 255, 255, 0.2);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        border: 3px solid rgba(255, 255, 255, 0.85);
        overflow: hidden;
    }

    .user-avatar::after {
        content: '';
        border-radius: 50%;
        /*position: absolute;*/
        /*top: 0;*/
        /*left: 0;*/
        /*right: 0;*/
        /*bottom: 0;*/
        /*background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0));*/
        /*z-index: 1;*/
    }

    .avatar-icon:hover {
        transform: translateY(-3px) scale(1.05);
    }

    .user-avatar-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        transition: all 0.3s ease;
    }

    .user-avatar:hover .user-avatar-img {
        transform: scale(1.1);
    }

    /* Online status indicator */
    .avatar-status {
        position: absolute;
        bottom: 0;
        right: 0;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        border: 2px solid #6584fa;
        z-index: 100;
        box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.1);
    }

    .avatar-status.online {
        background: linear-gradient(135deg, #2ecc71, #27ae60);
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0% {
            box-shadow: 0 0 0 0 rgba(46, 204, 113, 0.5);
        }
        70% {
            box-shadow: 0 0 0 6px rgba(46, 204, 113, 0);
        }
        100% {
            box-shadow: 0 0 0 0 rgba(46, 204, 113, 0);
        }
    }

    /* Enhanced dropdown menu */
    .user-dropdown-menu {
        width: 320px;
        padding: 0;
        overflow: hidden;
        border-radius: 15px;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2),
        0 5px 15px rgba(0, 0, 0, 0.12);
        border: 1px solid rgba(255, 255, 255, 0.1);
        transform-origin: top right;
        margin-top: 15px;
    }

    .dropdown-menu.show {
        animation: dropdownFadeIn 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55) forwards;
    }

    @keyframes dropdownFadeIn {
        from {
            opacity: 0;
            transform: translateY(-10px) scale(0.98);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .dropdown-user-info   {
        background: linear-gradient(135deg, #6584fa, #2B3D9F);
        padding: 15px;
        display: flex;
        align-items: center;
        color: #fff;
        position: relative;
        overflow: hidden;
    }

    .dropdown-user-info::before {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0) 70%);
        z-index: 1;
        opacity: 0.7;
    }

    .user-dropdown-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: 3px solid rgba(255, 255, 255, 0.6);
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        position: relative;
        z-index: 2;
    }

    .user-dropdown-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center;
        transition: all 0.5s ease;
        border-radius: 50%;
    }

    .user-dropdown-avatar:hover img {
        transform: scale(1.1);
    }

    .user-dropdown-details {
        position: relative;
        z-index: 2;
        left: 10px;
    }

    .user-dropdown-details h6 {
        margin: 0;
        font-weight: 700;
        font-size: 18px;
        margin-bottom: 4px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        position: relative;
    }

    .user-dropdown-details h6::after {
        content: '';
        position: absolute;
        bottom: -5px;
        left: 0;
        width: 30px;
        height: 2px;
        background: rgba(255, 255, 255, 0.5);
        border-radius: 2px;
    }

    .user-email {
        font-size: 13px;
        opacity: 0.9;
        display: block;
        margin-top: 8px;
        letter-spacing: 0.3px;
    }

    /* Menu items */
    .user-dropdown-menu .dropdown-item {
        padding: 14px 20px;
        transition: all 0.25s ease;
        display: flex;
        align-items: center;
        border-left: 3px solid transparent;
    }

    .user-dropdown-menu .dropdown-item:hover,
    .user-dropdown-menu .dropdown-item:focus {
        background: rgba(101, 132, 250, 0.08);
        border-left: 3px solid #6584fa;
        transform: translateX(3px);
    }

    .user-dropdown-menu .dropdown-item i {
        width: 22px;
        margin-right: 15px;
        font-size: 16px;
        color: #6584fa;
        text-align: center;
        position: relative;
        transition: all 0.3s ease;
    }

    .user-dropdown-menu .dropdown-item:hover i {
        transform: scale(1.2);
        color: #4a66d8;
    }

    .user-dropdown-menu .dropdown-divider {
        margin: 8px 0;
        opacity: 0.1;
    }

    /* Logout item */
    .user-dropdown-menu .logout-item {
        color: #dc3545;
        font-weight: 600;
        margin-top: 3px;
    }

    .user-dropdown-menu .logout-item i {
        color: #dc3545;
    }

    .user-dropdown-menu .logout-item:hover {
        background: rgba(220, 53, 69, 0.08);
        border-left: 3px solid #dc3545;
    }

    /* Responsive styles */
    @media (max-width: 992px) {
        .user-info {
            display: none !important;
        }

        .user-dropdown-menu {
            width: 280px;
            right: 0;
            left: auto !important;
        }
    }

    @media (max-width: 576px) {
        .user-profile-container {
            margin-left: 0;
            margin-top: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
        }

        .user-dropdown-menu {
            width: 260px;
        }
    }

    /* Dark mode compatibility */
    @media (prefers-color-scheme: dark) {
        .user-dropdown-menu {
            background-color: #252525;
        }

        .user-dropdown-menu .dropdown-item {
            color: #e0e0e0;
        }

        .user-dropdown-menu .dropdown-item:hover {
            background: rgba(101, 132, 250, 0.15);
        }
    }

    /* Arrow indicator for dropdown */
    .user-dropdown-menu::before {
        content: '';
        position: absolute;
        top: -8px;
        right: 20px;
        width: 16px;
        height: 16px;
        background: white;
        transform: rotate(45deg);
        border-radius: 2px;
        z-index: -1;
        box-shadow: -3px -3px 5px rgba(0, 0, 0, 0.02);
    }

    @media (prefers-color-scheme: dark) {
        .user-dropdown-menu::before {
            background: #252525;
        }
    }

    /* Beautiful scrollbar for dropdown */
    .user-dropdown-menu {
        max-height: calc(100vh - 150px);
        overflow-y: auto;
        scrollbar-width: thin;
        scrollbar-color: #6584fa rgba(0, 0, 0, 0.1);
    }

    .user-dropdown-menu::-webkit-scrollbar {
        width: 5px;
    }

    .user-dropdown-menu::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.05);
        border-radius: 10px;
    }

    .user-dropdown-menu::-webkit-scrollbar-thumb {
        background: rgba(101, 132, 250, 0.5);
        border-radius: 10px;
    }

    .user-dropdown-menu::-webkit-scrollbar-thumb:hover {
        background: rgba(101, 132, 250, 0.7);
    }

    /* Badge notifications */
    .dropdown-item .badge {
        margin-left: auto;
        background: #6584fa;
        font-weight: 500;
        font-size: 11px;
        padding: 4px 8px;
        border-radius: 10px;
    }

    /* Premium user indicator */
    .premium-user {
        position: absolute;
        top: -5px;
        right: -5px;
        background: linear-gradient(135deg, #FFD700, #FFA500);
        border-radius: 50%;
        width: 18px;
        height: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        z-index: 3;
    }

    .premium-user i {
        color: #fff;
        font-size: 10px;
    }
</style>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container-fluid navbar-container">
        <a class="navbar-brand" href="/JobTrans/index.jsp">
            <img src="<%= request.getContextPath() %>/img/logo/logo.png" alt="JobTrans Logo" class="d-inline-block align-text-top">
            <span>JobTrans</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item active">
                    <a class="nav-link active" href="http://localhost:8080/JobTrans/home">Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="http://localhost:8080/JobTrans/viec-lam?action=viewJobs">Công việc</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Tạo CV
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/cv?action=type"><i class="fas fa-file-alt"></i>Tạo CV</a></li>
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/cv?action=list"><i class="fas fa-file-alt"></i>CV của tôi</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/api.jsp"><i class="fas fa-tools"></i>Công cụ AI</a></li>
                    </ul>

                </li>
                <li class="nav-item">
                    <a class="nav-link " href="http://localhost:8080/JobTrans/home?action=top100">Top 100</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link " href="http://localhost:8080/JobTrans/policy.jsp">Chính sách</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="http://localhost:8080/JobTrans/about-me.jsp">Về chúng tôi</a>
                </li>
            </ul>
            <%if (account == null) {%>
            <div class="d-flex align-items-center">
                <a href="http://localhost:8080/JobTrans/login.jsp" class="btn btn-login">Đăng nhập</a>
                <a href="http://localhost:8080/JobTrans/register.jsp" class="btn btn-signup">Đăng ký</a>
            </div>
            <%} else{%>
            <div class="d-flex align-items-center user-profile-container">
                <!-- Notification and Message icons -->
                <div class="icon-buttons">
                    <!-- Notification Button -->
                    <div class="dropdown">
                        <div class="icon-btn" id="notificationDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-bell"></i>
                            <span class="icon-badge">3</span>
                            <c:set var="accId" value="<%=account.getAccountId()%>"/>
                            <span class="icon-badge">${notiDao.countNotificationByUnRead(accId)}</span>
                        </div>
                        <div class="dropdown-menu dropdown-menu-end notification-dropdown" aria-labelledby="notificationDropdown">
                            <div class="dropdown-header">
                                <span>Thông báo</span>
                                <span class="badge">${notiDao.countNotificationByUnRead(accId)} mới</span>
                            </div>
                            <c:forEach var="o" items="${notiDao.getTop5NotificationByUnRead(accId)}">
                                <div class="notification-item unread">
                                    <c:if test="${o.notificationType == 'Giao dịch'}">
                                        <div class="icon-container notification-icon">
                                            <i class="fas fa-money-bill-wave"></i>
                                        </div>
                                    </c:if>
                                    <c:if test="${o.notificationType == 'Hệ thống'}">
                                        <div class="icon-container notification-icon">
                                            <i class="fas fa-cog"></i>
                                        </div>
                                    </c:if>
                                    <c:if test="${o.notificationType == 'Tương tác'}">
                                        <div class="icon-container notification-icon">
                                            <i class="fas fa-tag"></i>
                                        </div>
                                    </c:if>
                                    <div class="notification-header-content">
                                        <div class="notification-header-title">${o.notificationTitle}</div>
                                        <div class="notification-text">${o.notificationContent}</div>
                                        <div class="notification-time">${o.formatTimeDifference()}</div>
                                    </div>
                                </div>
                            </c:forEach>
                            <div class="dropdown-footer">
                                <a href="notification?action=notification">Xem tất cả thông báo</a>
                            </div>
                        </div>
                    </div>

                    <!-- Message Button -->
                    <div class="dropdown">
                        <div class="icon-btn" id="messageDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-comment"></i>
                            <span class="icon-badge">2</span>
                        </div>
                        <div class="dropdown-menu dropdown-menu-end message-dropdown" aria-labelledby="messageDropdown">
                            <div class="dropdown-header">
                                <span>Tin nhắn</span>
                                <span class="badge">2 mới</span>
                            </div>
                            <div class="message-item unread">
                                <div class="avatar-container">
                                    <img src="img/home/recruiter.jpg" alt="User Avatar">
                                </div>
                                <div class="message-content">
                                    <div class="message-sender">
                                        <span class="status-indicator status-online"></span>
                                        Trần Minh Tuấn
                                    </div>
                                    <div class="message-preview">Chào bạn, chúng tôi đã xem qua CV của bạn và muốn hẹn phỏng vấn...</div>
                                    <div class="message-time">10 phút trước</div>
                                </div>
                            </div>
                            <div class="message-item unread">
                                <div class="avatar-container">
                                    <img src="img/home/recruiter.jpg" alt="User Avatar">
                                </div>
                                <div class="message-content">
                                    <div class="message-sender">
                                        <span class="status-indicator status-busy"></span>
                                        Nguyễn Thị Hương
                                    </div>
                                    <div class="message-preview">Kính gửi ứng viên, cảm ơn bạn đã quan tâm đến vị trí tuyển dụng...</div>
                                    <div class="message-time">30 phút trước</div>
                                </div>
                            </div>
                            <div class="message-item">
                                <div class="avatar-container">
                                    <img src="img/home/recruiter.jpg" alt="User Avatar">
                                </div>
                                <div class="message-content">
                                    <div class="message-sender">
                                        <span class="status-indicator status-offline"></span>
                                        Lê Văn Hoàng
                                    </div>
                                    <div class="message-preview">Xin chào, JobTrans muốn thông báo về cơ hội việc làm mới...</div>
                                    <div class="message-time">2 giờ trước</div>
                                </div>
                            </div>
                            <div class="message-item">
                                <div class="avatar-container">
                                    <img src="img/home/recruiter.jpg" alt="User Avatar">
                                </div>
                                <div class="message-content">
                                    <div class="message-sender">
                                        <span class="status-indicator status-offline"></span>
                                        Phạm Thanh Hà
                                    </div>
                                    <div class="message-preview">Chúng tôi xin thông báo lịch phỏng vấn của bạn đã được xác nhận...</div>
                                    <div class="message-time">1 ngày trước</div>
                                </div>
                            </div>
                            <div class="dropdown-footer">
                                <a href="messages.jsp">Xem tất cả tin nhắn</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User info section -->
                <div class="user-info d-flex align-items-center">
                    <div class="user-points me-3">
                        <span class="point-value"><%=account.getPoint()%></span>
                        <span class="point-label">điểm</span>
                    </div>
                    <div class="user-name me-3"><%=account.getAccountName()%></div>
                </div>

                <!-- User avatar dropdown -->
                <div class="dropdown">
                    <div class="avatar-icon" id="userDropdown" data-bs-toggle="dropdown">
                        <div class="user-avatar dropdown-toggle" role="button"  aria-expanded="false">
                            <%if(account.getAvatar().contains("https://lh3.googleusercontent.com/")){%>
                            <img src="<%=account.getAvatar()%>" alt="User Avatar" class="user-avatar-img" >
                            <%}else {%>
                            <img src="http://localhost:8080/JobTrans/<%=account.getAvatar()%>" alt="User Avatar" class="user-avatar-img" >
                            <%}%>
                        </div>
                        <span class="avatar-status online"></span>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end user-dropdown-menu" aria-labelledby="userDropdown">

                        <li class="dropdown-user-info">
                            <div class="user-dropdown-avatar">
                                <%if(account.getAvatar().contains("https://lh3.googleusercontent.com/")){%>
                                <img src="<%=account.getAvatar()%>" alt="User Avatar" class="user-avatar-img" >
                                <%}else {%>
                                <img src="http://localhost:8080/JobTrans/<%=account.getAvatar()%>" alt="User Avatar" class="user-avatar-img" >
                                <%}%>
                            </div>
                            <div class="user-dropdown-details">
                                <h6><%=account.getAccountName()%></h6>
                                <span class="user-email"><%=account.getEmail()%>></span>
                            </div>
                        </li>
                        <%if (account.getRole().equals("Admin")) {%>
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/dashboard-admin.jsp"><i class="fas fa-file-alt"></i>Quản lí chung</a></li>
                        <%}%>
                        <c:if test="${sessionScope.sessionAccount.typeAccount == 'Nhóm'}">

                            <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/group?action=view&account_id=${sessionScope.sessionAccount.accountId}"><i class="fas fa-user"></i>Hồ sơ cá nhân</a></li>
                        </c:if>
                        <c:if test="${sessionScope.sessionAccount.typeAccount == 'Cá nhân'}">
                            <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/profile?action=view&account_id=${sessionScope.sessionAccount.accountId}"><i class="fas fa-user"></i>Hồ sơ cá nhân</a></li>
                        </c:if>
                        <%if(account.getRole().equals("Người dùng")){%>
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/profile?action=job-manage-page"><i class="fas fa-file-alt"></i>Quản lí công việc</a></li>
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/cv?action=list"><i class="fas fa-id-card"></i>CV của tôi</a></li>
                        <%} else if (account.getRole().equals("Admin")) {%>
                        <li><a class="dropdown-item" href="http://localhost:8080/JobTrans/admin-manage?action=menu-management"><i class="fas fa-id-card"></i>Menu quản lí</a></li>
                        <%}%>
                        <li><a class="dropdown-item" href="profile?action=wallet"><i class="fas fa-file-alt"></i>Ví của tôi</a></li>
                        <li><a class="dropdown-item logout-item" href="http://localhost:8080/JobTrans/logout"><i class="fas fa-sign-out-alt"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
            <%}%>
        </div>
    </div>
</nav>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
