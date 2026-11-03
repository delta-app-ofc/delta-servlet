<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Documentação da página: Landing; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Site Delta</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/Ladding.css?v=20261102-25">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/LaddingResponsive.css?v=20261102-33">
    <%-- Bloco da página: estilos locais desta tela. --%>
    <style>
        @font-face {
            font-family: 'Talina DEMO';
            src: url('<%= request.getContextPath() %>/fontes/talina-demo.regular.otf') format('opentype');
            font-weight: normal;
            font-style: normal;
            font-display: swap;
        }
    </style>
    <%-- Bloco da página: código de interação executado pelo navegador. --%>
    <script defer src="<%= request.getContextPath() %>/js/script-landing.js"></script>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
</head>
<body>
    <div class="barra-fixa">
        <a href="#topico1" class="botao-topo"><div class="botao-logo"><p class="Delta">DELT</p><img src="<%= request.getContextPath() %>/imagens/LogoDelta.svg" id="LogoDelta" alt="Logo Delta"></div></a>
        <button class="botao-menu" id="botao-menu" type="button" aria-label="Abrir menu de navegação" aria-expanded="false" aria-controls="menu-navegacao"><span></span><span></span><span></span></button>
        <%-- Bloco da página: navegação. --%>
        <nav class="menu-navegacao" id="menu-navegacao" aria-label="Navegação da página">
            <a href="#topico1">Início</a><a href="#topico2">Conceito</a><a href="#topico3">Objetivos</a><a href="#topico4">Funcionalidades</a><a href="#topico5">Sobre nós</a><a href="#topico6">Nossos valores</a>
        </nav>
        <a href="<%= request.getContextPath() %>/cadastro"><div class="Cadastrar"><p id="cadastrar">Cadastrar</p></div></a>
        <a href="<%= request.getContextPath() %>/login"><p class="Entrar">Entrar</p></a>
        <p class="Inicio"><a href="#topico1">Início</a></p><p class="Conceito"><a href="#topico2">Conceito</a></p><p class="Objetivos"><a href="#topico3">Objetivos</a></p><p class="Funcionalidades"><a href="#topico4">Funcionalidades</a></p><p class="Sobre_Nos"><a href="#topico5">Sobre nós</a></p><p class="valores"><a href="#topico6">Nossos Valores</a></p>
    </div>

    <div class="FundoGradiente" id="topico1"></div>
    <p class="titulo1">CADA GOTA</p><p class="tituloPrincipal">INTELIGENTEMENTE</p><p class="titulo2">CONTROLADA</p>
    <img src="<%= request.getContextPath() %>/imagens/LogoTransparente.svg" id="LogoTransparente" alt="Delta">
    <p class="Texto">Monitore, preveja e reduza o consumo de água da sua residência com inteligência artificial. Tudo em tempo real, no seu celular.</p>
    <a href="<%= request.getContextPath() %>/cadastro"><div class="retanguloComecar"><div id="textoComecar">Começe agora!</div></div></a>

    <div class="carta1"><div class="conteudoCarta1"><div class="Numero"><span class="menos">-</span><span class="numero">35</span><span class="porcentagem">%</span></div><p class="textoCarta1">Redução média no consumo pós<br>3 meses de uso da plataforma</p></div></div>
    <div class="carta2"><div class="conteudoCarta2"><div class="horas"><span class="numero">24</span><span class="porcentagem">h</span></div><p class="textoCarta2">Monitoramento contínuo com<br>alertas instantâneos no celular</p></div></div>
    <div class="carta3"><div class="conteudoCarta3"><div class="Numero2"><span class="mais">+</span><span class="numero2">5</span></div><p class="textoCarta3">Funcionalidades de análise,<br>previsão e alertas automáticos</p></div></div>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="delta-section"><img src="<%= request.getContextPath() %>/imagens/FundoOndaGradiente.svg" id="FundoAzulOndaGradiente" alt="">
        <div class="O-Delta">O DELTA</div>
        <div class="textoDelta">O Projeto Delta é uma solução inteligente que conecta<br>
            dispositivos IoT diretamente ao seu hidrômetro para<br>
            monitorar o consumo de água em tempo real.<br>
            Usando inteligência artificial, o sistema prevê seus<br>
            custos futuros, envia alertas automáticos e detecta<br>
            vazamentos ocultos antes que gerem prejuízo, tudo<br>
            acessível na palma da sua mão.
        </div>
        <div class="Iphone"><img src="<%= request.getContextPath() %>/imagens/IphoneAPP.svg" alt="Aplicativo Delta"></div>
    </section>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="concept-section"><img src="<%= request.getContextPath() %>/imagens/FundoAzulClaroOnda.svg" class="FundoAzulClaroOnda" alt=""><p class="tituloConceito" id="topico2">CONCEITO</p><div class="retanguloCenario"><p class="miniTituloCenario">Cenário</p></div><div class="retanguloSolucao"><p class="miniTituloSolucao">Solução</p></div><div class="retanguloCenario2"><p class="conteudoCenario">A água é um recurso de extrema importância e que deve ter um controle inteligente. O nosso sistema oferece o monitoramento do consumo e permite com que você tome decisões melhores, contribuindo para a economia de água.</p></div><div class="retanguloSolucao2"><p class="conteudoSolucao">Diante dos problemas, o sistema proposto oferece monitoramento em tempo real, análise inteligente dos dados e atuação direta sobre o fluxo de água. Com isso, o usuário passa a ter controle total sobre o consumo.</p></div></section>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="objective-section"><img src="<%= request.getContextPath() %>/imagens/FundoAzulCurvadoGradiente.svg" id="FundoAzulCurvado" alt=""><p class="tituloObjetivos" id="topico3">OBJETIVOS</p>
        <div class="cartaoReducao"><img src="<%= request.getContextPath() %>/imagens/Hidrometro.svg" id="hidrometro" alt=""><p class="tituloReducao">Redução de Consumo</p><p class="informacoesReducao">• Reduzir o consumo excessivo de água;<br>• Identificar vazamentos e falhas rapidamente;<br>• Melhorar o controle operacional da rede hidráulica;<br>• Automatizar processos relacionados ao fluxo de água.</p></div>
        <div class="cartaoMonitoramento"><img src="<%= request.getContextPath() %>/imagens/Monitoramento.svg" id="monitoramento" alt=""><p class="tituloMonitoramento">Monitoramento inteligente</p><p class="informacoesMonitoramento">•Permitir monitoramento em tempo real;<br>•Facilitar a tomada de decisão através de dashboards e indicadores;<br>•Integrar sustentabilidade e tecnologia dentro da operação industrial;<br>•Contribuir para práticas alinhadas à ODS 12.</p></div>
        <div class="cartaoEficiencia"><img src="<%= request.getContextPath() %>/imagens/Eficiencia.svg" id="eficiencia" alt=""><p class="tituloEficiencia">Eficiência e sustentabilidade</p><p class="informacoesEficiencia">•Aumentar o reaproveitamento hídrico;<br>•Melhorar a eficiência dos processos industriais;<br>•Reduzir desperdícios e custos operacionais;<br>•Gerar relatórios e análises estratégicas.</p></div>
    </section>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="functionality-section"><img src="<%= request.getContextPath() %>/imagens/FundoAzulClaroOnda2.svg" id="FundoAzulClaroOnda2" alt=""><p class="tituloFuncionalidades" id="topico4">FUNCIONALIDADES</p>
        <div class="cartao1"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame1" alt=""><img src="<%= request.getContextPath() %>/imagens/relogio.svg" id="relogio" alt=""><p class="tituloCardMonitoramento">Monitoramento em tempo real</p><p class="informacoesCardMonitoramento">Acompanhe seu consumo a<br> qualquer momento.</p></div>
        <div class="cartao2"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame2" alt=""><img src="<%= request.getContextPath() %>/imagens/sino.svg" id="sino" alt=""><p class="tituloCardAlerta">Alertas inteligentes</p><p class="informacoesCardAlerta">Receba notificações de vazamentos<br> e consumos anormais.</p></div>
        <div class="cartao3"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame3" alt=""><img src="<%= request.getContextPath() %>/imagens/grafico.svg" id="grafico" alt=""><p class="tituloCardPrevisao">Previsão de consumo e gastos</p><p class="informacoesCardPrevisao">Veja a projeção do seu consumo e<br> do valor da conta.</p></div>
        <div class="cartao4"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame4" alt=""><img src="<%= request.getContextPath() %>/imagens/lista.svg" id="lista" alt=""><p class="tituloCardMetas">Metas personalizadas</p><p class="informacoesCardMetas">Defina metas de consumo e<br> acompanhe seu progresso.</p></div>
        <div class="cartao5"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame5" alt=""><img src="<%= request.getContextPath() %>/imagens/robo.svg" id="robo" alt=""><p class="tituloCardChatbot">Chatbot inteligente</p><p class="informacoesCardChatbot">Tire dúvidas e receba orientações<br> em linguagem natural.</p></div>
        <div class="cartao6"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame6" alt=""><img src="<%= request.getContextPath() %>/imagens/papel.svg" id="papel" alt=""><p class="tituloCardHistorico">Histórico completo</p><p class="informacoesCardHistorico">Consulte relatórios e histórico de<br> consumo detalhado.</p></div>
    </section>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="plans-section"><img src="<%= request.getContextPath() %>/imagens/fundo-planos.svg" class="fundo-planos" alt=""><p class="titulo-planos">NOSSOS PLANOS</p>
        <div class="retangulo1"><div class="parte-cima"><img src="<%= request.getContextPath() %>/imagens/gluh1.svg" class="gluh1" alt=""><h2 class="titulo-essencial">Essencial</h2></div><ul class="texto-retangulo1"><li>Monitoramento em tempo real;</li><li>Visualização do consumo;</li><li>Alertas de consumo e vazamentos;</li><li>Histórico básico de consumo;</li><li>Estimativa da próxima fatura;</li><li>Suporte técnico básico.</li></ul><p class="preco1">R$ 250,00</p><p class="mensal">mensalmente</p></div>
        <div class="retangulo2"><div class="parte-cima"><img src="<%= request.getContextPath() %>/imagens/gluh2.svg" class="gluh2" alt=""><h2 class="titulo-gestao">Gestão</h2></div><ul class="texto-retangulo2"><li>Todas as funções do Essencial;</li><li>Relatórios detalhados;</li><li>Metas e indicadores de eficiência;</li><li>Recomendações inteligentes;</li><li>Planejamento do consumo;</li><li>Integração com a previsão do tempo.</li></ul><p class="preco2">R$ 300,00</p><p class="mensal">mensalmente</p></div>
        <div class="retangulo3"><div class="parte-cima"><img src="<%= request.getContextPath() %>/imagens/gluh3.svg" class="gluh3" alt=""><h2 class="titulo-premium">Premium</h2></div><ul class="texto-retangulo3"><li>Todas as funções da Gestão;</li><li>Inteligência artificial e chatbot;</li><li>Previsão de consumo e falhas;</li><li>Estimativa avançada da fatura;</li><li>Otimização automática;</li><li>Rankings e recompensas por metas;</li><li>Suporte prioritário.</li></ul><p class="preco3">R$ 350,00</p><p class="mensal">mensalmente</p></div>
    </section>

    <p class="tituloNossaEquipe">NOSSA EQUIPE</p>
    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="carrossel-section"><div class="carrossel"><div class="fotosCarrossel">
        <% String[] equipe = {"bruno", "gabriel", "lucas", "manuela", "pedro", "pietra", "ana", "davi", "joão", "mariana", "samuel"}; %>
        <div class="grupo"><% for (String pessoa : equipe) { %>
            <div class="foto <%= "lucas".equals(pessoa) ? "foto-lucas" : "" %>" <%= "lucas".equals(pessoa) ? "id=\"lucas\"" : "" %>>
                <img src="<%= request.getContextPath() %>/imagens/<%= pessoa %>.svg?v=20261102-22" <%= "lucas".equals(pessoa) ? "id=\"lucasFoto\"" : "" %> alt="Integrante da equipe">
                <% if ("lucas".equals(pessoa)) { %><div id="lucasTexto"><img src="<%= request.getContextPath() %>/imagens/lucasTexto.svg?v=20261102-22" alt=""></div><% } %>
            </div>
        <% } %></div>
        <div class="grupo" aria-hidden="true"><% for (String pessoa : equipe) { %>
            <div class="foto <%= "lucas".equals(pessoa) ? "foto-lucas" : "" %>" <%= "lucas".equals(pessoa) ? "id=\"lucas\"" : "" %>>
                <img src="<%= request.getContextPath() %>/imagens/<%= pessoa %>.svg?v=20261102-22" <%= "lucas".equals(pessoa) ? "id=\"lucasFoto\"" : "" %> alt="">
                <% if ("lucas".equals(pessoa)) { %><div id="lucasTexto"><img src="<%= request.getContextPath() %>/imagens/lucasTexto.svg?v=20261102-22" alt=""></div><% } %>
            </div>
        <% } %></div>
    </div></div></section>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="FundoAzulCurvadoGradiente"><img src="<%= request.getContextPath() %>/imagens/FundoCurvaGradiente.svg" id="fundoCurvadoGradiente" alt=""><p class="sobreNos" id="topico5">SOBRE NÓS</p><p class="textoSobreNos">Somos estudantes do Instituto J&amp;F, onde aprendemos por meio da prática, do trabalho em equipe e de projetos reais. Neste projeto, unimos nossos conhecimentos para desenvolver uma solução baseada no ODS 12, utilizando tecnologia para promover o uso consciente da água e reduzir desperdícios. Buscamos transformar o que aprendemos em uma solução que possa gerar um impacto positivo.</p><img src="<%= request.getContextPath() %>/imagens/bracoGlub.svg" id="bracoGlub" alt=""><img src="<%= request.getContextPath() %>/imagens/gotaMenor.svg" id="gotaMenor" alt=""><img src="<%= request.getContextPath() %>/imagens/gotaMaior.svg" id="gotaMaior" alt=""><img src="<%= request.getContextPath() %>/imagens/corpoGlub.svg" id="corpoGlub" alt=""></section>

    <p class="NossosValores" id="topico6">NOSSOS VALORES</p>
    <div class="card-section"><button class="botao-voltar" id="botao-voltar" type="button" aria-label="Valor anterior"><img src="<%= request.getContextPath() %>/imagens/botaoVoltar.svg" class="icone" id="icone-voltar" alt=""></button><button class="botao-avancar" id="botao-avancar" type="button" aria-label="Próximo valor"><img src="<%= request.getContextPath() %>/imagens/botaoAvancar.svg" class="icone" id="icone-avancar" alt=""></button><div class="Valores"><ul class="lista-card" id="lista-card"><% String[] valores = {"atitude-de-dono", "determinacao", "disciplina", "disponibilidade", "franqueza", "humilde", "simplicidade"}; for (String valor : valores) { %><li class="card"><img src="<%= request.getContextPath() %>/imagens/<%= valor %>.svg" id="<%= valor %>" alt="Valor Delta: <%= valor %>"></li><% } %></ul></div></div>

    <a href="<%= request.getContextPath() %>/cadastro"><div class="retangulo-comecar-parte-final"></div></a><img src="<%= request.getContextPath() %>/imagens/parteFinal.svg" id="ParteFinal" alt="Comece agora">
    <%-- Bloco da página: rodapé. --%>
    <footer class="Footer"><img src="<%= request.getContextPath() %>/imagens/footer.svg" id="footer" alt=""><img src="<%= request.getContextPath() %>/imagens/logoFooter.svg" id="logo" alt="Delta"><p class="textoFooter">Transformando dados em economia com<br>monitoramento inteligente de água em<br>tempo real.</p>
        <ul class="coluna1"><h3>Navegações</h3><li><a href="#topico1">Início</a></li><li><a href="#topico2">Conceito</a></li><li><a href="#topico3">Objetivos</a></li><li><a href="#topico4">Funcionalidades</a></li><li><a href="#topico5">Sobre nós</a></li><li><a href="#topico6">Nossos Valores</a></li></ul>
        <ul class="coluna2"><h3>Contato</h3><li><a href="mailto:delta.app.oficial@gmail.com">delta.app.oficial@gmail.com</a></li></ul>
        <ul class="coluna3"><h3>Documentos</h3><li><a href="<%= request.getContextPath() %>/Termos.jsp">Termos de uso</a></li><li><a href="<%= request.getContextPath() %>/PoliticaPrivacidade.jsp">Política de privacidade</a></li></ul>
        <p class="direitos">© 2026 Projeto Delta. Todos os direitos reservados.</p>
    </footer>
</body>
</html>

