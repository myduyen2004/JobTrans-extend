<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đánh giá đối tác &#8211; JobTrans</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<style>
   body {
    font-family: 'Poppins', Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f9f9f9;
    color: #333;
}

/* Container của phần thông tin liên hệ */
.contact-container {
    display: flex;
    justify-content: center;
    gap: 40px;
    flex-wrap: wrap;
    text-align: center;
    padding: 30px;
    margin-top: 80px;
    margin-bottom: 40px;
}

.contact-item {
    flex: 1;
    max-width: 250px;
    padding: 15px;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease-in-out;
}

.contact-item:hover {
    transform: translateY(-5px);
}

.contact-item img {
    width: 50px;
    height: 50px;
    margin-bottom: 10px;
    border-radius: 40px;
}

.contact-item h3 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 5px;
}

.contact-item p {
    font-size: 14px;
    color: #555;
}

.contact-item a {
    color: #192663;
    font-weight: 600;
    text-decoration: none;
}

.contact-item a:hover {
    text-decoration: underline;
}
.contact-item:hover {
    background-color: #badce3;
    transform: scale(1.1); /* Phóng to nhẹ khi hover */
}

/* Feedback container */
.feedback-container {
    text-align: center;
    padding: 30px;
}

.feedback-button {
    background-color: #192663;
    color: white;
    padding: 12px 18px;
    border: none;
    border-radius: 25px;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
    transition: background 0.3s;
    margin-bottom: 20px;


}

.feedback-container {
    position: relative; /* Gốc cho button */
    text-align: center;
    padding: 30px;
}

.feedback-container {
    position: relative; /* Gốc cho button */
    text-align: center;
    padding: 30px;
}

.feedback-textarea {
    width: 76%;
    height: 300px;
    padding: 10px;
    border-radius: 8px;
    border: 2px solid #192663;
    font-size: 14px;
    transition: box-shadow 0.3s;
    resize: none;
   margin-top: 10px;
}

.feedback-textarea:focus {
    box-shadow: 0 0 8px rgba(25, 38, 99, 0.5);
    outline: none;
}

/* Nút nằm góc trái trên textarea */
.feedback-button {
    position: absolute;
    top: 10px; /* Khoảng cách từ trên xuống */
    left: 10px; /* Khoảng cách từ trái vào */
    background-color: #192663;
    color: white;
    padding: 8px 15px;
    border: none;
    border-radius: 20px;
    font-weight: bold;
    font-size: 14px;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
    margin-left: 165px;
    height: 40px;
}

/* Hiệu ứng hover */
.feedback-button:hover {
    background-color: #0f1b49;
    transform: scale(1.1); /* Phóng to nhẹ khi hover */
}
/* Banner */
.banner {
    text-align: center;
    background-color: #e8ecfc;
    padding: 30px;
    margin: 20px auto;
    border-radius: 12px;
    width: 76%;
}

.banner h2 {
    font-size: 22px;
    font-weight: bold;
    color: #333;
}

.banner p {
    font-size: 14px;
    color: #666;
}

.post-job-button {
    background-color: #4460f1;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 10px;
}

.post-job-button:hover {
    background-color: #e68900;
}

/* Responsive Design */
@media (max-width: 768px) {
    .contact-container {
        flex-direction: column;
        align-items: center;
    }

    .feedback-textarea {
        width: 95%;
    }

    .banner {
        width: 90%;
    }
}

</style>
<body>
<%@include file="includes/header-01.jsp"%>
    <div class="contact-container">
        <div class="contact-item">
            <img src="img/anh_icon/sdt.png" alt="Address">
            <h3>Địa chỉ</h3>
            <p>38 Lê Đại Hành, Ngũ Hành Sơn, Đà Nẵng</p>
        </div>

        <div class="contact-item">
            <img src="img/anh_icon/email.png" alt="Email">
            <h3>Email</h3>
            <p>congnvde180639@gmail.com</p>
        </div>

        <div class="contact-item">
            <img src="img/anh_icon/contact.png" alt="Contact">
            <h3>Liên hệ</h3>
            <p>0935280706</p>
        </div>

        <div class="contact-item">
            <img src="img/anh_icon/facebook.png" alt="Facebook">
            <h3>Facebook</h3>
            <p><a href="https://www.facebook.com/profile.php?id=100054503381115" target="_blank">Facebook Profile</a></p>
        </div>
    </div>

    <div class="feedback-container">
        <button class="feedback-button">Đóng góp ý kiến về trang web</button>
        <textarea class="feedback-textarea" placeholder="Nhập ý kiến của bạn tại đây..."></textarea>
    </div>

    <div class="banner">
        <h2>Tìm kiếm nhân tài cần thiết để phát triển doanh nghiệp của bạn.</h2>
        <p>Quảng cáo việc làm của bạn tới hàng triệu người dùng hàng tháng và tìm kiếm 15,8 triệu CV</p>
        <button class="post-job-button">Bắt đầu tìm kiếm</button>
    </div>
<%@include file="includes/footer.jsp" %>
</body>
</html>


