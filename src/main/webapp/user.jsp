<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Usuários - Delta</title>
</head>
<body>

<h1>Usuários</h1>

<form method="post" action="${pageContext.request.contextPath}/user">

    <input type="text" name="name"
           placeholder="Nome" required>

    <input type="email" name="email"
           placeholder="E-mail" required>

    <input type="password" name="password"
           placeholder="Senha" required>

    <input type="text" name="phone"
           placeholder="Telefone">

    <input type="text" name="birthDate"
           placeholder="dd/MM/yyyy" required>

    <label>
        Ativo:
        <input type="checkbox" name="isActive" value="true">
    </label>

    <label>
        Administrador:
        <input type="checkbox" name="isAdmin" value="true">
    </label>

    <label>
        Gerente:
        <input type="checkbox" name="isManager" value="true">
    </label>

    <button type="submit">Cadastrar</button>

</form>

<br>

<table border="1">

    <tr>
        <th>ID</th>
        <th>Nome</th>
        <th>E-mail</th>
        <th>Telefone</th>
        <th>Nascimento</th>
        <th>Cadastro</th>
        <th>Ativo</th>
        <th>Admin</th>
        <th>Gerente</th>
    </tr>

    <%
        List<User> users =
                (List<User>) request.getAttribute("users");

        for (User user : users) {
    %>

    <tr>
        <td><%= user.getId() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getEmail() %></td>
        <td><%= user.getPhone() %></td>
        <td><%= user.getBirthDate() %></td>
        <td><%= user.getRegistrationDate() %></td>
        <td><%= user.isActive() %></td>
        <td><%= user.isAdmin() %></td>
        <td><%= user.isManager() %></td>
    </tr>

    <%
        }
    %>

</table>

</body>
</html>