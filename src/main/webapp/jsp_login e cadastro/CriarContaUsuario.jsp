<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar sua conta</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/CriarConta.css?v=2">
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
        <div class="inteligentemente"><strong>inteligentemente</strong></div>
        <div class="titulo1">controlada</div>
        <img src="<%= request.getContextPath() %>/imagens/gluh-run.svg" class="glub" alt="Mascote Glub">
    </div>

    <div class="crie-sua-conta">Crie sua conta</div>

    <div class="botoes">
        <a href="<%= request.getContextPath() %>/cadastro?tipo=usuario" aria-current="page"><button type="button" class="usuario">Usuário</button></a>
        <a href="<%= request.getContextPath() %>/cadastro?tipo=admin"><button type="button" class="adm1">Administrador</button></a>
    </div>

    <form id="form-cadastro" action="<%= request.getContextPath() %>/auth/register" method="post">
        <input type="hidden" name="tipo" value="usuario">
        <div class="tituloNome">Nome completo</div>
        <input type="text" id="nome" name="name" placeholder="Digite seu nome" autocomplete="name" required minlength="2" maxlength="100">

        <div class="tituloEmail">E-mail</div>
        <input type="email" id="email" name="email" placeholder="Digite seu e-mail" autocomplete="email" required maxlength="254">

        <div class="tituloSenha">Senha</div>
        <div class="campo-senha">
            <input type="password" id="senha" name="password" placeholder="Digite sua senha" autocomplete="new-password" required minlength="8" maxlength="72">
            <button type="button" id="botaoOlho" aria-label="Alternar visibilidade da senha">
                <img id="iconeOlho" src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" alt="Mostrar senha">
            </button>
            <p id="mensagemSenha" aria-live="polite"></p>
        </div>
        <div class="container-lembrar">
            <input type="checkbox" id="lembrar-mim" name="lembrar" value="true">
            <label for="lembrar-mim">Lembrar de mim</label>
        </div>

        <button type="submit" id="botaoCriarConta" class="criar-conta">Criar</button>
    </form>

    <p class="login">Já tem uma conta? Faça <a href="<%= request.getContextPath() %>/login"><u><strong>login</strong></u></a></p>

    <script>window.deltaContextPath = '<%= request.getContextPath() %>';</script>
    <script src="<%= request.getContextPath() %>/js/input-validation.js"></script>
    <script src="<%= request.getContextPath() %>/js/script-criar-conta.js"></script>
</body>
</html>
