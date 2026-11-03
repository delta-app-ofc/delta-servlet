<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <% if (session.getAttribute("authUserId") == null || Boolean.TRUE.equals(session.getAttribute("authIsAdmin")) || Boolean.TRUE.equals(session.getAttribute("authIsManager"))) { response.sendRedirect(request.getContextPath() + "/login?role=user"); return; }
       String accountName = String.valueOf(session.getAttribute("authName") == null ? "" : session.getAttribute("authName"));
       String accountEmail = String.valueOf(session.getAttribute("authEmail") == null ? "" : session.getAttribute("authEmail"));
       String safeAccountName = accountName.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;");
       String safeAccountEmail = accountEmail.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;"); %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Site Delta</title>
    <script>
        try {
            if (sessionStorage.getItem('vindoDaIntro')) {
                sessionStorage.removeItem('vindoDaIntro');
                document.documentElement.classList.add('vem-da-intro');
                setTimeout(function () {
                    document.documentElement.classList.remove('vem-da-intro', 'intro-pronta');
                    var ponte = document.querySelector('.ponte');
                    if (ponte) ponte.remove();
                }, 4000);
            }
        } catch (e) {}
    </script>
    <link rel="preload" as="font" type="font/otf" href="<%= request.getContextPath() %>/fontes/talina-demo.regular.otf" crossorigin>
    <link rel="preload" as="image" href="<%= request.getContextPath() %>/imagens/triangulo.svg">
    <link rel="preload" as="image" href="<%= request.getContextPath() %>/imagens/gota.svg">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/LaddingLogin.css?v=20261102-33">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/LaddingResponsive.css?v=20261102-33">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/css_login%20e%20cadastro/TransicaoIntro.css">
    <style>
        @font-face { font-family: 'Talina DEMO'; src: url('<%= request.getContextPath() %>/fontes/talina-demo.regular.otf') format('opentype'); font-weight: normal; font-style: normal; font-display: swap; }
    </style>
    <script>window.deltaContextPath = '<%= request.getContextPath() %>';</script>
    <script defer src="<%= request.getContextPath() %>/js/script-landing-login.js?v=20261102-2"></script>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
