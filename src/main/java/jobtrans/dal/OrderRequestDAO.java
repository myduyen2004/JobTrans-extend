package jobtrans.dal;

import jobtrans.model.OrderRequest;
import jobtrans.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static java.lang.System.out;

/**
 * @author MyDuyen
 */

public class OrderRequestDAO {
    private final DBConnection dbConnection;

    public OrderRequestDAO() {
        dbConnection = DBConnection.getInstance();
    }

    private OrderRequest mapToOrderRequest(ResultSet rs) throws SQLException {
        OrderRequest request = new OrderRequest();
        request.setJobId(rs.getInt("jobId"));
        request.setSenderId(rs.getInt("sender_id"));
        request.setTrackingId(rs.getString("tracking_id"));
        request.setStatus(rs.getString("status"));

        // Map sản phẩm
        OrderRequest.Product product = new OrderRequest.Product();
        product.setName(rs.getString("product_name"));
        product.setQuantity(rs.getInt("product_quantity"));
        product.setWeight(rs.getDouble("product_weight"));
        List<OrderRequest.Product> productList = new ArrayList<>();
        productList.add(product);
        request.setProducts(productList);

        // Map thông tin đơn hàng
        OrderRequest.Order order = new OrderRequest.Order();
        order.setId(rs.getString("shipmentId"));
        order.setPick_name(rs.getString("pick_name"));
        order.setPick_province(rs.getString("pick_province"));
        order.setPick_district(rs.getString("pick_district"));
        order.setPick_ward(rs.getString("pick_ward"));
        order.setPick_address(rs.getString("pick_address"));
        order.setPick_tel(rs.getString("pick_tel"));
        order.setName(rs.getString("name"));
        order.setProvince(rs.getString("province"));
        order.setDistrict(rs.getString("district"));
        order.setWard(rs.getString("ward"));
        order.setAddress(rs.getString("address"));
        order.setTel(rs.getString("tel"));

        request.setOrder(order);
        return request;
    }

