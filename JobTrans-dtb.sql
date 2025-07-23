CREATE DATABASE JobTransnew
GO
USE JobTransnew;
GO
CREATE TABLE Account (
                         account_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                         account_name NVARCHAR(100) NOT NULL,
                         email VARCHAR(50) NOT NULL,
                         password VARCHAR(MAX),
	avatar VARCHAR(MAX) DEFAULT 'img/default-avatar.jpg',
	oauth_id NVARCHAR(MAX), -- dành cho đăng nhập Google
	oauth_provider NVARCHAR(MAX), -- dành cho đăng nhập Google
	date_of_birth DATE,
    gender NVARCHAR(10) CHECK (gender IN (N'Nam', N'Nữ')),
    phone VARCHAR(50),
	address NVARCHAR(MAX),
	education NVARCHAR(255),
	speciality NVARCHAR(500),
	experience_years INT,
	skills NVARCHAR(MAX), -- xử lí như tách tag
	bio NVARCHAR(MAX),
	point INT DEFAULT 0,
	star_rate FLOAT DEFAULT 0,
	amount_wallet DECIMAL(18, 2) DEFAULT 0,
	verified_link NVARCHAR(MAX),
    verified_account BIT,
	complete_percent DECIMAL(5, 4),
    label_tag NVARCHAR(255),
    count INT, --so lan bi am diem
    role NVARCHAR(100) DEFAULT N'Người dùng' CHECK (role IN (N'Người dùng', N'Admin')),
	type_account NVARCHAR(100) CHECK (type_account IN (N'Cá nhân', N'Nhóm')),
	level_account NVARCHAR(100) DEFAULT N'Tài khoản thường' CHECK (level_account IN (N'Tài khoản thường', N'Tài khoản VIP')),
	signature NVARCHAR(MAX),
	join_date DATETIME DEFAULT GETDATE(),
	count_member INT,
    status NVARCHAR(50) DEFAULT N'Đang hoạt động' CHECK (status IN (N'Đang hoạt động', N'Bị cấm', N'Chờ xử lí'))
);
-- Tạo bảng Group_Member
CREATE TABLE Group_Member (
                              member_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                              member_name NVARCHAR(50),
                              account_id INT NOT NULL,
                              avatar_member NVARCHAR(MAX) DEFAULT 'default-avatar.jpg',
                              gender NVARCHAR(10),
                              date_of_birth DATE,
                              phone VARCHAR(50),
                              address NVARCHAR(MAX),
                              position NVARCHAR(MAX),
                              speciality NVARCHAR(50),
                              experience_years INT,
                              skills NVARCHAR(MAX),
                              bio NVARCHAR(MAX),
                              education NVARCHAR(255),
                              status NVARCHAR(50) DEFAULT N'Đang hoạt động' CHECK (status IN (N'Đang hoạt động', N'Ngừng hoạt động')),
    -- Thiết lập khóa ngoại liên kết với bảng Account
                              CONSTRAINT FK_GroupMember_Account FOREIGN KEY (account_id)
                                  REFERENCES Account(account_id)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE
);

