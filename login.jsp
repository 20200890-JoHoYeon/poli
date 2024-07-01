<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    boolean isLoggedIn = session != null && session.getAttribute("loginSuccess") != null;

    if (isLoggedIn) {
        response.sendRedirect("main.jsp");
        return;
    }

    String signupSuccess = (String) session.getAttribute("signupSuccess");
    if (signupSuccess != null) {
        session.removeAttribute("signupSuccess"); // 세션에서 제거
    }

    String loginError = (String) session.getAttribute("loginError");
    if (loginError != null) {
        session.removeAttribute("loginError"); // 세션에서 제거
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Poli 로그인</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #faf8ee;
            position: relative;
        }
        .logo {
            margin-bottom: 10px;
            margin-top: 10px;
            font-weight: bold;
            font-size: 18px;
        }
        .login-container {
            background-color: white;
            padding: 20px;
            width: 450px;
            border-radius: 60px;
            box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.25);
            text-align: center;
            position: relative;
        }
        .login-container input {
            width: 62%;
            padding: 20px;
            margin: 10px 0;
            border: 1px solid #D9D9D9;
            border-radius: 30px;
            font-weight: bold;
            font-size: 15px;
        }
        .login-button {
            width: 70%;
            padding: 20px;
            margin-top: 15px;
            margin-bottom: 10px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 38px;
            cursor: pointer;
            font-weight: bold; /* 글씨 볼드 */
            font-size: 22px; /* 글씨 크기 조정 */
        }
        .login-button:hover {
            background-color: #333;
        }
        .go-signup {
            text-decoration: none;
            width: 50%;
            padding: 10px;
            margin-top: 15px;
            margin-bottom: 10px;
            color: black;
            cursor: pointer;
            font-weight: bold; /* 글씨 볼드 */
            font-size: 18px; /* 글씨 크기 조정 */
        }
        .go-signup:hover {
            text-decoration: none; /* 밑줄 제거 */
            color: inherit; /* 부모 요소의 글자 색상 상속 */
            outline: none; /* 기본 outline 제거 */
        }
        .login-container input::placeholder {
            font-weight: bold;
            font-size: 16px;
            opacity: 0.5;
        }
        .message {
            background-color: #ffffff; /* 흰색 배경 */
            font-weight: bold;
            color: #3c763d;
            padding: 10px;
            border: 1px solid #d6e9c6;
            border-radius: 4px;
            position: absolute;
            top: -145px;
            width: 450px;
            text-align: center;
            display: none;
        }
    </style>
    <script>
        window.onload = function() {
            var signupSuccessMessage = document.getElementById('signupSuccessMessage');
            if (signupSuccessMessage) {
                signupSuccessMessage.style.display = 'block';
                setTimeout(function() {
                    signupSuccessMessage.style.display = 'none';
                }, 3000); // 3초 후에 메시지 숨기기
            }

            var loginErrorMessage = document.getElementById('loginErrorMessage');
            if (loginErrorMessage) {
                loginErrorMessage.style.display = 'block';
                setTimeout(function() {
                    loginErrorMessage.style.display = 'none';
                }, 3000); // 3초 후에 메시지 숨기기
            }
        }
    </script>
</head>
<body>
    <div class="login-container">
        <% if (signupSuccess != null) { %>
            <div id="signupSuccessMessage" class="message"><%= signupSuccess %></div>
        <% } %>
        <% if (loginError != null) { %>
            <div id="loginErrorMessage" class="message" style="color: #a94442; border-color: #ebccd1;"><%= loginError %></div>
        <% } %>
        <form action="loginCheck.jsp" method="post">
            <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") != null ? request.getParameter("redirect") : "main.jsp" %>">
            <img src="logo.png" class="logo"><br>
            <input type="text" name="username" placeholder="아이디" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <button type="submit" class="login-button">로그인</button>
        </form>
        <a href="signup.jsp" class="go-signup">회원가입</a>
    </div>
</body>
</html>