</head>
<body>
    <div class="ponte" aria-hidden="true"><div class="pm-marca"><div class="pm-texto">DELT</div><div class="pm-logo"><div class="pm-triangulo"></div><div class="pm-gota"></div></div></div></div>
    <div class="barra-fixa">
        <a href="#topico1" class="botao-topo"><div class="botao-logo"><p class="Delta">DELT</p><img src="<%= request.getContextPath() %>/imagens/LogoDelta.svg" id="LogoDelta" alt="Logo Delta"></div></a>
        <button class="botao-menu" id="botao-menu" type="button" aria-label="Abrir menu de navegação" aria-expanded="false" aria-controls="menu-navegacao"><span></span><span></span><span></span></button>
        <nav class="menu-navegacao" id="menu-navegacao" aria-label="Navegação da página">
            <a href="#topico1">Início</a><a href="#topico2">Conceito</a><a href="#topico3">Objetivos</a><a href="#topico4">Funcionalidades</a><a href="#topico5">Sobre nós</a><a href="#topico6">Nossos valores</a>
        </nav>
        <div class="auth-acoes">
            <a href="<%= request.getContextPath() %>/login">Entrar</a>
            <a class="acao-cadastrar" href="<%= request.getContextPath() %>/cadastro">Cadastrar</a>
        </div>
        <button id="minha-conta" class="minha-conta" type="button" aria-haspopup="dialog" aria-controls="modal" aria-expanded="false">Minha Conta</button>
        <p class="Inicio"><a href="#topico1">Início</a></p><p class="Conceito"><a href="#topico2">Conceito</a></p><p class="Objetivos"><a href="#topico3">Objetivos</a></p><p class="Funcionalidades"><a href="#topico4">Funcionalidades</a></p><p class="Sobre_Nos"><a href="#topico5">Sobre nós</a></p><p class="valores"><a href="#topico6">Nossos Valores</a></p>
    </div>

    <div id="fade" class="hide"></div>
    <section id="modal" class="hide" role="dialog" aria-modal="true" aria-label="Minha conta">
        <button id="close-modal" type="button" aria-label="Fechar">&times;</button>
        <img id="modal-svg" src="<%= request.getContextPath() %>/imagens/Configura%C3%A7%C3%B5es%20-%20Perfil.svg" alt="Configurações da conta: perfil">
        <div class="titulo-minha-conta">Minha conta</div>
        <div class="retangulo-modal"></div>
        <nav class="subtitulos-modal" aria-label="Configurações da conta">
            <div class="indicador"></div>
            <p class="topico active" data-secao="subtitulo-perfil" role="button" tabindex="0">Perfil</p>
            <p class="topico" data-secao="subtitulo-seguranca" role="button" tabindex="0">Segurança</p>
            <p class="topico" data-secao="subtitulo-notificacoes" role="button" tabindex="0">Notificações</p>
            <p id="borda"></p>
            <p class="sair-da-conta" id="sair-da-conta" role="button" tabindex="0" style="position: relative; z-index: 3;">Sair da conta</p>
            <img src="<%= request.getContextPath() %>/imagens/lixeira.svg" class="lixeira" alt="">
        </nav>
        <div class="conteudo">
            <section class="secao" id="secao-perfil">
                <h2 class="titulo-config">Perfil</h2>
                <div class="modal-body" id="modal-body-perfil">
                    <p>Gerencie suas informações pessoais e dados cadastrais.</p>
                    <form id="config-perfil">
                        <p class="nome-modal" id="rotulo-nome">Nome</p>
                        <input type="text" id="nome" name="name" aria-labelledby="rotulo-nome" value="<%= safeAccountName %>" required maxlength="100">
                        <p class="email-modal" id="rotulo-email">Email</p>
                        <input type="email" id="email" name="email" aria-labelledby="rotulo-email" value="<%= safeAccountEmail %>" required maxlength="100">
                        <button type="submit" class="salvar">Salvar alterações</button>
                        <p id="perfil-status" role="status" hidden></p>
                    </form>
                </div>
            </section>

            <section class="secao" id="secao-seguranca" style="display: none;">
                <h2 class="titulo-seguranca">Segurança</h2>
                <div class="modal-body" id="modal-body-seguranca">
                    <p>Gerencie suas credenciais e os métodos de acesso à sua conta.</p>
                    <form id="form-seguranca">
                        <p class="senha-nova-modal" id="rotulo-senha-nova">Digite sua senha nova</p>
                        <div class="campo-senha-config">
                            <input type="password" id="senha-nova" name="password" aria-labelledby="rotulo-senha-nova" minlength="8" pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}" title="Use ao menos 8 caracteres, com letra maiúscula, minúscula, número e caractere especial." required>
                            <button type="button" id="botaoOlho" aria-label="Alternar visibilidade da senha"><img id="iconeOlho" src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" alt=""></button>
                        </div>
                        <ul class="regras-senha regras-senha-seguranca" aria-label="Requisitos da senha">
                            <li data-regra="tamanho">Pelo menos 8 caracteres</li>
                            <li data-regra="letras">Uma letra maiúscula e minúscula</li>
                            <li data-regra="numero-simbolo">Um número e caractere especial</li>
                        </ul>
                        <p class="confirmar-senha-nova-modal" id="rotulo-confirmar-senha">Confirmar senha nova</p>
                        <div class="campo-senha-config">
                            <input type="password" id="confirmar-senha-nova" aria-labelledby="rotulo-confirmar-senha" minlength="8" required>
                            <button type="button" id="botaoOlho1" aria-label="Alternar visibilidade da confirmação"><img id="iconeOlho1" src="<%= request.getContextPath() %>/imagens/olho-fechado.svg" alt=""></button>
                        </div>
                        <button type="submit" class="salvar-senha">Salvar alterações</button>
                        <p id="seguranca-status" role="status" hidden></p>
                    </form>
                </div>
            </section>

            <section class="secao" id="secao-notificacoes" style="display: none;">
                <h2 class="titulo-notificacoes">Notificações</h2>
                <div class="modal-body" id="modal-body-notificacoes">
                    <p>Escolha quais novidades, estudos e comunicados você deseja receber por e-mail.</p>
                </div>
                <p class="subtitulo-email">Email cadastrado</p>
                <p class="email-cadastrado"><%= safeAccountEmail %></p>
                <p class="tipos-not">Tipos de conteúdo e comunicação</p>
                <p class="texto-not">Selecione os assuntos do seu interesse</p>
                <div class="container-caixas">
                    <div class="linha">
                        <input type="checkbox" id="relatorio" name="relatorio">
                        <label for="relatorio">Relatórios e Estudos sobre Gestão Hídrica:<br>Artigos, pesquisas e cases sobre sustentabilidade e consumo.</label>
                    </div>
                    <div class="linha">
                        <input type="checkbox" id="novidade" name="novidade">
                        <label for="novidade">Novidades do Projeto e Lançamentos:<br>Avisos em primeira mão sobre novas funções da plataforma.</label>
                    </div>
                    <div class="linha">
                        <input type="checkbox" id="evento" name="evento">
                        <label for="evento">Convites para Webinars e Eventos:<br>Alertas sobre apresentações ao vivo e discussões técnicas.</label>
                    </div>
                </div>
                <button type="button" class="salvar-not">Salvar alterações</button>
                <p id="notificacoes-status" role="status" hidden></p>
            </section>
        </div>
        <p id="conta-status" role="status"></p>
    </section>
    <div id="popup-salvo" class="popup-salvo" role="status" aria-live="polite" hidden>
        <span class="popup-salvo-icone" aria-hidden="true">✓</span>
        <span id="popup-salvo-mensagem">Informações salvas com sucesso!</span>
        <button id="fechar-popup-salvo" type="button" aria-label="Fechar confirmação">×</button>
    </div>    <div id="fade-confirmar" class="hide" style="z-index: 2190;"></div>
    <div id="modal-confirmar" class="hide" role="alertdialog" aria-labelledby="titulo-confirmar" aria-modal="true" style="z-index: 2200;">
        <button id="close-modal-confirmar" type="button" aria-label="Fechar">×</button>
        <div class="icone-confirmar" aria-hidden="true"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3 2 20h20L12 3z"/><path d="M12 10v4M12 17.5v.01"/></svg></div>
        <div class="texto-confirmar"><h3 id="titulo-confirmar">Alterações não salvas</h3><p>Você fez mudanças que ainda não foram salvas. Se fechar agora, elas serão perdidas.</p><p id="status-confirmar-salvamento" role="status" hidden></p></div>
        <div class="botoes-confirmar"><button id="botao-descartar" type="button">Descartar</button><button id="botao-continuar" type="button">Continuar editando</button><button id="botao-salvar-fechar" type="button">Salvar alterações</button></div>
    </div>
    <div id="fade-menor" class="hide"></div>
    <div id="modal-menor" class="hide" role="dialog" aria-modal="true" aria-label="Sair da conta">
        <button id="close-modal-menor" type="button" aria-label="Fechar">&times;</button>
        <div class="conteudo-modal-menor">
            <p class="sair-conta-titulo">Sair da sua conta?</p>
            <p class="texto-sair">Você precisará fazer login novamente para acessar a plataforma.</p>
            <div class="fundo-vermelho"></div>
            <p class="excluir">Deseja encerrar permanentemente?</p>
            <p class="texto-excluir">Se você quer apagar todos os seus dados, você pode<br>
                <a href="#" id="excluir-conta"><u><strong>Excluir minha conta definitivamente</strong></u></a>
            </p>
            <p id="excluir-conta-status" role="status"></p>
            <button id="botao-cancelar" class="botao-cancelar" type="button">Cancelar</button>
            <a href="<%= request.getContextPath() %>/auth/logout?return=landing" id="botao-sair" class="botao-sair" onclick="event.stopImmediatePropagation();">Sair</a>
        </div>
    </div>
    <div id="fade-excluir-conta" class="hide"></div>
    <div id="modal-excluir-conta" class="hide" role="alertdialog" aria-modal="true" aria-labelledby="titulo-excluir-conta" aria-describedby="texto-confirmar-exclusao">
        <button id="fechar-confirmar-exclusao" type="button" aria-label="Fechar">&times;</button>
        <div class="icone-confirmar-exclusao" aria-hidden="true"><svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3 2.5 20h19L12 3z"/><path d="M12 9v5m0 3h.01"/></svg></div>
        <h2 id="titulo-excluir-conta">Atenção</h2>
        <p id="texto-confirmar-exclusao">Deseja excluir permanentemente esta conta e os dados locais associados?</p>
        <p id="erro-confirmar-exclusao" role="alert"></p>
        <div class="botoes-confirmar-exclusao"><button id="botao-confirmar-exclusao" type="button">Excluir</button><button id="botao-cancelar-exclusao" type="button">Cancelar</button></div>
    </div>
    <div class="FundoGradiente" id="topico1"></div>
    <p class="titulo1">CADA GOTA</p><p class="tituloPrincipal">INTELIGENTEMENTE</p><p class="titulo2">CONTROLADA</p>
    <img src="<%= request.getContextPath() %>/imagens/LogoTransparente.svg" id="LogoTransparente" alt="Delta">
    <p class="Texto">Monitore, preveja e reduza o consumo de água da sua residência com inteligência artificial. Tudo em tempo real, no seu celular.</p>
    <a href="<%= request.getContextPath() %>/cadastro"><div class="retanguloComecar"><div id="textoComecar">Começe agora!</div></div></a>

    <div class="carta1"><div class="conteudoCarta1"><div class="Numero"><span class="menos">-</span><span class="numero">35</span><span class="porcentagem">%</span></div><p class="textoCarta1">Redução média no consumo pós<br>3 meses de uso da plataforma</p></div></div>
    <div class="carta2"><div class="conteudoCarta2"><div class="horas"><span class="numero">24</span><span class="porcentagem">h</span></div><p class="textoCarta2">Monitoramento contínuo com<br>alertas instantâneos no celular</p></div></div>
    <div class="carta3"><div class="conteudoCarta3"><div class="Numero2"><span class="mais">+</span><span class="numero2">5</span></div><p class="textoCarta3">Funcionalidades de análise,<br>previsão e alertas automáticos</p></div></div>

    <div class="delta-section"><img src="<%= request.getContextPath() %>/imagens/FundoOndaGradiente.svg" id="FundoAzulOndaGradiente" alt=""><div class="O-Delta">O DELTA</div><div class="textoDelta">O Projeto Delta é uma solução inteligente que conecta<br>dispositivos IoT diretamente ao seu hidrômetro para<br>monitorar o consumo de água em tempo real.<br>Usando inteligência artificial, o sistema prevê seus<br>custos futuros, envia alertas automáticos e detecta<br>vazamentos ocultos antes que gerem prejuízo, tudo<br>acessível na palma da sua mão.</div><div class="Iphone"><img src="<%= request.getContextPath() %>/imagens/IphoneAPP.svg" alt="Aplicativo Delta"></div></div>

    <div class="concept-section"><img src="<%= request.getContextPath() %>/imagens/FundoAzulClaroOnda.svg" class="FundoAzulClaroOnda" alt=""><p class="tituloConceito" id="topico2">CONCEITO</p><div class="retanguloCenario"><p class="miniTituloCenario">Cenário</p></div><div class="retanguloSolucao"><p class="miniTituloSolucao">Solução</p></div><div class="retanguloCenario2"><p class="conteudoCenario">A água é um recurso de extrema importância e que deve ter um controle inteligente. O nosso sistema oferece o monitoramento do consumo e permite com que você tome decisões melhores, contribuindo para a economia de água.</p></div><div class="retanguloSolucao2"><p class="conteudoSolucao">Diante dos problemas, o sistema proposto oferece monitoramento em tempo real, análise inteligente dos dados e atuação direta sobre o fluxo de água. Com isso, o usuário passa a ter controle total sobre o consumo.</p></div></div>

    <div class="objective-section"><img src="<%= request.getContextPath() %>/imagens/FundoAzulCurvadoGradiente.svg" id="FundoAzulCurvado" alt=""><p class="tituloObjetivos" id="topico3">OBJETIVOS</p>
        <div class="cartaoReducao"><img src="<%= request.getContextPath() %>/imagens/Hidrometro.svg" id="hidrometro" alt=""><p class="tituloReducao">Redução de Consumo</p><p class="informacoesReducao">• Reduzir o consumo excessivo de água;<br>• Identificar vazamentos e falhas rapidamente;<br>• Melhorar o controle operacional da rede hidráulica;<br>• Automatizar processos relacionados ao fluxo de água.</p></div>
        <div class="cartaoMonitoramento"><img src="<%= request.getContextPath() %>/imagens/Monitoramento.svg" id="monitoramento" alt=""><p class="tituloMonitoramento">Monitoramento inteligente</p><p class="informacoesMonitoramento">•Permitir monitoramento em tempo real;<br>•Facilitar a tomada de decisão através de dashboards e indicadores;<br>•Integrar sustentabilidade e tecnologia dentro da operação industrial;<br>•Contribuir para práticas alinhadas à ODS 12.</p></div>
        <div class="cartaoEficiencia"><img src="<%= request.getContextPath() %>/imagens/Eficiencia.svg" id="eficiencia" alt=""><p class="tituloEficiencia">Eficiência e sustentabilidade</p><p class="informacoesEficiencia">•Aumentar o reaproveitamento hídrico;<br>•Melhorar a eficiência dos processos industriais;<br>•Reduzir desperdícios e custos operacionais;<br>•Gerar relatórios e análises estratégicas.</p></div>
    </div>

    <div class="functionality-section"><img src="<%= request.getContextPath() %>/imagens/FundoAzulClaroOnda2.svg" id="FundoAzulClaroOnda2" alt=""><p class="tituloFuncionalidades" id="topico4">FUNCIONALIDADES</p>
        <div class="cartao1"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame1" alt=""><img src="<%= request.getContextPath() %>/imagens/relogio.svg" id="relogio" alt=""><p class="tituloCardMonitoramento">Monitoramento em tempo real</p><p class="informacoesCardMonitoramento">Acompanhe seu consumo a<br> qualquer momento.</p></div>
        <div class="cartao2"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame2" alt=""><img src="<%= request.getContextPath() %>/imagens/sino.svg" id="sino" alt=""><p class="tituloCardAlerta">Alertas inteligentes</p><p class="informacoesCardAlerta">Receba notificações de vazamentos<br> e consumos anormais.</p></div>
        <div class="cartao3"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame3" alt=""><img src="<%= request.getContextPath() %>/imagens/grafico.svg" id="grafico" alt=""><p class="tituloCardPrevisao">Previsão de consumo e gastos</p><p class="informacoesCardPrevisao">Veja a projeção do seu consumo e<br> do valor da conta.</p></div>
        <div class="cartao4"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame4" alt=""><img src="<%= request.getContextPath() %>/imagens/lista.svg" id="lista" alt=""><p class="tituloCardMetas">Metas personalizadas</p><p class="informacoesCardMetas">Defina metas de consumo e<br> acompanhe seu progresso.</p></div>
        <div class="cartao5"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame5" alt=""><img src="<%= request.getContextPath() %>/imagens/robo.svg" id="robo" alt=""><p class="tituloCardChatbot">Chatbot inteligente</p><p class="informacoesCardChatbot">Tire dúvidas e receba orientações<br> em linguagem natural.</p></div>
        <div class="cartao6"><img src="<%= request.getContextPath() %>/imagens/cartao-funcionalidade.svg" id="frame6" alt=""><img src="<%= request.getContextPath() %>/imagens/papel.svg" id="papel" alt=""><p class="tituloCardHistorico">Histórico completo</p><p class="informacoesCardHistorico">Consulte relatórios e histórico de<br> consumo detalhado.</p></div>
    </div>
