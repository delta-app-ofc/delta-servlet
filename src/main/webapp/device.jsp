<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Device" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dispositivos - Delta</title>
</head>
<body>

<h1>Dispositivos</h1>

<form method="post" action="${pageContext.request.contextPath}/device">

    <input type="text" name="deviceId" placeholder="ID do dispositivo" required>

    <input type="number" name="propertyId"
           placeholder="ID da propriedade" required>

    <label>
        Ativo:
        <input type="checkbox" name="active" value="true">
    </label>

    <input type="text" name="installationDate"
           placeholder="dd/MM/yyyy" required>

    <button type="submit">Cadastrar</button>

</form>

<br>

<table border="1">

    <tr>
        <th>ID</th>
        <th>Dispositivo</th>
        <th>Propriedade</th>
        <th>Ativo</th>
        <th>Data de instalação</th>
        <th>Ações</th>
    </tr>

    <%
        List<Device> devices =
                (List<Device>) request.getAttribute("devices");

        for (Device device : devices) {
    %>

    <tr>
        <td><%= device.getId() %></td>
        <td><%= device.getDeviceId() %></td>
        <td><%= device.getPropertyId() %></td>
        <td><%= device.isActive() %></td>
        <td><%= device.getInstallationDate() %></td>

        <td>
            <button type="button"
                    onclick="editarDispositivo(
                        <%= device.getId() %>,
                            '<%= device.getDeviceId() %>',
                        <%= device.getPropertyId() %>,
                        <%= device.isActive() %>,
                            '<%= device.getInstallationDate() %>'
                            )">
                Editar
            </button>

            <button type="button"
                    onclick="deletarDispositivo(<%= device.getId() %>)">
                Excluir
            </button>
        </td>
    </tr>

    <%
        }
    %>

</table>

<script>

    function editarDispositivo(id, deviceId, propertyId, active, installationDate) {

        const novoDeviceId = prompt("ID do dispositivo:", deviceId);
        if (novoDeviceId === null) return;

        const novoPropertyId = prompt("ID da propriedade:", propertyId);
        if (novoPropertyId === null) return;

        const novoActive = confirm("O dispositivo está ativo?");
        const novaInstallationDate =
            prompt("Data de instalação (dd/MM/yyyy):", installationDate);

        if (novaInstallationDate === null) return;

        const parametros = new URLSearchParams();

        parametros.append("id", id);
        parametros.append("deviceId", novoDeviceId);
        parametros.append("propertyId", novoPropertyId);
        parametros.append("active", novoActive);
        parametros.append("installationDate", novaInstallationDate);

        fetch("${pageContext.request.contextPath}/device?" + parametros.toString(), {
            method: "PUT"
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao atualizar dispositivo.");
                }
            })
            .catch(error => {
                console.error(error);
                alert("Erro ao atualizar dispositivo.");
            });
    }


    function deletarDispositivo(id) {

        if (!confirm("Deseja realmente excluir este dispositivo?")) {
            return;
        }

        fetch("${pageContext.request.contextPath}/device?id=" + id, {
            method: "DELETE"
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Erro ao excluir dispositivo.");
                }
            })
            .catch(error => {
                console.error(error);
                alert("Erro ao excluir dispositivo.");
            });
    }

</script>

</body>
</html>