<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String action = request.getParameter("action");
    String fileId = request.getParameter("fileId"); // 추가: fileId 파라미터 받기
    String inputPassword = request.getParameter("password");

    if ("delete".equals(action)) {
        String sql = "DELETE FROM tbl_file WHERE file_id = ? AND file_pwd = ?"; // 수정: fileId로 삭제 쿼리 변경
        String driverName = "com.mysql.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3307/poli";
        String dbUsername = "root";
        String dbPassword = "011129";
        Connection conn = null;

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fileId); // 수정: fileId로 바인딩
            pstmt.setString(2, inputPassword);

            int count = pstmt.executeUpdate();

            if (count > 0) {
                response.getWriter().write("TRUE");
            } else {
                response.getWriter().write("FALSE");
            }
        } catch (SQLException e) {
            response.getWriter().write("오류 발생: " + e.getMessage());
        } 
    }
%>
