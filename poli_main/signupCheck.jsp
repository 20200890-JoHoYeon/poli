<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String name = request.getParameter("name");
    String id = request.getParameter("id");
    String pwd = request.getParameter("pwd");

    String sql = "INSERT INTO tbl_user(name, id, pwd, tier) VALUES(?, ?, ?, 'bronze')";
    String insertGallerySql = "INSERT INTO tbl_gallery (user_id) VALUES (LAST_INSERT_ID())";

    String driverName = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3307/poli";
    String dbUsername = "root";
    String dbPassword = "011129";
    Connection conn = null;
    PreparedStatement pstmt = null;
    boolean isSuccess = false;

    try {
        // JDBC 드라이버 로드
        Class.forName(driverName);

        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 트랜잭션 시작
        conn.setAutoCommit(false);

        // tbl_user 테이블에 데이터 삽입
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, id);
        pstmt.setString(3, pwd);
        pstmt.executeUpdate();

        // tbl_gallery 테이블에 데이터 삽입
        pstmt = conn.prepareStatement(insertGallerySql);
        pstmt.executeUpdate();

        // 트랜잭션 커밋
        conn.commit();
        isSuccess = true;
    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                // 트랜잭션 롤백
                conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        isSuccess = false;
    } finally {
        // 리소스 해제
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 리소스 해제 후 리디렉션 수행
    if (isSuccess) {
        session.setAttribute("signupSuccess", "회원가입에 성공했습니다.");
        response.sendRedirect("login.jsp");
    } else {
        response.sendRedirect("signup.jsp");
    }
%>
