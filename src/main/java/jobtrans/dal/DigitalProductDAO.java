package jobtrans.dal;

import jobtrans.model.DigitalProduct;
import jobtrans.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author MyDuyen
 */

public class DigitalProductDAO {
    private final DBConnection dbConnection;

    public DigitalProductDAO() {
        dbConnection = DBConnection.getInstance();
    }

    public DigitalProduct mapToRow(ResultSet rs) throws SQLException {
        DigitalProduct dp = new DigitalProduct();
        dp.setDigitalProductId(rs.getInt("digital_product_id"));
        dp.setJobId(rs.getInt("job_id"));
        dp.setSenderId(rs.getInt("sender_id"));
        dp.setDigitalProductUrl(rs.getString("digital_product_url"));
        dp.setNotes(rs.getString("notes"));
        dp.setStatus(rs.getString("status"));
        return dp;
    }

    public DigitalProduct getDigitalProduct(int jobId, int senderId) throws Exception {
        String sql = "SELECT * FROM DigitalProduct WHERE job_id = ? AND sender_id = ?";
        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, senderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapToRow(rs); // dùng lại hàm ánh xạ 1 dòng
                }
            }
        }
        return null;
    }

    public void insertDigitalProduct(DigitalProduct dp) throws Exception {
        String sql = "INSERT INTO DigitalProduct (job_id, sender_id, digital_product_url, notes, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dp.getJobId());
            ps.setInt(2, dp.getSenderId());
            ps.setString(3, dp.getDigitalProductUrl());
            ps.setString(4, dp.getNotes());
            ps.setString(5, dp.getStatus());
            ps.executeUpdate();
        }
    }

    public void updateStatus(int productId, String status) throws Exception {
        String sql = "UPDATE DigitalProduct SET status = ? WHERE digital_product_id = ?";
        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }
    public List<DigitalProduct> getAllDigitalProductByJobId(int jobId) {
        List<DigitalProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM DigitalProduct WHERE job_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DigitalProduct dp = mapToRow(rs); // gọi hàm ánh xạ 1 dòng
                    list.add(dp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // hoặc log ra hệ thống log
        }

        return list;
    }







}