-- Tạo api- key dùng cho ChatBot
CREATE TABLE user_api_keys (
                               id INT IDENTITY(1,1) PRIMARY KEY,
                               account_id INT NOT NULL,
                               openrouter_api_key TEXT NOT NULL,
                               created_at DATETIME DEFAULT GETDATE(),  -- Thay TIMESTAMP bằng DATETIME và GETDATE() để lấy thời gian hiện tại
                               CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES Account(account_id)
);
-- Tạo bảng Criteria vi phạm, cộng điểm
CREATE TABLE Criteria (
                          criteria_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                          content NVARCHAR(MAX),
                          criteria_point INT,
                          label_tag NVARCHAR(255) NULL,
                          type_criteria NVARCHAR(255) DEFAULT N'Trừ điểm' CHECK (type_criteria IN (N'Trừ điểm', N'Cộng điểm', N'Block', N'Nhãn cảnh báo'))
);
-- Tạo bảng PointHistory
CREATE TABLE PointHistory (
                              history_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                              account_id INT,
                              criteria_id INT,
                              time DATETIME DEFAULT GETDATE(),
                              point_note NVARCHAR(MAX)

    -- Thiết lập khóa ngoại
    CONSTRAINT FK_PointHistory_Account FOREIGN KEY (account_id)
    REFERENCES Account(account_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

                              CONSTRAINT FK_PointHistory_Criteria FOREIGN KEY (criteria_id)
                                  REFERENCES Criteria(criteria_id)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE
);
--Loại mẫu CV
CREATE TABLE CV_Type (
                         type_id INT IDENTITY(1,1) PRIMARY KEY,
                         type_name NVARCHAR(100) NOT NULL,
                         description NVARCHAR(MAX),
                         price_cv INT,
                         image_cv VARCHAR(MAX)
    );
-- CV
CREATE TABLE CV (
                    CV_id INT IDENTITY(1,1) PRIMARY KEY,
                    account_id INT NOT NULL FOREIGN KEY REFERENCES Account(account_id) ON DELETE CASCADE,
                    job_position NVARCHAR(200),
                    summary NVARCHAR(MAX),
                    more_infor NVARCHAR(MAX),
                    created_at DATE DEFAULT GETDATE(),
                    sex NVARCHAR(10),  -- Sửa lại độ dài phù hợp
                    dateOfBirth DATE,  -- Đúng cú pháp
                    phone VARCHAR(10),
                    email VARCHAR(30),
                    address NVARCHAR(100),
                    CV_upload NVARCHAR(MAX),
                    avatar_cv NVARCHAR(MAX),
                    name NVARCHAR(100),
                    type_id INT,
                    CONSTRAINT FK_CV_CV_Type FOREIGN KEY (type_id)
                        REFERENCES CV_Type(type_id) ON DELETE SET NULL
);
CREATE TABLE BackGround_CV (
                               CV_id INT NOT NULL,
                               backgroundCV NVARCHAR(255),
                               PRIMARY KEY (CV_id, backgroundCV),
                               FOREIGN KEY (CV_id) REFERENCES CV(CV_id) ON DELETE CASCADE,
);
--School
CREATE TABLE School (
                        education_id INT IDENTITY(1,1) PRIMARY KEY,
                        school_name NVARCHAR(100) NOT NULL
);
CREATE TABLE CV_education (
                              CV_id INT NOT NULL,
                              education_id INT NOT NULL,
                              start_date DATE,
                              end_date DATE,
                              field_of_study NVARCHAR(100),
                              degree NVARCHAR(50),
                              edu_more_infor NVARCHAR(MAX),
                              school_custom NVARCHAR(200),
                              PRIMARY KEY (CV_id, education_id),
                              FOREIGN KEY (CV_id) REFERENCES CV(CV_id) ON DELETE CASCADE,
                              FOREIGN KEY (education_id) REFERENCES School(education_id) ON DELETE CASCADE
);
--Certification
CREATE TABLE Certification (
                               certification_id INT IDENTITY(1,1) PRIMARY KEY,
                               certification_name NVARCHAR(100) NOT NULL
);
CREATE TABLE CV_Certification (
                                  CV_id INT NOT NULL,
                                  certification_id INT NOT NULL,
                                  year DATE,
                                  certification_custom NVARCHAR(200),

                                  description NVARCHAR(MAX),
                                  PRIMARY KEY (CV_id, certification_id),
                                  FOREIGN KEY (CV_id) REFERENCES CV(CV_id) ON DELETE CASCADE,
                                  FOREIGN KEY (certification_id) REFERENCES Certification(certification_id) ON DELETE CASCADE
);
-- Company
CREATE TABLE Company (
                         experience_id INT IDENTITY(1,1) PRIMARY KEY,
                         company_name NVARCHAR(100) NOT NULL,
                         description NVARCHAR(MAX)
);

CREATE TABLE CV_Experience (
                               CV_id INT NOT NULL,
                               experience_id INT NOT NULL,
                               start_at DATE,
                               end_at DATE,
                               company_custom NVARCHAR(200),
                               job_position NVARCHAR(100),
                               description NVARCHAR(MAX),
                               achievement NVARCHAR(MAX),
                               address NVARCHAR(100),
                               PRIMARY KEY (CV_id, experience_id),
                               FOREIGN KEY (CV_id) REFERENCES CV(CV_id) ON DELETE CASCADE,
                               FOREIGN KEY (experience_id) REFERENCES Company(experience_id) ON DELETE CASCADE
);
--Skill
CREATE TABLE Main_Skill (
                            mainSkill_id INT IDENTITY(1,1) PRIMARY KEY,
                            main_skill NVARCHAR(100) NOT NULL -- VD: Lập trình, Ngôn ngữ
);

CREATE TABLE Skill (
                       skill_id INT IDENTITY(1,1) PRIMARY KEY,
                       mainSkill_id INT NOT NULL, -- Liên kết đến nhóm kỹ năng
                       skill NVARCHAR(100) NOT NULL, -- VD: CSS, HTML, Tiếng Anh
                       FOREIGN KEY (mainSkill_id) REFERENCES Main_Skill(mainSkill_id) ON DELETE CASCADE
);
CREATE TABLE CV_Skill (
                          CV_id INT NOT NULL,
                          skill_id INT NOT NULL, -- Liên kết đến Skill thay vì Main_Skill
                          skill_custom NVARCHAR(200) NULL, -- Nếu muốn nhập kỹ năng ngoài danh mục
                          level_skill INT,

                          PRIMARY KEY (CV_id, skill_id),
                          FOREIGN KEY (CV_id) REFERENCES CV(CV_id) ON DELETE CASCADE,
                          FOREIGN KEY (skill_id) REFERENCES Skill(skill_id) ON DELETE CASCADE
);
-- JOB
CREATE TABLE StatusJob(
                          status_job_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                          status_job_name NVARCHAR(100),
                          status_job_description NVARCHAR(MAX)
)
CREATE TABLE JobCategory (
                             category_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                             category_name NVARCHAR(50) NOT NULL,
                             description NVARCHAR(100),
);
CREATE TABLE Job (
                     job_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                     post_account_id INT NOT NULL, -- Thêm khóa ngoại tham chiếu Account
                     job_title NVARCHAR(150) NOT NULL,
                     post_date DATETIME DEFAULT GETDATE(),
                     job_description NVARCHAR(MAX),
                     requirements NVARCHAR(MAX),
                     benefit NVARCHAR(MAX),
                     attachment VARCHAR(MAX),
    category_id INT NOT NULL,
	budget_max DECIMAL(18,2),
    budget_min DECIMAL(18,2),
    due_date_post DATE, --Hạn kết thúc bài đăng
	due_date_job DATE, -- Hạn dự kiến kết thúc công việc
    have_interviewed BIT,
	have_tested BIT,
    num_of_member INT,
    secure_wallet DECIMAL(18,2),
	status_post NVARCHAR(100) DEFAULT N'Đang tuyển' CHECK (status_post IN (N'Đang tuyển', N'Hết hạn')),
	status_job_id INT NOT NULL DEFAULT 1,
	CONSTRAINT FK_Job_StatusJob FOREIGN KEY (status_job_id) REFERENCES StatusJob(status_job_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_Job_JobCategory FOREIGN KEY (category_id) REFERENCES JobCategory(category_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Job_Account FOREIGN KEY (post_account_id) REFERENCES Account(account_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Tag (
                     tag_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                     tag_name NVARCHAR(50) NOT NULL,
                     description NVARCHAR(100)
);

CREATE TABLE JobTag (
                        job_tag_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                        tag_id INT NOT NULL,
                        job_id INT NOT NULL,
                        CONSTRAINT FK_JobTag_Job FOREIGN KEY (job_id) REFERENCES Job(job_id)
                            ON DELETE CASCADE,
                        CONSTRAINT FK_JobTag_Tag FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
                            ON DELETE CASCADE
);
CREATE TABLE Test (
                      test_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                      job_id INT NOT NULL, -- test dành cho job nào
                      test_link VARCHAR(500) NOT NULL,
                      have_required BIT NOT NULL DEFAULT 1, -- có bắt buộc hay không (default TRUE)
                      created_at DATETIME DEFAULT GETDATE(),
                      CONSTRAINT FK_Test_Job FOREIGN KEY (job_id) REFERENCES Job(job_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Reject_reason(
                              reject_reason_id INT IDENTITY(1,1) PRIMARY KEY,
                              reject_reason NVARCHAR(500)
)

CREATE TABLE JobGreeting (
                             greeting_id INT IDENTITY(1,1) PRIMARY KEY,
                             job_seeker_id INT NOT NULL, -- Thêm khóa ngoại tham chiếu Account
                             job_id INT NOT NULL,
                             cv_id INT NOT NULL,
                             create_at DATETIME DEFAULT GETDATE(),
                             price DECIMAL(18,2),
                             expected_day INT,
                             introduction NVARCHAR(MAX),
                             attachment NVARCHAR(MAX),
                             have_read BIT,
                             reject_reason_id INT,
                             reject_reason_note NVARCHAR(MAX),
                             confirm_note NVARCHAR(MAX),
                             status NVARCHAR(100) DEFAULT N'Chờ xét duyệt' CHECK (status IN (N'Chờ xét duyệt', N'Chờ phỏng vấn', N'Bị từ chối', N'Được nhận')),
                             FOREIGN KEY (job_seeker_id) REFERENCES Account(account_id),
                             FOREIGN KEY (cv_id) REFERENCES CV(cv_id),
                             FOREIGN KEY (job_id) REFERENCES Job(job_id) ON DELETE CASCADE
                                 ON UPDATE CASCADE,
                             FOREIGN KEY (reject_reason_id) REFERENCES Reject_reason(reject_reason_id)
);
CREATE TABLE Interview (
                           interview_id INT IDENTITY(1,1) PRIMARY KEY,
                           interview_date DATE DEFAULT CAST(GETDATE() AS DATE),
                           interview_time TIME DEFAULT CAST(GETDATE() AS TIME),
                           interview_form NVARCHAR(20) CHECK (interview_form IN (N'Offline', N'Online')),
                           interview_address NVARCHAR(MAX),
                           interview_link NVARCHAR(MAX),
                           interview_record NVARCHAR(MAX),
                           interview_note NVARCHAR(MAX),
                           job_id INT NOT NULL,  -- Thêm cột job_id
                           greeting_id INT,

    -- Thiết lập khóa ngoại tham chiếu đến bảng Job
                           CONSTRAINT FK_Interview_Job FOREIGN KEY (job_id) REFERENCES Job(job_id),
                           FOREIGN KEY (greeting_id) REFERENCES JobGreeting(greeting_id) ON DELETE CASCADE
                               ON UPDATE CASCADE
);
CREATE TABLE Conversation (
                              conversation_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                              job_id INT NOT NULL,
                              start_date DATE NOT NULL,
                              CONSTRAINT FK_Conversation_Job FOREIGN KEY (job_id) REFERENCES Job(job_id) ON DELETE CASCADE
);
CREATE TABLE Message (
                         message_id INT IDENTITY(1,1) PRIMARY KEY,
                         conversation_id INT NOT NULL,
                         sender_id INT NOT NULL,
                         content NVARCHAR(MAX),
                         sent_time DATETIME DEFAULT GETDATE(),
                         replied_to_id INT,
                         is_sticker BIT DEFAULT 0,
                         attachment_url VARCHAR(255),
                         CONSTRAINT FK_Message_Account FOREIGN KEY (sender_id) REFERENCES Account(account_id),
                         CONSTRAINT FK_Message_Conversation FOREIGN KEY (conversation_id) REFERENCES Conversation(conversation_id)
                             ON DELETE CASCADE
                             ON UPDATE CASCADE
);
ALTER TABLE Message
    ADD is_sticker BIT DEFAULT 0;
CREATE TABLE Stickers (
                          sticker_id INT IDENTITY(1,1) PRIMARY KEY,
                          sticker_url VARCHAR(255) NOT NULL,
                          sticker_name NVARCHAR(50)
);

CREATE TABLE Shipment (
                          shipmentSequence INT IDENTITY(1,1) PRIMARY KEY,
                          shipmentId VARCHAR(50),               -- Mã đơn hàng bên thứ ba
                          jobId INT NOT NULL,                   -- Khóa ngoại đến bảng Job
                          sender_id INT NOT NULL,
                          pick_name NVARCHAR(100),
                          pick_province NVARCHAR(100),
                          pick_district NVARCHAR(100),
                          pick_ward NVARCHAR(100),
                          pick_address NVARCHAR(200),
                          pick_tel VARCHAR(20),
                          name NVARCHAR(100),
                          province NVARCHAR(100),
                          district NVARCHAR(100),
                          ward NVARCHAR(100),
                          address NVARCHAR(200),
                          tel VARCHAR(20),
                          product_name NVARCHAR(200),
                          product_quantity INT,
                          product_weight FLOAT,
                          status NVARCHAR(50),
                          tracking_id VARCHAR(100),
                          CONSTRAINT FK_Shipment_Account FOREIGN KEY (sender_id) REFERENCES Account(account_id),
                          CONSTRAINT FK_Shipment_Job FOREIGN KEY (jobId) REFERENCES Job(job_id)
                              ON DELETE CASCADE
                              ON UPDATE CASCADE
);
CREATE TRIGGER trg_SetShipmentId
    ON Shipment
    AFTER INSERT
AS
BEGIN
UPDATE s
SET shipmentId = 'J' + CAST(i.shipmentSequence AS VARCHAR)
    FROM Shipment s
    INNER JOIN inserted i ON s.shipmentSequence = i.shipmentSequence;
END;


CREATE TABLE DigitalProduct(
                               digital_product_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                               job_id INT NOT NULL,
                               CONSTRAINT FK_DigitalProduct_Job FOREIGN KEY (job_id) REFERENCES Job(job_id) ON DELETE CASCADE
                                   ON UPDATE CASCADE,
                               sender_id INT NOT NULL,
                               CONSTRAINT FK_DigitalProduct_Account FOREIGN KEY (sender_id) REFERENCES Account(account_id),
                               digital_product_url VARCHAR(MAX),
							notes NVARCHAR(MAX),
							status NVARCHAR(100)

)
CREATE TABLE Feedback (
                          feedback_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                          job_id INT NOT NULL,                      -- Mã công việc được phản hồi
                          from_user_id INT NOT NULL,                -- Người gửi feedback (có thể là seeker hoặc employer)
                          to_user_id INT NOT NULL,                  -- Người nhận feedback
                          rating INT CHECK (rating BETWEEN 1 AND 5),-- Điểm đánh giá sao (từ 1 đến 5)
                          content NVARCHAR(MAX),                    -- Nội dung phản hồi (mô tả chi tiết)
                          created_at DATETIME DEFAULT GETDATE(),    -- Thời gian gửi feedback
                          type NVARCHAR(20) CHECK (type IN (N'EmployerToSeeker', N'SeekerToEmployer')), -- Loại feedback
                          FOREIGN KEY (job_id) REFERENCES Job(job_id) ON DELETE CASCADE
                              ON UPDATE CASCADE,
                          FOREIGN KEY (from_user_id) REFERENCES Account(account_id),
                          FOREIGN KEY (to_user_id) REFERENCES Account(account_id)
);

--Vào thẳng Constrain của bảng Feedback để xóa constraint cũ của check type
ALTER TABLE Feedback ADD CONSTRAINT CK_Feedback_Type CHECK (type IN (N'EmployerToSeeker', N'SeekerToEmployer', N'SeekerToSeeker'));

CREATE TABLE CancelRequest (
                               cancel_request_id INT IDENTITY(1,1) PRIMARY KEY,
                               job_id INT NOT NULL,
                               requester_id INT NOT NULL, -- ID người yêu cầu hủy
                               reason NVARCHAR(MAX),      -- Lý do yêu cầu hủy
                               created_at DATETIME DEFAULT GETDATE(), -- Thời gian gửi yêu cầu
                               have_approved BIT DEFAULT 0, -- Trạng thái phê duyệt (0: chưa duyệt, 1: đã duyệt)

    -- Ràng buộc khóa ngoại
                               CONSTRAINT FK_CancelRequest_Job FOREIGN KEY (job_id) REFERENCES Job(job_id)
                                   ON DELETE CASCADE
                                   ON UPDATE CASCADE,
                               CONSTRAINT FK_CancelRequest_Account FOREIGN KEY (requester_id) REFERENCES Account(account_id)
);
-- Tạo Bảng Contract
CREATE TABLE Contract (
                          contract_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                          applicant_id INT NOT NULL,
                          employer_id INT NOT NULL,
                          job_id INT NOT NULL,
                          contract_preview  NVARCHAR(MAX),
                          contract_link NVARCHAR(MAX),
                          status NVARCHAR(100) DEFAULT N'Chưa ký kết' CHECK (status IN (N'Chờ bên B xác nhận kí kết', N'Kí kết thành công', N'Kí kết thất bại', N'Hoàn tất thanh lí')),
                          A_name NVARCHAR(100) NOT NULL,
                          A_identity VARCHAR(50) NOT NULL, --số cccd/cmnd
                          A_identity_date DATE NOT NULL, --ngày cấp
                          A_identity_address  NVARCHAR(100) NOT NULL, --nơi cấp
                          A_birthday DATE,
                          A_address NVARCHAR(500),
                          A_representative NVARCHAR(500), --đại diện
                          A_tax_code NVARCHAR(20) NOT NULL, --mã số thuế
                          A_phone_number VARCHAR(50),
                          A_email VARCHAR(200),
                          A_signature NVARCHAR(MAX) NOT NULL,
                          B_name NVARCHAR(100) NOT NULL,
                          B_identity VARCHAR(50) NOT NULL, --số cccd/cmnd
                          B_identity_date DATE NOT NULL, --ngày cấp
                          B_identity_address  NVARCHAR(100) NOT NULL, --nơi cấp
                          B_birthday DATE,
                          B_address NVARCHAR(500),
                          B_representative NVARCHAR(500), --đại diện
                          B_phone_number VARCHAR(50),
                          B_email VARCHAR(200),
                          B_signature NVARCHAR(MAX) NULL,
                          job_goal NVARCHAR(MAX) NOT NULL,
                          job_requirement NVARCHAR(MAX) NOT NULL,
                          start_date DATE NOT NULL,
                          end_date DATE NOT NULL,
                          job_address NVARCHAR(MAX) NOT NULL,
                          job_fee DECIMAL(18,2) NOT NULL,
                          job_deposit_A DECIMAL(18,2) NOT NULL,
                          job_deposit_A_date DATE NOT NULL,
                          job_deposit_A_text NVARCHAR(200),
                          job_deposit_B DECIMAL(18,2) NOT NULL,
                          job_deposit_B_date DATE NOT NULL,
                          job_deposit_B_text NVARCHAR(200),
                          CONSTRAINT FK_Contract_Job FOREIGN KEY (job_id) REFERENCES Job(job_id)
                              ON DELETE CASCADE
                              ON UPDATE CASCADE,
                          FOREIGN KEY (applicant_id) REFERENCES Account(account_id),
                          FOREIGN KEY (employer_id) REFERENCES Account(account_id)

);
-- Tạo bảng Transaction
CREATE TABLE [Transaction] (
                               transaction_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT,
    job_id INT,
    amount DECIMAL(18,2) NOT NULL,
    created_date DATETIME DEFAULT GETDATE(),
    description NVARCHAR(MAX),
    transaction_type NVARCHAR(50) DEFAULT N'Thêm tiền' CHECK (transaction_type IN (N'Thêm tiền', N'Trừ tiền', N'Rút tiền')) ,
    status BIT DEFAULT 1,

    -- Thiết lập khóa ngoại
    FOREIGN KEY (sender_id) REFERENCES Account(account_id),

    FOREIGN KEY (receiver_id) REFERENCES Account(account_id),

    CONSTRAINT FK_Transaction_Job FOREIGN KEY (job_id) REFERENCES Job(job_id) ON DELETE CASCADE
                                                                              ON UPDATE CASCADE
    );

-- Tạo bảng Notification
CREATE TABLE Notification (
                              notification_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                              account_id INT,  -- Khóa ngoại tham chiếu đến Account
                              notification_title NVARCHAR(150),
                              notification_content NVARCHAR(MAX),
                              notification_type NVARCHAR(100) CHECK (notification_type IN(N'Giao dịch', N'Hệ thống', N'Tương tác')),
                              notification_time DATETIME DEFAULT GETDATE(),
                              have_read BIT,
                              link_detail NVARCHAR(MAX),
    -- Thiết lập khóa ngoại liên kết với bảng Account
                              CONSTRAINT FK_Notification_Account FOREIGN KEY (account_id)
                                  REFERENCES Account(account_id)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE
);

CREATE TABLE Report (
                        report_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                        job_id INT,
                        reported_account INT,
                        report_by INT,
                        criteria_id INT,
                        content_report NVARCHAR(MAX),
                        attachment NVARCHAR(MAX),
                        report_time DATETIME DEFAULT GETDATE(),
                        note_by_admin NVARCHAR(MAX),
                        status NVARCHAR(200) DEFAULT N'Chờ xử lí' CHECK (status IN (N'Chờ xử lí', N'Bị từ chối', N'Đã xử lí')) ,
                        CONSTRAINT FK_Report_Job FOREIGN KEY (job_id) REFERENCES Job(job_id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
                        FOREIGN KEY (reported_account) REFERENCES Account(account_id),
                        FOREIGN KEY (report_by) REFERENCES Account(account_id),
                        FOREIGN KEY (criteria_id) REFERENCES Criteria(criteria_id)
);

INSERT INTO [JobTransnew].[dbo].[Stickers] ([sticker_url], [sticker_name])
VALUES
    ('stickers/corgi.png', 'corgi'),
    ('stickers/so-cute.png', 'so-cute'),
    ('stickers/strawberry-milk.png', 'strawberry-milk'),
    ('stickers/paper-plane.png', 'paper-plane'),
    ('stickers/sun.png', 'sun'),
    ('stickers/book.png', 'book'),
    ('stickers/heart-shape.png', 'heart-shape'),
    ('stickers/cat.png', 'cat'),
    ('stickers/emoticon.png', 'emoticon'),
    ('stickers/smile.png', 'smile');
ALTER TABLE CV
    add color NVARCHAR(MAX);

UPDATE CV_Type
SET image_cv = './img/anh1/cv1.png'
WHERE type_id = 1;
UPDATE CV_Type
SET image_cv = './img/anh1/cv2.png'
WHERE type_id = 2;
UPDATE CV_Type
SET image_cv = './img/anh1/cv3.png'
WHERE type_id = 3;
UPDATE CV_Type
SET image_cv = './img/anh1/cv4.png'
WHERE type_id = 4;

INSERT INTO CV_Type (type_name, description, price_cv, image_cv)
VALUES
    ('Mordern CV', N'CV hiện đại với thông tin cá nhân và kinh nghiệm làm việc.', 0, 'img/cv/basic_cv_image.jpg'),
    ('Professional CV', N'CV chuyên nghiệp với các kỹ năng, chứng chỉ, và dự án đã thực hiện.', 0 , 'img/cv/professional_cv.jpg')
ALTER TABLE Job
    ADD CONSTRAINT DF_Job_SecureWallet DEFAULT 0.00 FOR secure_wallet;
