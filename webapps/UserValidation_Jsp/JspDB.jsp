<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%!
    Connection con;
    PreparedStatement ps1, ps2;

    public void jspInit() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");
            ps1 = con.prepareStatement("SELECT COUNT(*) FROM users WHERE username = ? AND password = ?");
            ps2 = con.prepareStatement("SELECT * FROM users");
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error initializing JSP: " + ex.getMessage());
        }
    }

    public void jspDestroy() {
        try {
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (con != null) con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
%>

<%
    String param = request.getParameter("s1");

    if ("link".equals(param)) {
        try {
            ResultSet rs = ps2.executeQuery();
            out.println("<table>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString(1) + "</td>");
                out.println("<td>" + rs.getString(2) + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error executing query: " + e.getMessage());
        }
    } else {
        String user = request.getParameter("uname");
        String pass = request.getParameter("pwd");

        try {
            ps1.setString(1, user);
            ps1.setString(2, pass);
            ResultSet rs = ps1.executeQuery();
            int cnt = 0;
            if (rs.next()) {
                cnt = rs.getInt(1);
            }
            if (cnt == 0) {
                out.println("<b><i><font color=red>Invalid credential</font></i></b>");
            } else {
                out.println("<form><fieldset style='width:25%;'>");
                out.println("<b><i><font color=red>Valid credential..</font></i></b><br>");
                out.println("<b><i><font size=6 color=blue>Welcome to My Page</font></i></b>");
                out.println("</fieldset></form>");
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error executing query: " + e.getMessage());
        }
    }
%>
