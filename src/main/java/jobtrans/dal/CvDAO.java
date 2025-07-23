package jobtrans.dal;

import jobtrans.model.*;
import jobtrans.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CvDAO {
    private final DBConnection dbConnection;


    public CvDAO() {
        dbConnection = DBConnection.getInstance();
    }
    public int getLatestCVIDByAccountId(int accountId) throws SQLException {
        int cvId = -1;
        String sql = "SELECT TOP 1 CV_id FROM CV WHERE account_id = ? ORDER BY CV_id DESC";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cvId = rs.getInt("CV_id");
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return cvId;
    }

    public CV findPDFById(int cvId) {
        String sql = "SELECT CV_id, CV_upload FROM CV WHERE CV_id = ?";
        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cvId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CV cv = new CV();
                cv.setCvId(rs.getInt("CV_id"));
                cv.setCvUpload(rs.getString("CV_upload"));
                return cv;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public boolean uploadCVFile(int accountId, String cvUploadPath, String linkCVReview) {
        String sql = "INSERT INTO CV (account_id, CV_upload, link_cv_review) VALUES (?, ?, ?)";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ps.setString(2, cvUploadPath);
            ps.setString(3, linkCVReview); // Có thể là null nếu không cần xem trước
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public int addCV(CV cv) throws SQLException, Exception {
        String queryAddCV = "INSERT INTO CV (account_id, job_position, summary, more_infor, sex, dateOfBirth, phone, email, address, CV_upload, avatar_cv, name, type_id,color) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";

        int cvId = 0;

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(queryAddCV, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, cv.getAccountId());
            stmt.setString(2, cv.getJobPosition());
            stmt.setString(3, cv.getSummary());
            stmt.setString(4, cv.getMoreInfo());
            stmt.setString(5, cv.getSex());
            stmt.setDate(6, new java.sql.Date(cv.getDateOfBirth().getTime())); // Chuyển đổi đúng định dạng
            stmt.setString(7, cv.getSdt());
            stmt.setString(8, cv.getEmail());
            stmt.setString(9, cv.getAddress());
            stmt.setString(10, cv.getCvUpload());
            stmt.setString(11, cv.getAvatarCv());
            stmt.setString(12, cv.getCvName());  // Thêm giá trị cho cột name
            stmt.setInt(13, cv.getCvType());   // Thêm giá trị cho cột type_id
            stmt.setString(14,cv.getBackroundColor());
            int affectedRows = stmt.executeUpdate(); // Dùng executeUpdate() thay vì executeQuery()
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        cvId = rs.getInt(1); // Lấy ID của CV mới tạo
                    }
                }
            }

            if (cvId > 0) {
                addSkillsForCV(cvId, cv.getSkillList(), conn);
                addExperiencesForCV(cvId, cv.getExperienceList(), conn);
                addEducationsForCV(cvId, cv.getEducationList(), conn);
                addCertificationsForCV(cvId, cv.getCertificationList(), conn);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi thêm CV: " + e.getMessage());
        }


        return cvId;
    }


    private void addSkillsForCV(int cvId, List<Skill> skills, Connection conn) throws SQLException {
        String query = "INSERT INTO CV_Skill (CV_id, skill_id, skill_custom, level_skill) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            for (Skill skill : skills) {
                stmt.setInt(1, cvId);
                stmt.setInt(2, skill.getSkillId());  // Lưu skill_id từ bảng Skill
                stmt.setString(3, skill.getSkillCustom()); // Có thể null nếu không nhập custom
                stmt.setInt(4, skill.getLevelSkill()); // Level kỹ năng

                stmt.addBatch();
            }
            stmt.executeBatch(); // Thực hiện nhiều lệnh cùng lúc để tối ưu hiệu suất
        }
    }

    private void addExperiencesForCV(int cvId, List<Experience> experiences, Connection conn) throws SQLException {
        String query = "INSERT INTO CV_Experience (CV_id, experience_id, start_at, end_at, " +
                "company_custom, job_position, address, description, achievement) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            for (Experience exp : experiences) {
                stmt.setInt(1, cvId);
                stmt.setInt(2, exp.getExperienceId());  // Added experience_id
                stmt.setDate(3, new java.sql.Date(exp.getStartAt().getTime()));
                stmt.setDate(4, new java.sql.Date(exp.getEndAt().getTime()));
                stmt.setString(5, exp.getCustomCompany());
                stmt.setString(6, exp.getJobPosition());
                stmt.setString(7, exp.getAddress());
                stmt.setString(8, exp.getDescription());
                stmt.setString(9, exp.getAchievement());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    private void addEducationsForCV(int cvId, List<Education> educations, Connection conn) throws SQLException {
        String query = "INSERT INTO CV_education (CV_id, education_id, start_date, end_date, " +
                "field_of_study, degree, edu_more_infor, school_custom) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            for (Education edu : educations) {
                stmt.setInt(1, cvId);
                stmt.setInt(2, edu.getEducationId()); // Assuming Education class has getEducationId()

                // Convert dates properly
                stmt.setDate(3, new java.sql.Date(edu.getStartDate().getTime()));
                stmt.setDate(4, new java.sql.Date(edu.getEndDate().getTime()));

                stmt.setString(5, edu.getFieldOfStudy());
                stmt.setString(6, edu.getDegree());
                stmt.setString(7, edu.getMoreInfor());
                stmt.setString(8, edu.getCustomSchool());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    private void addCertificationsForCV(int cvId, List<Certification> certifications, Connection conn) throws SQLException {
        String query = "INSERT INTO CV_Certification (CV_id, certification_id, year, certification_custom, description) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            for (Certification cert : certifications) {
                stmt.setInt(1, cvId);
                stmt.setInt(2, cert.getCertificationId());  // Assuming getCertificationId() exists

                // Convert awardYear to java.sql.Date
                stmt.setDate(3, new java.sql.Date(cert.getAwardYear().getTime()));

                stmt.setString(4, cert.getCustomCertification());
                stmt.setString(5, cert.getDescription());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public boolean deleteCvByCvId(int cvId) throws SQLException, Exception {

        PreparedStatement stmt = null;
        Connection conn = null; // Declare the connection here

        try {
            conn = dbConnection.openConnection();
            conn.setAutoCommit(false);  // Bắt đầu transaction

            if (getListSkillByCvId(cvId) != null) {
                deleteSkillByCvId(cvId);
            }

            if (getListExperienceByCvId(cvId) != null) {
                deleteExperienceByCvId(cvId);
            }

            if (getEducationByCVId(cvId) != null) {
                deleteEducationByCvId(cvId);
            }

            if (getListCertificationByCvId(cvId) != null) {
                deleteCertificationByCvId(cvId);
            }

            String queryDeleteCv = "DELETE FROM CV WHERE CV_id = ?";
            stmt = conn.prepareStatement(queryDeleteCv);
            stmt.setInt(1, cvId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();  // Rollback trong trường hợp có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    /// // Skill ////

    public ArrayList<Skill> getListSkillByCvId(int cvId) {
        ArrayList<Skill> skills = new ArrayList<>();
        String sql = "SELECT cs.cv_id, s.skill_id, ms.mainSkill_id, ms.main_skill, s.skill, " +
                "cs.skill_custom, cs.level_skill " +
                "FROM CV_Skill cs " +
                "JOIN Skill s ON cs.skill_id = s.skill_id " +
                "JOIN Main_Skill ms ON s.mainSkill_id = ms.mainSkill_id " +
                "WHERE cs.cv_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {

            statement.setInt(1, cvId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int skillId = resultSet.getInt("skill_id");
                int mainSkillId = resultSet.getInt("mainSkill_id");
                String mainSkillName = resultSet.getString("main_skill");
                String skillName = resultSet.getString("skill");
                String skillCustom = resultSet.getString("skill_custom");
                int levelSkill = resultSet.getInt("level_skill");

                Skill skill = new Skill(cvId, skillId, mainSkillId, mainSkillName, skillName, skillCustom, levelSkill);
                skills.add(skill);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách kỹ năng của CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return skills;
    }

    public String getSkillNameById(int skillId) {
        String skillName = null;
        String sql = "SELECT skill FROM Skill WHERE skill_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, skillId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                skillName = rs.getString("skill");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tên kỹ năng với skill_id " + skillId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return skillName;
    }

    public List<String> getAllSkillNames() {
        List<String> skillNames = new ArrayList<>();
        String sql = "SELECT skill FROM Skill";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                skillNames.add(rs.getString("skill"));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách kỹ năng: " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return skillNames;
    }

    public boolean deleteSkillByCvId(int cvId) {
        String query = "DELETE FROM CV_Skill WHERE cv_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, cvId);
            int rowsAffected = stmt.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa kỹ năng với CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Lỗi không xác định khi xóa kỹ năng: " + e.getMessage());
        }
        return false;
    }


    /// // expericienr
    public boolean deleteExperienceByCvId(int cvId) {
        String query = "DELETE FROM CV_Experience WHERE CV_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, cvId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("Lỗi khi xóa kinh nghiệm của CV ID " + cvId + ": " + e.getMessage());
            return false;
        }
    }

    public ArrayList<Experience> getListExperienceByCvId(int cvId) {
        ArrayList<Experience> experiences = new ArrayList<>();
        String sql = "SELECT cv_id, experience_id, job_position, company_custom, description, start_at, end_at, achievement, address " +
                "FROM CV_Experience WHERE CV_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {

            statement.setInt(1, cvId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int experienceId = resultSet.getInt("experience_id");
                String jobPosition = resultSet.getString("job_position");
                String companyCustom = resultSet.getString("company_custom");
                String description = resultSet.getString("description");
                String achievement = resultSet.getString("achievement");
                String address = resultSet.getString("address"); // Lấy địa chỉ làm việc
                Date startAt = resultSet.getDate("start_at");
                Date endAt = resultSet.getDate("end_at");
                // Lấy tên công ty từ bảng `Company`
                String companyName = getCompanyNameById(experienceId);

                Experience experience = new Experience(experienceId, cvId, companyName, startAt, endAt, companyCustom, jobPosition, address, description, achievement);
                experiences.add(experience);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách kinh nghiệm cho CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Lỗi không xác định khi lấy kinh nghiệm của CV ID " + cvId + ": " + e.getMessage());
        }

        return experiences;
    }


    //education
    public ArrayList<Education> getEducationByCVId(int cvId) {
        ArrayList<Education> educationList = new ArrayList<>();
        String sql = "SELECT education_id, start_date, end_date, field_of_study, degree, edu_more_infor, school_custom " +
                "FROM CV_Education WHERE cv_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {

            statement.setInt(1, cvId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int educationId = resultSet.getInt("education_id");
                Date startDate = resultSet.getDate("start_date");
                Date endDate = resultSet.getDate("end_date");
                String fieldOfStudy = resultSet.getString("field_of_study");
                String degree = resultSet.getString("degree");
                String moreInfor = resultSet.getString("edu_more_infor");
                String customSchool = resultSet.getString("school_custom");

                // Lấy tên trường từ bảng School
                String schoolName = getSchoolNameById(educationId);

                Education edu = new Education(educationId, schoolName, startDate, endDate, fieldOfStudy, degree, moreInfor, customSchool);
                educationList.add(edu);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách giáo dục của CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return educationList;
    }



    public List<String> getAllSchoolNames() {
        List<String> schoolNames = new ArrayList<>();
        String sql = "SELECT school_name FROM School";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                schoolNames.add(rs.getString("school_name"));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách trường học: " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return schoolNames;
    }

    public List<String> getAllSchools() {
        List<String> schools = new ArrayList<>();
        String sql = "SELECT school_name FROM School";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                schools.add(rs.getString("school_name"));
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách trường học: " + e.getMessage());
        }
        return schools;
    }
    public Integer getCompanyIdByName(String companyName) throws Exception {
        String sql = "SELECT experience_id FROM Company WHERE company_name = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, companyName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("experience_id"); // Lấy ID từ cột experience_id
                }
            }

        } catch (SQLException e) {
            throw new Exception("Error when getting company id by name: " + e.getMessage(), e);
        }

        return null; // Không tìm thấy
    }
    public Integer getSchoolIdByName(String schoolName) throws Exception {
        String sql = "SELECT education_id FROM School WHERE school_name = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, schoolName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("education_id");
                }
            }
        } catch (SQLException e) {
            throw new Exception("Error when getting school id by name: " + e.getMessage(), e);
        }

        return null; // Không tìm thấy trả về null
    }

    public Integer getCertificationIdByName(String certificationName) throws Exception {
        String sql = "SELECT certification_id FROM Certification WHERE certification_name = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, certificationName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("certification_id"); // Trả về ID tìm được
                }
            }

        } catch (SQLException e) {
            throw new Exception("Error when getting certification id by name: " + e.getMessage(), e);
        }

        return null; // Không tìm thấy
    }

    public boolean deleteEducationByCvId(int cvId) {
        String query = "DELETE FROM CV_Education WHERE cv_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, cvId);
            int rowsAffected = stmt.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa học vấn với CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Lỗi không xác định khi xóa học vấn: " + e.getMessage());
        }
        return false;
    }


    /// ceitication
    public ArrayList<Certification> getListCertificationByCvId(int cvId) {
        ArrayList<Certification> certifications = new ArrayList<>();
        String sql = "SELECT certification_id, year, description, certification_custom " +
                "FROM CV_Certification WHERE cv_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {

            statement.setInt(1, cvId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int certificationId = resultSet.getInt("certification_id");
                Date awardYear = resultSet.getDate("year");
                String description = resultSet.getString("description");
                String certificationCustom = resultSet.getString("certification_custom");

                // Lấy tên chứng chỉ từ bảng Certification
                String certificationName = getCertificationNameById(certificationId);

                Certification certification = new Certification(certificationId, certificationName, awardYear, certificationCustom, description);
                certifications.add(certification);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách chứng chỉ của CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return certifications;
    }



    public List<String> getAllCertificationNames() {
        List<String> certificationNames = new ArrayList<>();
        String sql = "SELECT certification_name FROM Certification";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                certificationNames.add(rs.getString("certification_name"));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách chứng chỉ: " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return certificationNames;
    }

    public boolean deleteCertificationByCvId(int cvId) {
        String query = "DELETE FROM CV_Certification WHERE cv_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, cvId);
            int rowsAffected = stmt.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa chứng chỉ với CV ID " + cvId + ": " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Lỗi không xác định khi xóa chứng chỉ: " + e.getMessage());
        }
        return false;
    }




    /// /view CV
    public CV getCvById(int cvId) throws Exception {
        CV cv = null;
        String query = "SELECT CV_id, account_id, job_position, summary, more_infor, created_at, "
                + "sex, dateOfBirth, phone, email, address, CV_upload, avatar_cv, name, type_id ,color "
                + "FROM CV WHERE CV_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement preparedStatement = conn.prepareStatement(query)) {

            preparedStatement.setInt(1, cvId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    cv = new CV();
                    cv.setCvId(resultSet.getInt("CV_id"));
                    cv.setAccountId(resultSet.getInt("account_id"));
                    cv.setJobPosition(resultSet.getString("job_position"));
                    cv.setSummary(resultSet.getString("summary"));
                    cv.setMoreInfo(resultSet.getString("more_infor"));
                    cv.setCreatedAt(resultSet.getDate("created_at"));
                    cv.setSex(resultSet.getString("sex"));
                    cv.setDateOfBirth(resultSet.getDate("dateOfBirth"));
                    cv.setSdt(resultSet.getString("phone"));
                    cv.setEmail(resultSet.getString("email"));
                    cv.setAddress(resultSet.getString("address"));
                    cv.setCvUpload(resultSet.getString("CV_upload"));
                    cv.setAvatarCv(resultSet.getString("avatar_cv"));
                    cv.setCvName(resultSet.getString("name"));
                    cv.setCvType(resultSet.getInt("type_id")); // Lấy type_id từ bảng CV
                    cv.setBackroundColor(resultSet.getString("color"));
                    // Lấy danh sách liên quan
                    cv.setSkillList(getListSkillByCvId(cvId));
                    cv.setEducationList(getEducationByCVId(cvId));
                    cv.setCertificationList(getListCertificationByCvId(cvId));
                    cv.setExperienceList(getListExperienceByCvId(cvId));

                    // Lấy thông tin loại CV từ bảng CV_Type
                    // Gọi phương thức lấy thông tin loại CV
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi lấy CV: " + e.getMessage());
        }
        return cv;
    }





    public String getMainSkillByMainSkillId(int mainSkillId) throws Exception {
        String mainSkill = null;
        String sql = "SELECT main_skill FROM Main_Skill WHERE mainSkill_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, mainSkillId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                mainSkill = rs.getString("main_skill");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mainSkill;
    }

    public String getSkillBySkillId(int skillId) throws Exception {
        String skillName = null;
        String sql = "SELECT skill FROM Skill WHERE skill_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, skillId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                skillName = rs.getString("skill");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return skillName;
    }
    public String getCertificationNameById(int certificationId) {
        String certificationName = null;
        String sql = "SELECT certification_name FROM Certification WHERE certification_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, certificationId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                certificationName = rs.getString("certification_name");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tên chứng chỉ với certification_id " + certificationId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return certificationName;
    }
    public String getSchoolNameById(int educationId) {
        String schoolName = null;
        String sql = "SELECT school_name FROM School WHERE education_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, educationId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                schoolName = rs.getString("school_name");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tên trường cho education_id " + educationId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return schoolName;
    }
    public String getCompanyNameById(int experienceId) {
        String companyName = null;
        String sql = "SELECT company_name FROM Company WHERE experience_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, experienceId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    companyName = rs.getString("company_name");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tên công ty với experience_id = " + experienceId + ": " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return companyName;
    }
    public ArrayList<CV> getCVByUserId(int accountId) {
        ArrayList<CV> cvList = new ArrayList<>();
        String sql = "SELECT * FROM CV WHERE account_id = ?";

        try (
                PreparedStatement statement = dbConnection.openConnection().prepareStatement(sql)) {
            statement.setInt(1, accountId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int cvId = resultSet.getInt("CV_id");
                String title = resultSet.getString("job_position");
                String summary = resultSet.getString("summary");
                Date createdAt = resultSet.getDate("created_at");
                int cvType = resultSet.getInt("type_id");

                CV cv = new CV(cvId,accountId,title,summary,createdAt,cvType);
//                cv.setEducationList(getEducationByCVId(cvId));
//                cv.setCertificationList(getListCertificationByCvId(cvId));
//                cv.setExperienceList(getListExperienceByCvId(cvId));
//                cv.setSkillList(getListSkillByCvId(cvId));

                cvList.add(cv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cvList;
    }


    /// select cv- type
    public List<CVType> getAllCVTypes() {
        List<CVType> cvTypes = new ArrayList<>();
        String sql = "SELECT type_id, type_name, description, price_cv, image_cv FROM CV_Type";  // Thêm image_cv vào câu truy vấn

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                CVType cvType = new CVType(
                        rs.getInt("type_id"),
                        rs.getString("type_name"),
                        rs.getString("description"),
                        rs.getInt("price_cv"),
                        rs.getString("image_cv") // Lấy giá trị từ cột image_cv
                );
                cvTypes.add(cvType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return cvTypes;
    }


    /// / get ALL to Create


    public List<String> getAllCompanyName() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT company_name FROM Company";
        try {
            Connection conn = dbConnection.openConnection();
            PreparedStatement statement = conn.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("company_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Skill> getAllMainSkill() {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT mainSkill_id, main_skill FROM Main_Skill";

        try {
            Connection conn = dbConnection.openConnection();
            PreparedStatement statement = conn.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                list.add(new Skill(rs.getInt(1), rs.getString(2)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public String getTypeNameById(int typeId) {
        String typeName = null;
        String sql = "SELECT type_name FROM CV_Type WHERE type_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, typeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                typeName = rs.getString("type_name");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return typeName;
    }
    public List<Skill> getSkillByMainSkill(int mainSkill_id) {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.mainSkill_id, s.skill_id, s.skill " +
                "FROM Skill s " +
                "JOIN Main_Skill ms ON s.mainSkill_id = ms.mainSkill_id " +
                "WHERE ms.mainSkill_id = ?";

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, mainSkill_id);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Thêm đối tượng Skill vào danh sách
                list.add(new Skill(rs.getInt("mainSkill_id"), rs.getInt("skill_id"), rs.getString("skill")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    ///  update
    public boolean updateCV(CV cv) throws SQLException, Exception {
        String queryUpdateCV = "UPDATE CV SET job_position = ?, summary = ?, more_infor = ?, sex = ?, dateOfBirth = ?, phone = ?, email = ?, address = ?, CV_upload = ?, avatar_cv = ?, name = ?, type_id = ?, color = ?  WHERE CV_id = ?";

        boolean isUpdated = false;

        try (Connection conn = dbConnection.openConnection();
             PreparedStatement stmt = conn.prepareStatement(queryUpdateCV)) {

            stmt.setString(1, cv.getJobPosition());
            stmt.setString(2, cv.getSummary());
            stmt.setString(3, cv.getMoreInfo());
            stmt.setString(4, cv.getSex());
            stmt.setDate(5, new java.sql.Date(cv.getDateOfBirth().getTime()));
            stmt.setString(6, cv.getSdt());
            stmt.setString(7, cv.getEmail());
            stmt.setString(8, cv.getAddress());
            stmt.setString(9, cv.getCvUpload());
            stmt.setString(10, cv.getAvatarCv());
            stmt.setString(11, cv.getCvName());
            stmt.setInt(12, cv.getCvType());
            stmt.setString(13, cv.getBackroundColor());  // color
            stmt.setInt(14, cv.getCvId());               // CV_id
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                isUpdated = true;



                // Insert lại dữ liệu mới
                updateSkillsForCV(cv.getCvId(), cv.getSkillList());
                updateExperienceForCV(cv.getCvId(), cv.getExperienceList());
                updateEducationForCV(cv.getCvId(), cv.getEducationList());
                updateCertificationsForCV(cv.getCvId(), cv.getCertificationList());
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi cập nhật CV: " + e.getMessage());
        }

        return isUpdated;
    }


    public void updateSkillsForCV(int cvId, List<Skill> skills) throws Exception {
        String deleteQuery = "DELETE FROM CV_Skill WHERE cv_id = ?";
        String insertQuery = "INSERT INTO CV_Skill (cv_id, skill_id, skill_custom, level_skill) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection connection = dbConnection.openConnection();
             PreparedStatement deleteStmt = connection.prepareStatement(deleteQuery);
             PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {

            // Delete all old skills
            deleteStmt.setInt(1, cvId);
            deleteStmt.executeUpdate();

            // Insert new skills
            for (Skill skill : skills) {
                insertStmt.setInt(1, cvId);
                insertStmt.setInt(2, skill.getSkillId());
                insertStmt.setString(3, skill.getSkillCustom());
                insertStmt.setInt(4, skill.getLevelSkill());
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();
        }
    }
    public void updateExperienceForCV(int cvId, List<Experience> experiences) throws Exception {
        String deleteQuery = "DELETE FROM CV_Experience WHERE cv_id = ?";
        String insertQuery = "INSERT INTO CV_Experience (cv_id, experience_id, job_position, " +
                "address, description, start_at, end_at, company_custom, achievement) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = dbConnection.openConnection();
             PreparedStatement deleteStmt = connection.prepareStatement(deleteQuery);
             PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {

            // Delete all old experiences
            deleteStmt.setInt(1, cvId);
            deleteStmt.executeUpdate();

            // Insert new experiences
            for (Experience exp : experiences) {
                insertStmt.setInt(1, cvId);
                insertStmt.setInt(2, exp.getExperienceId());
                insertStmt.setString(3, exp.getJobPosition());
                insertStmt.setString(4, exp.getAddress());
                insertStmt.setString(5, exp.getDescription());
                insertStmt.setDate(6, new java.sql.Date(exp.getStartAt().getTime()));
                insertStmt.setDate(7, new java.sql.Date(exp.getEndAt().getTime()));
                insertStmt.setString(8, exp.getCustomCompany());
                insertStmt.setString(9, exp.getAchievement());
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();
        }
    }public void updateEducationForCV(int cvId, List<Education> educations) throws Exception {
        String deleteQuery = "DELETE FROM CV_education WHERE cv_id = ?";
        String insertQuery = "INSERT INTO CV_education (cv_id, education_id, start_date, " +
                "end_date, field_of_study, degree, edu_more_infor, school_custom) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = dbConnection.openConnection();
             PreparedStatement deleteStmt = connection.prepareStatement(deleteQuery);
             PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {

            // Delete all old education records
            deleteStmt.setInt(1, cvId);
            deleteStmt.executeUpdate();

            // Insert new education records
            for (Education edu : educations) {
                insertStmt.setInt(1, cvId);
                insertStmt.setInt(2, edu.getEducationId());
                insertStmt.setDate(3, new java.sql.Date(edu.getStartDate().getTime()));
                insertStmt.setDate(4, new java.sql.Date(edu.getEndDate().getTime()));
                insertStmt.setString(5, edu.getFieldOfStudy());
                insertStmt.setString(6, edu.getDegree());
                insertStmt.setString(7, edu.getMoreInfor());
                insertStmt.setString(8, edu.getCustomSchool());
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();
        }
    }
    public void updateCertificationsForCV(int cvId, List<Certification> certifications) throws Exception {
        String deleteQuery = "DELETE FROM CV_Certification WHERE cv_id = ?";
        String insertQuery = "INSERT INTO CV_Certification (cv_id, certification_id, year, " +
                "description, certification_custom) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = dbConnection.openConnection();
             PreparedStatement deleteStmt = connection.prepareStatement(deleteQuery);
             PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {

            // Delete all old certifications
            deleteStmt.setInt(1, cvId);
            deleteStmt.executeUpdate();

            // Insert new certifications
            for (Certification cert : certifications) {
                insertStmt.setInt(1, cvId);
                insertStmt.setInt(2, cert.getCertificationId());
                insertStmt.setDate(3, new java.sql.Date(cert.getAwardYear().getTime()));
                insertStmt.setString(4, cert.getDescription());
                insertStmt.setString(5, cert.getCustomCertification());
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();
        }
    }

    public List<CV> getCVsByAccountId(int accountId) {
        List<CV> list = new ArrayList<>();
        String sql = "SELECT * FROM CV WHERE account_id = ?";
        try (Connection conn = dbConnection.openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CV cv = new CV();
                    cv.setCvId(rs.getInt("CV_id"));
                    cv.setAccountId(rs.getInt("account_id"));
                    cv.setJobPosition(rs.getString("job_position"));
                    cv.setSummary(rs.getString("summary"));
                    cv.setMoreInfo(rs.getString("more_infor"));
                    cv.setCreatedAt(rs.getDate("created_at"));
                    cv.setSex(rs.getString("sex"));
                    cv.setDateOfBirth(rs.getDate("dateOfBirth"));
//                    cv.setPhone(rs.getString("phone"));
                    cv.setEmail(rs.getString("email"));
                    cv.setAddress(rs.getString("address"));
                    cv.setCvUpload(rs.getString("CV_upload"));
                    cv.setAvatarCv(rs.getString("avatar_cv"));
                    cv.setCvName(rs.getString("name"));
                    cv.setCvType(rs.getInt("type_id"));
                    cv.setBackroundColor(rs.getString("color"));
                    list.add(cv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

}


