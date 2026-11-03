<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%-- Documentação da página: Property; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>
<%@ page import="java.util.List" %>
<%-- Documentação da página: Property; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>
<%@ page import="com.example.delta_back.model.Property" %>
<%-- Documentação da página: Property; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>

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
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delta - Propriedades</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Property.css?v=20261101-sidebar-gota">
    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Pop-up.css">
    <%-- Bloco da página: código de interação executado pelo navegador. --%>
    <script src="https://unpkg.com/lucide@latest"></script>

    <%-- Bloco da página: estilos locais desta tela. --%>
    <style>
        .property-validation {
            display: none;
            margin: 0 0 22px;
            padding: 14px 18px;
            border: 1px solid #dc2626;
            border-left: 5px solid #dc2626;
            border-radius: 8px;
            background: #fef2f2;
            color: #991b1b;
            font-family: 'Poppins', sans-serif;
            font-size: 13px;
        }

        .property-validation.visible {
            display: block;
        }

        .property-validation strong {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
        }

        .property-validation ul {
            margin: 0;
            padding-left: 20px;
        }

        .crud-field input.validation-error,
        .crud-field select.validation-error {
            border: 1px solid #dc2626 !important;
            outline: 1px solid #dc2626;
            background-color: #fffafa;
        }

        .crud-field .validation-hint {
            display: block;
            margin-top: 5px;
            color: #dc2626;
            font-size: 11px;
        }

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

<%-- Bloco da página: conteúdo auxiliar. --%>
<aside class="sidebar">
    <img class="sidebar-drop" src="<%= ctx %>/imagens/Gota_Sidebar.png" alt="" aria-hidden="true">
    <div class="logo-area">
        <img src="<%= ctx %>/imagens/LogoDelta.png" alt="Logo Delta" id="logo">
    </div>

    <%-- Bloco da página: navegação. --%>
    <nav class="menu">
        <a href="<%= ctx %>/inicio" class="menu-item">Início</a>
        <a href="<%= ctx %>/user" class="menu-item">Usuários</a>
        <a href="<%= ctx %>/region" class="menu-item">Região</a>
        <a href="<%= ctx %>/regionrate" class="menu-item">Taxa Regional</a>
        <a href="<%= ctx %>/property" class="menu-item active">Propriedades</a>
        <a href="<%= ctx %>/device" class="menu-item">Dispositivos</a>
        <a href="<%= ctx %>/address" class="menu-item">Endereço</a>
    </nav>

    <div class="sidebar-bottom">
        <div class="account">
            <div class="avatar"><i data-lucide="user"></i></div>
            <span><%= escapeHtml(session.getAttribute("authName")) %></span>
        </div>

        <a href="<%= ctx %>/auth/logout" class="logout">
            <i data-lucide="log-out"></i>
            <span>Sair</span>
        </a>
    </div>
</aside>

<%-- Bloco da página: conteúdo principal. --%>
<main class="main">

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="crud-page" id="crudPage">

        <%-- Bloco da página: cabeçalho. --%>
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
                    <input id="searchInput" type="text" placeholder="Buscar">
                </div>

                <button class="crud-filter" type="button" title="Filtro">
                    <i data-lucide="funnel"></i>
                </button>
            </div>

            <button class="crud-add" type="button" onclick="startCreate()">
                <i data-lucide="circle-plus"></i>
                Adicionar Propriedade
            </button>
        </div>

        <div class="crud-table-wrap">
            <%-- Bloco da página: tabela de dados. --%>
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
                    for (Property property : properties) { %>
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
                <%  }
                } %>
                </tbody>
            </table>
        </div>
    </section>

    <%-- Bloco da página: seção de conteúdo. --%>
    <section class="crud-page" id="propertyFormPage" style="display: none;">

        <%-- Bloco da página: cabeçalho. --%>
        <header class="crud-form-header">
            <div>
                <h1 id="formPageTitle">Adicionar Propriedade</h1>
                <p>Registros e Dados das Propriedades</p>
            </div>
        </header>

        <%-- Bloco da página: formulário e envio de dados. --%>
        <form class="crud-form-card" id="propertyForm" novalidate>
            <div class="form-title" id="formTitle">Nova Propriedade</div>

            <div id="propertyValidation"
                 class="property-validation"
                 role="alert"
                 aria-live="polite">
                <strong>Verifique os seguintes campos:</strong>
                <ul id="propertyValidationList"></ul>
            </div>

            <div class="form-grid">
                <div class="crud-field">
                    <label for="name">Nome</label>
                    <input id="name" name="name" type="text">
                </div>

                <div class="crud-field">
                    <label for="type">Tipo</label>
                    <input id="type" name="type" type="text">
                </div>

                <div class="crud-field">
                    <label for="classification">Classificação</label>
                    <input id="classification" name="classification" type="text">
                </div>

                <div class="crud-field">
                    <label for="addressId">ID do Endereço</label>
                    <input id="addressId" name="addressId" type="number">
                </div>

                <div class="crud-field">
                    <label for="registrationDate">Data de Registro</label>
                    <input id="registrationDate" name="registrationDate"
                           type="date"
                           max="<%= java.time.LocalDate.now() %>">
                </div>
            </div>

            <div class="crud-form-actions">
                <button type="button" class="crud-cancel" onclick="cancelForm()">
                    Cancelar
                </button>
                <button type="submit" class="crud-save" id="saveButton">
                    Adicionar Propriedade
                </button>
            </div>
        </form>
    </section>

