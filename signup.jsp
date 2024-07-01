<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
    boolean isLoggedIn = session != null && session.getAttribute("loginSuccess") != null;

    if (isLoggedIn) {
        response.sendRedirect("main.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Poli 회원가입</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #faf8ee;
        }
        .logo{
        	margin-bottom: 10px; 
        	margin-top:10px; 
        	font-weight: bold; 
        	font-size: 18px;"
        }
        .signup-container {
            background-color: white;
            padding: 20px;
            width:450px;
            border-radius: 60px;
            box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.25);
            text-align: center;
        }
        .signup-container input {
            width: 62%;
            padding: 20px;
            margin: 10px;
            border: 1px solid #D9D9D9;
            border-radius: 30px;
            font-weight: bold; 
            font-size: 15px; 
        }
        .signup-botton{
            width: 70%;
            padding: 20px;
            margin-top:15px;
            margin-bottom: 15px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 38px;
            cursor: pointer;
            font-weight: bold; /* 글씨 볼드 */
            font-size: 22px; /* 글씨 크기 조정 */
        }
        .signup-botton:hover {
            background-color: #333;
        }
        .go-login{
        	text-decoration: none;
            width: 50%;
            padding: 10px;
            margin-top:10px;
            margin-bottom: 10px;
            color :balck;
            font-weight: bold; /* 글씨 볼드 */
            font-size: 18px; /* 글씨 크기 조정 */
        }
        .go-login:hover {       
            text-decoration: none; /* 밑줄 제거 */
    		color: inherit; /* 부모 요소의 글자 색상 상속 */
    		outline: none; /* 기본 outline 제거 */
        }
        .signup-container input::placeholder {
            font-weight: bold; 
            font-size: 16px;
            opacity: 0.5;
        }
    </style>
	<script type="text/javascript">
		function checksignup() 
		{
			var f = document.signup;
			var id = f.id.value;
			var pwd= f.pwd.value;
			var name = f.name.value;
			
			
			if(name == ""){
				alert("닉네임을 입력해주세요.")
				f.name.focus();
				return false;
			}
			else if (name.length > 10) {
	            alert("닉네임은 10자리 이내로 입력해주세요.");
	            form.name.focus();
	            return false;
	        }
			else if(id == ""){
				alert("아이디를 입력해주세요.")
				f.id.focus();
				return false;
			}
			if (id.length > 10) {
	            alert("아이디는 10자리 이내로 입력해주세요.");
	            form.name.focus();
	            return false;
	        }
			else if(pwd == ""){
				alert("비밀번호를 입력해주세요.")
				f.pwd.focus();
				return false;
			}
			else if (name.length > 20) {
	            alert("비밀번호는 20자리 이내로 입력해주세요.");
	            form.name.focus();
	            return false;
	        }
		}		
	</script>    
</head>
<body>
    <div class="signup-container">
        <form name = "signup" action="signupCheck.jsp" method="post"onsubmit ="return checksignup()">
            <img src="logo.png" class = "logo" ><br>
            <input type="text" name = "name" placeholder="닉네임 (10자리)">
            <input type="text" name="id" placeholder="아이디 (10자리)" >
            <input type="password" name="pwd" placeholder="비밀번호 (20자리)">
            <button type="submit" class = "signup-botton">회원가입</button>
        </form>
        <a href="login.jsp" class="go-login">로그인</a>
    </div>
    
</body>
</html>
