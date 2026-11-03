<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Documentação da página: CriarConta; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar sua conta</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/CriarConta.css?v=5">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/ResponsiveCore.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/login.svg" class="fundo-svg" alt="" aria-hidden="true">
    <a href="javascript:history.back()" aria-label="Voltar"><img src="<%= request.getContextPath() %>/imagens/voltar.svg" class="voltar" alt="Voltar"></a>

    <div class="gota">
        <div class="titulo">Cada gota</div>
        <div class="inteligentemente"><strong>inteligentemente</strong></div>
        <div class="titulo1">controlada</div>
        <img src="<%= request.getContextPath() %>/imagens/gluh-run.svg" class="glub" alt="">
    </div>

    <div class="crie-sua-conta">Crie sua conta</div>

    <%-- Bloco da página: formulário e envio de dados. --%>
    <form id="form-cadastro" action="<%= request.getContextPath() %>/auth/register" method="post">
        <label for="nome" class="tituloNome">Nome Completo</label>
        <input type="text" id="nome" name="name" placeholder="Digite seu nome completo" autocomplete="name" required data-required minlength="2" maxlength="100">

        <label for="telefone" class="tituloTelefone">Telefone</label>
        <input type="tel" id="telefone" name="phone" placeholder="Digite seu telefone" autocomplete="tel" inputmode="tel" required data-required pattern="(?:[0-9]{10,15}|\+[0-9]{10,14})" maxlength="15">

        <label for="email" class="tituloEmail">E-mail</label>
        <input type="email" id="email" name="email" placeholder="Digite seu e-mail" autocomplete="email" required data-required maxlength="100">

        <label for="senha" class="tituloSenha">Senha</label>
        <div class="campo-senha">
            <input type="password" id="senha" name="password" placeholder="Crie uma senha" autocomplete="new-password" required data-required minlength="8" maxlength="72">
            <button type="button" id="botaoOlho" aria-label="Alternar visibilidade da senha">
                <img id="iconeOlho" src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" alt="Mostrar senha">
            </button>
            <p id="mensagemSenha" aria-live="polite"></p>
        </div>
        <ul class="regras-senha" aria-label="Requisitos da senha">
            <li data-regra="tamanho">Pelo menos 8 caracteres</li>
            <li data-regra="letras">Uma letra maiúscula e minúscula</li>
            <li data-regra="numero-simbolo">Um número e caractere especial</li>
        </ul>
        <div class="container-lembrar">
            <input type="checkbox" id="lembrar-mim" name="lembrar" value="true">
            <label for="lembrar-mim">Lembrar de mim</label>
        </div>
        <div class="container-termos">
            <input type="checkbox" id="aceita-termos" name="aceita-termos" required data-required>
            <label for="aceita-termos">Eu li e estou ciente dos <a href="<%= request.getContextPath() %>/Termos.jsp">termos de uso</a> e <a href="<%= request.getContextPath() %>/PoliticaPrivacidade.jsp">políticas de privacidade</a></label>
        </div>
        <button type="submit" id="botaoCriarConta" class="criar-conta">Criar conta</button>
    </form>

    <p class="login">Já tem uma conta? Faça o <a href="<%= request.getContextPath() %>/login"><u><strong>login</strong></u></a></p>
    <%-- Bloco da página: código de interação executado pelo navegador. --%>
    <script>window.deltaContextPath = '<%= request.getContextPath() %>';</script>
    <%-- Bloco da página: código de interação executado pelo navegador. --%>
    <script src="<%= request.getContextPath() %>/js/input-validation.js?v=2"></script>
    <%-- Bloco da página: código de interação executado pelo navegador. --%>
    <script src="<%= request.getContextPath() %>/js/script-criar-conta.js?v=2"></script>
</body>
</html>
