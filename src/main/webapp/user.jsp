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
        <th>Ações</th>
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

        <td>
            <button type="button"
                    onclick="editarUsuario(
                        <%= user.getId() %>,
                            '<%= user.getName() %>',
                            '<%= user.getEmail() %>',
                            '<%= user.getPassword() %>',
                            '<%= user.getPhone() %>',
                            '<%= user.getBirthDate() %>',
                        <%= user.isActive() %>,
                        <%= user.isAdmin() %>,
                        <%= user.isManager() %>
                            )">
                Editar
            </button>

            <button type="button"
                    onclick="deletarUsuario(<%= user.getId() %>)">
                Excluir
            </button>
        </td>
    </tr>

    <%
        }
    %>

</table>

<script>

    function editarUsuario(
        id,
        name,
        email,
        password,
        phone,
        birthDate,
        isActive,
        isAdmin,
        isManager
    ) {

        const novoName = prompt("Nome:", name);

        if (novoName === null) {
            return;
        }

        const novoEmail = prompt("E-mail:", email);

        if (novoEmail === null) {
            return;
        }

        const novaPassword = prompt("Senha:", password);

        if (novaPassword === null) {
            return;
        }

        const novoPhone = prompt("Telefone:", phone);

        if (novoPhone === null) {
            return;
        }

        const novaBirthDate = prompt(
            "Data de nascimento (dd/MM/yyyy):",
            converterData(birthDate)
        );

        if (novaBirthDate === null) {
            return;
        }

        const novoIsActive = confirm(
            "O usuário está ativo?"
        );

        const novoIsAdmin = confirm(
            "O usuário é administrador?"
        );

        const novoIsManager = confirm(
            "O usuário é gerente?"
        );

        const parametros = new URLSearchParams();

        parametros.append("id", id);
        parametros.append("name", novoName);
        parametros.append("email", novoEmail);
        parametros.append("password", novaPassword);
        parametros.append("phone", novoPhone);
        parametros.append("birthDate", novaBirthDate);
        parametros.append("isActive", novoIsActive);
        parametros.append("isAdmin", novoIsAdmin);
        parametros.append("isManager", novoIsManager);

        fetch("${pageContext.request.contextPath}/user?" + parametros.toString(), {
            method: "PUT"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao atualizar usuário.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao atualizar usuário.");

            });
    }


    function converterData(data) {

        const partes = data.split("-");

        if (partes.length === 3) {
            return partes[2] + "/" + partes[1] + "/" + partes[0];
        }

        return data;
    }


    function deletarUsuario(id) {

        if (!confirm("Deseja realmente excluir este usuário?")) {
            return;
        }

        fetch("${pageContext.request.contextPath}/user?id=" + id, {
            method: "DELETE"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao excluir usuário.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao excluir usuário.");

            });
    }

</script>

</body>
</html>