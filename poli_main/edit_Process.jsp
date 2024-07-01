<%@ page import="java.io.*, java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session = request.getSession();
    if (session == null || session.getAttribute("userId") == null) {
        out.println("<script>");
        out.println("alert('로그인이 필요합니다.');");
        out.println("window.location.href = 'login.jsp';");
        out.println("</script>");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    String fileId = request.getParameter("fileId");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String message = request.getParameter("message");
    
    String existingFilePath = request.getParameter("existingFilePath");
    String existingFileName = request.getParameter("existingFileName");
    String existingFileExt = request.getParameter("existingFileExt");
    
    String fileName = request.getParameter("file");
    String filePath = existingFilePath;
    String ext = "";

    java.util.Date now = new java.util.Date();
    java.sql.Timestamp nowTime = new java.sql.Timestamp(now.getTime());

    if (fileName != null && !fileName.isEmpty()) {
        ext = fileName.substring(fileName.lastIndexOf('.') + 1);
        filePath = "uploads/" + fileName;
    } else {
        fileName = existingFileName;
        ext = existingFileExt;
    }
    	

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3307/poli";
    String dbUsername = "root";
    String dbPassword = "011129"; 
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName(driverName);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        String checkPwdSql = "SELECT file_pwd FROM tbl_file WHERE file_id = ?";
        pstmt = conn.prepareStatement(checkPwdSql);
        pstmt.setString(1, fileId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String dbFilePassword = rs.getString("file_pwd");

            if (dbFilePassword.equals(password)) {
                String sql = "UPDATE tbl_file SET title = ?, text = ?, file_path = ?, file_name = ?, ext = ?,mod_date = ? WHERE file_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, title);
                pstmt.setString(2, message);
                pstmt.setString(3, filePath);
                pstmt.setString(4, fileName);
                pstmt.setString(5, ext);
                pstmt.setTimestamp(6, nowTime);
                pstmt.setString(7, fileId);

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    out.println("<script>");
                    out.println("alert('게시글 수정에 성공했습니다.');");
                    out.println("window.location.href = 'galleryPage.jsp';");
                    out.println("</script>");
                } else {
                    out.println("<script>");
                    out.println("alert('게시글 수정에 실패했습니다.');");
                    out.println("window.location.href = 'galleryPage.jsp';");
                    out.println("</script>");
                }
            } else {
                out.println("<script>");
                out.println("alert('비밀번호가 일치하지 않습니다.');");
                out.println("window.location.href = 'editPage.jsp?fileId=" + fileId + "';");
                out.println("</script>");
            }
        } else {
            out.println("<script>");
            out.println("alert('해당 게시글이 존재하지 않습니다. File ID: " + fileId + "');");
            out.println("</script>");
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        out.println("<script>");
        out.println("alert('오류 발생: " + e.getMessage() + "');");
        out.println("window.location.href = 'galleryPage.jsp';");
        out.println("</script>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
