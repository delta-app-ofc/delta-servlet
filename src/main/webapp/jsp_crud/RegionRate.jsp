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
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Taxa Regional</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
            rel="stylesheet"
    >

    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/RegionRate.css">
    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Pop-up.css">

    <style>
        .validation-box {
            margin: 0 0 22px;
            padding: 14px 18px;
            border: 1px solid #dc2626;
            border-radius: 10px;
            background: #fef2f2;
            color: #991b1b;
        }

        .validation-box[hidden] {
            display: none;
        }

        .validation-box strong {
            display: block;
            margin-bottom: 6px;
        }

        .validation-box ul {
            margin: 0;
            padding-left: 22px;
        }

        .validation-box li {
            margin-top: 4px;
        }
    </style>

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
        <a href="<%= ctx %>/inicio" class="menu-item">Início</a>
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
            <span><%= esc(session.getAttribute("authName")) %></span>
        </div>

        <a href="<%= ctx %>/auth/logout" class="logout">
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
    let toastTimeout = null;

    lucide.createIcons();

    function esc(value) {
        return String(value ?? "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    function startCreate() {
        editingId = null;
        renderForm(null);
    }

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

    function normalizeDate(value) {
        if (!value) return "";

        const date = String(value).trim();

        if (/^\d{4}-\d{2}-\d{2}$/.test(date)) {
            return date;
        }

        const brazilian = date.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);

        if (brazilian) {
            return brazilian[3] + "-" + brazilian[2] + "-" + brazilian[1];
        }

        return "";
    }

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

                    <form id="rateForm" novalidate>

                        <div
                            id="validationBox"
                            class="validation-box"
                            role="alert"
                            aria-live="polite"
                            hidden
                        >
                            <strong>Verifique os seguintes campos:</strong>
                            <ul id="validationList"></ul>
                        </div>

                        <div class="form-grid">

                            <div class="crud-field">
                                <label for="region_id">ID da Região</label>
                                <input
                                    type="number"
                                    id="region_id"
                                    name="region_id"
                                    value="${editing ? esc(rate.regionId) : ""}"
                                >
                            </div>

                            <div class="crud-field">
                                <label for="m3value">Valor por m³</label>
                                <input
                                    type="number"
                                    id="m3value"
                                    name="m3value"
                                    step="any"
                                    value="${editing ? esc(rate.m3value) : ""}"
                                >
                            </div>

                            <div class="crud-field">
                                <label for="initial_validity">Início da Validade</label>
                                <input
                                    type="date"
                                    id="initial_validity"
                                    name="initial_validity"
                                    max="<%= java.time.LocalDate.now() %>"
                                    value="${editing ? esc(rate.initialValidity) : ""}"
                                >
                            </div>

                            <div class="crud-field">
                                <label for="final_validity">Fim da Validade</label>
                                <input
                                    type="date"
                                    id="final_validity"
                                    name="final_validity"
                                    max="<%= java.time.LocalDate.now() %>"
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

    function cancelForm() {
        window.location.href = contextPath + "/regionrate";
    }

    function showValidationErrors(messages) {
        const box = document.getElementById("validationBox");
        const list = document.getElementById("validationList");

        if (!box || !list) return;

        list.replaceChildren();

        messages.forEach(message => {
            const item = document.createElement("li");
            item.textContent = message;
            list.appendChild(item);
        });

        box.hidden = messages.length === 0;

        if (messages.length > 0) {
            box.scrollIntoView({
                behavior: "smooth",
                block: "center"
            });
        }
    }

    async function saveForm(event) {
        event.preventDefault();

        const form = document.getElementById("rateForm");
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
                        "Content-Type":
                            "application/x-www-form-urlencoded;charset=UTF-8"
                    },
                    body: params.toString()
                }
            );

            if (!response.ok) {
                const message = (await response.text()).trim();

                showValidationErrors([
                    message ||
                    "Não foi possível salvar a taxa regional. Verifique os dados e tente novamente."
                ]);

                return;
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
            console.error("Erro ao salvar taxa regional:", error);

            showValidationErrors([
                error.message ||
                "Ocorreu um erro ao salvar a taxa regional. Tente novamente."
            ]);

        } finally {
            const currentButton = document.getElementById("saveButton");

            if (currentButton) {
                currentButton.disabled = false;
                currentButton.textContent = editing
                    ? "Salvar alterações"
                    : "Cadastrar Taxa";
            }
        }
    }

    function showPopup(type, data = {}) {
        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        if (type === "success") {
            const icon = document.querySelector("#popupSuccess .popup-icon");

            icon.classList.remove("warning-icon");
            icon.classList.add("success-icon");
            icon.textContent = "✓";

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

    function closePopup() {
        document.getElementById("popupOverlay").classList.remove("show");
        document.body.classList.remove("locked");

        recordToDelete = null;

        if (reloadAfterPopup) {
            reloadAfterPopup = false;
            window.location.href = contextPath + "/regionrate";
        }
    }

    function showToast(message, title = "Sucesso", type = "success") {
        const toast = document.getElementById("globalToast");

        toast.className = "global-toast show";

        if (type === "edit") toast.classList.add("toast-edit");
        if (type === "delete") toast.classList.add("toast-delete");

        document.getElementById("toastTitle").textContent = title;
        document.getElementById("toastMessage").textContent = message;

        document.getElementById("toastSymbol").textContent =
            type === "delete" ? "!" : "✓";

        if (toastTimeout !== null) {
            clearTimeout(toastTimeout);
        }

        toastTimeout = setTimeout(hideToast, 4000);
    }

    function hideToast() {
        document.getElementById("globalToast").classList.remove("show");

        if (toastTimeout !== null) {
            clearTimeout(toastTimeout);
            toastTimeout = null;
        }
    }

    function deleteRecord(button) {
        const row = button.closest("tr");

        if (!row) return;

        recordToDelete = row.dataset.id;

        showPopup("delete", { id: recordToDelete });

        document.getElementById("confirmDeleteBtn").onclick =
            async function () {
                if (recordToDelete === null) return;

                const id = recordToDelete;
                const confirmButton =
                    document.getElementById("confirmDeleteBtn");

                confirmButton.disabled = true;
                confirmButton.textContent = "Excluindo...";

                try {
                    const response = await fetch(
                        contextPath + "/regionrate?id=" +
                        encodeURIComponent(id),
                        { method: "DELETE" }
                    );

                    if (!response.ok) {
                        const message = (await response.text()).trim();

                        throw new Error(
                            message ||
                            "Não foi possível excluir a taxa regional."
                        );
                    }

                    document.getElementById("popupOverlay")
                        .classList.remove("show");

                    document.body.classList.remove("locked");
                    recordToDelete = null;

                    showToast(
                        "Taxa regional excluída com sucesso.",
                        "REGISTRO EXCLUÍDO",
                        "delete"
                    );

                    setTimeout(() => {
                        window.location.href = contextPath + "/regionrate";
                    }, 1000);

                } catch (error) {
                    document.getElementById("popupOverlay")
                        .classList.remove("show");

                    document.body.classList.remove("locked");
                    recordToDelete = null;

                    showToast(
                        error.message || "Ocorreu um erro ao excluir a taxa.",
                        "Erro ao excluir",
                        "delete"
                    );

                } finally {
                    confirmButton.disabled = false;
                    confirmButton.textContent = "Confirmar Exclusão";
                }
            };
    }

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
