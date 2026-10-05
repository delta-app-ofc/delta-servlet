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
        <th>Ações</th>
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

        <td>
            <button type="button"
                    onclick="editarEndereco(
                        <%= address.getId() %>,
                        <%= address.getRegionId() %>,
                            '<%= address.getCep() %>',
                            '<%= address.getCity() %>',
                            '<%= address.getState() %>'
                            )">
                Editar
            </button>

            <button type="button"
                    onclick="deletarEndereco(<%= address.getId() %>)">
                Excluir
            </button>
        </td>
    </tr>

    <%
        }
    %>
</table>

<script>

    function editarEndereco(id, regionId, cep, city, state) {

        const novoRegionId = prompt("ID da Região:", regionId);
        if (novoRegionId === null) return;

        const novoCep = prompt("CEP:", cep);
        if (novoCep === null) return;

        const novaCity = prompt("Cidade:", city);
        if (novaCity === null) return;

        const novoState = prompt("Estado:", state);
        if (novoState === null) return;

        const parametros = new URLSearchParams();

        parametros.append("id", id);
        parametros.append("regionId", novoRegionId);
        parametros.append("cep", novoCep);
        parametros.append("city", novaCity);
        parametros.append("state", novoState);

        fetch("${pageContext.request.contextPath}/address?" + parametros.toString(), {
            method: "PUT"
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao atualizar endereço.");
                }
            })
            .catch(error => {
                console.error(error);
                alert("Erro ao atualizar endereço.");
            });
    }


    function deletarEndereco(id) {

        if (!confirm("Deseja realmente excluir este endereço?")) {
            return;
        }

        fetch("${pageContext.request.contextPath}/address?id=" + id, {
            method: "DELETE"
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao excluir endereço.");
                }
            })
            .catch(error => {
                console.error(error);
                alert("Erro ao excluir endereço.");
            });
    }

</script>

</body>
</html>