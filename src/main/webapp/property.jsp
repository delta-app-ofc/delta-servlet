
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Property" %>

<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    String ctx = request.getContextPath();

    List<Property> properties =
            (List<Property>) request.getAttribute("properties");

    if (properties == null) {
        response.sendRedirect(ctx + "/property");
        return;
    }

    int totalProperties = properties.size();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Propriedades</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="<%= ctx %>/css/Property.css">
    <link rel="stylesheet" href="<%= ctx %>/css/Pop-up.css">

    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body>

<aside class="sidebar">
    <div class="logo-area">
        <img src="<%= ctx %>/imagens/LogoDelta.png"
             alt="Logo Delta"
             id="logo">
    </div>

    <nav class="menu">
        <a href="<%= ctx %>/index.jsp" class="menu-item">Início</a>
        <a href="<%= ctx %>/user" class="menu-item">Usuários</a>
        <a href="<%= ctx %>/region" class="menu-item">Região</a>
        <a href="<%= ctx %>/regionrate" class="menu-item">Taxa Regional</a>
        <a href="<%= ctx %>/property" class="menu-item active">Propriedades</a>
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
                <h1>Propriedades</h1>
                <p>Registros e Dados das Propriedades</p>
            </div>

            <div class="crud-header-right">
                <div class="crud-total">
                    <span>Total de Registros:</span>
                    <strong><%= totalProperties %></strong>
                </div>
            </div>
        </header>

        <div class="crud-toolbar">
            <div class="crud-search-area">
                <div class="crud-search">
                    <i data-lucide="search"></i>
                    <input id="searchInput"
                           type="text"
                           placeholder="Buscar">
                </div>

                <button class="crud-filter"
                        type="button"
                        title="Filtro">
                    <i data-lucide="funnel"></i>
                </button>
            </div>

            <button class="crud-add"
                    type="button"
                    onclick="startCreate()">
                <i data-lucide="circle-plus"></i>
                Adicionar Propriedade
            </button>
        </div>

        <div class="crud-table-wrap">
            <table class="crud-table" id="propertyTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Tipo</th>
                    <th>Classificação</th>
                    <th>ID do Endereço</th>
                    <th>Data de Registro</th>
                    <th>Ações</th>
                </tr>
                </thead>

                <tbody id="propertyTableBody">
                <% if (properties.isEmpty()) { %>
                <tr>
                    <td colspan="7" class="crud-empty">
                        Nenhuma propriedade cadastrada.
                    </td>
                </tr>
                <% } else {
                    for (Property property : properties) {
                %>
                <tr>
                    <td><%= property.getId() %></td>
                    <td><%= escapeHtml(property.getName()) %></td>
                    <td><%= escapeHtml(property.getType()) %></td>
                    <td><%= escapeHtml(property.getClassification()) %></td>
                    <td><%= property.getAddressId() %></td>
                    <td><%= escapeHtml(property.getRegistrationDate()) %></td>

                    <td class="crud-actions-cell">
                        <button type="button"
                                class="crud-action"
                                title="Editar"
                                onclick="editRecord(this)"
                                data-id="<%= property.getId() %>"
                                data-name="<%= escapeHtml(property.getName()) %>"
                                data-type="<%= escapeHtml(property.getType()) %>"
                                data-classification="<%= escapeHtml(property.getClassification()) %>"
                                data-address-id="<%= property.getAddressId() %>"
                                data-registration-date="<%= escapeHtml(property.getRegistrationDate()) %>">
                            <i data-lucide="pencil"></i>
                        </button>

                        <button type="button"
                                class="crud-action delete"
                                title="Excluir"
                                onclick="deleteRecord(<%= property.getId() %>)">
                            <i data-lucide="trash-2"></i>
                        </button>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<div class="overlay" id="popupOverlay">
    <div class="popup">
        <button type="button" class="close" onclick="closePopup()">×</button>

        <div class="popup-content" id="popupSuccess">
            <div class="popup-icon success-icon">✓</div>
            <span class="popup-tag">Propriedades</span>
            <h2 id="popupSuccessTitle">Cadastro concluído!</h2>
            <p id="popupSuccessDesc">
                A operação foi realizada com sucesso.
            </p>

            <button type="button" class="popup-primary" onclick="closePopup()">
                OK, Entendido
            </button>
            <button type="button" class="popup-secondary" onclick="closePopup()">
                Voltar
            </button>
        </div>

        <div class="popup-content" id="popupDelete">
            <div class="popup-icon warning-icon">!</div>
            <span class="popup-tag danger-tag">Excluir Registro</span>
            <h2>Confirmar exclusão</h2>
            <p>Você tem certeza que deseja excluir esta propriedade?</p>

            <div class="selected-record">
                <span>REGISTRO SELECIONADO</span>
                <strong id="deleteRecordLabel">ID #--</strong>
            </div>

            <div class="delete-actions">
                <button type="button" class="popup-secondary" onclick="closePopup()">
                    Cancelar
                </button>
                <button type="button" class="popup-danger" id="confirmDeleteBtn">
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
        <span id="toastMessage">Ação realizada com sucesso.</span>
    </div>
    <button type="button" onclick="hideToast()">×</button>
</div>

<script>
    const contextPath = "<%= ctx %>";
    const crudPage = document.getElementById("crudPage");
    const tableBody = document.getElementById("propertyTableBody");

    let editingId = null;
    let recordToDelete = null;
    let reloadAfterPopup = false;

    lucide.createIcons();

    function escapeText(value) {
        return String(value ?? "")
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;")
            .replaceAll("'", "&#39;");
    }

    function formatDate(value) {
        if (!value) return "";

        const text = String(value);

        if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
            return text;
        }

        const match = text.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);

        if (match) {
            return `${match[3]}-${match[2]}-${match[1]}`;
        }

        return "";
    }

    function startCreate() {
        editingId = null;
        renderForm();
    }

    function editRecord(button) {
        editingId = Number(button.dataset.id);

        renderForm({
            id: editingId,
            name: button.dataset.name,
            type: button.dataset.type,
            classification: button.dataset.classification,
            addressId: button.dataset.addressId,
            registrationDate: formatDate(button.dataset.registrationDate)
        });
    }

    function renderForm(property = null) {
        const editing = property !== null;

        crudPage.innerHTML = `
            <div class="crud-form-page">
                <header class="crud-form-header">
                    <div>
                        <h1>${editing ? "Editar Propriedade" : "Adicionar Propriedade"}</h1>
                        <p>Registros e Dados das Propriedades</p>
                    </div>
                </header>

                <form class="crud-form-card" id="propertyForm">
                    <div class="form-title">
                        ${editing ? "Editar dados da propriedade" : "Nova Propriedade"}
                    </div>

                    <div class="form-grid">
                        <div class="crud-field">
                            <label for="name">Nome</label>
                            <input id="name" name="name" type="text"
                                   value="${escapeText(property?.name)}" required>
                        </div>

                        <div class="crud-field">
                            <label for="type">Tipo</label>
                            <input id="type" name="type" type="text"
                                   value="${escapeText(property?.type)}" required>
                        </div>

                        <div class="crud-field">
                            <label for="classification">Classificação</label>
                            <input id="classification" name="classification" type="text"
                                   value="${escapeText(property?.classification)}" required>
                        </div>

                        <div class="crud-field">
                            <label for="addressId">ID do Endereço</label>
                            <input id="addressId" name="addressId" type="number"
                                   min="1" step="1"
                                   value="${escapeText(property?.addressId)}" required>
                        </div>

                        <div class="crud-field">
                            <label for="registrationDate">Data de Registro</label>
                            <input id="registrationDate" name="registrationDate"
                                   type="date"
                                   value="${escapeText(property?.registrationDate)}" required>
                        </div>
                    </div>

                    <div class="crud-form-actions">
                        <button type="button" class="crud-cancel" onclick="cancelForm()">
                            Cancelar
                        </button>

                        <button type="submit" class="crud-save">
                            ${editing ? "Salvar alterações" : "Adicionar Propriedade"}
                        </button>
                    </div>
                </form>
            </div>
        `;

        document.getElementById("propertyForm")
            .addEventListener("submit", saveForm);

        lucide.createIcons();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function cancelForm() {
        window.location.href = contextPath + "/property";
    }

    async function saveForm(event) {
        event.preventDefault();

        const form = event.currentTarget;

        if (!form.reportValidity()) return;

        const params = new URLSearchParams(new FormData(form));
        const isEdit = editingId !== null;

        let url = contextPath + "/property";
        let method = "POST";

        if (isEdit) {
            params.append("id", editingId);
            url += "?" + params.toString();
            method = "PUT";
        }

        try {
            const response = await fetch(url, {
                method: method,
                headers: isEdit
                    ? {}
                    : {
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                    },
                body: isEdit ? null : params.toString()
            });

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            reloadAfterPopup = true;

            showPopup(
                "success",
                isEdit ? "Alterações salvas!" : "Cadastro concluído!",
                isEdit
                    ? "A propriedade foi atualizada com sucesso."
                    : "A propriedade foi cadastrada com sucesso."
            );

            showToast(
                isEdit ? "Propriedade atualizada." : "Propriedade cadastrada.",
                isEdit ? "ALTERAÇÕES SALVAS" : "CADASTRO CONCLUÍDO",
                isEdit ? "edit" : "success"
            );

        } catch (error) {
            console.error(error);
            alert("Não foi possível salvar a propriedade. Verifique os dados e tente novamente.");
        }
    }

    function deleteRecord(id) {
        recordToDelete = Number(id);
        document.getElementById("deleteRecordLabel").textContent = "ID #" + id;
        showPopup("delete");

        document.getElementById("confirmDeleteBtn").onclick = confirmDelete;
    }

    async function confirmDelete() {
        if (recordToDelete === null) return;

        try {
            const response = await fetch(
                contextPath + "/property?id=" + encodeURIComponent(recordToDelete),
                { method: "DELETE" }
            );

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            closePopup();
            showToast("Propriedade excluída com sucesso.", "REGISTRO EXCLUÍDO", "delete");

            window.location.href = contextPath + "/property";

        } catch (error) {
            console.error(error);
            alert("Não foi possível excluir a propriedade.");
        }
    }

    function showPopup(type, title = "", description = "") {
        const overlay = document.getElementById("popupOverlay");
        const success = document.getElementById("popupSuccess");
        const deletion = document.getElementById("popupDelete");

        success.classList.remove("active");
        deletion.classList.remove("active");

        if (type === "success") {
            document.getElementById("popupSuccessTitle").textContent = title;
            document.getElementById("popupSuccessDesc").textContent = description;
            success.classList.add("active");
        } else {
            deletion.classList.add("active");
        }

        document.body.classList.add("locked");
        overlay.classList.add("show");
    }

    function closePopup() {
        document.getElementById("popupOverlay").classList.remove("show");
        document.body.classList.remove("locked");

        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        recordToDelete = null;

        if (reloadAfterPopup) {
            reloadAfterPopup = false;
            window.location.href = contextPath + "/property";
        }
    }

    function showToast(message, title = "Sucesso", type = "success") {
        const toast = document.getElementById("globalToast");
        const symbol = document.getElementById("toastSymbol");

        toast.className = "global-toast show";

        if (type === "edit") toast.classList.add("toast-edit");
        if (type === "delete") toast.classList.add("toast-delete");

        document.getElementById("toastTitle").textContent = title;
        document.getElementById("toastMessage").textContent = message;
        symbol.textContent = type === "delete" ? "!" : "✓";

        setTimeout(hideToast, 4000);
    }

    function hideToast() {
        document.getElementById("globalToast").classList.remove("show");
    }

    document.getElementById("searchInput").addEventListener("input", function () {
        const query = this.value.toLowerCase().trim();

        Array.from(tableBody.querySelectorAll("tr")).forEach(row => {
            row.hidden = !row.textContent.toLowerCase().includes(query);
        });
    });
</script>

</body>
</html>