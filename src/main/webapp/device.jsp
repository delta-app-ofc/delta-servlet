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
    </tr>

    <%
        }
    %>

</table>

</body>
</html>