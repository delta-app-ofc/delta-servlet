<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar senha - e-mail</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/EmailVerificacao.css?v=2">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="" aria-hidden="true">

    <main class="container">
        <h1 class="titulo">Qual é o e-mail da conta?</h1>
        <p class="informacoes">Digite o e-mail cadastrado para receber as instruções de recuperação de senha.</p>

        <form id="forgot-password-form" action="<%= request.getContextPath() %>/auth/forgot-password" method="post">
            <input type="email" id="email" name="email" placeholder="E-mail" autocomplete="email" required maxlength="100" aria-label="E-mail cadastrado">
            <button type="submit" class="enviar-codigo">Enviar código</button>
        </form>
    </main>
    <script src="<%= request.getContextPath() %>/js/input-validation.js?v=2"></script>
    <script>
        (() => {
            const form = document.getElementById('forgot-password-form');
            const email = document.getElementById('email');
            const validation = window.deltaInputValidation;
            email.addEventListener('input', () => email.setCustomValidity(''));
            form.addEventListener('submit', event => {
                email.setCustomValidity(validation.isValidEmail(email.value)
                    ? ''
                    : 'Informe um e-mail válido.');
                if (!form.reportValidity()) event.preventDefault();
            });
        })();
    </script>
</body>
</html>
