package jobtrans.dal;

import jobtrans.model.Contract;
import jobtrans.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContractDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private final DBConnection dbConnection;

    public ContractDAO() {
        dbConnection = DBConnection.getInstance();
    }

    public Contract getContractById(int contractId) {
        Contract contract = null;
        String query = "SELECT * FROM Contract WHERE contract_id = ?";

        try {
            conn = DBConnection.openConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, contractId);
            rs = ps.executeQuery();

            if (rs.next()) {
                contract = mapResultSetToContract(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return contract;
    }

    public boolean insertContract(Contract contract) {
        boolean success = false;

        try {
            conn = DBConnection.openConnection();
            String sql = "INSERT INTO Contract (" +
                    "applicant_id, employer_id, job_id, contract_preview, contract_link, status, " +
                    "A_name, A_identity, A_identity_date, A_identity_address, A_birthday, A_address, " +
                    "A_representative, A_tax_code, A_phone_number, A_email, A_signature, " +
                    "B_name, B_identity, B_identity_date, B_identity_address, B_birthday, B_address, " +
                    "B_representative, B_phone_number, B_email, B_signature, " +
                    "job_goal, job_requirement, start_date, end_date, job_address, job_fee, " +
                    "job_deposit_A, job_deposit_A_date, job_deposit_A_text, " +
                    "job_deposit_B, job_deposit_B_date, job_deposit_B_text) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            int index = 1;
            ps.setInt(index++, contract.getApplicantId());
            ps.setInt(index++, contract.getEmployerId());
            ps.setInt(index++, contract.getJobId());
            ps.setString(index++, contract.getContractPreview());
            ps.setString(index++, contract.getContractLink());
            ps.setString(index++, contract.getStatus());

            // Employer (Party A) information
            ps.setString(index++, contract.getaName());
            ps.setString(index++, contract.getaIdentity());
            ps.setDate(index++, contract.getaIdentityDate());
            ps.setString(index++, contract.getaIdentityAddress());
            ps.setDate(index++, contract.getaBirthday());
            ps.setString(index++, contract.getaAddress());
            ps.setString(index++, contract.getaRepresentative());
            ps.setString(index++, contract.getaTaxCode());
            ps.setString(index++, contract.getaPhoneNumber());
            ps.setString(index++, contract.getaEmail());
            ps.setString(index++, contract.getaSignature());

            // Freelancer (Party B) information
            ps.setString(index++, contract.getbName());
            ps.setString(index++, contract.getbIdentity());
            ps.setDate(index++, contract.getbIdentityDate());
            ps.setString(index++, contract.getbIdentityAddress());
            ps.setDate(index++, contract.getbBirthday());
            ps.setString(index++, contract.getbAddress());
            ps.setString(index++, contract.getbRepresentative());
            ps.setString(index++, contract.getbPhoneNumber());
            ps.setString(index++, contract.getbEmail());
            ps.setString(index++, contract.getbSignature());

            // Job details
            ps.setString(index++, contract.getJobGoal());
            ps.setString(index++, contract.getJobRequirement());
            ps.setDate(index++, contract.getStartDate());
            ps.setDate(index++, contract.getEndDate());
            ps.setString(index++, contract.getJobAddress());
            ps.setBigDecimal(index++, contract.getJobFee());

            // Deposits
            ps.setBigDecimal(index++, contract.getJobDepositA());
            ps.setDate(index++, contract.getJobDepositADate());
            ps.setString(index++, contract.getJobDepositAText());
            ps.setBigDecimal(index++, contract.getJobDepositB());
            ps.setDate(index++, contract.getJobDepositBDate());
            ps.setString(index++, contract.getJobDepositBText());

            int rowsAffected = ps.executeUpdate();
            success = (rowsAffected > 0);

            if (success) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    contract.setContractId(generatedKeys.getInt(1));
                }
                generatedKeys.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return success;
    }


    public boolean updateContractStatus(int contractId, String status) {
        boolean success = false;
        String query = "UPDATE Contract SET status = ? WHERE contract_id = ?";

        try {
            conn = DBConnection.openConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, contractId);

            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return success;
    }

    private Contract mapResultSetToContract(ResultSet rs) throws SQLException {
        Contract contract = new Contract();

        try {
            contract.setContractId(rs.getInt("contract_id"));
            contract.setApplicantId(rs.getInt("applicant_id"));
            contract.setEmployerId(rs.getInt("employer_id"));
            contract.setJobId(rs.getInt("job_id"));
            contract.setContractPreview(rs.getString("contract_preview"));
            contract.setContractLink(rs.getString("contract_link"));
            contract.setStatus(rs.getString("status"));
            contract.setaName(rs.getString("A_name"));
            contract.setaIdentity(rs.getString("A_identity"));
            contract.setaIdentityDate(rs.getDate("A_identity_date"));
            contract.setaIdentityAddress(rs.getString("A_identity_address"));
            contract.setaBirthday(rs.getDate("A_birthday"));
            contract.setaAddress(rs.getString("A_address"));
            contract.setaRepresentative(rs.getString("A_representative"));
            contract.setaTaxCode(rs.getString("A_tax_code"));
            contract.setaPhoneNumber(rs.getString("A_phone_number"));
            contract.setaEmail(rs.getString("A_email"));
            contract.setaSignature(rs.getString("A_signature"));
            contract.setbName(rs.getString("B_name"));
            contract.setbIdentity(rs.getString("B_identity"));
            contract.setbIdentityDate(rs.getDate("B_identity_date"));
            contract.setbIdentityAddress(rs.getString("B_identity_address"));
            contract.setbBirthday(rs.getDate("B_birthday"));
            contract.setbAddress(rs.getString("B_address"));
            contract.setbRepresentative(rs.getString("B_representative"));
            contract.setbPhoneNumber(rs.getString("B_phone_number"));
            contract.setbEmail(rs.getString("B_email"));
            contract.setbSignature(rs.getString("B_signature"));
            contract.setJobGoal(rs.getString("job_goal"));
            contract.setJobRequirement(rs.getString("job_requirement"));
            contract.setStartDate(rs.getDate("start_date"));
            contract.setEndDate(rs.getDate("end_date"));
            contract.setJobAddress(rs.getString("job_address"));
            contract.setJobFee(rs.getBigDecimal("job_fee"));
            contract.setJobDepositA(rs.getBigDecimal("job_deposit_A"));
            contract.setJobDepositADate(rs.getDate("job_deposit_A_date"));
            contract.setJobDepositAText(rs.getString("job_deposit_A_text"));
            contract.setJobDepositB(rs.getBigDecimal("job_deposit_B"));
            contract.setJobDepositBDate(rs.getDate("job_deposit_B_date"));
            contract.setJobDepositBText(rs.getString("job_deposit_B_text"));
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return contract;
    }

    public Contract getContractByJobIdAndApplicantId(int job_id, int applicantId) throws SQLException {
        Contract contract = null;
        String sql = "SELECT * FROM Contract WHERE job_id = ? AND applicant_id = ?";

        try (Connection conn = DBConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, job_id);
            stmt.setInt(2, applicantId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    contract = mapResultSetToContract(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting contract by Job ID: " + job_id);
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return contract;
    }
    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateBSignatureContract(String bSignature, int contractId) throws SQLException {
        boolean success = false;
        String query = "UPDATE Contract SET B_signature = ? WHERE contract_id = ?";

        try {
            conn = DBConnection.openConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, bSignature);
            ps.setInt(2, contractId);

            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return success;
    }

    public List<Contract> getContractListByJobIdWasSuccess(int jobId) throws Exception {
        List<Contract> contractList = new ArrayList<>();
        String sql = "SELECT * FROM Contract \n" +
                "WHERE job_id = ? \n" +
                "  AND (status LIKE N'Kí kết thành công%' OR status LIKE N'Hoàn tất thanh lí%')\n";

        try (Connection conn = DBConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, jobId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contractList.add(mapResultSetToContract(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return contractList;
    }
    public List<Contract> getContractListByJobId(int jobId) throws Exception {
        List<Contract> contractList = new ArrayList<>();
        String sql = "SELECT * FROM Contract WHERE job_id = ?";

        try (Connection conn = DBConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, jobId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contractList.add(mapResultSetToContract(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return contractList;
    }

//    public static void main(String[] args) {
//        ContractDAO contractDAO = new ContractDAO();
//        System.out.println(contractDAO.getContractListByJobIdWasSuccess(2));
//    }
}