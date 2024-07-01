<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    boolean postPageLoggedIn = session != null && session.getAttribute("loginSuccess") != null;

    if (!postPageLoggedIn) {
        response.sendRedirect("login.jsp?redirect=postPage.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성하기</title>
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
            } else if (file == "") {
                alert("첨부파일이 비어있습니다.");
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
        <h1>추억 기록하기</h1>
        <p>돌아오지 않는 소중한 시간들을<br>Poli를 통해 기록해 보세요.</p>
        <form action="postPage_process.jsp" class="postForm" name="postPage" method="post"  onsubmit="return checkCategory()">
            <input class="postInput div_margin" type="text" name="title" maxlength="20" placeholder="제목 (20자 입력 가능)"><br>
            <div>
                <label for="file" class="main_area">
                    <div class="btn-upload fileInput_area ">
                        <img id="imagePreview" class="fileInput_img " src="file_Null.png" alt="Image Preview">
                    </div>
                </label>
                <input type="file" name="file" id="file" accept="image/*" >
            </div>    
            <textarea class="postInput div_margin" rows="50" name="message"  maxlength="50"  placeholder="내용 (50자 입력 가능)" style="resize: none;"></textarea><br>
            <input class="postInput" type="password" name="password" maxlength="4" placeholder="비밀번호 (4자 숫자로 입력 가능)"><br>
            <div class="btn_area div_margin">
                <input type="button" class="btn" value="취소하기" onclick="location.href='main.jsp'">
                <input type="submit" class="btn" value="작성하기">
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
