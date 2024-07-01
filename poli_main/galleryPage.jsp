<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<% 
    boolean galleryPageLoggedIn = session != null && session.getAttribute("loginSuccess") != null;

    if (!galleryPageLoggedIn) {
        response.sendRedirect("login.jsp?redirect=galleryPage.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>gallery Page</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="galleryStyle.css">
    <script src="script.js" defer></script>
    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const gridContainer = document.querySelector(".grid-container");
        let isDown = false;
        let startX;
        let scrollLeft;

        gridContainer.addEventListener('dragstart', function(e) {
            e.preventDefault();
        });

        gridContainer.addEventListener("mousedown", (e) => {
            isDown = true;
            gridContainer.classList.add("active");
            startX = e.pageX - gridContainer.offsetLeft;
            scrollLeft = gridContainer.scrollLeft;
        });

        gridContainer.addEventListener("mouseleave", () => {
            isDown = false;
            gridContainer.classList.remove("active");
        });

        gridContainer.addEventListener("mouseup", () => {
            isDown = false;
            gridContainer.classList.remove("active");
        });

        gridContainer.addEventListener("mousemove", (e) => {
            if (!isDown) return;
            e.preventDefault();
            const x = e.pageX - gridContainer.offsetLeft;
            const walk = (x - startX) * 1.5;
            gridContainer.scrollLeft = scrollLeft - walk;
        });

        const imageContainers = document.querySelectorAll('.image-container');
        const modal = document.getElementById('myModal');
        const closeModal = document.getElementsByClassName('close')[0];
        const modalImage = document.querySelector('.modal-image');
        const modalTitle = document.querySelector('.modal-title');
        const modalDescription = document.querySelector('.modal-description');
        const deleteBtn = document.querySelector('.delete-btn');
        const editBtn = document.querySelector('.edit-btn');

        let currentFileId = '';

        imageContainers.forEach(container => {
            container.addEventListener('click', () => {
                const imgSrc = container.querySelector('.uploaded-image').getAttribute('src');
                const title = container.getAttribute('data-title');
                const description = container.getAttribute('data-description');
                const fileId = container.getAttribute('data-file-id');

                modalImage.src = imgSrc;
                modalTitle.textContent = title;
                modalDescription.textContent = description;
                currentFileId = fileId;
                modal.style.display = 'block';
            });
        });

        closeModal.addEventListener('click', () => {
            modal.style.display = 'none';
        });

        window.addEventListener('click', (event) => {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        });

        deleteBtn.addEventListener('click', () => {
            const password = prompt("기록을 지우시겠습니까? 비밀번호를 입력해주세요(숫자 4자리).");
            
            if (password) {
                if (password.length !== 4) {
                    alert("비밀번호는 4자리로 입력해주세요.");
                    return;
                }

                fetch('galleryPage_process.jsp?action=delete&fileId=' + currentFileId + '&password=' + encodeURIComponent(password), {
                    method: 'GET'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('서버 오류');
                    }
                    return response.text();
                })
                .then(data => {
                    data = data.toLowerCase();
                    if (data.includes("true")) {
                        alert("이미지가 성공적으로 삭제되었습니다.");
                        window.location.reload();
                    } else if (data.includes("false")) {
                        alert("이미지 삭제에 실패했습니다.");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            }
        });

        editBtn.addEventListener('click', () => {
            const editPageUrl = 'editPage.jsp?fileId=' + currentFileId;
            window.location.href = editPageUrl;
        });
    });
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
        <h1>추억 모아보기</h1>
        <p>돌아오지 않은 시간들을<br>Poli와 함께 다시 회상해 보세요.</p>
        <hr>
        <br><br> 
    <div class="grid-container">
        <% 
            String driverName = "com.mysql.jdbc.Driver";
            String url = "jdbc:mysql://localhost:3307/poli";
            String dbUsername = "root";
            String dbPassword = "011129";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName(driverName);
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                session = request.getSession();
                if (session == null || session.getAttribute("userId") == null) {
                    out.println("<script>");
                    out.println("alert('로그인이 필요합니다.');");
                    out.println("window.location.href = 'login.jsp';");
                    out.println("</script>");
                    return;
                }

                int userId = (int) session.getAttribute("userId");

                String sql = "SELECT file_id, file_pwd, title, text, file_name, file_path, reg_date FROM tbl_file WHERE user_Id = ? ORDER BY reg_date DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    String fileId = rs.getString("file_id");
                    String filePwd = rs.getString("file_pwd");
                    String title = rs.getString("title");
                    String text = rs.getString("text");
                    String fileName = rs.getString("file_name");
                    String filePath = rs.getString("file_path");
                    String regDateString = rs.getString("reg_date");

                    String formattedDate;
                    if (regDateString != null) {
                        try {
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                            SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-MM-dd"); 
                            Date date = formatter.parse(regDateString);
                            formattedDate = outputFormatter.format(date);
                        } catch (Exception e) {
                            formattedDate = "날짜 오류";
                        }
                    } else {
                        SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-MM-dd");
                        formattedDate = outputFormatter.format(new Date());
                    }
                 
			        %>
			        <div class="image-container" data-file-id="<%= fileId %>" data-title="<%= title %>" data-description="<%= text %>">
			            <img src="<%= filePath %>" alt="<%= fileName %>" class="uploaded-image">
			            <div class="image-date"><%= formattedDate %></div>
			        </div>
			        <% 
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                out.println("오류 발생: " + e.getMessage());
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
    </div>

    <!-- 모달 -->
    <div id="myModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title"></span>
            <span class="close">&times;</span>
        </div>
        <img src="" class="modal-image" alt="Image">
        <div class="modal-description"></div>
        <button class="edit-btn btn">수정</button>
        <button class="delete-btn btn">삭제</button>
    </div>
</div>
</body>
</html>
