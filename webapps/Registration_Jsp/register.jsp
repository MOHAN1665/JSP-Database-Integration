<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%!
    Connection con;
    PreparedStatement ps;

    public void jspInit() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/XE", "root", "root");
            ps = con.prepareStatement("INSERT INTO Students (First_Name, Last_Name, Age) VALUES (?, ?, ?)");
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error initializing JSP: " + ex.getMessage());
        }
    }

    public void jspDestroy() {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
%>

<%
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    int age = Integer.parseInt(request.getParameter("age"));

    try {
        ps.setString(1, firstName);
        ps.setString(2, lastName);
        ps.setInt(3, age);
        
        int rowsAffected = ps.executeUpdate();
        
        if (rowsAffected > 0) {
            out.println("<h2>Student registered successfully!</h2>");
        } else {
            out.println("<h2>Error registering student.</h2>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Error executing query: " + e.getMessage());
    }
%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Registration</title>
</head>
<body>
    <form method="post" action="register.jsp">
        <fieldset style="width: 23%; background-color: #b3d1ff">
            <h3><center>Student Registration</center></h3>
            <hr>
            <table>
                <tr>
                    <td>First Name:</td>
                    <td><input type="text" name="first_name"></td>
                </tr>
                <tr>
                    <td>Last Name:</td>
                    <td><input type="text" name="last_name"></td>
                </tr>
                <tr>
                    <td>Age:</td>
                    <td><input type="text" name="age"></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" value="Register"></td>
                </tr>
            </table>
        </fieldset>
    </form>
</body>
</html>