</main>

<div class="overlay" id="popupOverlay">
    <div class="popup">
        <button type="button" class="close" onclick="closePopup()">×</button>

        <div class="popup-content" id="popupSuccess">
            <div class="popup-icon success-icon">✓</div>
            <span class="popup-tag">Propriedades</span>
            <h2 id="popupSuccessTitle">Cadastro concluído!</h2>
            <p id="popupSuccessDesc">A operação foi realizada com sucesso.</p>

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

            <div class="region-delete-warning">
                <span class="warning-symbol">!</span>
                <div>
                    <strong>Atenção: exclusão de dados relacionados</strong>
                    As Taxas Regionais vinculadas a esta região também
                    serão excluídas. Essa ação não poderá ser desfeita.
                </div>
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

<%-- Bloco da página: código de interação executado pelo navegador. --%>
<script>
    const contextPath = "<%= ctx %>";
    const crudPage = document.getElementById("crudPage");
    const formPage = document.getElementById("propertyFormPage");
    const tableBody = document.getElementById("propertyTableBody");

    let editingId = null;
    let recordToDelete = null;
    let reloadAfterPopup = false;

    lucide.createIcons();

    function formatDate(value) {
        if (!value) return "";

        const text = String(value);

        if (/^\d{4}-\d{2}-\d{2}$/.test(text)) return text;

        const match = text.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
        if (match) return `${match[3]}-${match[2]}-${match[1]}`;

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
        const form = document.getElementById("propertyForm");

        form.reset();

        document.getElementById("propertyValidation").classList.remove("visible");
        document.getElementById("propertyValidationList").replaceChildren();

        form.querySelectorAll(".validation-error").forEach(field => {
            field.classList.remove("validation-error");
            field.removeAttribute("aria-invalid");
        });

        form.querySelectorAll(".validation-hint").forEach(hint => hint.remove());

        document.getElementById("formPageTitle").textContent =
            editing ? "Editar Propriedade" : "Adicionar Propriedade";

        document.getElementById("formTitle").textContent =
            editing ? "Editar dados da propriedade" : "Nova Propriedade";

        document.getElementById("saveButton").textContent =
            editing ? "Salvar alterações" : "Adicionar Propriedade";

        if (editing) {
            form.elements.name.value = property.name ?? "";
            form.elements.type.value = property.type ?? "";
            form.elements.classification.value = property.classification ?? "";
            form.elements.addressId.value = property.addressId ?? "";
            form.elements.registrationDate.value = property.registrationDate ?? "";
        }

        ["name", "type", "classification"].forEach(id => {
            const field = document.getElementById(id);

            field.oninput = function () {
                const start = this.selectionStart;
                const end = this.selectionEnd;

                this.value = this.value.toLocaleUpperCase("pt-BR");

                if (start !== null && end !== null) {
                    this.setSelectionRange(start, end);
                }
            };
        });

        form.onsubmit = saveForm;

        crudPage.style.display = "none";
        formPage.style.display = "block";

        lucide.createIcons();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function showValidationErrors(messages) {
        const box = document.getElementById("propertyValidation");
        const list = document.getElementById("propertyValidationList");

        list.replaceChildren();

        document.querySelectorAll("#propertyForm .validation-error")
            .forEach(field => {
                field.classList.remove("validation-error");
                field.removeAttribute("aria-invalid");
            });

        document.querySelectorAll("#propertyForm .validation-hint")
            .forEach(hint => hint.remove());

        messages.forEach(message => {
            const li = document.createElement("li");
            li.textContent = message;
            list.appendChild(li);
        });

        box.classList.add("visible");
        box.scrollIntoView({ behavior: "smooth", block: "center" });
    }

    function cancelForm() {
        formPage.style.display = "none";
        crudPage.style.display = "block";
        editingId = null;
    }

    async function saveForm(event) {
        event.preventDefault();

        const form = event.currentTarget;
        const params = new URLSearchParams(new FormData(form));

        ["name", "type", "classification"].forEach(key => {
            params.set(key, params.get(key).trim().toLocaleUpperCase("pt-BR"));
        });

        const isEdit = editingId !== null;
        let url = contextPath + "/property";
        let method = "POST";

        if (isEdit) {
            params.set("id", String(editingId));
            url += "?" + params.toString();
            method = "PUT";
        }

        try {
            const response = await fetch(url, {
                method,
                headers: isEdit
                    ? {}
                    : { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
                body: isEdit ? null : params.toString()
            });

            if (!response.ok) {
                const message = (await response.text()).trim();
                showValidationErrors([
                    message || "Não foi possível salvar. Verifique os dados informados."
                ]);
                return;
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
            showValidationErrors([
                "Não foi possível conectar ao servidor. Tente novamente."
            ]);
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
                const message = (await response.text()).trim();
                alert(message || "Não foi possível excluir a propriedade.");
                return;
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
