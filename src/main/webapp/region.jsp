<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Region" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Regiões - Delta</title>
</head>
<body>

<h1>Regiões</h1>

<form method="post" action="${pageContext.request.contextPath}/region">

    <input type="text" name="name"
           placeholder="Nome da região" required>

    <button type="submit">Cadastrar</button>

</form>

<br>

<table border="1">

    <tr>
        <th>ID</th>
        <th>Nome</th>
    </tr>

    <%
        List<Region> regions =
                (List<Region>) request.getAttribute("region");

        for (Region region : regions) {
    %>

    <tr>
        <td><%= region.getId() %></td>
        <td><%= region.getName() %></td>
    </tr>

    <%
        }
    %>

</table>

</body>
</html>