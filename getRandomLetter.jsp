<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String songName = "";
    String url = "";
    String lifeQuotes = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/poli", "root", "011129");

        String randomLetterQuery = "SELECT song_name, url, lifeQuotes FROM tbl_letter ORDER BY RAND() LIMIT 1";
        PreparedStatement pstmt = conn.prepareStatement(randomLetterQuery);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            songName = rs.getString("song_name");
            url = rs.getString("url");
            lifeQuotes = rs.getString("lifeQuotes").replace("\n", "<br>");
        }

        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<div>
    <span id="song_name"><%= songName %></span>
    <span id="url"><%= url %></span>
    <span id="lifeQuotes"><%= lifeQuotes %></span>
</div>