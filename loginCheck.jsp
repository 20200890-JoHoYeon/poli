<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
    String id = request.getParameter("username");
    String pwd = request.getParameter("password");
    String redirectPage = request.getParameter("redirect");

    String sql = "SELECT * FROM tbl_user WHERE id = ? AND pwd = ?";

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3307/poli";
    String dbUsername = "root";
    String dbPassword = "011129";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isSuccess = false;

    try {
        // JDBC 드라이버 로드
        Class.forName(driverName);

        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // PreparedStatement 생성 및 매개변수 설정
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.setString(2, pwd);
		
        // 쿼리 실행
        rs = pstmt.executeQuery();
        
        // 결과 확인
        if (rs.next()) {
            isSuccess = true;
            // 로그인 성공 메시지를 세션에 저장
            session.setAttribute("loginSuccess", "로그인에 성공했습니다.");
            session.setAttribute("userId", rs.getInt("user_Id")); // 사용자 ID 저장
            session.setAttribute("userName", rs.getString("name")); // 사용자 이름 저장
            session.setAttribute("userTier", rs.getString("tier")); // 사용자 등급
            session.setAttribute("joinDate", rs.getTimestamp("join_date")); // 회원가입 시점 저장
        } else {
            isSuccess = false;
            session.setAttribute("loginError", "아이디 또는 비밀번호를 확인해주세요."); // 로그인 실패 메시지 세션에 저장
        }
    } catch (Exception e) {
        e.printStackTrace();
        isSuccess = false;
        session.setAttribute("loginError", "로그인 중 오류가 발생했습니다."); // 예외 발생 시 오류 메시지 세션에 저장
    } finally {
        // 리소스 해제
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 리소스 해제 후 리디렉션 수행
    if (isSuccess) {
        response.sendRedirect(redirectPage);
    } else {
        response.sendRedirect("login.jsp?redirect=" + redirectPage);
    }
%>