<p class="tituloNossaEquipe">NOSSA EQUIPE</p>
    <section class="carrossel-section"><div class="carrossel"><div class="fotosCarrossel">
        <% String[] equipe = {"bruno", "gabriel", "lucas", "manuela", "pedro", "pietra", "ana", "davi", "joão", "mariana", "samuel"}; %>
        <div class="grupo"><% for (String pessoa : equipe) { %><div class="foto <%= "lucas".equals(pessoa) ? "foto-lucas" : "" %>" <%= "lucas".equals(pessoa) ? "id=\"lucas\"" : "" %>><img src="<%= request.getContextPath() %>/imagens/<%= pessoa %>.svg?v=20261102-22" <%= "lucas".equals(pessoa) ? "id=\"lucasFoto\"" : "" %> alt="Integrante da equipe"><% if ("lucas".equals(pessoa)) { %><div id="lucasTexto"><img src="<%= request.getContextPath() %>/imagens/lucasTexto.svg?v=20261102-22" alt=""></div><% } %></div><% } %></div>
        <div class="grupo" aria-hidden="true"><% for (String pessoa : equipe) { %><div class="foto <%= "lucas".equals(pessoa) ? "foto-lucas" : "" %>" <%= "lucas".equals(pessoa) ? "id=\"lucas\"" : "" %>><img src="<%= request.getContextPath() %>/imagens/<%= pessoa %>.svg?v=20261102-22" <%= "lucas".equals(pessoa) ? "id=\"lucasFoto\"" : "" %> alt=""><% if ("lucas".equals(pessoa)) { %><div id="lucasTexto"><img src="<%= request.getContextPath() %>/imagens/lucasTexto.svg?v=20261102-22" alt=""></div><% } %></div><% } %></div>
    </div></div></section>

    <div class="FundoAzulCurvadoGradiente"><img src="<%= request.getContextPath() %>/imagens/FundoCurvaGradiente.svg" id="fundoCurvadoGradiente" alt=""><p class="sobreNos" id="topico5">SOBRE NÓS</p><p class="textoSobreNos">Somos estudantes do Instituto J&amp;F, onde<br>aprendemos por meio da prática, do trabalho em<br>equipe e de projetos reais. Neste projeto, unimos<br>nossos conhecimentos para desenvolver uma<br>solução baseada no ODS 12, utilizando tecnologia<br>para promover o uso consciente da água e reduzir<br>desperdícios. Buscamos transformar o que<br>aprendemos em uma solução que possa gerar um<br>impacto positivo.</p><img src="<%= request.getContextPath() %>/imagens/bracoGlub.svg" id="bracoGlub" alt=""><img src="<%= request.getContextPath() %>/imagens/gotaMenor.svg" id="gotaMenor" alt=""><img src="<%= request.getContextPath() %>/imagens/gotaMaior.svg" id="gotaMaior" alt=""><img src="<%= request.getContextPath() %>/imagens/corpoGlub.svg" id="corpoGlub" alt=""></div>

    <p class="NossosValores" id="topico6">NOSSOS VALORES</p>
    <div class="card-section visivel"><button class="botao-voltar" id="botao-voltar" type="button" aria-label="Valor anterior"><img src="<%= request.getContextPath() %>/imagens/botaoVoltar.svg" class="icone" id="icone-voltar" alt=""></button><button class="botao-avancar" id="botao-avancar" type="button" aria-label="Próximo valor"><img src="<%= request.getContextPath() %>/imagens/botaoAvancar.svg" class="icone" id="icone-avancar" alt=""></button><div class="Valores"><ul class="lista-card" id="lista-card"><% String[] valores = {"atitude-de-dono", "determinacao", "disciplina", "disponibilidade", "franqueza", "humilde", "simplicidade"}; for (String valor : valores) { %><li class="card"><img src="<%= request.getContextPath() %>/imagens/<%= valor %>.svg" id="<%= valor %>" alt="Valor Delta: <%= valor %>"></li><% } %></ul></div></div>

    <a href="<%= request.getContextPath() %>/cadastro"><div class="retangulo-comecar-parte-final"></div></a><img src="<%= request.getContextPath() %>/imagens/parteFinal.svg" id="ParteFinal" alt="Comece agora">
    <div class="Footer"><img src="<%= request.getContextPath() %>/imagens/footer.svg" id="footer" alt=""><img src="<%= request.getContextPath() %>/imagens/logoFooter.svg" id="logo" alt="Delta"><p class="textoFooter">Transformando dados em economia com<br>monitoramento inteligente de água em<br>tempo real.</p>
        <ul class="coluna1"><h3>Navegações</h3><li><a href="#topico1">Início</a></li><li><a href="#topico2">Conceito</a></li><li><a href="#topico3">Objetivos</a></li><li><a href="#topico4">Funcionalidades</a></li><li><a href="#topico5">Sobre nós</a></li><li><a href="#topico6">Nossos Valores</a></li></ul>
        <ul class="coluna2"><h3>Contato</h3><li><a href="mailto:delta.app.oficial@gmail.com">delta.app.oficial@gmail.com</a></li></ul>
        <ul class="coluna3"><h3>Documentos</h3><li><a href="<%= request.getContextPath() %>/Termos.jsp">Termos de uso</a></li><li><a href="<%= request.getContextPath() %>/PoliticaPrivacidade.jsp">Política de privacidade</a></li></ul>
        <p class="direitos">© 2026 Projeto Delta. Todos os direitos reservados.</p>
    </div>
    <script>
        (() => {
            const raiz = '<%= request.getContextPath() %>';
            const alternarSenha = (botaoId, campoId, iconeId) => {
                const botao = document.getElementById(botaoId);
                const campo = document.getElementById(campoId);
                const icone = document.getElementById(iconeId);
                botao?.addEventListener('click', event => {
                    event.stopImmediatePropagation();
                    const mostrar = campo.type === 'password';
                    campo.type = mostrar ? 'text' : 'password';
                    icone.src = raiz + (mostrar ? '/imagens/olho-aberto.svg' : '/imagens/olho-fechado.svg');
                });
            };
            alternarSenha('botaoOlho', 'senha-nova', 'iconeOlho');
            alternarSenha('botaoOlho1', 'confirmar-senha-nova', 'iconeOlho1');
            document.querySelectorAll('.topico[role="button"]').forEach(tab => {
                tab.addEventListener('keydown', event => {
                    if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); tab.click(); }
                });
            });

            const modalSair = document.getElementById('modal-menor');
            const fadeSair = document.getElementById('fade-menor');
            const fecharSair = () => { modalSair?.classList.add('hide'); fadeSair?.classList.add('hide'); };
            const abrirSair = () => {
                modalSair?.classList.remove('hide');
                fadeSair?.classList.remove('hide');
            };
            document.getElementById('sair-da-conta')?.addEventListener('click', event => { event.stopImmediatePropagation(); abrirSair(); });
            document.getElementById('sair-da-conta')?.addEventListener('keydown', event => {
                if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); abrirSair(); }
            });
            const modalExcluir = document.getElementById('modal-excluir-conta');
            const fadeExcluir = document.getElementById('fade-excluir-conta');
            const fecharExcluir = () => { modalExcluir?.classList.add('hide'); fadeExcluir?.classList.add('hide'); };
            const abrirExcluir = event => {
                event.preventDefault();
                event.stopImmediatePropagation();
                modalExcluir?.classList.remove('hide');
                fadeExcluir?.classList.remove('hide');
            };
            document.getElementById('excluir-conta')?.addEventListener('click', abrirExcluir);
            [document.getElementById('fechar-confirmar-exclusao'), document.getElementById('botao-cancelar-exclusao'), fadeExcluir].forEach(botao => botao?.addEventListener('click', event => { event.stopImmediatePropagation(); fecharExcluir(); }));
            document.getElementById('botao-confirmar-exclusao')?.addEventListener('click', async event => {
                event.stopImmediatePropagation();
                const botao = event.currentTarget;
                const erro = document.getElementById('erro-confirmar-exclusao');
                botao.disabled = true;
                try {
                    const resposta = await fetch(raiz + '/account/profile', { method: 'DELETE', credentials: 'same-origin' });
                    if (!resposta.ok) throw new Error(await mensagemDeErro(resposta, 'Não foi possível excluir a conta.'));
                    window.location.assign(raiz + '/login');
                } catch (falha) {
                    erro.textContent = falha.message;
                    botao.disabled = false;
                }
            });
            document.getElementById('botao-cancelar')?.addEventListener('click', event => { event.stopImmediatePropagation(); fecharSair(); });
            document.getElementById('close-modal-menor')?.addEventListener('click', event => { event.stopImmediatePropagation(); fecharSair(); });
            fadeSair?.addEventListener('click', event => { event.stopImmediatePropagation(); fecharSair(); });

            const confirmacao = document.getElementById('modal-confirmar');
            const fadeConfirmacao = document.getElementById('fade-confirmar');
            const mostrarConfirmacao = () => {
                const status = document.getElementById('status-confirmar-salvamento');
                if (status) { status.textContent = ''; status.hidden = true; }
                confirmacao?.classList.remove('hide');
                fadeConfirmacao?.classList.remove('hide');
            };
            const esconderConfirmacao = () => {
                confirmacao?.classList.add('hide');
                fadeConfirmacao?.classList.add('hide');
            };
            const modalConta = document.getElementById('modal');
            const perfil = document.getElementById('config-perfil');
            const seguranca = document.getElementById('form-seguranca');
            const relatorio = document.getElementById('relatorio');
            const novidade = document.getElementById('novidade');
            const evento = document.getElementById('evento');
            const lerPerfil = () => ({ name: perfil.querySelector('[name="name"]').value, email: perfil.querySelector('[name="email"]').value });
            const lerSeguranca = () => ({ password: seguranca.querySelector('[name="password"]').value, confirmation: document.getElementById('confirmar-senha-nova').value });
            const lerNotificacoes = () => ({ reports: relatorio.checked, news: novidade.checked, events: evento.checked });
            let basePerfil = lerPerfil();
            let baseSeguranca = lerSeguranca();
            let baseNotificacoes = lerNotificacoes();
            let acaoPendente = null;
            const igual = (a, b) => Object.keys(a).every(key => a[key] === b[key]);
            const temAlteracoes = () => !igual(lerPerfil(), basePerfil) || !igual(lerSeguranca(), baseSeguranca) || !igual(lerNotificacoes(), baseNotificacoes);

            const atualizarBaseNotificacoes = async () => {
                try {
                    const response = await fetch(raiz + '/account/notifications', { credentials: 'same-origin' });
                    if (!response.ok) return;
                    const values = await response.json();
                    baseNotificacoes = { reports: Boolean(values.reports), news: Boolean(values.news), events: Boolean(values.events) };
                    relatorio.checked = baseNotificacoes.reports;
                    novidade.checked = baseNotificacoes.news;
                    evento.checked = baseNotificacoes.events;
                } catch (_) {}
            };
            document.getElementById('minha-conta')?.addEventListener('click', atualizarBaseNotificacoes);

            const popupFeedback = document.getElementById('popup-salvo');
            const mensagemPopupFeedback = document.getElementById('popup-salvo-mensagem');
            let timerPopupFeedback;
            const mostrarFeedback = mensagem => {
                const statusConfirmacao = document.getElementById('status-confirmar-salvamento');
                const modalConfirmacao = document.getElementById('modal-confirmar');
                if (statusConfirmacao && modalConfirmacao && !modalConfirmacao.classList.contains('hide')) {
                    statusConfirmacao.textContent = mensagem;
                    statusConfirmacao.hidden = false;
                }
                if (!popupFeedback) return;
                window.clearTimeout(timerPopupFeedback);
                mensagemPopupFeedback.textContent = mensagem;
                popupFeedback.hidden = false;
                popupFeedback.classList.add('visivel');
                timerPopupFeedback = window.setTimeout(() => {
                    popupFeedback.classList.remove('visivel');
                    popupFeedback.hidden = true;
                }, 3500);
            };
            const mensagemDeErro = async (response, fallback) => {
                const tipo = response.headers.get('content-type') || '';
                if (tipo.includes('text/html')) {
                    return response.status === 404
                        ? 'O servidor não encontrou o endpoint da conta (404). Reinicie ou reimplante a aplicação Delta_Back no Tomcat.'
                        : fallback;
                }
                const texto = (await response.text()).trim();
                return texto ? texto.slice(0, 400) : fallback;
            };
            const postar = async (path, values) => {
                const response = await fetch(raiz + path, {
                    method: 'POST', credentials: 'same-origin',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                    body: new URLSearchParams(values)
                });
                if (!response.ok) throw new Error(await mensagemDeErro(response, 'Não foi possível salvar as alterações.'));
            };
            const salvarPerfil = async () => {
                if (!perfil.reportValidity()) return false;
                const values = lerPerfil();
                try {
                    await postar('/account/profile', values);
                    basePerfil = values;
                    document.querySelectorAll('.email-cadastrado').forEach(item => { item.textContent = values.email; });
                    document.getElementById('perfil-status').textContent = ''; mostrarFeedback('Dados atualizados com sucesso.');
                    return true;
                } catch (error) { mostrarFeedback(error.message); return false; }
            };
            const salvarSeguranca = async () => {
                const password = seguranca.querySelector('[name="password"]').value;
                const confirmation = document.getElementById('confirmar-senha-nova');
                confirmation.setCustomValidity(password === confirmation.value ? '' : 'As senhas não coincidem.');
                if (!seguranca.reportValidity()) return false;
                try {
                    await postar('/account/password', { password });
                    seguranca.reset();
                    baseSeguranca = lerSeguranca();
                    document.getElementById('seguranca-status').textContent = ''; mostrarFeedback('Senha alterada com sucesso.');
                    return true;
                } catch (error) { mostrarFeedback(error.message); return false; }
            };
            const salvarNotificacoes = async () => {
                const values = lerNotificacoes();
                try {
                    await postar('/account/notifications', { reports: String(values.reports), news: String(values.news), events: String(values.events) });
                    baseNotificacoes = values;
                    document.getElementById('notificacoes-status').textContent = ''; mostrarFeedback('Preferências salvas no banco de dados.');
                    return true;
                } catch (error) { mostrarFeedback(error.message); return false; }
            };
            const salvarTudo = async () => {
                if (!igual(lerPerfil(), basePerfil) && !(await salvarPerfil())) return false;
                if (!igual(lerSeguranca(), baseSeguranca) && !(await salvarSeguranca())) return false;
                if (!igual(lerNotificacoes(), baseNotificacoes) && !(await salvarNotificacoes())) return false;
                return true;
            };

            perfil.addEventListener('submit', event => {
                event.preventDefault(); event.stopImmediatePropagation();
                salvarPerfil();
            }, true);
            seguranca.addEventListener('submit', event => {
                event.preventDefault(); event.stopImmediatePropagation();
                salvarSeguranca();
            }, true);
            document.querySelector('.salvar-not')?.addEventListener('click', event => {
                event.preventDefault(); event.stopImmediatePropagation();
                salvarNotificacoes();
            }, true);

            const continuarAcao = () => {
                const action = acaoPendente;
                acaoPendente = null;
                if (action?.type === 'close') fecharModalConta();
                if (action?.type === 'tab') action.target.click();
                if (action?.type === 'exit-prompt') abrirSair();
                if (action?.type === 'logout') window.location.assign(raiz + '/auth/logout?return=landing');
            };
            const reverterAlteracoes = () => {
                perfil.querySelector('[name="name"]').value = basePerfil.name;
                perfil.querySelector('[name="email"]').value = basePerfil.email;
                seguranca.querySelector('[name="password"]').value = baseSeguranca.password;
                document.getElementById('confirmar-senha-nova').value = baseSeguranca.confirmation;
                relatorio.checked = baseNotificacoes.reports;
                novidade.checked = baseNotificacoes.news;
                evento.checked = baseNotificacoes.events;
            };
            const fecharModalConta = () => {
                modalConta.querySelectorAll('input, textarea, select').forEach(campo => campo.setCustomValidity(''));
                modalConta.querySelectorAll('[role="status"]').forEach(status => { status.textContent = ''; status.hidden = true; });
                modalConta.classList.add('hide');
                document.getElementById('fade')?.classList.add('hide');
                document.getElementById('minha-conta')?.setAttribute('aria-expanded', 'false');
            };
            document.addEventListener('click', event => {
                const target = event.target;
                let action = null;
                if (target.closest('#close-modal') || target.id === 'fade') action = { type: 'close' };
                else if (target.matches('.topico[data-secao]') && !target.classList.contains('active')) action = { type: 'tab', target };
                else if (target.closest('#sair-da-conta')) action = { type: 'exit-prompt' };
                else if (target.closest('#botao-sair')) action = { type: 'logout' };
                if (!action) return;
                if (action.type === 'close') {
                    event.preventDefault();
                    event.stopImmediatePropagation();
                    if (temAlteracoes()) {
                        acaoPendente = action;
                        fecharSair();
                        mostrarConfirmacao();
                    } else {
                        fecharModalConta();
                    }
                    return;
                }
                if (!temAlteracoes()) return;
                event.preventDefault();
                event.stopImmediatePropagation();
                acaoPendente = action;
                fecharSair();
                mostrarConfirmacao();
            }, true);
            document.addEventListener('keydown', event => {
                if (event.key !== 'Escape') return;
                if (!confirmacao?.classList.contains('hide')) {
                    event.preventDefault(); event.stopImmediatePropagation();
                    esconderConfirmacao(); acaoPendente = null;
                } else if (modalConta && !modalConta.classList.contains('hide')) {
                    event.preventDefault(); event.stopImmediatePropagation();
                    if (temAlteracoes()) {
                        acaoPendente = { type: 'close' };
                        mostrarConfirmacao();
                    } else {
                        fecharModalConta();
                    }
                }
            }, true);
            const continuarEditando = () => { esconderConfirmacao(); acaoPendente = null; };
            document.getElementById('botao-continuar')?.addEventListener('click', event => { event.stopImmediatePropagation(); continuarEditando(); });
            document.getElementById('close-modal-confirmar')?.addEventListener('click', event => { event.stopImmediatePropagation(); continuarEditando(); });
            fadeConfirmacao?.addEventListener('click', event => { event.stopImmediatePropagation(); continuarEditando(); });
            document.getElementById('botao-descartar')?.addEventListener('click', event => {
                event.stopImmediatePropagation();
                reverterAlteracoes(); esconderConfirmacao(); continuarAcao();
            });
            document.getElementById('botao-salvar-fechar')?.addEventListener('click', async event => {
                event.stopImmediatePropagation();
                const button = document.getElementById('botao-salvar-fechar');
                button.disabled = true;
                const saved = await salvarTudo();
                button.disabled = false;
                if (saved) { esconderConfirmacao(); continuarAcao(); }
            });
        })();
    </script>
    <script src="<%= request.getContextPath() %>/js/transicao-intro.js"></script>
</body>
</html>









