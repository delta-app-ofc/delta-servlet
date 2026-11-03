<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Documentação da página: CodigoVerificacao; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Código de Verificação</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/CodigoVerificacao.css?v=3">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/ResponsiveCore.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="Fundo decorativo">

    <%
        com.example.delta_back.auth.AuthChallenge activeChallenge =
                (com.example.delta_back.auth.AuthChallenge) session.getAttribute("authChallenge");
        String destinationEmail = activeChallenge == null ? "" : activeChallenge.getEmail();
        String maskedEmail = destinationEmail;
        int atIndex = destinationEmail.indexOf('@');
        if (atIndex > 0) {
            String localPart = destinationEmail.substring(0, atIndex);
            String maskedLocal = localPart.length() <= 2
                    ? localPart.charAt(0) + "***"
                    : localPart.charAt(0) + "***" + localPart.substring(localPart.length() - 2);
            maskedEmail = maskedLocal + destinationEmail.substring(atIndex);
        }
        maskedEmail = maskedEmail.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    %>
    <a href="<%= request.getContextPath() %>/auth/edit-email" aria-label="Voltar e alterar o e-mail">
        <img src="<%= request.getContextPath() %>/imagens/voltar.svg" class="voltar" alt="Voltar">
    </a>

    <%-- Bloco da página: formulário e envio de dados. --%>
    <form id="form-verificacao" action="<%= request.getContextPath() %>/auth/verify-code" method="post" hidden>
        <input type="hidden" name="code" id="codigo-completo">
    </form>
    <%-- Bloco da página: formulário e envio de dados. --%>
    <form id="form-reenvio" action="<%= request.getContextPath() %>/auth/resend-code" method="post" hidden></form>

    <%-- Bloco da página: conteúdo principal. --%>
    <main class="container" data-expira-em="<%= activeChallenge == null ? "" : activeChallenge.getExpiresAt().toEpochMilli() %>">
        <h1 class="titulo">Insira o código abaixo:</h1>
        <p class="informacoes">Código enviado para o e-mail: <strong><%= maskedEmail %></strong> <a class="alterar-email" href="<%= request.getContextPath() %>/auth/edit-email"><strong>Alterar e-mail</strong></a></p>

        <div class="grupo-inputs" role="group" aria-label="Código de verificação">
            <input form="form-verificacao" type="text" inputmode="numeric" autocomplete="one-time-code" maxlength="1" pattern="[0-9]" required class="codigo-input" aria-label="Primeiro dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" pattern="[0-9]" required class="codigo-input" aria-label="Segundo dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" pattern="[0-9]" required class="codigo-input" aria-label="Terceiro dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" pattern="[0-9]" required class="codigo-input" aria-label="Quarto dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" pattern="[0-9]" required class="codigo-input" aria-label="Quinto dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" pattern="[0-9]" required class="codigo-input" aria-label="Sexto dígito">
        </div>

        <p class="tempo" id="tempo-expiracao">Esse código expira em 10:00</p>
        <button type="submit" form="form-verificacao" class="confirmar">Confirmar</button>
        <p class="reenviar-codigo">Não recebeu o e-mail? <a href="#" id="reenviarCodigo"><strong>Reenviar</strong></a></p>
    </main>

    <%-- Bloco da página: código de interação executado pelo navegador. --%>
    <script>
        (() => {
            const campos = [...document.querySelectorAll('.codigo-input')];
            const formulario = document.getElementById('form-verificacao');
            const expiracaoServidor = Number(document.querySelector('.container').dataset.expiraEm);
            const expiraEm = expiracaoServidor || Date.now() + 10 * 60 * 1000;
            const timer = document.getElementById('tempo-expiracao');
            const atualizarTimer = () => {
                const segundosRestantes = Math.max(0, Math.ceil((expiraEm - Date.now()) / 1000));
                const minutos = String(Math.floor(segundosRestantes / 60)).padStart(2, '0');
                const segundos = String(segundosRestantes % 60).padStart(2, '0');
                timer.textContent = 'Esse c' + String.fromCharCode(243) + 'digo expira em ' + minutos + ':' + segundos;
            };
            atualizarTimer();
            window.setInterval(atualizarTimer, 1000);
            document.getElementById('reenviarCodigo').addEventListener('click', (evento) => {
                evento.preventDefault();
                document.getElementById('form-reenvio').submit();
            });

            campos.forEach((campo, indice) => {
                campo.addEventListener('input', () => {
                    campo.value = campo.value.replace(/\D/g, '').slice(-1);
                    if (campo.value && indice < campos.length - 1) campos[indice + 1].focus();
                });
                campo.addEventListener('keydown', (evento) => {
                    if (evento.key === 'Backspace' && !campo.value && indice > 0) campos[indice - 1].focus();
                });
                campo.addEventListener('paste', (evento) => {
                    const codigo = evento.clipboardData.getData('text').replace(/\D/g, '').slice(0, campos.length);
                    if (!codigo) return;
                    evento.preventDefault();
                    [...codigo].forEach((digito, posicao) => { campos[posicao].value = digito; });
                    campos[Math.min(codigo.length, campos.length - 1)].focus();
                });
            });

            formulario.addEventListener('submit', (evento) => {
                const codigo = campos.map((campo) => campo.value).join('');
                if (codigo.length !== campos.length) {
                    evento.preventDefault();
                    campos.find((campo) => !campo.value)?.focus();
                    return;
                }
                document.getElementById('codigo-completo').value = codigo;
            });
        })();
    </script>
</body>
</html>
