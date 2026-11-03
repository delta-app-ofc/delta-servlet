<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrar em sua Conta</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/EntrarConta.css?v=20261102-1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/ResponsiveCore.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/login.svg" class="fundo-svg" alt="Fundo">
    <a href="javascript:history.back()" aria-label="Voltar"><img src="<%= request.getContextPath() %>/imagens/voltar.svg" class="voltar" alt="Voltar"></a>

    <div class="gota">
        <div class="titulo">Cada gota</div>
        <div class="inteligentemente">inteligentemente</div>
        <div class="titulo1">controlada</div>
        <img src="<%= request.getContextPath() %>/imagens/gluh-run.svg" class="glub" alt="Mascote Glub">
    </div>

    <%
        String selectedLoginRole = "admin".equals(request.getAttribute("loginRole"))
                || "admin".equalsIgnoreCase(request.getParameter("role")) ? "admin" : "user";
    %>
    <div class="botoes" role="group" aria-label="Tipo de conta">
        <a href="<%= request.getContextPath() %>/login?role=user" class="<%= "user".equals(selectedLoginRole) ? "usuario" : "usuario1" %>" <%= "user".equals(selectedLoginRole) ? "aria-current=\"page\"" : "" %>>Usuário</a>
        <a href="<%= request.getContextPath() %>/login?role=admin" class="<%= "admin".equals(selectedLoginRole) ? "adm" : "adm1" %>" <%= "admin".equals(selectedLoginRole) ? "aria-current=\"page\"" : "" %>>Administrador</a>
    </div>

    <div class="entrar">Entrar</div>
    <form id="form-login" action="<%= request.getContextPath() %>/auth/login" method="post">
        <input type="hidden" name="role" value="<%= selectedLoginRole %>">
        <label for="email" class="tituloEmail">Email</label>
        <input type="email" id="email" name="email" placeholder="Digite seu email" autocomplete="username" required data-required maxlength="100">

        <label for="senha" class="tituloSenha">Senha</label>
        <div class="campo-senha">
            <input type="password" id="senha" name="password" placeholder="Digite sua senha" autocomplete="current-password" required data-required maxlength="72">
            <button type="button" id="botaoOlho" aria-label="Mostrar ou ocultar senha">
                <img src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" id="iconeOlho" alt="Mostrar senha">
            </button>
        </div>

        <a href="<%= request.getContextPath() %>/recuperar-senha" class="esqueceu" id="texto-azul">Esqueceu a senha?</a>
        <button type="submit" class="criar-conta">Entrar</button>
    </form>
    <p class="criar">Não possui conta? Faça o <a href="<%= request.getContextPath() %>/cadastro"><u><strong>cadastro</strong></u></a></p>

    <script>
        (() => {
            const botao = document.getElementById('botaoOlho');
            const senha = document.getElementById('senha');
            const icone = document.getElementById('iconeOlho');
            const raiz = '<%= request.getContextPath() %>';
            botao.addEventListener('click', () => {
                const mostrar = senha.type === 'password';
                senha.type = mostrar ? 'text' : 'password';
                icone.src = raiz + (mostrar ? '/imagens/olho-aberto.svg' : '/imagens/olho-fechado.svg');
                botao.setAttribute('aria-label', mostrar ? 'Ocultar senha' : 'Mostrar ou ocultar senha');
            });
        })();
    </script>
</body>
</html>
