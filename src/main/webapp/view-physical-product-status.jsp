<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <title>Tình trạng đơn hàng</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <style>


        .dashboard-content-container {
            max-width: 1000px;
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
            animation: fadeInUp 0.8s ease-out;
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
            margin-bottom: 10px;
        }

        .tracking-info {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(21, 42, 105, 0.1);
            border: 2px solid rgba(21, 42, 105, 0.1);
        }

        .tracking-header {
            background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .tracking-id {
            font-size: 1.2rem;
            font-weight: 600;
        }

        .order-status {
            font-size: 0.9rem;
            padding: 5px 15px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .timeline {
            position: relative;
            margin: 30px 0;
        }

        .timeline-item {
            position: relative;
            padding: 20px 0 20px 60px;
            border-left: 3px solid #e9ecef;
        }

        .timeline-item:last-child {
            border-left: none;
        }

        .timeline-item.active {
            border-left-color: rgb(21, 42, 105);
        }

        .timeline-item.completed {
            border-left-color: #28a745;
        }

        .timeline-icon {
            position: absolute;
            left: -12px;
            top: 25px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: white;
        }

        .timeline-item.active .timeline-icon {
            background: rgb(21, 42, 105);
            animation: pulse 2s infinite;
        }

        .timeline-item.completed .timeline-icon {
            background: #28a745;
        }

        .timeline-content {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid #e9ecef;
        }

        .timeline-item.active .timeline-content {
            border-color: rgb(21, 42, 105);
            box-shadow: 0 5px 20px rgba(21, 42, 105, 0.15);
        }

        .timeline-item.completed .timeline-content {
            border-color: #28a745;
        }

        .timeline-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: rgb(21, 42, 105);
            margin-bottom: 8px;
        }

        .timeline-time {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 10px;
        }

        .timeline-description {
            color: #495057;
            line-height: 1.5;
        }

        .order-details {
            background: #f8f9fc;
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            border: 1px solid #e3e6f0;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: rgb(21, 42, 105);
        }

        .detail-value {
            color: #495057;
        }

        .back-button {
            display: inline-block;
            padding: 12px 25px;
            background: linear-gradient(to right, rgb(21, 42, 105), rgb(54, 75, 140));
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            margin-top: 20px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(21, 42, 105, 0.3);
        }

        .status-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-shipping {
            background: #cce5ff;
            color: #0066cc;
            border: 1px solid #80bdff;
        }

        .status-delivered {
            background: #d1f2eb;
            color: #00695c;
            border: 1px solid #7dcea0;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

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

        @keyframes pulse {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(21, 42, 105, 0.7);
            }
            70% {
                transform: scale(1.1);
                box-shadow: 0 0 0 10px rgba(21, 42, 105, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(21, 42, 105, 0);
            }
        }

        @media (max-width: 768px) {
            .dashboard-content-inner {
                padding: 20px;
            }

            .dashboard-headline h3 {
                font-size: 2rem;
            }

            .tracking-header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }

            .timeline-item {
                padding-left: 40px;
            }

            .timeline-icon {
                left: -8px;
                width: 16px;
                height: 16px;
                font-size: 10px;
            }

            .detail-row {
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>
</head>
<body>

<div id="wrapper">
    <%@include file="/includes/header-01.jsp" %>
    <div class="dashboard-content-container">
        <div class="dashboard-content-inner">
            <div class="dashboard-headline">
                <h3>Tình trạng đơn hàng</h3>
            </div>

            <div class="tracking-info">
                <div class="tracking-header">
                    <div class="tracking-id">Mã vận đơn: <span>${orderRequest.getTrackingId()}</span></div>
                    <div class="order-status">
                        <c:choose>
                            <c:when test="${statusText.contains('delivered') || statusText.contains('Delivered') || statusText.contains('giao hàng thành công')}">
                                <span class="status-badge status-delivered">${statusText}</span>
                            </c:when>
                            <c:when test="${statusText.contains('shipping') || statusText.contains('Shipping') || statusText.contains('đang vận chuyển')}">
                                <span class="status-badge status-shipping">${statusText}</span>
                            </c:when>
                            <c:when test="${statusText.contains('cancelled') || statusText.contains('Cancelled') || statusText.contains('hủy')}">
                                <span class="status-badge status-cancelled">${statusText}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-pending">${statusText}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="timeline">
                    <div class="timeline-item completed">
                        <div class="timeline-icon">✓</div>
                        <div class="timeline-content">
                            <div class="timeline-title">Đơn hàng đã được tạo</div>
                            <div class="timeline-time">${createdDate}</div>
                            <div class="timeline-description">Đơn hàng của bạn đã được tạo thành công và gửi đến hệ thống vận chuyển.</div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${statusText.contains('delivered') || statusText.contains('Delivered') || statusText.contains('giao hàng thành công')}">
                            <div class="timeline-item completed">
                                <div class="timeline-icon">✓</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Đã xác nhận đơn hàng</div>
                                    <div class="timeline-time">Đã hoàn thành</div>
                                    <div class="timeline-description">Đơn hàng đã được xác nhận và chuẩn bị vận chuyển.</div>
                                </div>
                            </div>

                            <div class="timeline-item completed">
                                <div class="timeline-icon">✓</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Đang vận chuyển</div>
                                    <div class="timeline-time">Đã hoàn thành</div>
                                    <div class="timeline-description">Hàng đã được vận chuyển đến địa chỉ người nhận.</div>
                                </div>
                            </div>

                            <div class="timeline-item completed">
                                <div class="timeline-icon">📦</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Đã giao hàng thành công</div>
                                    <div class="timeline-time">${modifiedDate}</div>
                                    <div class="timeline-description">Đơn hàng đã được giao thành công đến người nhận.</div>
                                </div>
                            </div>
                        </c:when>

                        <c:when test="${statusText.contains('shipping') || statusText.contains('Shipping') || statusText.contains('đang vận chuyển')}">
                            <div class="timeline-item completed">
                                <div class="timeline-icon">✓</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Đã xác nhận đơn hàng</div>
                                    <div class="timeline-time">Đã hoàn thành</div>
                                    <div class="timeline-description">Đơn hàng đã được xác nhận và chuẩn bị vận chuyển.</div>
                                </div>
                            </div>

                            <div class="timeline-item active">
                                <div class="timeline-icon">🚚</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Đang vận chuyển</div>
                                    <div class="timeline-time">${modifiedDate}</div>
                                    <div class="timeline-description">Hàng đang trên đường vận chuyển đến địa chỉ người nhận.</div>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <div class="timeline-icon">📦</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Chờ giao hàng</div>
                                    <div class="timeline-time">Đang chờ</div>
                                    <div class="timeline-description">Hàng sẽ được giao đến địa chỉ người nhận.</div>
                                </div>
                            </div>
                        </c:when>

                        <c:when test="${statusText.contains('cancelled') || statusText.contains('Cancelled') || statusText.contains('hủy')}">
                            <div class="timeline-item" style="border-left-color: #dc3545;">
                                <div class="timeline-icon" style="background: #dc3545;">✕</div>
                                <div class="timeline-content" style="border-color: #dc3545;">
                                    <div class="timeline-title" style="color: #dc3545;">Đơn hàng đã bị hủy</div>
                                    <div class="timeline-time">${modifiedDate}</div>
                                    <div class="timeline-description">Đơn hàng đã được hủy bỏ.</div>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="timeline-item active">
                                <div class="timeline-icon">⏳</div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Đang xử lý</div>
                                    <div class="timeline-time">${modifiedDate}</div>
                                    <div class="timeline-description">${statusText}</div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="order-details">
                <h4 style="color: rgb(21, 42, 105); margin-bottom: 20px; font-size: 1.3rem;">Thông tin chi tiết</h4>

                <div class="detail-row">
                    <span class="detail-label">Người gửi:</span>
                    <span class="detail-value">${orderRequest.getOrder().getPick_name()}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">SĐT người gửi:</span>
                    <span class="detail-value">${orderRequest.getOrder().getPick_tel()}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Địa chỉ lấy hàng:</span>
                    <span class="detail-value">${orderRequest.getOrder().getPick_address()}, ${orderRequest.getOrder().getPick_ward()}, ${orderRequest.getOrder().getPick_district()}, ${orderRequest.getOrder().getPick_province()}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Người nhận:</span>
                    <span class="detail-value">${orderRequest.getOrder().getName()}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">SĐT người nhận:</span>
                    <span class="detail-value">${orderRequest.getOrder().getTel()}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Địa chỉ giao hàng:</span>
                    <span class="detail-value">${orderRequest.getOrder().getAddress()}, ${orderRequest.getOrder().getWard()}, ${orderRequest.getOrder().getDistrict()}, ${orderRequest.getOrder().getProvince()}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Ngày tạo đơn:</span>
                    <span class="detail-value">${createdDate}</span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Cập nhật lần cuối:</span>
                    <span class="detail-value">${modifiedDate}</span>
                </div>

                <c:if test="${not empty orderRequest.getProducts()}">
                    <div class="detail-row">
                        <span class="detail-label">Sản phẩm:</span>
                        <span class="detail-value">
              <c:forEach var="product" items="${orderRequest.getProducts()}" varStatus="status">
                  ${product.name} (SL: ${product.quantity}, KL: ${product.weight}kg)<c:if test="${!status.last}">, </c:if>
              </c:forEach>
            </span>
                    </div>
                </c:if>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <a href="javascript:history.back()" class="back-button">← Quay lại</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>