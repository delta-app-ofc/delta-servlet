<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Código de verificação</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/CodigoVerificacao.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/AuthMessage.css">
</head>
<body>
    <%@ include file="/WEB-INF/jspf/auth-error.jspf" %>
    <img src="<%= request.getContextPath() %>/imagens/codigo.svg" class="fundo-svg" alt="" aria-hidden="true">

    <form id="form-verificacao" action="<%= request.getContextPath() %>/auth/verify-code" method="post" hidden>
        <input type="hidden" name="code" id="codigo-completo">
    </form>

    <form id="form-reenvio" action="<%= request.getContextPath() %>/auth/resend-code" method="post" hidden></form>

    <main class="container">
        <h1 class="titulo">Insira o código abaixo:</h1>
        <p class="informacoes">Confira o código que enviamos no seu e-mail</p>

        <div class="grupo-inputs" role="group" aria-label="Código de verificação">
            <input form="form-verificacao" type="text" inputmode="numeric" autocomplete="one-time-code" maxlength="1" class="codigo-input" aria-label="Primeiro dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" class="codigo-input" aria-label="Segundo dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" class="codigo-input" aria-label="Terceiro dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" class="codigo-input" aria-label="Quarto dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" class="codigo-input" aria-label="Quinto dígito">
            <input form="form-verificacao" type="text" inputmode="numeric" maxlength="1" class="codigo-input" aria-label="Sexto dígito">
        </div>
        <a href="#" class="reenviar-codigo" id="reenviarCodigo">Reenviar código</a>
        <button type="submit" form="form-verificacao" class="confirmar">Confirmar</button>
    </main>


    <script>
        (() => {
            const campos = [...document.querySelectorAll('.codigo-input')];
            const formulario = document.getElementById('form-verificacao');
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
