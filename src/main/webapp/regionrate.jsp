
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.example.delta_back.model.Region_Rate" %>

<%!
    private String esc(Object value) {
        if (value == null) return "";

        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#039;");
    }
%>

<%
    List<Region_Rate> regionRates =
        (List<Region_Rate>) request.getAttribute("regionRate");

    if (regionRates == null) {
        regionRates = Collections.emptyList();
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Taxa Regional</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <link rel="stylesheet" href="<%= ctx %>/css/RegionRate.css">
    <link rel="stylesheet" href="<%= ctx %>/css/Pop-up.css">

    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body>

<aside class="sidebar">

    <div class="logo-area">
        <img
            src="<%= ctx %>/imagens/LogoDelta.png"
            alt="Logo Delta"
            id="logo"
        >
    </div>

    <nav class="menu">
        <a href="<%= ctx %>/index.jsp" class="menu-item">Início</a>
        <a href="<%= ctx %>/user" class="menu-item">Usuários</a>
        <a href="<%= ctx %>/region" class="menu-item">Região</a>
        <a href="<%= ctx %>/regionrate" class="menu-item active">Taxa Regional</a>
        <a href="<%= ctx %>/property" class="menu-item">Propriedades</a>
        <a href="<%= ctx %>/device" class="menu-item">Dispositivos</a>
        <a href="<%= ctx %>/address" class="menu-item">Endereço</a>
    </nav>

    <div class="sidebar-bottom">

        <div class="account">
            <div class="avatar">
                <i data-lucide="user"></i>
            </div>
            <span>admin123</span>
        </div>

        <a href="<%= ctx %>/inicio.jsp" class="logout">
            <i data-lucide="log-out"></i>
            <span>Sair</span>
        </a>

    </div>

</aside>

<main class="main">

    <section class="crud-page" id="crudPage">

        <header class="crud-header">

            <div class="crud-title">
                <h1>Taxa Regional</h1>
                <p>Registros e Valores das Taxas Regionais</p>
            </div>

            <div class="crud-header-right">
                <div class="crud-total">
                    <span>Total de Registros:</span>
                    <strong><%= regionRates.size() %></strong>
                </div>
            </div>

        </header>

        <div class="crud-toolbar">

            <div class="crud-search-area">

                <div class="crud-search">
                    <i data-lucide="search"></i>
                    <input
                        id="searchInput"
                        type="text"
                        placeholder="Buscar taxa regional"
                    >
                </div>

                <button
                    class="crud-filter"
                    type="button"
                    title="Filtro"
                >
                    <i data-lucide="funnel"></i>
                </button>

            </div>

            <button
                class="crud-add"
                type="button"
                onclick="startCreate()"
            >
                <i data-lucide="circle-plus"></i>
                Adicionar Taxa
            </button>

        </div>

        <div class="crud-table-wrap">

            <table class="crud-table">

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>ID da Região</th>
                        <th>Valor por m³</th>
                        <th>Início da Validade</th>
                        <th>Fim da Validade</th>
                        <th>Ações</th>
                    </tr>
                </thead>

                <tbody id="rateTableBody">

                <% if (regionRates.isEmpty()) { %>

                    <tr>
                        <td colspan="6" class="crud-empty">
                            Nenhuma taxa regional cadastrada.
                        </td>
                    </tr>

                <% } else {
                    for (Region_Rate rate : regionRates) {
                %>

                    <tr
                        data-id="<%= rate.getId() %>"
                        data-region-id="<%= rate.getRegionId() %>"
                        data-m3value="<%= esc(rate.getM3Value()) %>"
                        data-initial-validity="<%= esc(rate.getInitialValidity()) %>"
                        data-final-validity="<%= esc(rate.getFinalValidity()) %>"
                    >
                        <td><%= rate.getId() %></td>

                        <td><%= rate.getRegionId() %></td>

                        <td><%= esc(rate.getM3Value()) %></td>

                        <td><%= esc(rate.getInitialValidity()) %></td>

                        <td><%= esc(rate.getFinalValidity()) %></td>

                        <td class="crud-actions-cell">

                            <button
                                type="button"
                                class="crud-action"
                                onclick="editRecord(this)"
                                title="Editar"
                            >
                                <i data-lucide="pencil"></i>
                            </button>

                            <button
                                type="button"
                                class="crud-action delete"
                                onclick="deleteRecord(this)"
                                title="Excluir"
                            >
                                <i data-lucide="trash-2"></i>
                            </button>

                        </td>
                    </tr>

                <%  }
                   } %>

                </tbody>

            </table>

        </div>

    </section>

</main>

<!-- POP-UP -->

<div class="overlay" id="popupOverlay">

    <div class="popup">

        <button
            type="button"
            class="close"
            onclick="closePopup()"
        >×</button>

        <div class="popup-content" id="popupSuccess">

            <div class="popup-icon success-icon">✓</div>

            <span class="popup-tag" id="popupSuccessTag">Taxa Regional</span>

            <h2 id="popupSuccessTitle">Operação concluída!</h2>

            <p id="popupSuccessDesc">
                A operação foi realizada com sucesso.
            </p>

            <button
                type="button"
                class="popup-primary"
                onclick="closePopup()"
            >
                OK, Entendido
            </button>

            <button
                type="button"
                class="popup-secondary"
                onclick="closePopup()"
            >
                Voltar
            </button>

        </div>

        <div class="popup-content" id="popupDelete">

            <div class="popup-icon warning-icon">!</div>

            <span class="popup-tag danger-tag">Excluir Registro</span>

            <h2>Confirmar exclusão</h2>

            <p>Tem certeza de que deseja excluir esta taxa regional?</p>

            <div class="selected-record">
                <span>REGISTRO SELECIONADO</span>
                <strong id="deleteRecordLabel">ID #--</strong>
            </div>

            <div class="delete-actions">

                <button
                    type="button"
                    class="popup-secondary"
                    onclick="closePopup()"
                >
                    Cancelar
                </button>

                <button
                    type="button"
                    class="popup-danger"
                    id="confirmDeleteBtn"
                >
                    Confirmar Exclusão
                </button>

            </div>

        </div>

    </div>

</div>

<!-- TOAST -->

<div class="global-toast" id="globalToast">

    <div class="toast-symbol" id="toastSymbol">✓</div>

    <div>
        <strong id="toastTitle">Sucesso!</strong>
        <span id="toastMessage">Operação realizada com sucesso.</span>
    </div>

    <button type="button" onclick="hideToast()">×</button>

</div>

<script>
    const contextPath = "<%= ctx %>";

    let editingId = null;
    let recordToDelete = null;
    let reloadAfterPopup = false;

    lucide.createIcons();

    // Escapar valores inseridos no HTML pelo JavaScript
    function esc(value) {
        return String(value ?? "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    // Abrir formulário de cadastro
    function startCreate() {
        editingId = null;
        renderForm(null);
    }

    // Abrir formulário de edição
    function editRecord(button) {
        const row = button.closest("tr");

        if (!row) return;

        editingId = row.dataset.id;

        renderForm({
            id: row.dataset.id,
            regionId: row.dataset.regionId,
            m3value: row.dataset.m3value,
            initialValidity: normalizeDate(row.dataset.initialValidity),
            finalValidity: normalizeDate(row.dataset.finalValidity)
        });
    }

    // Normalizar datas para o formato exigido por input type=date
    function normalizeDate(value) {
        if (!value) return "";

        const date = String(value).trim();

        // Já está no formato yyyy-MM-dd
        if (/^\d{4}-\d{2}-\d{2}$/.test(date)) {
            return date;
        }

        // Converter dd/MM/yyyy para yyyy-MM-dd
        const brazilian = date.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);

        if (brazilian) {
            return brazilian[3] + "-" + brazilian[2] + "-" + brazilian[1];
        }

        return "";
    }

    // Montar formulário
    function renderForm(rate) {
        const editing = rate !== null;
        const page = document.getElementById("crudPage");

        page.innerHTML = `
            <section class="crud-form-page">

                <header class="crud-form-header">
                    <div>
                        <h1>${editing ? "Editar Taxa Regional" : "Adicionar Taxa Regional"}</h1>
                        <p>${editing ? "Atualize os dados da taxa" : "Preencha os dados para cadastrar uma nova taxa"}</p>
                    </div>
                </header>

                <div class="crud-form-card">

                    <h2 class="form-title">Dados da Taxa Regional</h2>

                    <form id="rateForm">

                        <div class="form-grid">

                            <div class="crud-field">
                                <label for="region_id">ID da Região</label>
                                <input
                                    type="number"
                                    id="region_id"
                                    name="region_id"
                                    min="1"
                                    required
                                    value="${editing ? esc(rate.regionId) : ""}"
                                >
                            </div>

                            <div class="crud-field">
                                <label for="m3value">Valor por m³</label>
                                <input
                                    type="number"
                                    id="m3value"
                                    name="m3value"
                                    min="0"
                                    step="0.01"
                                    required
                                    value="${editing ? esc(rate.m3value) : ""}"
                                >
                            </div>

                            <div class="crud-field">
                                <label for="initial_validity">Início da Validade</label>
                                <input
                                    type="date"
                                    id="initial_validity"
                                    name="initial_validity"
                                    required
                                    value="${editing ? esc(rate.initialValidity) : ""}"
                                >
                            </div>

                            <div class="crud-field">
                                <label for="final_validity">Fim da Validade</label>
                                <input
                                    type="date"
                                    id="final_validity"
                                    name="final_validity"
                                    required
                                    value="${editing ? esc(rate.finalValidity) : ""}"
                                >
                            </div>

                        </div>

                        <div class="crud-form-actions">

                            <button
                                type="button"
                                class="crud-cancel"
                                onclick="cancelForm()"
                            >
                                Cancelar
                            </button>

                            <button
                                type="submit"
                                class="crud-save"
                                id="saveButton"
                            >
                                ${editing ? "Salvar alterações" : "Cadastrar Taxa"}
                            </button>

                        </div>

                    </form>

                </div>

            </section>
        `;

        document.getElementById("rateForm")
            .addEventListener("submit", saveForm);

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    // Voltar para a tabela
    function cancelForm() {
        window.location.href = contextPath + "/regionrate";
    }

    // Salvar cadastro ou edição
    async function saveForm(event) {
        event.preventDefault();

        const form = document.getElementById("rateForm");

        if (!form.reportValidity()) return;

        const params = new URLSearchParams(new FormData(form));
        const editing = editingId !== null;

        if (editing) {
            params.set("id", editingId);
        }

        const button = document.getElementById("saveButton");
        button.disabled = true;
        button.textContent = "Salvando...";

        try {
            const url = contextPath + "/regionrate";

            const response = await fetch(
                editing ? url + "?" + params.toString() : url,
                {
                    method: editing ? "PUT" : "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                    },
                    body: params.toString()
                }
            );

            if (!response.ok) {
                const message = await response.text();
                console.error("Erro ao salvar taxa regional:", message);

                throw new Error(
                    "Não foi possível salvar a taxa regional. HTTP " +
                    response.status
                );
            }

            reloadAfterPopup = true;

            showPopup("success", {
                title: editing ? "Alterações salvas!" : "Cadastro concluído!",
                desc: editing
                    ? "Os dados da taxa regional foram atualizados com sucesso."
                    : "A nova taxa regional foi cadastrada com sucesso."
            });

            showToast(
                editing
                    ? "Taxa regional atualizada com sucesso."
                    : "Taxa regional cadastrada com sucesso.",
                editing ? "ALTERAÇÕES SALVAS" : "CADASTRO CONCLUÍDO",
                editing ? "edit" : "success"
            );

        } catch (error) {
            console.error(error);
            alert(error.message || "Ocorreu um erro ao salvar a taxa.");

            button.disabled = false;
            button.textContent = editing
                ? "Salvar alterações"
                : "Cadastrar Taxa";
        }
    }

    // Exibir pop-up
    function showPopup(type, data = {}) {
        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        if (type === "success") {
            document.getElementById("popupSuccessTitle").textContent =
                data.title || "Operação concluída!";

            document.getElementById("popupSuccessDesc").textContent =
                data.desc || "Ação realizada com sucesso.";

            document.getElementById("popupSuccessTag").textContent =
                "Taxa Regional";

            document.getElementById("popupSuccess").classList.add("active");
        }

        if (type === "delete") {
            document.getElementById("deleteRecordLabel").textContent =
                "ID #" + data.id;

            document.getElementById("popupDelete").classList.add("active");
        }

        document.getElementById("popupOverlay").classList.add("show");
        document.body.classList.add("locked");
    }

    // Fechar pop-up
    function closePopup() {
        document.getElementById("popupOverlay").classList.remove("show");
        document.body.classList.remove("locked");

        recordToDelete = null;

        if (reloadAfterPopup) {
            reloadAfterPopup = false;
            window.location.href = contextPath + "/regionrate";
        }
    }

    // Notificações
    function showToast(message, title = "Sucesso", type = "success") {
        const toast = document.getElementById("globalToast");

        toast.className = "global-toast show";

        if (type === "edit") toast.classList.add("toast-edit");
        if (type === "delete") toast.classList.add("toast-delete");

        document.getElementById("toastTitle").textContent = title;
        document.getElementById("toastMessage").textContent = message;

        document.getElementById("toastSymbol").textContent =
            type === "delete" ? "!" : "✓";

        setTimeout(hideToast, 4000);
    }

    function hideToast() {
        document.getElementById("globalToast").classList.remove("show");
    }

    // Excluir taxa regional
    function deleteRecord(button) {
        const row = button.closest("tr");

        if (!row) return;

        recordToDelete = row.dataset.id;

        showPopup("delete", { id: recordToDelete });

        document.getElementById("confirmDeleteBtn").onclick =
            async function () {
                if (recordToDelete === null) return;

                const id = recordToDelete;

                try {
                    const response = await fetch(
                        contextPath + "/regionrate?id=" +
                        encodeURIComponent(id),
                        { method: "DELETE" }
                    );

                    if (!response.ok) {
                        const message = await response.text();
                        console.error("Erro ao excluir taxa regional:", message);

                        throw new Error(
                            "Não foi possível excluir a taxa regional. HTTP " +
                            response.status
                        );
                    }

                    closePopup();

                    showToast(
                        "Taxa regional excluída com sucesso.",
                        "REGISTRO EXCLUÍDO",
                        "delete"
                    );

                    setTimeout(() => {
                        window.location.href = contextPath + "/regionrate";
                    }, 1000);

                } catch (error) {
                    console.error(error);
                    alert(error.message || "Ocorreu um erro ao excluir a taxa.");
                }
            };
    }

    // Pesquisar na tabela
    const searchInput = document.getElementById("searchInput");

    if (searchInput) {
        searchInput.addEventListener("input", function () {
            const query = this.value.toLowerCase();

            document.querySelectorAll("#rateTableBody tr[data-id]")
                .forEach(row => {
                    row.style.display =
                        row.innerText.toLowerCase().includes(query) ? "" : "none";
                });
        });
    }
</script>

</body>
</html>