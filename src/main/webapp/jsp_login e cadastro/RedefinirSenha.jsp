<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recupere sua senha</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/RecuperarSenha.css?v=3">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
    <style>
        @media (min-width: 701px) {
            html, body { width: 100%; height: 100vh; min-height: 0; overflow: hidden; }
            .fundo-svg { position: fixed; height: 100vh; }
            .recupere-sua-senha, .campo-senha1, .campo-senha2, .avancar { left: calc(75.5vw - min(33.6vw, 48vh) / 2); width: min(33.6vw, 48vh); }
            .recupere-sua-senha { position: absolute; z-index: 25; top: 23.5vh; color: #003E9B; text-align: center; font: 700 4.7vh/1.3 'Unbounded', sans-serif; }
            .senha-nova, .confirmar-senha { position: absolute; z-index: 16; left: calc(75.5vw - min(33.6vw, 48vh) / 2 + 2px); color: #003E9B; font: 700 clamp(16px, 1.76vh, 18px) Montserrat, sans-serif; }
            .senha-nova { top: 42vh; }
            .campo-senha1, .campo-senha2 { height: 6.84vh; }
            .campo-senha1 { top: 44.5vh; }
            .confirmar-senha { top: 53.6vh; }
            .campo-senha2 { top: 56vh; }
            #senha-nova, #confirmar-senha { border: 2px solid #003E9B; background-color: #FAFAFA; font-size: clamp(16px, 1.76vh, 18px); }
            .botaoOlho { display: none; }
            .avancar { top: 70.8vh; height: 6.74vh; font: 700 2.05vh 'Unbounded', sans-serif; }
        }
    </style>
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
    <script src="<%= request.getContextPath() %>/js/input-validation.js?v=2"></script>
    <script src="<%= request.getContextPath() %>/js/script-recuperar-conta.js"></script>
</body>
</html>
