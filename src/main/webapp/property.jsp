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
        <th>Ações</th>
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

        <td>
            <button type="button"
                    onclick="editarPropriedade(
                        <%= property.getId() %>,
                            '<%= property.getName() %>',
                            '<%= property.getType() %>',
                            '<%= property.getClassification() %>',
                        <%= property.getAddressId() %>,
                            '<%= property.getRegistrationDate() %>'
                            )">
                Editar
            </button>

            <button type="button"
                    onclick="deletarPropriedade(<%= property.getId() %>)">
                Excluir
            </button>
        </td>
    </tr>

    <%
        }
    %>

</table>

<script>

    function editarPropriedade(
        id,
        name,
        type,
        classification,
        addressId,
        registrationDate
    ) {

        const novoName = prompt("Nome:", name);
        if (novoName === null) return;

        const novoType = prompt("Tipo:", type);
        if (novoType === null) return;

        const novaClassification =
            prompt("Classificação:", classification);
        if (novaClassification === null) return;

        const novoAddressId =
            prompt("ID do endereço:", addressId);
        if (novoAddressId === null) return;

        const novaRegistrationDate =
            prompt(
                "Data de cadastro (dd/MM/yyyy):",
                registrationDate
            );

        if (novaRegistrationDate === null) return;

        const parametros = new URLSearchParams();

        parametros.append("id", id);
        parametros.append("name", novoName);
        parametros.append("type", novoType);
        parametros.append("classification", novaClassification);
        parametros.append("addressId", novoAddressId);
        parametros.append("registrationDate", novaRegistrationDate);

        fetch("${pageContext.request.contextPath}/property?" + parametros.toString(), {
            method: "PUT"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao atualizar propriedade.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao atualizar propriedade.");

            });
    }


    function deletarPropriedade(id) {

        if (!confirm("Deseja realmente excluir esta propriedade?")) {
            return;
        }

        fetch("${pageContext.request.contextPath}/property?id=" + id, {
            method: "DELETE"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao excluir propriedade.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao excluir propriedade.");

            });
    }

</script>

</body>
</html>