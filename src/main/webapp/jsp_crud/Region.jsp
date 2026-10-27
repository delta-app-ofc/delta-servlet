<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.example.delta_back.model.Region" %>

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
    List<Region> regions =
            (List<Region>) request.getAttribute("region");

    if (regions == null) {
        regions = Collections.emptyList();
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Região</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
            rel="stylesheet"
    >

    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Region.css">
    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Pop-up.css">

    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        .region-delete-warning {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-top: 16px;
            padding: 12px 14px;
            border: 1px solid #e5b85c;
            border-radius: 8px;
            background-color: #fff8e6;
            color: #795b16;
            font-size: 12px;
            line-height: 1.6;
            text-align: left;
            margin-bottom: 18px;
        }

        .region-delete-warning .warning-symbol {
            flex-shrink: 0;
            font-size: 17px;
            font-weight: 700;
        }

        .region-delete-warning strong {
            display: block;
            margin-bottom: 3px;
        }
    </style>
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
        <a href="<%= ctx %>/region" class="menu-item active">Região</a>
        <a href="<%= ctx %>/regionrate" class="menu-item">Taxa Regional</a>
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

        <a href="<%= ctx %>/inicio" class="logout">
            <i data-lucide="log-out"></i>
            <span>Sair</span>
        </a>
    </div>
</aside>

<main class="main">
    <section class="crud-page" id="crudPage">
        <header class="crud-header">
            <div class="crud-title">
                <h1>Região</h1>
                <p>Registros e Dados das Regiões</p>
            </div>

            <div class="crud-header-right">
                <div class="crud-total">
                    <span>Total de Registros:</span>
                    <strong><%= regions.size() %></strong>
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
                            placeholder="Buscar região"
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
                Adicionar Região
            </button>
        </div>

        <div class="crud-table-wrap">
            <table class="crud-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th></th>
                </tr>
                </thead>

                <tbody id="regionTableBody">
                <% if (regions.isEmpty()) { %>
                <tr>
                    <td colspan="3" class="crud-empty">
                        Nenhuma região cadastrada.
                    </td>
                </tr>
                <% } else {
                    for (Region region : regions) {
                %>
                <tr
                        data-id="<%= region.getId() %>"
                        data-name="<%= esc(region.getName()) %>"
                >
                    <td><%= region.getId() %></td>
                    <td><%= esc(region.getName()) %></td>

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
            <span class="popup-tag" id="popupSuccessTag">Região</span>

            <h2 id="popupSuccessTitle">Cadastro concluído!</h2>

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

            <p>Você tem certeza que deseja excluir esta região?</p>

            <div class="selected-record">
                <span>REGISTRO SELECIONADO</span>
                <strong id="deleteRecordLabel">ID #--</strong>
            </div>

            <div class="region-delete-warning">
                <span class="warning-symbol">!</span>
                <div>
                    <strong>Atenção: exclusão de dados relacionados</strong>
                    As Taxas Regionais vinculadas a esta região também
                    serão excluídas. Essa ação não poderá ser desfeita.
                </div>
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
        <span id="toastMessage">Operação realizada.</span>
    </div>

    <button type="button" onclick="hideToast()">×</button>
</div>

<script>
    const contextPath = "<%= ctx %>";

    let editingId = null;
    let recordToDelete = null;
    let reloadAfterPopup = false;
    let toastTimeout = null;

    function esc(value) {
        return String(value ?? "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    lucide.createIcons();

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
            name: row.dataset.name
        });
    }

    function renderForm(region) {
        const editing = region !== null;
        const page = document.getElementById("crudPage");

        page.innerHTML = `
            <header class="crud-form-header">
                <div>
                    <h1>${editing ? "Editar Região" : "Adicionar Região"}</h1>
                    <p>Registros e Dados das Regiões</p>
                </div>
            </header>

            <form class="crud-form-card" id="regionForm" novalidate>
                <input
                    type="hidden"
                    name="id"
                    value="${editing ? esc(region.id) : ""}"
                >

                <div class="form-title">
                    ${editing ? "Editar dados da região" : "Nova Região"}
                </div>

                <div class="form-grid">
                    <div class="crud-field">
                        <label for="regionName">Nome</label>

                        <input
                            id="regionName"
                            name="name"
                            type="text"
                            maxlength="20"
                            value="${editing ? esc(region.name) : ""}"
                            placeholder="Digite o nome da região"
                            autocomplete="off"
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
                        ${editing ? "Salvar alterações" : "Adicionar Região"}
                    </button>
                </div>
            </form>
        `;

        const nameInput = document.getElementById("regionName");

        nameInput.addEventListener("input", function () {
            const start = this.selectionStart;
            const end = this.selectionEnd;

            this.value = this.value.toLocaleUpperCase("pt-BR");

            this.setSelectionRange(start, end);
        });

        document.getElementById("regionForm")
            .addEventListener("submit", saveForm);

        lucide.createIcons();

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function cancelForm() {
        window.location.href = contextPath + "/region";
    }

    async function saveForm(event) {
        event.preventDefault();

        const form = document.getElementById("regionForm");
        const name = document.getElementById("regionName")
            .value.trim().toLocaleUpperCase("pt-BR");

        const editing = editingId !== null;
        const params = new URLSearchParams();

        params.set("name", name);

        if (editing) {
            params.set("id", editingId);
        }

        const button = document.getElementById("saveButton");

        button.disabled = true;
        button.textContent = "Salvando...";

        try {
            const url = contextPath + "/region";

            const requestUrl = editing
                ? url + "?" + params.toString()
                : url;

            const options = {
                method: editing ? "PUT" : "POST",
                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded;charset=UTF-8"
                }
            };

            if (!editing) {
                options.body = params.toString();
            }

            const response = await fetch(requestUrl, options);

            if (!response.ok) {
                const errorText = (await response.text()).trim();

                throw new Error(
                    errorText || "Não foi possível salvar a região."
                );
            }

            reloadAfterPopup = true;

            showPopup("success", {
                title: editing
                    ? "Alterações salvas!"
                    : "Cadastro concluído!",
                desc: editing
                    ? "Os dados da região foram atualizados com sucesso."
                    : "A nova região foi cadastrada com sucesso."
            });

            showToast(
                editing
                    ? "Região atualizada com sucesso."
                    : "Região cadastrada com sucesso.",
                editing ? "ALTERAÇÕES SALVAS" : "CADASTRO CONCLUÍDO",
                "success"
            );

        } catch (error) {
            showToast(
                error.message || "Ocorreu um erro ao salvar a região.",
                "ERRO AO SALVAR",
                "delete"
            );

            button.disabled = false;
            button.textContent = editing
                ? "Salvar alterações"
                : "Adicionar Região";
        }
    }

    function showPopup(type, data = {}) {
        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        if (type === "success") {
            document.getElementById("popupSuccessTitle").textContent =
                data.title || "Operação concluída!";

            document.getElementById("popupSuccessDesc").textContent =
                data.desc || "Ação realizada com sucesso.";

            document.getElementById("popupSuccessTag").textContent = "Região";

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
            window.location.href = contextPath + "/region";
        }
    }

    function showToast(message, title = "Sucesso", type = "success") {
        const toast = document.getElementById("globalToast");

        if (toastTimeout !== null) {
            clearTimeout(toastTimeout);
        }

        toast.className = "global-toast show";

        if (type === "edit") toast.classList.add("toast-edit");
        if (type === "delete") toast.classList.add("toast-delete");

        document.getElementById("toastTitle").textContent = title;
        document.getElementById("toastMessage").textContent = message;
        document.getElementById("toastSymbol").textContent =
            type === "delete" ? "!" : "✓";

        toastTimeout = setTimeout(hideToast, 5000);
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

        const confirmButton = document.getElementById("confirmDeleteBtn");

        confirmButton.onclick = async function () {
            if (recordToDelete === null) return;

            const id = recordToDelete;
            const params = new URLSearchParams({ id });

            confirmButton.disabled = true;
            confirmButton.textContent = "Excluindo...";

            try {
                const response = await fetch(
                    contextPath + "/region?" + params.toString(),
                    { method: "DELETE" }
                );

                if (!response.ok) {
                    const errorText = (await response.text()).trim();

                    throw new Error(
                        errorText || "Não foi possível excluir a região."
                    );
                }

                document.getElementById("popupOverlay")
                    .classList.remove("show");

                document.body.classList.remove("locked");
                recordToDelete = null;

                showToast(
                    "Região excluída com sucesso.",
                    "REGISTRO EXCLUÍDO",
                    "success"
                );

                setTimeout(function () {
                    window.location.href = contextPath + "/region";
                }, 700);

            } catch (error) {
                document.getElementById("popupOverlay")
                    .classList.remove("show");

                document.body.classList.remove("locked");
                recordToDelete = null;

                showToast(
                    error.message || "Ocorreu um erro ao excluir a região.",
                    "ERRO AO EXCLUIR",
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
            const query = this.value.toLocaleLowerCase("pt-BR");

            document.querySelectorAll("#regionTableBody tr[data-id]")
                .forEach(row => {
                    const id = row.dataset.id.toLowerCase();
                    const name = row.dataset.name.toLocaleLowerCase("pt-BR");

                    row.style.display =
                        id.includes(query) || name.includes(query)
                            ? ""
                            : "none";
                });
        });
    }
</script>

</body>
</html>
