<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar senha - e-mail</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/EmailVerificacao.css">
</head>
<body>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="" aria-hidden="true">

    <main class="container">
        <h1 class="titulo">Qual é o e-mail da conta?</h1>
        <p class="informacoes">Digite o e-mail cadastrado para receber as instruções de recuperação de senha.</p>

        <form action="<%= request.getContextPath() %>/auth/forgot-password" method="post">
            <input type="email" id="email" name="email" placeholder="E-mail" autocomplete="email" required maxlength="254" aria-label="E-mail cadastrado">
            <button type="submit" class="enviar-codigo">Enviar código</button>
        </form>
    </main>
</body>
</html>
