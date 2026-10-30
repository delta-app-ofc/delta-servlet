<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Object sessionName = session.getAttribute("authName");
    String welcomeName = sessionName == null ? "Usuário" : String.valueOf(sessionName);
    welcomeName = welcomeName.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bem-vindo(a) | Delta</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/LoginConcluido.css">
</head>
<body>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="" aria-hidden="true">

    <main class="retangulo">
        <img src="<%= request.getContextPath() %>/imagens/LogoDelta2.png" class="login" alt="Delta">
        <p class="texto">Bem-vindo(a). <strong><%= welcomeName %>.</strong><br>
            <span>Sua conta foi criada com sucesso</span>
        </p>
        <form action="<%= request.getContextPath() %>/auth/logout" method="post">
            <button type="submit" class="sair">Sair</button>
        </form>
    </main>
</body>
</html>
