<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recupere sua senha</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/RecuperarSenha.css">
</head>
<body>
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

    <div class="recupere-sua-senha">Recupere sua senha</div>

    <form id="form-redefinir-senha" action="<%= request.getContextPath() %>/auth/reset-password" method="post">
        <label for="senha-nova" class="senha-nova">Senha nova</label>
        <div class="campo-senha1">
            <input type="password" id="senha-nova" name="password" placeholder="Digite sua senha nova" autocomplete="new-password" required minlength="8" maxlength="72">
            <button type="button" id="botaoOlho1" class="botaoOlho" aria-label="Mostrar senha">
                <img src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" id="iconeOlho1" class="iconeOlho" alt="">
            </button>
        </div>

        <label for="confirmar-senha" class="confirmar-senha">Confirme sua senha nova</label>
        <div class="campo-senha2">
            <input type="password" id="confirmar-senha" name="confirmPassword" placeholder="Digite a senha novamente" autocomplete="new-password" required minlength="8" maxlength="72">
            <button type="button" id="botaoOlho2" class="botaoOlho" aria-label="Mostrar senha">
                <img src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" id="iconeOlho2" class="iconeOlho" alt="">
            </button>
        </div>

        <button type="submit" class="avancar">Avançar</button>
    </form>

    <script>window.deltaContextPath = '<%= request.getContextPath() %>';</script>
    <script src="<%= request.getContextPath() %>/js/script-recuperar-conta.js"></script>
</body>
</html>
