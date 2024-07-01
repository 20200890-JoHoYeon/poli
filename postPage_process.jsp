<%@ page import="java.io.*, java.sql.*, javax.servlet.*, javax.servlet.annotation.*, javax.servlet.http.*, java.util.*" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%


    // 세션에서 사용자 ID 가져오기 (로그인 구현 필요)
    session = request.getSession();
    if (session == null) {
    	out.println("<script>");
    	out.println("alert('세션이 존재하지 않습니다.');");
    	out.println("window.location.href = 'login.jsp';");
		out.println("</script>");
        return;
    }
    if (session.getAttribute("userId") == null) {
    	out.println("<script>");
    	out.println("alert('아이디가 존재하지 않습니다.');");
		out.println("window.location.href = 'login.jsp';");
		out.println("</script>");
    	out.println("아이디가 존재하지 않습니다.");
        return;
    }
	
    int userId = (int) session.getAttribute("userId");

	            
    String password = request.getParameter("password");
	String title = request.getParameter("title");
	String message = request.getParameter("message");
	String fileName = request.getParameter("file");
	String ext = fileName.substring(fileName.lastIndexOf('.') + 1);
    String filePath = "uploads/" + fileName;
    
	System.out.println("/n");
	System.out.println(request.getParameter("password"));
	System.out.println(request.getParameter("title"));
	System.out.println(request.getParameter("message"));
	System.out.println(fileName);
	System.out.println(ext);
	System.out.println(filePath);
	
    
    // 데이터베이스에 파일 정보 저장
    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3307/poli";
    String dbUsername = "root";
    String dbPassword = "011129";
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName(driverName);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        String sql = "INSERT INTO tbl_file (file_pwd, user_id, content_id, title, text, ext, file_name, file_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, password);
        pstmt.setInt(2, userId);
        pstmt.setString(3, "1");
        pstmt.setString(4, title);
        pstmt.setString(5, message);
        pstmt.setString(6, ext);
        pstmt.setString(7, fileName); 
        pstmt.setString(8, filePath); 

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            // 파일 업로드 및 DB 저장 성공
            out.println("<script>");
		    out.println("alert('게시글 작성에 성공했습니다.');");
		    out.println("window.location.href = 'main.jsp';");
		    out.println("</script>");
		    
        } else {
            // DB 저장 실패
        	out.println("<script>");
        	out.println("alert('파일 업로드 및 DB 저장에 실패했습니다.');");
		    out.println("window.location.href = 'main.jsp';");
		    out.println("</script>");
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        out.println("<script>");
        out.println("alert('오류 발생: " + e.getMessage() + "');");
        out.println("window.location.href = 'main.jsp';");
        out.println("</script>");
    } finally {
        // 리소스 해제
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

%>
