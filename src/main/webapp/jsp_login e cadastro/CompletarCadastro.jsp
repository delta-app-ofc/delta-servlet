<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quase lá! | Delta</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/CompleteCadastro.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="" aria-hidden="true">
    <a href="<%= request.getContextPath() %>/cadastro" class="voltar" aria-label="Voltar para o cadastro">
        <img src="<%= request.getContextPath() %>/imagens/voltar.svg" alt="Voltar">
    </a>

    <main class="container">
        <h1 class="titulo">Quase lá!</h1>
        <p class="informacoes">Seu e-mail já foi confirmado. Complete os dados necessários para criar sua conta.</p>

        <form id="form-completar-cadastro" class="form-completar-cadastro" action="<%= request.getContextPath() %>/auth/complete-registration" method="post">
            <input type="tel" id="telefone" name="phone" placeholder="Telefone" autocomplete="tel" inputmode="tel" required pattern="\+?[0-9]{10,15}" maxlength="16">
            <input type="date" id="data" name="birthdate" autocomplete="bday" max="<%= java.time.LocalDate.now() %>" required>
            <button type="submit" class="concluir-cadastro">Concluir cadastro</button>
        </form>
    </main>
    <script src="<%= request.getContextPath() %>/js/input-validation.js"></script>
    <script>
        (() => {
            const form = document.getElementById('form-completar-cadastro');
            const phone = document.getElementById('telefone');
            const birthdate = document.getElementById('data');
            const validation = window.deltaInputValidation;
            [phone, birthdate].forEach(input => input.addEventListener('input', () => input.setCustomValidity('')));
            form.addEventListener('submit', event => {
                phone.setCustomValidity(validation.isValidPhone(phone.value)
                    ? ''
                    : 'Informe de 10 a 15 dígitos, com + opcional no início e sem espaços ou pontuação.');
                birthdate.setCustomValidity(validation.isTodayOrEarlier(birthdate.value)
                    ? ''
                    : 'Informe uma data de nascimento válida até hoje.');
                if (!form.reportValidity()) event.preventDefault();
            });
        })();
    </script>
</body>
</html>
