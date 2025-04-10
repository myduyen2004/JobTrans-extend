<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en-US">

<!-- Mirrored from themebing.com/wp/prolancer/projects/?projects-layout=projects_fullwidth by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 13 Jan 2025 09:33:35 GMT -->
<!-- Added by HTTrack -->
<meta http-equiv="content-type" content="text/html;charset=UTF-8"/><!-- /Added by HTTrack -->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="profile" href="https://gmpg.org/xfn/11">

    <title>Quản lí Công việc [Tên công việc] &#8211; JobTrans</title>
    <meta name='robots' content='max-image-preview:large'/>
    <link rel="icon" type="image/png" href="wp-content/uploads/2021/09/logo.png">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

</head>
<style>
    :root {
        --primary: #2c3e50;
        --secondary: #34495e;
        --accent: #3498db;
        --light: #ecf0f1;
        --dark: #2c3e50;
        --text: #333;
        --border: #ddd;
        --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        --radius: 8px;
        --transition: all 0.3s ease;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Roboto', sans-serif;
        background-color: #f5f7fa;
        color: var(--text);
        line-height: 1.6;
        min-height: 100vh;

        justify-content: center;
        padding: 40px 0;
    }

    .cv-container {
        width: 1200px;
        display: flex;
        box-shadow: var(--shadow);
        background: white;
        border-radius: var(--radius);
        overflow: hidden;
        position: relative;
        margin-top: 20px;
        margin-left: 10%;
    }

    /* Sidebar Styles */
    .cv-sidebar {
        width: 350px;
        background: var(--primary);
        color: white;
        padding: 40px 30px;
        position: relative;
        z-index: 1;
    }

    .avatar-container {
        width: 200px;
        height: 200px;
        border-radius: 50%;
        margin: 0 auto 30px;
        border: 4px solid white;
        overflow: hidden;
        position: relative;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        transition: var(--transition);
    }

    .avatar-container:hover {
        transform: scale(1.03);
    }

    .avatar-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .avatar-upload {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0, 0, 0, 0.7);
        color: white;
        padding: 10px;
        text-align: center;
        font-size: 14px;
        opacity: 0;
        transition: var(--transition);
    }

    .avatar-container:hover .avatar-upload {
        opacity: 1;
    }

    .section-title {
        font-family: 'Montserrat', sans-serif;
        font-size: 20px;
        font-weight: 700;
        margin: 30px 0 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        color: white;
        position: relative;
    }

    .section-title:after {
        content: '';
        position: absolute;
        left: 0;
        bottom: -2px;
        width: 50px;
        height: 2px;
        background: var(--accent);
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-control {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: var(--radius);
        background: rgba(255, 255, 255, 0.1);
        color: white;
        font-size: 15px;
        transition: var(--transition);
    }

    .form-control:focus {
        outline: none;
        border-color: var(--accent);
        background: rgba(255, 255, 255, 0.2);
    }

    .form-control::placeholder {
        color: rgba(255, 255, 255, 0.7);
    }

    textarea.form-control {
        min-height: 100px;
        resize: vertical;
    }

    /* Main Content Styles */
    .cv-content {
        flex: 1;
        padding: 50px;
        background: white;
        position: relative;
    }

    .header-section {
        text-align: center;
        margin-bottom: 50px;
    }

    .name-input {
        font-size: 32px;
        font-weight: 700;
        color: var(--dark);
        border: none;
        border-bottom: 2px solid var(--accent);
        padding: 10px 0;
        text-align: center;
        width: 80%;
        margin: 0 auto 15px;
        font-family: 'Montserrat', sans-serif;
        transition: var(--transition);
    }

    .name-input:focus {
        outline: none;
        border-bottom-color: var(--primary);
    }

    .position-input {
        font-size: 20px;
        color: var(--secondary);
        border: none;
        text-align: center;
        width: 80%;
        margin: 0 auto;
        padding: 5px 0;
        transition: var(--transition);
    }

    .position-input:focus {
        outline: none;
        color: var(--primary);
    }

    .content-section {
        margin-bottom: 40px;
    }

    .content-title {
        font-family: 'Montserrat', sans-serif;
        font-size: 24px;
        font-weight: 700;
        color: var(--primary);
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid var(--light);
        position: relative;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .content-title:after {
        content: '';
        position: absolute;
        left: 0;
        bottom: -2px;
        width: 50px;
        height: 2px;
        background: var(--accent);
    }

    .btn-group {
        display: flex;
        gap: 10px;
    }

    .btn {
        padding: 8px 16px;
        border: none;
        border-radius: var(--radius);
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: var(--transition);
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    .btn-primary {
        background: var(--accent);
        color: white;
    }

    .btn-primary:hover {
        background: #2980b9;
        transform: translateY(-2px);
    }

    .btn-danger {
        background: #e74c3c;
        color: white;
    }

    .btn-danger:hover {
        background: #c0392b;
    }

    .date-group {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
    }

    .date-group .form-control {
        flex: 1;
    }

    /* Main content form controls */
    .main-form-control {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid var(--border);
        border-radius: var(--radius);
        font-size: 15px;
        transition: var(--transition);
        margin-bottom: 15px;
        background: white;
    }

    .main-form-control:focus {
        outline: none;
        border-color: var(--accent);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
    }

    textarea.main-form-control {
        min-height: 120px;
    }

    .submit-btn {
        background: var(--primary);
        color: white;
        padding: 14px 30px;
        font-size: 16px;
        font-weight: 600;
        border: none;
        border-radius: var(--radius);
        cursor: pointer;
        transition: var(--transition);
        display: block;
        margin: 40px auto 0;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .submit-btn:hover {
        background: var(--secondary);
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    }

    /* Animation */
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .cv-sidebar > div,
    .cv-content > div {
        animation: fadeIn 0.5s ease-out forwards;
    }

    .cv-sidebar > div:nth-child(1) {
        animation-delay: 0.1s;
    }

    .cv-sidebar > div:nth-child(2) {
        animation-delay: 0.2s;
    }

    .cv-sidebar > div:nth-child(3) {
        animation-delay: 0.3s;
    }

    .cv-content > div:nth-child(1) {
        animation-delay: 0.2s;
    }

    .cv-content > div:nth-child(2) {
        animation-delay: 0.3s;
    }

    .cv-content > div:nth-child(3) {
        animation-delay: 0.4s;
    }

    .cv-content > div:nth-child(4) {
        animation-delay: 0.5s;
    }
</style>
<body class="archive post-type-archive post-type-archive-projects wp-custom-logo theme-prolancer woocommerce-no-js elementor-default elementor-kit-1806">

<!-- Preloading -->
<div id="preloader">
    <div class="spinner">
        <div class="uil-ripple-css">
            <div></div>
            <div></div>
        </div>
    </div>
</div>

<a class="skip-link screen-reader-text" href="#content">Skip to content</a>

<%@include file="includes/header-login-01.jsp" %>


<!--Mobile Navigation Toggler-->
<div class="off-canvas-menu-bar">
    <div class="container">
        <div class="row">
            <div class="col-6 my-auto">
                <a href="../index.html" class="custom-logo-link" rel="home"><img width="500" height="71"
                                                                                 src="wp-content/uploads/2021/09/logo.png"
                                                                                 class="custom-logo" alt="ProLancer"
                                                                                 decoding="async"
                                                                                 srcset="https://themebing.com/wp/prolancer/wp-content/uploads/2021/09/logo.png 500w, https://themebing.com/wp/prolancer/wp-content/uploads/2021/09/logo-300x43.png 300w"
                                                                                 sizes="(max-width: 500px) 100vw, 500px"/></a>
            </div>
            <div class="col-6">
                <div class="mobile-nav-toggler float-end"><span class="fal fa-bars"></span></div>
            </div>
        </div>
    </div>
</div>

<!-- Mobile Menu  -->
<div class="off-canvas-menu">
    <div class="menu-backdrop"></div>
    <i class="close-btn fa fa-close"></i>
    <nav class="mobile-nav">
        <div class="text-center pt-3 pb-3">
            <a href="../index.html" class="custom-logo-link" rel="home"><img width="500" height="71"
                                                                             src="wp-content/uploads/2021/09/logo.png"
                                                                             class="custom-logo" alt="ProLancer"
                                                                             decoding="async"
                                                                             srcset="https://themebing.com/wp/prolancer/wp-content/uploads/2021/09/logo.png 500w, https://themebing.com/wp/prolancer/wp-content/uploads/2021/09/logo-300x43.png 300w"
                                                                             sizes="(max-width: 500px) 100vw, 500px"/></a>
        </div>

        <ul class="navigation"><!--Keep This Empty / Menu will come through Javascript--></ul>
        <div class="text-center">
            <a href="../frontend-dashboard/index6f28.html?fed=dashboard" class="prolancer-btn mt-4">
                Dashboard </a>
        </div>
    </nav>
</div>


<section>
    <div class="breadcrumbs">
        <div class="container">
            <div class="row">
                <div class="col-md-12 my-auto">

                    <ul class="trail-items">
                        <li class="trail-item trail-begin"><a href="../index.html"><span
                                style="font-family: 'Inter', sans-serif;">Công việc của tôi</span></a>
                            <meta itemprop="position" content="1"/>
                        </li>
                        <li class="trail-item trail-end"><span itemprop="item"><span
                                itemprop="name">Công việc đã đăng</span></span>
                            <meta itemprop="position" content="2"/>
                        </li>
                    </ul>
                </div>
                <h1>
                    QUẢN LÍ CÔNG VIỆC </h1>
            </div>

        </div>
    </div>
</section>
<div style="display: flex">
    <div>
        <div class="cv-container">

            <%@include file="./includes/sidebar.jsp" %>

            <!-- Left Sidebar -->
            <div class="cv-sidebar">
                <div class="avatar-container">
                    <img id="avatar-preview" src="https://randomuser.me/api/portraits/men/32.jpg" alt="John Doe">
                </div>

                <h2 class="section-title">Contact Info</h2>
                <div class="form-group">
                    <div class="contact-info"><i class="fas fa-phone"></i> (123) 456-7890</div>
                </div>
                <div class="form-group">
                    <div class="contact-info"><i class="fas fa-envelope"></i> john.doe@example.com</div>
                </div>
                <div class="form-group">
                    <div class="contact-info"><i class="fas fa-map-marker-alt"></i> 123 Main St, New York, NY</div>
                </div>
                <div class="form-group">
                    <div class="contact-info"><i class="fas fa-birthday-cake"></i> June 15, 1990</div>
                </div>

                <h2 class="section-title">Skills</h2>
                <div class="skills-section">
                    <div class="skill-item">
                        <div class="skill-name">Java Development</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 90%;"></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-name">Spring Framework</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 85%;"></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-name">Database Design</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 80%;"></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-name">Project Management</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 75%;"></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-name">Team Leadership</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 85%;"></div>
                        </div>
                    </div>
                </div>

                <h2 class="section-title">Languages</h2>
                <div class="skills-section">
                    <div class="skill-item">
                        <div class="skill-name">English</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 100%;"></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-name">Spanish</div>
                        <div class="skill-proficiency">
                            <div class="proficiency-bar" style="width: 60%;"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="cv-content">
                <div class="header-section">
                    <h1 class="name">John Doe</h1>
                    <h2 class="position">Senior Software Engineer</h2>
                    <div class="summary-short">8+ years of experience in Java development and system architecture</div>
                </div>

                <div class="content-section">
                    <div class="content-title">Professional Summary</div>
                    <div class="content-text">
                        <p>Results-driven Senior Software Engineer with over 8 years of experience in designing and implementing
                            enterprise-level applications. Specialized in Java backend development with extensive knowledge of
                            Spring Framework, microservices architecture, and cloud technologies.</p>
                        <p>Proven track record of leading development teams and delivering high-quality software solutions that
                            meet business requirements. Passionate about clean code, software design patterns, and mentoring
                            junior developers.</p>
                    </div>
                </div>

                <div class="content-section">
                    <div class="content-title">Work Experience</div>

                    <div class="experience-item">
                        <div class="experience-header">
                            <h3 class="company">Tech Solutions Inc.</h3>
                            <div class="position-date">
                                <span class="position">Senior Software Engineer</span>
                                <span class="date">Jan 2020 - Present</span>
                            </div>
                        </div>
                        <ul class="experience-details">
                            <li>Led a team of 5 developers in designing and implementing a microservices-based e-commerce
                                platform
                            </li>
                            <li>Reduced system response time by 40% through performance optimization and database tuning</li>
                            <li>Implemented CI/CD pipelines reducing deployment time from 2 hours to 15 minutes</li>
                            <li>Mentored junior developers and conducted code reviews to maintain code quality standards</li>
                        </ul>
                    </div>

                    <div class="experience-item">
                        <div class="experience-header">
                            <h3 class="company">Global Systems Corp.</h3>
                            <div class="position-date">
                                <span class="position">Software Engineer</span>
                                <span class="date">Mar 2016 - Dec 2019</span>
                            </div>
                        </div>
                        <ul class="experience-details">
                            <li>Developed RESTful APIs for financial services applications using Spring Boot</li>
                            <li>Collaborated with cross-functional teams to design database schemas and optimize queries</li>
                            <li>Implemented automated testing framework reducing bug reports by 30%</li>
                            <li>Participated in Agile development processes including sprint planning and retrospectives</li>
                        </ul>
                    </div>
                </div>

                <div class="content-section">
                    <div class="content-title">Education</div>

                    <div class="education-item">
                        <div class="education-header">
                            <h3 class="institution">Massachusetts Institute of Technology</h3>
                            <div class="degree-date">
                                <span class="degree">Master of Computer Science</span>
                                <span class="date">2014 - 2016</span>
                            </div>
                        </div>
                        <div class="education-details">
                            <p>Specialization in Software Engineering and Distributed Systems</p>
                            <p>GPA: 3.8/4.0</p>
                        </div>
                    </div>

                    <div class="education-item">
                        <div class="education-header">
                            <h3 class="institution">Stanford University</h3>
                            <div class="degree-date">
                                <span class="degree">Bachelor of Science in Computer Science</span>
                                <span class="date">2010 - 2014</span>
                            </div>
                        </div>
                        <div class="education-details">
                            <p>Minor in Mathematics</p>
                            <p>Dean's List for 6 semesters</p>
                        </div>
                    </div>
                </div>

                <div class="content-section">
                    <div class="content-title">Certifications</div>

                    <div class="certification-item">
                        <div class="certification-header">
                            <h3 class="certification-name">Oracle Certified Professional: Java SE 11 Developer</h3>
                            <span class="date">2021</span>
                        </div>
                    </div>

                    <div class="certification-item">
                        <div class="certification-header">
                            <h3 class="certification-name">AWS Certified Solutions Architect - Associate</h3>
                            <span class="date">2020</span>
                        </div>
                    </div>

                    <div class="certification-item">
                        <div class="certification-header">
                            <h3 class="certification-name">Spring Professional Certification</h3>
                            <span class="date">2019</span>
                        </div>
                    </div>
                </div>

            </div>


            </form>
        </div>

    </div>
    <%@include file="includes/sidebar_cv.jsp" %>
</div>

</body>
</html>