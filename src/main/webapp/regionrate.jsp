<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Region_Rate" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Taxas das Regiões - Delta</title>
</head>
<body>

<h1>Taxas das Regiões</h1>

<form method="post" action="${pageContext.request.contextPath}/regionrate">

    <input
            type="number"
            name="region_id"
            placeholder="ID da região"
            required
    >

    <input
            type="number"
            step="0.01"
            name="m3value"
            placeholder="Valor por m³"
            required
    >

    <input
            type="text"
            name="initial_validity"
            placeholder="Data inicial (dd/MM/yyyy)"
            required
    >

    <input
            type="text"
            name="final_validity"
            placeholder="Data final (dd/MM/yyyy)"
            required
    >

    <button type="submit">Cadastrar</button>

</form>

<br>

<table border="1">

    <tr>
        <th>ID</th>
        <th>ID da Região</th>
        <th>Valor por m³</th>
        <th>Início da Validade</th>
        <th>Fim da Validade</th>
        <th>Ações</th>
    </tr>

    <%
        List<Region_Rate> regionRates =
                (List<Region_Rate>) request.getAttribute("regionRate");

        if (regionRates != null) {
            for (Region_Rate regionRate : regionRates) {
    %>

    <tr>
        <td><%= regionRate.getId() %></td>
        <td><%= regionRate.getRegionId() %></td>
        <td><%= regionRate.getM3Value() %></td>
        <td><%= regionRate.getInitialValidity() %></td>
        <td><%= regionRate.getFinalValidity() %></td>

        <td>
            <button type="button"
                    onclick="editarTaxa(
                        <%= regionRate.getId() %>,
                        <%= regionRate.getRegionId() %>,
                            '<%= regionRate.getM3Value() %>',
                            '<%= regionRate.getInitialValidity() %>',
                            '<%= regionRate.getFinalValidity() %>'
                            )">
                Editar
            </button>

            <button type="button"
                    onclick="deletarTaxa(<%= regionRate.getId() %>)">
                Excluir
            </button>
        </td>
    </tr>

    <%
            }
        }
    %>

</table>

<script>

    function editarTaxa(
        id,
        regionId,
        m3value,
        initialValidity,
        finalValidity
    ) {

        const novoRegionId =
            prompt("ID da região:", regionId);

        if (novoRegionId === null) {
            return;
        }

        const novoM3Value =
            prompt("Valor por m³:", m3value);

        if (novoM3Value === null) {
            return;
        }

        const novaInitialValidity =
            prompt(
                "Data inicial (dd/MM/yyyy):",
                converterData(initialValidity)
            );

        if (novaInitialValidity === null) {
            return;
        }

        const novaFinalValidity =
            prompt(
                "Data final (dd/MM/yyyy):",
                converterData(finalValidity)
            );

        if (novaFinalValidity === null) {
            return;
        }

        const parametros = new URLSearchParams();

        parametros.append("id", id);
        parametros.append("region_id", novoRegionId);
        parametros.append("m3value", novoM3Value);
        parametros.append("initial_validity", novaInitialValidity);
        parametros.append("final_validity", novaFinalValidity);

        fetch("${pageContext.request.contextPath}/regionrate?" + parametros.toString(), {
            method: "PUT"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao atualizar taxa da região.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao atualizar taxa da região.");

            });
    }


    function converterData(data) {

        const partes = data.split("-");

        if (partes.length === 3) {
            return partes[2] + "/" + partes[1] + "/" + partes[0];
        }

        return data;
    }


    function deletarTaxa(id) {

        if (!confirm("Deseja realmente excluir esta taxa?")) {
            return;
        }

        fetch("${pageContext.request.contextPath}/regionrate?id=" + id, {
            method: "DELETE"
        })
            .then(response => {

                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao excluir taxa da região.");
                }

            })
            .catch(error => {

                console.error(error);
                alert("Erro ao excluir taxa da região.");

            });
    }

</script>

</body>
</html>