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
        <th>Ações</th>
    </tr>

    <%
        List<Region> regions =
                (List<Region>) request.getAttribute("region");

        for (Region region : regions) {
    %>

    <tr>
        <td><%= region.getId() %></td>
        <td><%= region.getName() %></td>

        <td>
            <button type="button"
                    onclick="editarRegiao(
                        <%= region.getId() %>,
                            '<%= region.getName() %>'
                            )">
                Editar
            </button>

            <button type="button"
                    onclick="deletarRegiao(<%= region.getId() %>)">
                Excluir
            </button>
        </td>
    </tr>

    <%
        }
    %>

</table>

<script>

    function editarRegiao(id, name) {

        const novoName = prompt("Nome da região:", name);

        if (novoName === null) {
            return;
        }

        const parametros = new URLSearchParams();

        parametros.append("id", id);
        parametros.append("name", novoName);

        fetch("${pageContext.request.contextPath}/region?" + parametros.toString(), {
            method: "PUT"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao atualizar região.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao atualizar região.");

            });
    }


    function deletarRegiao(id) {

        if (!confirm("Deseja realmente excluir esta região?")) {
            return;
        }

        fetch("${pageContext.request.contextPath}/region?id=" + id, {
            method: "DELETE"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao excluir região.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao excluir região.");

            });
    }

</script>

</body>
</html>