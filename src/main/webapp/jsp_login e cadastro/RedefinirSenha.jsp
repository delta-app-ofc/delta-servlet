<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recupere sua Senha</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/RecuperarSenha.css?v=4">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/ResponsiveCore.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/login.svg" class="fundo-svg" alt="Fundo">
    <a href="<%= request.getContextPath() %>/auth/verify-code"><img src="<%= request.getContextPath() %>/imagens/voltar.svg" class="voltar" alt="Voltar"></a>

    <div class="gota">
        <div class="titulo">Cada gota</div>
        <div class="inteligentemente">inteligentemente</div>
        <div class="titulo1">controlada.</div>
        <img src="<%= request.getContextPath() %>/imagens/gluh-run.svg" class="glub" alt="Mascote Glub">
    </div>

    <form id="form-redefinir-senha" class="form-recuperar" action="<%= request.getContextPath() %>/auth/reset-password" method="post">
        <h1 class="recuperar-titulo">Recupere<br>sua senha</h1>

        <label for="senha-nova" class="tituloSenhaNova">Senha nova</label>
        <div class="campo-senha1">
            <input type="password" id="senha-nova" name="password" placeholder="Digite a senha nova" autocomplete="new-password" required minlength="8" maxlength="72">
            <button type="button" id="botaoOlho1" class="botaoOlho" data-toggle-password="senha-nova" aria-label="Mostrar senha">
                <img src="<%= request.getContextPath() %>/imagens/olho-aberto.svg" id="iconeOlho1" class="iconeOlho" alt="">
            </button>
        </div>
        <ul class="requisitos-senha" aria-label="Requisitos da senha">
            <li data-regra="tamanho">Pelo menos 8 caracteres</li>
            <li data-regra="maiuscula">Uma letra maiúscula</li>
            <li data-regra="numero">Um número</li>
        </ul>

        <label for="confirmar-senha" class="tituloConfirmarSenha">Confirme a senha nova</label>
        <div class="campo-senha2">
            <input type="password" id="confirmar-senha" name="confirmPassword" placeholder="Digite a senha novamente" autocomplete="new-password" required minlength="8" maxlength="72">
            <button type="button" id="botaoOlho2" class="botaoOlho" data-toggle-password="confirmar-senha" aria-label="Mostrar senha">
                <img src="<%= request.getContextPath() %>/imagens/olho-aberto.svg" id="iconeOlho2" class="iconeOlho" alt="">
            </button>
        </div>

        <button type="submit" class="avancar" data-password-form>Salvar senha</button>
    </form>

    <script>window.deltaContextPath = '<%= request.getContextPath() %>';</script>
    <script src="<%= request.getContextPath() %>/js/input-validation.js?v=2"></script>
    <script src="<%= request.getContextPath() %>/js/script-recuperar-conta.js"></script>
</body>
</html>
