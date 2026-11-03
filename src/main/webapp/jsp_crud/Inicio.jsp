
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
  private String escapeSidebarName(Object value) {
    if (value == null) return "";
    return String.valueOf(value)
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
  }
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

  <meta charset="UTF-8">
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">

  <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

  <title>Delta - Início</title>

  <link rel="preconnect"
        href="https://fonts.googleapis.com">

  <link rel="preconnect"
        href="https://fonts.gstatic.com"
        crossorigin>

  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
        rel="stylesheet">

  <link rel="stylesheet"
        href="<%= request.getContextPath() %>/css/css_crud/Inicio.css?v=20261101-sidebar-gota-2">

  <script src="https://unpkg.com/lucide@latest"></script>

</head>

<body>

<!-- MENU LATERAL -->

<aside class="sidebar">

  <div class="logo-area">

    <img src="<%= request.getContextPath() %>/imagens/LogoDelta.png"
         alt="Logo Delta"
         id="logo">

  </div>

  <img class="sidebar-drop" src="<%= request.getContextPath() %>/imagens/Gota_Sidebar.png" alt="">

  <nav class="menu">

    <a href="<%= request.getContextPath() %>/inicio"
       class="menu-item active">
      Início
    </a>

    <a href="<%= request.getContextPath() %>/user"
       class="menu-item">
      Usuários
    </a>

    <a href="<%= request.getContextPath() %>/region"
       class="menu-item">
      Região
    </a>

    <a href="<%= request.getContextPath() %>/regionrate"
       class="menu-item">
      Taxa Regional
    </a>

    <a href="<%= request.getContextPath() %>/property"
       class="menu-item">
      Propriedades
    </a>

    <a href="<%= request.getContextPath() %>/device"
       class="menu-item">
      Dispositivos
    </a>

    <a href="<%= request.getContextPath() %>/address"
       class="menu-item">
      Endereço
    </a>

  </nav>

  <div class="sidebar-bottom">

    <div class="account">

      <div class="avatar">
        <i data-lucide="user"></i>
      </div>

      <span><%= escapeSidebarName(session.getAttribute("authName")) %></span>

    </div>

    <a href="<%= request.getContextPath() %>/auth/logout"
       class="logout">

      <i data-lucide="log-out"></i>

      <span>Sair</span>

    </a>

  </div>

</aside>

<!-- CONTEÚDO -->

<main class="main">

  <!-- CABEÇALHO -->

  <header class="page-header">
    <div class="page-heading">
      <h1>Início</h1>
      <p>Acesso aos registros e dados do sistema</p>
    </div>
    <img class="header-drop" src="<%= request.getContextPath() %>/imagens/GotaDelta_inicio.png" alt="Mascote Delta">
  </header>

  <div class="divider"></div>

  <!-- ESTATÍSTICAS -->

  <section class="stats">

    <article class="stat-card"><strong data-count="users"><%= request.getAttribute("totalUsers") %></strong><span>Usuários<br>cadastrados</span></article>
    <article class="stat-card"><strong data-count="properties"><%= request.getAttribute("totalProperties") %></strong><span>Propriedades<br>cadastradas</span></article>
    <article class="stat-card"><strong data-count="devices"><%= request.getAttribute("totalDevices") %></strong><span>Dispositivos<br>cadastrados</span></article>
    <article class="stat-card"><strong data-count="regions"><%= request.getAttribute("totalRegions") %></strong><span>Regiões<br>cadastradas</span></article>

  </section>

  <!-- ACESSO RÁPIDO -->

  <section class="quick-access">

    <div class="section-title">

      <h2>
        Acesso rápido
      </h2>

      <p>
        Acesse diretamente cada tabela do sistema.
      </p>

    </div>

    <div class="quick-grid">

      <!-- USUÁRIOS -->

      <a href="<%= request.getContextPath() %>/user"
         class="quick-card">

        <div class="quick-icon">
          <i data-lucide="users"></i>
        </div>

        <div class="quick-text">

          <h3>
            Usuários
          </h3>

          <p>
            Registros e Dados dos Usuários
          </p>

        </div>

        <i class="arrow"
           data-lucide="arrow-right">
        </i>

      </a>

      <article class="overview-card">
        <div class="overview-heading"><div class="quick-icon"><i data-lucide="droplet"></i></div><div><h3>Visão geral do sistema</h3><p>Total de cadastros por tabela</p></div></div>
        <div class="chart">
          <svg id="dashboard-chart" viewBox="0 0 640 320"
               data-users="<%= request.getAttribute("totalUsers") %>"
               data-properties="<%= request.getAttribute("totalProperties") %>"
               data-devices="<%= request.getAttribute("totalDevices") %>"
               data-regions="<%= request.getAttribute("totalRegions") %>"
               role="img" aria-label="Quantidade de registros cadastrados por tabela"></svg>
        </div>
      </article>

      <!-- REGIÃO -->

      <a href="<%= request.getContextPath() %>/region"
         class="quick-card">

        <div class="quick-icon">
          <i data-lucide="map-pin"></i>
        </div>

        <div class="quick-text">

          <h3>
            Região
          </h3>

          <p>
            Registros e Dados das Regiões
          </p>

        </div>

        <i class="arrow"
           data-lucide="arrow-right">
        </i>

      </a>

      <!-- TAXA REGIONAL -->

      <a href="<%= request.getContextPath() %>/regionrate"
         class="quick-card">

        <div class="quick-icon">
          <i data-lucide="circle-dollar-sign"></i>
        </div>

        <div class="quick-text">

          <h3>
            Taxa Regional
          </h3>

          <p>
            Registros e Valores das Taxas Regionais
          </p>

        </div>

        <i class="arrow"
           data-lucide="arrow-right">
        </i>

      </a>

      <!-- PROPRIEDADES -->

      <a href="<%= request.getContextPath() %>/property"
         class="quick-card">

        <div class="quick-icon">
          <i data-lucide="house"></i>
        </div>

        <div class="quick-text">

          <h3>
            Propriedades
          </h3>

          <p>
            Registros e Dados das Propriedades
          </p>

        </div>

        <i class="arrow"
           data-lucide="arrow-right">
        </i>

      </a>

      <!-- DISPOSITIVOS -->

      <a href="<%= request.getContextPath() %>/device"
         class="quick-card">

        <div class="quick-icon">
          <i data-lucide="settings-2"></i>
        </div>

        <div class="quick-text">

          <h3>
            Dispositivos
          </h3>

          <p>
            Registros e Dados dos Dispositivos
          </p>

        </div>

        <i class="arrow"
           data-lucide="arrow-right">
        </i>

      </a>

      <!-- ENDEREÇOS -->

      <a href="<%= request.getContextPath() %>/address"
         class="quick-card">

        <div class="quick-icon">
          <i data-lucide="map-pin-house"></i>
        </div>

        <div class="quick-text">

          <h3>
            Endereços
          </h3>

          <p>
            Registros e Dados dos Endereços
          </p>

        </div>

        <i class="arrow"
           data-lucide="arrow-right">
        </i>

      </a>

    </div>

  </section>

