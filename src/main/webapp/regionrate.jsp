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
    </tr>

    <%
            }
        }
    %>

</table>

</body>
</html>