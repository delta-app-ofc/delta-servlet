
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.example.delta_back.model.User" %>

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

    private String formatDate(Object value) {
        if (value == null) return "";

        String date = String.valueOf(value);

        if (date.matches("\\d{4}-\\d{2}-\\d{2}")) {
            return date.substring(8, 10) + "/"
                + date.substring(5, 7) + "/"
                + date.substring(0, 4);
        }

        return date;
    }
%>

<%
    List<User> users = (List<User>) request.getAttribute("users");

    if (users == null) {
        users = Collections.emptyList();
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Usuários</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <link rel="stylesheet" href="<%= ctx %>/css/User.css">
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
        <a href="<%= ctx %>/user" class="menu-item active">Usuários</a>
        <a href="<%= ctx %>/region" class="menu-item">Região</a>
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
                <h1>Usuários</h1>
                <p>Registros e Dados dos Usuários</p>
            </div>

            <div class="crud-header-right">
                <div class="crud-total">
                    <span>Total de Registros:</span>
                    <strong><%= users.size() %></strong>
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
                        placeholder="Buscar usuário"
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
                Adicionar Usuário
            </button>

        </div>

        <div class="crud-table-wrap">

            <table class="crud-table">

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>E-mail</th>
                        <th>Senha</th>
                        <th>Telefone</th>
                        <th>Nascimento</th>
                        <th>Registro</th>
                        <th>Ativo</th>
                        <th>Admin</th>
                        <th>Gerente</th>
                        <th></th>
                    </tr>
                </thead>

                <tbody id="userTableBody">

                <% if (users.isEmpty()) { %>

                    <tr>
                        <td colspan="11" class="crud-empty">
                            Nenhum usuário cadastrado.
                        </td>
                    </tr>

                <% } else { %>

                    <% for (User user : users) { %>

                        <tr
                            data-id="<%= user.getId() %>"
                            data-name="<%= esc(user.getName()) %>"
                            data-email="<%= esc(user.getEmail()) %>"
                            data-phone="<%= esc(user.getPhone()) %>"
                            data-birthdate="<%= esc(user.getBirthDate()) %>"
                            data-registration-date="<%= esc(user.getRegistrationDate()) %>"
                            data-active="<%= user.isActive() %>"
                            data-admin="<%= user.isAdmin() %>"
                            data-manager="<%= user.isManager() %>"
                        >

                            <td><%= user.getId() %></td>
                            <td><%= esc(user.getName()) %></td>
                            <td><%= esc(user.getEmail()) %></td>
                            <td>••••••••</td>
                            <td><%= esc(user.getPhone()) %></td>
                            <td><%= esc(formatDate(user.getBirthDate())) %></td>
                            <td><%= esc(formatDate(user.getRegistrationDate())) %></td>
                            <td><%= user.isActive() ? "Sim" : "Não" %></td>
                            <td><%= user.isAdmin() ? "Sim" : "Não" %></td>
                            <td><%= user.isManager() ? "Sim" : "Não" %></td>

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

                    <% } %>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

</main>

<!-- Pop-up -->

<div class="overlay" id="popupOverlay">

    <div class="popup">

        <button
            type="button"
            class="close"
            onclick="closePopup()"
        >×</button>

        <div class="popup-content" id="popupSuccess">

            <div class="popup-icon success-icon">✓</div>

            <span class="popup-tag" id="popupSuccessTag">
                Usuários
            </span>

            <h2 id="popupSuccessTitle">
                Cadastro concluído!
            </h2>

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

            <span class="popup-tag danger-tag">
                Excluir Registro
            </span>

            <h2>Confirmar exclusão</h2>

            <p>
                Você tem certeza que deseja excluir este usuário?
            </p>

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

<!-- Notificação -->

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

    lucide.createIcons();

    function esc(value) {
        return String(value ?? "")
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;")
            .replaceAll("'", "&#039;");
    }

    function formatDate(value) {
        if (!value) return "";

        const parts = value.split("-");

        if (parts.length !== 3) return value;

        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    function startCreate() {
        editingId = 0;
        renderForm(null);
    }

    function editRecord(button) {
        const row = button.closest("tr");

        if (!row) return;

        editingId = Number(row.dataset.id);

        renderForm({
            id: row.dataset.id,
            name: row.dataset.name,
            email: row.dataset.email,
            phone: row.dataset.phone,
            birthdate: row.dataset.birthdate,
            registrationDate: row.dataset.registrationDate,
            active: row.dataset.active,
            admin: row.dataset.admin,
            manager: row.dataset.manager
        });
    }

    function renderForm(user) {
        const editing = user !== null;
        const page = document.getElementById("crudPage");

        page.innerHTML = `
            <header class="crud-form-header">
                <div>
                    <h1>${editing ? "Editar Usuário" : "Adicionar Usuário"}</h1>
                    <p>Registros e Dados dos Usuários</p>
                </div>
            </header>

            <form
                class="crud-form-card"
                id="crudForm"
                onsubmit="saveForm(event)"
            >
                <input
                    type="hidden"
                    name="id"
                    value="${editing ? esc(user.id) : "0"}"
                >

                <div class="form-title">
                    ${editing ? "Editar dados do usuário" : "Novo usuário"}
                </div>

                <div class="form-grid">

                    <div class="crud-field">
                        <label for="fName">Nome</label>
                        <input
                            id="fName"
                            name="name"
                            type="text"
                            value="${editing ? esc(user.name) : ""}"
                            required
                        >
                    </div>

                    <div class="crud-field">
                        <label for="fEmail">E-mail</label>
                        <input
                            id="fEmail"
                            name="email"
                            type="email"
                            value="${editing ? esc(user.email) : ""}"
                            required
                        >
                    </div>

                    <div class="crud-field">
                        <label for="fPassword">
                            ${editing ? "Nova senha (opcional)" : "Senha"}
                        </label>

                        <input
                            id="fPassword"
                            name="password"
                            type="password"
                            autocomplete="new-password"
                            placeholder="${editing
                                ? "Deixe vazio para manter a senha atual"
                                : "Digite a senha"}"
                            ${editing ? "" : "required"}
                        >
                    </div>

                    <div class="crud-field">
                        <label for="fPhone">Telefone</label>
                        <input
                            id="fPhone"
                            name="phone"
                            type="tel"
                            value="${editing ? esc(user.phone) : ""}"
                            required
                        >
                    </div>

                    <div class="crud-field">
                        <label for="fBirthdate">Nascimento</label>
                        <input
                            id="fBirthdate"
                            name="birthdate"
                            type="date"
                            value="${editing ? esc(user.birthdate) : ""}"
                            required
                        >
                    </div>

                    <div class="crud-field">
                        <label for="fRegistrationDate">Data de registro</label>
                        <input
                            id="fRegistrationDate"
                            name="registration_date"
                            type="date"
                            value="${editing ? esc(user.registrationDate) : ""}"
                            ${editing ? "readonly" : ""}
                        >
                    </div>

                    <div class="crud-field">
                        <label for="fActive">Ativo</label>
                        <select id="fActive" name="is_active" required>
                            <option value="true" ${editing && user.active === "true" ? "selected" : ""}>
                                Sim
                            </option>
                            <option value="false" ${editing && user.active === "false" ? "selected" : ""}>
                                Não
                            </option>
                        </select>
                    </div>

                    <div class="crud-field">
                        <label for="fAdmin">Administrador</label>
                        <select id="fAdmin" name="is_admin" required>
                            <option value="false" ${!editing || user.admin !== "true" ? "selected" : ""}>
                                Não
                            </option>
                            <option value="true" ${editing && user.admin === "true" ? "selected" : ""}>
                                Sim
                            </option>
                        </select>
                    </div>

                    <div class="crud-field">
                        <label for="fManager">Gerente</label>
                        <select id="fManager" name="is_manager" required>
                            <option value="false" ${!editing || user.manager !== "true" ? "selected" : ""}>
                                Não
                            </option>
                            <option value="true" ${editing && user.manager === "true" ? "selected" : ""}>
                                Sim
                            </option>
                        </select>
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
                        ${editing ? "Salvar alterações" : "Adicionar Usuário"}
                    </button>

                </div>

            </form>
        `;

        lucide.createIcons();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function cancelForm() {
        editingId = null;
        window.location.href = contextPath + "/user";
    }

    async function saveForm(event) {
        event.preventDefault();

        const form = document.getElementById("crudForm");

        if (!form.reportValidity()) return;

        const formData = new FormData(form);
        const params = new URLSearchParams();

        for (const [key, value] of formData.entries()) {
            params.set(key, String(value).trim());
        }

        const id = params.get("id");
        const editing = id !== "0" && id !== "";

        const button = document.getElementById("saveButton");
        button.disabled = true;
        button.textContent = "Salvando...";

        let url = contextPath + "/user";

        const options = {
            method: editing ? "PUT" : "POST",
            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded;charset=UTF-8"
            }
        };

        if (editing) {
            // O servlet lê os parâmetros do PUT com request.getParameter().
            // Por isso, os dados da edição são enviados na query string.
            url += "?" + params.toString();
        } else {
            // No POST, os dados vão no corpo da requisição.
            options.body = params.toString();
        }

        try {
            const response = await fetch(url, options);

            if (!response.ok) {
                const errorText = await response.text();

                console.error(
                    "Erro ao salvar usuário:",
                    response.status,
                    errorText
                );

                throw new Error(
                    "Não foi possível " +
                    (editing ? "editar" : "cadastrar") +
                    " o usuário. Código HTTP: " + response.status
                );
            }

            reloadAfterPopup = true;

            showPopup("success", {
                title: editing
                    ? "Alterações salvas!"
                    : "Cadastro concluído!",
                desc: editing
                    ? "Os dados do usuário foram atualizados com sucesso."
                    : "O novo usuário foi cadastrado com sucesso.",
                tag: "Usuários"
            });

            showToast(
                editing
                    ? "Usuário atualizado com sucesso."
                    : "Usuário cadastrado com sucesso.",
                editing ? "ALTERAÇÕES SALVAS" : "CADASTRO CONCLUÍDO",
                editing ? "edit" : "success"
            );

        } catch (error) {
            console.error(error);
            alert(error.message || "Ocorreu um erro ao salvar o usuário.");

            button.disabled = false;
            button.textContent = editing
                ? "Salvar alterações"
                : "Adicionar Usuário";
        }
    }

    function showPopup(type, data = {}) {
        const overlay = document.getElementById("popupOverlay");
        const successContent = document.getElementById("popupSuccess");
        const deleteContent = document.getElementById("popupDelete");

        successContent.classList.remove("active");
        deleteContent.classList.remove("active");

        if (type === "success") {
            document.getElementById("popupSuccessTitle").innerText =
                data.title || "Operação concluída!";

            document.getElementById("popupSuccessDesc").innerText =
                data.desc || "Ação realizada com sucesso.";

            document.getElementById("popupSuccessTag").innerText =
                data.tag || "Usuários";

            successContent.classList.add("active");

        } else if (type === "delete") {
            document.getElementById("deleteRecordLabel").innerText =
                "ID #" + data.id;

            deleteContent.classList.add("active");
        }

        document.body.classList.add("locked");
        overlay.classList.add("show");
    }

    function closePopup() {
        document.getElementById("popupOverlay").classList.remove("show");
        document.body.classList.remove("locked");

        recordToDelete = null;

        if (reloadAfterPopup) {
            reloadAfterPopup = false;
            window.location.href = contextPath + "/user";
        }
    }

    function showToast(message, title = "Sucesso", type = "success") {
        const toast = document.getElementById("globalToast");
        const toastSymbol = document.getElementById("toastSymbol");

        toast.className = "global-toast show";

        if (type === "edit") toast.classList.add("toast-edit");
        if (type === "delete") toast.classList.add("toast-delete");

        document.getElementById("toastTitle").innerText = title;
        document.getElementById("toastMessage").innerText = message;

        toastSymbol.innerText = type === "delete" ? "!" : "✓";

        setTimeout(hideToast, 4000);
    }

    function hideToast() {
        document.getElementById("globalToast").classList.remove("show");
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
                const params = new URLSearchParams({ id: id });

                try {
                    // Envia o ID na URL para o doDelete receber pelo getParameter().
                    const response = await fetch(
                        contextPath + "/user?" + params.toString(),
                        { method: "DELETE" }
                    );

                    if (!response.ok) {
                        const errorText = await response.text();
                        console.error(errorText);

                        throw new Error(
                            "Não foi possível excluir o usuário. Código HTTP: " +
                            response.status
                        );
                    }

                    reloadAfterPopup = true;
                    closePopup();

                } catch (error) {
                    console.error(error);
                    alert(error.message);
                }
            };
    }

    document.getElementById("searchInput").addEventListener(
        "input",
        function () {
            const query = this.value.toLowerCase();

            document.querySelectorAll("#userTableBody tr[data-id]").forEach(
                function (row) {
                    row.style.display = row.textContent
                        .toLowerCase()
                        .includes(query) ? "" : "none";
                }
            );
        }
    );
</script>

</body>
</html>