<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrar em sua conta</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/EntrarConta.css?v=2">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/login.svg" class="fundo-svg" alt="" aria-hidden="true">
    <a href="<%= request.getContextPath() %>/inicio" aria-label="Voltar">
        <img src="<%= request.getContextPath() %>/imagens/voltar.svg" class="voltar" alt="Voltar">
    </a>

    <div class="gota">
        <div class="titulo">Cada gota</div>
        <div class="inteligentemente">inteligentemente</div>
        <div class="titulo1">controlada</div>
        <img src="<%= request.getContextPath() %>/imagens/gluh-run.svg" class="glub" alt="Mascote Glub">
    </div>

    <div class="entrar">Entrar</div>

    <form id="form-login" action="<%= request.getContextPath() %>/auth/login" method="post">
        <label for="email" class="tituloEmail">E-mail</label>
        <input type="email" id="email" name="email" placeholder="Digite seu e-mail" autocomplete="username" required maxlength="254">

        <label for="senha" class="tituloSenha">Senha</label>
        <div class="campo-senha">
            <input type="password" id="senha" name="password" placeholder="Digite sua senha" autocomplete="current-password" required maxlength="72">
            <button type="button" id="botaoOlho" aria-label="Mostrar senha" aria-pressed="false">
                <img src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" id="iconeOlho" alt="">
            </button>
        </div>

        <a href="<%= request.getContextPath() %>/recuperar-senha" class="esqueceu" id="texto-azul">Esqueceu a senha?</a>
        <button type="submit" class="criar-conta">Entrar</button>
    </form>

    <p class="criar">Não possui uma conta? <a href="<%= request.getContextPath() %>/cadastro"><u><strong>Registre-se</strong></u></a></p>

    <script src="<%= request.getContextPath() %>/js/input-validation.js"></script>
    <script>
        (() => {
            const botao = document.getElementById('botaoOlho');
            const senha = document.getElementById('senha');
            const icone = document.getElementById('iconeOlho');
            const raiz = '<%= request.getContextPath() %>';
            const email = document.getElementById('email');
            const form = document.getElementById('form-login');
            const validation = window.deltaInputValidation;

            email.addEventListener('input', () => email.setCustomValidity(''));
            form.addEventListener('submit', event => {
                email.setCustomValidity(validation.isValidEmail(email.value)
                    ? ''
                    : 'Informe um e-mail válido.');
                if (!form.reportValidity()) event.preventDefault();
            });

            botao.addEventListener('click', () => {
                const mostrar = senha.type === 'password';
                senha.type = mostrar ? 'text' : 'password';
                icone.src = raiz + (mostrar ? '/imagens/olho-aberto.svg' : '/imagens/olho-fechado.svg');
                botao.setAttribute('aria-label', mostrar ? 'Ocultar senha' : 'Mostrar senha');
                botao.setAttribute('aria-pressed', String(mostrar));
            });
        })();
    </script>
</body>
</html>
