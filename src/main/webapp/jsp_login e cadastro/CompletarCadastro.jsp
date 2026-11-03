<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quase lá! | Delta</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/ConcluirLogin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/ResponsiveCore.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="Fundo decorativo">
    <a href="<%= request.getContextPath() %>/cadastro" class="voltar" aria-label="Voltar para o cadastro">
        <img src="<%= request.getContextPath() %>/imagens/voltar.svg" alt="Voltar">
    </a>

    <main class="container">
        <h1 class="titulo">Quase lá!</h1>
        <p class="informacoes">Seu e-mail já foi confirmado. Complete os dados necessários para criar sua conta.</p>

        <form id="form-completar-cadastro" class="form-completar-cadastro" action="<%= request.getContextPath() %>/auth/complete-registration" method="post">
            <label class="rotulo-data" for="data">Digite sua data de nascimento</label>
            <input type="date" id="data" name="birthdate" placeholder="dd/mm/aaaa" autocomplete="bday" max="<%= java.time.LocalDate.now().minusYears(18) %>" required data-required>
            <button type="submit" class="concluir-cadastro">Concluir cadastro</button>
        </form>
    </main>
    <script src="<%= request.getContextPath() %>/js/input-validation.js?v=2"></script>
    <script>
        (() => {
            const form = document.getElementById('form-completar-cadastro');
            const birthdate = document.getElementById('data');
            const validation = window.deltaInputValidation;
            birthdate.addEventListener('input', () => birthdate.setCustomValidity(''));
            form.addEventListener('submit', event => {
                birthdate.setCustomValidity(validation.isTodayOrEarlier(birthdate.value)
                    ? ''
                    : 'Informe uma data de nascimento válida até hoje.');
                if (!form.reportValidity()) event.preventDefault();
            });
        })();
    </script>
</body>
</html>