    public List<OrderRequest> getAllOrderRequestByJobId(int jobId) {
        List<OrderRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM Shipment WHERE jobId = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapToOrderRequest(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public OrderRequest getOrderRequestByJobIdAndSenderId(int jobId, int senderId) {
        String sql = "SELECT * FROM Shipment WHERE jobId = ? AND sender_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, senderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapToOrderRequest(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertShipment(OrderRequest orderRequest, int jobId, int senderId) throws Exception{
        String query = "INSERT INTO Shipment (jobId, sender_id, pick_name, pick_province, pick_district, pick_ward, pick_address, pick_tel, "
                + "name, province, district, ward, address, tel, product_name, product_quantity, product_weight, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?)";
        try (Connection con = dbConnection.openConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            // Cài đặt các thông tin của order
            OrderRequest.Order order = orderRequest.getOrder();
            ps.setInt(1, jobId);
            ps.setInt(2, senderId);
            ps.setString(3, order.getPick_name());
            ps.setString(4, order.getPick_province());
            ps.setString(5, order.getPick_district());
            ps.setString(6, order.getPick_ward());
            ps.setString(7, order.getPick_address());
            ps.setString(8, order.getPick_tel());

            ps.setString(9, order.getName());
            ps.setString(10, order.getProvince());
            ps.setString(11, order.getDistrict());
            ps.setString(12, order.getWard());
            ps.setString(13, order.getAddress());
            ps.setString(14, order.getTel());

            // Lấy thông tin sản phẩm từ danh sách products
            List<OrderRequest.Product> products = orderRequest.getProducts();
            if (products != null && !products.isEmpty()) {
                OrderRequest.Product product = products.get(0);
                ps.setString(15, product.getName());
                ps.setInt(16, product.getQuantity());
                ps.setDouble(17, product.getWeight());
            } else {
                ps.setNull(15, java.sql.Types.NVARCHAR);
                ps.setNull(16, java.sql.Types.INTEGER);
                ps.setNull(17, java.sql.Types.FLOAT);
            }

            // Cài đặt trạng thái
            ps.setString(18, orderRequest.getStatus());
//            ps.setString(19, orderRequest.getTrackingId());

            // Thực hiện chèn dữ liệu
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateShipmentByJobId(OrderRequest orderRequest, int jobId) throws Exception {
        String query = "UPDATE Shipment SET pick_name = ?, pick_province = ?, pick_district = ?, pick_ward = ?, "
                + "pick_address = ?, pick_tel = ?, name = ?, province = ?, district = ?, ward = ?, address = ?, tel = ?, "
                + "product_name = ?, product_quantity = ?, product_weight = ?, status = ? "
                + "WHERE jobId = ?";

        try (Connection con = dbConnection.openConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            // Lấy thông tin từ OrderRequest
            OrderRequest.Order order = orderRequest.getOrder();
            ps.setString(1, order.getPick_name());
            ps.setString(2, order.getPick_province());
            ps.setString(3, order.getPick_district());
            ps.setString(4, order.getPick_ward());
            ps.setString(5, order.getPick_address());
            ps.setString(6, order.getPick_tel());

            ps.setString(7, order.getName());
            ps.setString(8, order.getProvince());
            ps.setString(9, order.getDistrict());
            ps.setString(10, order.getWard());
            ps.setString(11, order.getAddress());
            ps.setString(12, order.getTel());

            // Xử lý sản phẩm
            List<OrderRequest.Product> products = orderRequest.getProducts();
            if (products != null && !products.isEmpty()) {
                OrderRequest.Product product = products.get(0);
                ps.setString(13, product.getName());
                ps.setInt(14, product.getQuantity());
                ps.setDouble(15, product.getWeight());
            } else {
                ps.setNull(13, java.sql.Types.NVARCHAR);
                ps.setNull(14, java.sql.Types.INTEGER);
                ps.setNull(15, java.sql.Types.FLOAT);
            }

            // Cập nhật trạng thái
            ps.setString(16, orderRequest.getStatus());

            // Xác định jobId để cập nhật
            ps.setInt(17, jobId);

            // Thực hiện cập nhật dữ liệu
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatusByJobId(int jobId, String newStatus) throws Exception {
        String sql = "UPDATE Shipment SET status = ? WHERE jobId = ?";

        try (PreparedStatement preparedStatement = dbConnection.openConnection().prepareStatement(sql)) {
            preparedStatement.setString(1, newStatus); // Thay đổi giá trị `status`
            preparedStatement.setInt(2, jobId);     // Đặt điều kiện `jobId`

            int rowsUpdated = preparedStatement.executeUpdate();
            return rowsUpdated > 0; // Trả về true nếu có ít nhất một dòng được cập nhật

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTrackingId(int jobId, String trackingId) throws Exception {
        String sql = "UPDATE Shipment SET tracking_id = ? WHERE jobId = ?";

        try (PreparedStatement preparedStatement = dbConnection.openConnection().prepareStatement(sql)) {
            preparedStatement.setString(1, trackingId);
            preparedStatement.setInt(2, jobId);

            int rowsAffected = preparedStatement.executeUpdate();
            out.println(rowsAffected);
            return rowsAffected > 0; // Trả về true nếu có bản ghi bị ảnh hưởng
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi lỗi nếu có
            out.println(e);
            return false; // Trả về false nếu có lỗi xảy ra
        }
    }
    public OrderRequest getOrderRequestByTrackingId(String trackingId) throws Exception {
        String sql = "SELECT * FROM Shipment WHERE tracking_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trackingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OrderRequest orderRequest = new OrderRequest();

                    // Gán jobId và senderId
                    orderRequest.setJobId(rs.getInt("jobId"));
                    orderRequest.setSenderId(rs.getInt("sender_id"));
                    orderRequest.setTrackingId(rs.getString("tracking_id"));
                    orderRequest.setStatus(rs.getString("status"));

                    // Tạo đối tượng Product từ product_name, quantity, weight
                    OrderRequest.Product product = new OrderRequest.Product();
                    product.setName(rs.getString("product_name"));
                    product.setQuantity(rs.getInt("product_quantity"));
                    product.setWeight(rs.getDouble("product_weight"));
                    // Có thể gán product_code nếu bạn lưu nó ở bảng khác (hoặc không có thì bỏ qua)
                    orderRequest.setProducts(List.of(product)); // Đơn giản là 1 sản phẩm trong shipment

                    // Tạo đối tượng Order từ các trường còn lại
                    OrderRequest.Order order = new OrderRequest.Order();
                    order.setPick_name(rs.getString("pick_name"));
                    order.setPick_province(rs.getString("pick_province"));
                    order.setPick_district(rs.getString("pick_district"));
                    order.setPick_ward(rs.getString("pick_ward"));
                    order.setPick_address(rs.getString("pick_address"));
                    order.setPick_tel(rs.getString("pick_tel"));

                    order.setName(rs.getString("name"));
                    order.setProvince(rs.getString("province"));
                    order.setDistrict(rs.getString("district"));
                    order.setWard(rs.getString("ward"));
                    order.setAddress(rs.getString("address"));
                    order.setTel(rs.getString("tel"));

                    orderRequest.setOrder(order);

                    return orderRequest;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi truy vấn OrderRequest theo trackingId: " + trackingId, e);
        }

        return null; // Không tìm thấy shipment
    }


    public static void main(String[] args) throws Exception {
        OrderRequestDAO orderRequestDAO = new OrderRequestDAO();
        orderRequestDAO.updateTrackingId(2, "123");
    }

}
