<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delta</title>
    <% if (session.getAttribute("authUserId") == null || Boolean.TRUE.equals(session.getAttribute("authIsAdmin")) || Boolean.TRUE.equals(session.getAttribute("authIsManager"))) { response.sendRedirect(request.getContextPath() + "/login?role=user"); return; } %>
    <link rel="preload" as="font" type="font/otf" href="<%= request.getContextPath() %>/fontes/talina-demo.regular.otf" crossorigin>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/Animacao.css?v=20261102-1">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <style>
        @font-face {
            font-family: 'Talina DEMO';
            src: url('<%= request.getContextPath() %>/fontes/talina-demo.regular.otf') format('opentype');
            font-weight: 400;
            font-style: normal;
            font-display: block;
        }
    </style>
</head>
<body class="intro-ativa">
    <div class="animacao">
        <div class="pulso"></div>
        <p class="texto-slogan" style="top: calc(50% + 52px); font-size: 22px;">Cada gota controlada</p>
    </div>

    <div class="marca">
        <div class="texto" style="font-size: 107px;">DELT</div>
        <div class="logo" style="width: 97.279px; height: 95.832px; margin-top: -25px;">
            <div class="triangulo" style="background-image: url('<%= request.getContextPath() %>/imagens/triangulo.svg');"></div>
            <div class="gota" style="background-image: url('<%= request.getContextPath() %>/imagens/gota.svg');"></div>
        </div>
    </div>

    <script>
        const intro = document.querySelector('.animacao');
        const marca = document.querySelector('.marca');

        async function ajustarMarca() {
            try {
                await document.fonts.load('400 107px "Talina DEMO"');
                await document.fonts.ready;
            } catch (_) {}
            if (!marca) return;

            const deslocamentoLogo = 90;

            marca.style.setProperty('--logo-shift', `${deslocamentoLogo}px`);
            try { sessionStorage.setItem('deltaIntroLogoShift', `${deslocamentoLogo}px`); } catch (_) {}
        }

        ajustarMarca();
        window.addEventListener('resize', ajustarMarca);

        let introFinalizada = false;
        function finalizarIntro() {
            if (introFinalizada) return;
            introFinalizada = true;
            document.body.classList.remove('intro-ativa');
            intro?.remove();
            try { sessionStorage.setItem('vindoDaIntro', '1'); } catch (_) {}
            window.location.replace('<%= request.getContextPath() %>/landing-login');
        }

        intro.addEventListener('animationend', (e) => {
            if (e.animationName === 'sumir-intro') finalizarIntro();
        });
        window.setTimeout(finalizarIntro, 7000);
    </script>
</body>
</html>

