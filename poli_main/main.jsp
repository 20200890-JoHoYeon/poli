<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter, java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Page</title>
    <link rel="stylesheet" href="style.css">
    <script src="script.js" defer></script>
</head>
<body>
    <header class="navbar">
        <a href="main.jsp" class="logo">
            <img src="logo.png" alt="Logo">
        </a>
        <nav>
            <ul>
                <% 
                    String loginText = "LOGIN";
                    boolean isLoggedIn = false;
                    if (session.getAttribute("loginSuccess") != null) {
                        loginText = "LOGOUT";
                        isLoggedIn = true;
                    }
                %>
                <li><a href="<%= isLoggedIn ? "javascript:logout();" : "login.jsp?redirect=main.jsp" %>"><%= loginText %></a></li>
                <li><a href="<%= isLoggedIn ? "postPage.jsp" : "login.jsp?redirect=postPage.jsp" %>" class="post">POST</a></li>
                <li><a href="<%= isLoggedIn ? "galleryPage.jsp" : "login.jsp?redirect=galleryPage.jsp" %>">GALLERY</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <h1>행운의 편지</h1>
        <p>당신의 오늘 하루를 점쳐보거나,<br>추천하는 오늘의 플리를 접해보세요.</p>
        <div class="slider">
            <button class="prev" onclick="changeSlide(-1)"><img src="prev.png" alt="Previous"></button>
            <div class="slides">
                <img id="dummyImage" class="slide-img" src="letter.png" alt="Letter" />
                <img id="leftImage" class="slide-img" src="letter.png" alt="Letter" />
                <div id="centerImage" class="slide-img">
                    <img src="letter.png" alt="Letter" />
                    <div class="overlay">
                        <h2 id="overlay-title"><a href="#" target="_blank"></a></h2>
                        <p id="overlay-text"></p>
                    </div>
                </div>
                <img id="rightImage" class="slide-img" src="letter.png" alt="Letter" />
                <img id="dummyImage" class="slide-img" src="letter.png" alt="Letter" />
            </div>
            <button class="next" onclick="changeSlide(1)"><img src="next.png" alt="Next"></button>
        </div>
        <hr>
        <% 
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String name = null;
            String tier = null;
            String newTier = null;
            int fileCount = 0;
            long daysSinceJoin = 0;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/poli", "root", "011129");

                if (isLoggedIn) {
                    int userId = (int) session.getAttribute("userId");

                    String userQuery = "SELECT tier, join_date, name FROM tbl_user WHERE user_id = ?";
                    pstmt = conn.prepareStatement(userQuery);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        name = rs.getString("name");
                        tier = rs.getString("tier");
                        Timestamp joinDate = rs.getTimestamp("join_date");
                        LocalDate joinLocalDate = joinDate.toLocalDateTime().toLocalDate();
                        daysSinceJoin = ChronoUnit.DAYS.between(joinLocalDate, LocalDate.now()) + 1;
                    }
                    rs.close();
                    pstmt.close();

                    String fileCountQuery = "SELECT COUNT(*) AS fileCount FROM tbl_file WHERE user_id = ? AND del_yn IS NULL";
                    pstmt = conn.prepareStatement(fileCountQuery);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        fileCount = rs.getInt("fileCount");
                    }
                    
                    if (fileCount >= 25 && daysSinceJoin >= 25) {
                        newTier = "다이아";
                    } else if (fileCount >= 15 && daysSinceJoin >= 15) {
                        newTier = "골드";
                    } else if (fileCount >= 5 && daysSinceJoin >= 5) {
                        newTier = "실버";
                    } else {
                        newTier = "브론즈";
                    }
                    
                    if (!newTier.equals(tier)) {
                        String updateTierQuery = "UPDATE tbl_user SET tier = ? WHERE user_id = ?";
                        pstmt = conn.prepareStatement(updateTierQuery);
                        pstmt.setString(1, newTier);
                        pstmt.setInt(2, userId);
                        pstmt.executeUpdate();
                        tier = newTier;
                    }
                %>
                <div class="more">
                    <a href="galleryPage.jsp">
                        <img src="more.png" alt="More">더보기 >
                    </a>
                </div>
                <div class="gallery">
                <% 
                    String recentFilesQuery = "SELECT file_path, reg_date FROM tbl_file WHERE user_id = ? AND del_yn IS NULL ORDER BY reg_date DESC LIMIT 4";
                    pstmt = conn.prepareStatement(recentFilesQuery);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");
                    int count = 0;
                    while (rs.next() && count < 4) {
                        String filePath = rs.getString("file_path");
                        LocalDateTime regDate = rs.getTimestamp("reg_date").toLocalDateTime();
                        String formattedDate = regDate.format(formatter);
                        count++;
                %>
                        <div class="polaroid">
                            <img src="<%= filePath %>" alt="Image">
                            <div class="caption"><%= formattedDate %></div>
                        </div>
                <%
                    }
                %>
                </div>
                <h2><span class="name"><%= name %></span> <span class="other">님의 추억이 이만큼이나 쌓였어요</span></h2>
                <div class="container">
                    <div class="info">
                        <div class="item">
                            <div class="icon"><img src="grade.png" alt="Grade"></div>
                            <div class="label">등급</div>
                            <div class="value-box">
                                <div class="value"><%= tier %></div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="icon"><img src="record.png" alt="Record"></div>
                            <div class="label">기록</div>
                            <div class="value-box">
                                <div class="value"><%= fileCount %>글</div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="icon"><img src="day.png" alt="Day"></div>
                            <div class="label">탄생일</div>
                            <div class="value-box">
                                <div class="value">D+<%= daysSinceJoin %></div>
                            </div>
                        </div>
                    </div>
                    <div class="buttons">
                        <button class="btn" id="gradeButton">등급 올리는 법</button>
                        <a href="postPage.jsp">
                            <button class="btn">추억 남기러 가기</button>
                        </a>
                    </div>
                </div>
                <% } %>
        <% } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        } %>
        <% if (!isLoggedIn) { %>
        <div id="cta-container" class="container">
            <div class="signup-cta">
                <h2>아직 Poli의 회원이 아니신가요?</h2>
                <p>돌아오지 않는 소중한 시간들을<br>Poli를 통해 기록해 보세요.</p>
                <a href="signup.jsp"><button class="btn">회원가입</button></a>
            </div>
        </div>
        <% } %>
    </main>
</body>
</html>