</main>

<script>
  if (window.lucide) lucide.createIcons();
  (() => {
    const svg = document.getElementById('dashboard-chart');
    if (!svg) return;

    const namespace = 'http://www.w3.org/2000/svg';
    const make = (tag, attributes = {}, text = '') => {
      const node = document.createElementNS(namespace, tag);
      Object.entries(attributes).forEach(([name, value]) => node.setAttribute(name, value));
      if (text) node.textContent = text;
      svg.appendChild(node);
      return node;
    };
    const data = [
      {key: 'users', label: ['Usuários', 'cadastrados'], color: '#252b66'},
      {key: 'properties', label: ['Propriedades', 'cadastradas'], color: '#30389b'},
      {key: 'devices', label: ['Dispositivos', 'cadastrados'], color: '#416ee8'},
      {key: 'regions', label: ['Regiões', 'cadastradas'], color: '#24b6e8'}
    ].map(item => {
      const parsed = Number(svg.dataset[item.key]);
      return {...item, value: Number.isFinite(parsed) ? Math.max(0, parsed) : 0};
    });

    const largest = Math.max(0, ...data.map(item => item.value));
    const maximum = Math.max(50, Math.ceil(largest / 50) * 50);
    const left = 58, right = 630, top = 20, baseline = 246;
    const plotHeight = baseline - top;
    const groupWidth = (right - left) / data.length;

    for (let tick = 5; tick >= 0; tick--) {
      const y = top + plotHeight * (5 - tick) / 5;
      make('line', {x1: left, x2: right, y1: y, y2: y, stroke: '#e5e8f0', 'stroke-width': 1});
      make('text', {x: left - 10, y: y + 4, 'text-anchor': 'end', fill: '#747b8b', 'font-size': 12}, String(Math.round(maximum * tick / 5)));
    }

    make('line', {x1: left, x2: right, y1: baseline, y2: baseline, stroke: '#cfd3df', 'stroke-width': 1});
    data.forEach((item, index) => {
      const center = left + groupWidth * (index + 0.5);
      const barWidth = Math.min(58, groupWidth * 0.48);
      const height = item.value / maximum * plotHeight;
      const y = baseline - height;
      make('rect', {x: center - barWidth / 2, y: top, width: barWidth, height: plotHeight, rx: 9, fill: '#f1f3fa'});
      if (height > 0) make('rect', {x: center - barWidth / 2, y, width: barWidth, height, rx: 9, fill: item.color});
      make('text', {x: center, y: Math.max(top + 14, y - 8), 'text-anchor': 'middle', fill: '#30389b', 'font-size': 15, 'font-weight': 700}, String(item.value));
      const label = make('text', {x: center, y: baseline + 24, 'text-anchor': 'middle', fill: '#292c36', 'font-size': 11});
      item.label.forEach((line, lineIndex) => {
        const span = document.createElementNS(namespace, 'tspan');
        span.setAttribute('x', center);
        span.setAttribute('dy', lineIndex === 0 ? 0 : 14);
        span.textContent = line;
        label.appendChild(span);
      });
    });
  })();
</script>

</body>

</html>
