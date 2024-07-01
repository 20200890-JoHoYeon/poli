<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.*, java.text.SimpleDateFormat" %>

<% 
    boolean editPageLoggedIn = session != null && session.getAttribute("loginSuccess") != null;
    if (!editPageLoggedIn) {
        response.sendRedirect("login.jsp?redirect=edit.jsp");
        return;
    }

    String fileId = request.getParameter("fileId");

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3307/poli";
    String dbUsername = "root";
    String dbPassword = "011129";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String title = "";
    String text = "";
    String filePath = "";
    String formattedDate = "";
    String ext = "";
    String filename = "";
    String regDateString = "";

    try {
        Class.forName(driverName);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        String sql = "SELECT title, text, file_path, reg_date, ext,file_name FROM tbl_file WHERE file_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fileId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            text = rs.getString("text");
            filePath = rs.getString("file_path");
            ext = rs.getString("ext");
            filename = rs.getString("file_name");
            
            
            regDateString = rs.getString("reg_date");
			
            if (regDateString != null) {
                try {
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-mm-dd");
                    SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-mm-dd"); 
                    java.util.Date date = formatter.parse(regDateString); 
                    formattedDate = outputFormatter.format(date);
                } catch (Exception e) {
                    formattedDate = "날짜 오류";
                }
            } else {
                SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-mm-dd");
                formattedDate = outputFormatter.format(new java.util.Date()); 
            }
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정하기</title>
    <link rel="stylesheet" href="style.css">
    <script src="script.js" defer></script>
    <link rel="stylesheet" href="postStyle.css">
    <script type="text/javascript">
        function checkCategory() {
            var f = document.postPage;
            var title = f.title.value;
            var file = f.file.value;
            var password = f.password.value;
            var message = f.message.value;

            if (title == "") {
                alert("제목을 입력해주세요.");
                f.title.focus();
                return false;
            } else if (message == "") {
                alert("내용을 입력해주세요.");
                f.message.focus();
                return false;
            } else if (password == "") {
                alert("비밀번호를 입력해주세요.");
                f.password.focus();
                return false;
            } else if (isNaN(password)) {
                alert("비밀번호는 숫자로만 입력해 주세요.");
                f.password.focus();
                return false;
            } else {
                return true;
            }
        }
    </script>
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
        <h1>추억 다시담기</h1>
        <p>사진첩 속 기억들을<br>Poli와 함께 새롭게 담아보아요.</p>
        <form action="edit_Process.jsp" class="postForm" name="postPage" method="post" onsubmit="return checkCategory()">
            <input type="hidden" name="fileId" value="<%= fileId %>">
            <input type="hidden" name="existingFilePath" value="<%= filePath %>">
            <input type="hidden" name="existingFileName" value="<%= filename%>">
            <input type="hidden" name="existingFileExt" value="<%= ext%>">
            
            <div class="title_area">
            <input class="postInput div_margin" type="text" name="title" maxlength="20" value="<%= title %>" placeholder="제목 (20자 입력 가능)"><br>  
            <div class="reg_date_div"><%= regDateString %></div>
            </div>
            <div>
                <label for="file" class="main_area">
                    <div class="btn-upload fileInput_area">
                        <img id="imagePreview" class="fileInput_img" src="<%= filePath %>" alt="Image Preview">
                    </div>
                </label>
                <input type="file" name="file" id="file" accept="image/*">
            </div>    
            <textarea class="postInput div_margin" rows="50" name="message" maxlength="50" placeholder="내용 (50자 입력 가능)" style="resize: none;"><%= text %></textarea><br>
            <input class="postInput" type="password" name="password" maxlength="4" placeholder="비밀번호 (4자 숫자로 입력 가능)"><br>
            <div class="btn_area div_margin">
                <input type="submit" class="btn" value="수정하기">
                <input type="button" class="btn" value="취소하기" onclick="location.href='galleryPage.jsp'">
            </div>
        </form>
    </main>
    <script>
        document.getElementById('file').addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imagePreview').src = e.target.result;
                }
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>
