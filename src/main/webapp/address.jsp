<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Address" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Endereços - Delta</title>
</head>
<body> 

<h1>Endereços</h1>

<form method="post" action="${pageContext.request.contextPath}/address">
    <input type="number" name="regionId" placeholder="ID da Região" required>
    <input type="text" name="cep" placeholder="CEP" required>
    <input type="text" name="city" placeholder="Cidade" required>
    <input type="text" name="state" placeholder="Estado" required>
    <button type="submit">Cadastrar</button>
</form>

<br>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Região</th>
        <th>CEP</th>
        <th>Cidade</th>
        <th>Estado</th>
    </tr>

    <%
        List<Address> addresses =
                (List<Address>) request.getAttribute("addresses");

        for (Address address : addresses) {
    %>

    <tr>
        <td><%= address.getId() %></td>
        <td><%= address.getRegionId() %></td>
        <td><%= address.getCep() %></td>
        <td><%= address.getCity() %></td>
        <td><%= address.getState() %></td>
    </tr>

    <%
        }
    %>
</table>

</body>
</html>