<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Property" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Propriedades - Delta</title>
</head>
<body>

<h1>Propriedades</h1>

<form method="post" action="${pageContext.request.contextPath}/property">

    <input type="text" name="name"
           placeholder="Nome" required>

    <input type="text" name="type"
           placeholder="Tipo" required>

    <input type="text" name="classification"
           placeholder="Classificação" required>

    <input type="number" name="addressId"
           placeholder="ID do endereço" required>

    <input type="text" name="registrationDate"
           placeholder="dd/MM/yyyy" required>

    <button type="submit">Cadastrar</button>

</form>

<br>

<table border="1">

    <tr>
        <th>ID</th>
        <th>Nome</th>
        <th>Tipo</th>
        <th>Classificação</th>
        <th>Endereço</th>
        <th>Data de cadastro</th>
    </tr>

    <%
        List<Property> properties =
                (List<Property>) request.getAttribute("properties");

        for (Property property : properties) {
    %>

    <tr>
        <td><%= property.getId() %></td>
        <td><%= property.getName() %></td>
        <td><%= property.getType() %></td>
        <td><%= property.getClassification() %></td>
        <td><%= property.getAddressId() %></td>
        <td><%= property.getRegistrationDate() %></td>
    </tr>

    <%
        }
    %>

</table>

</body>
</html>