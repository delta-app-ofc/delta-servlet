<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Device" %>

<%!
    public String escapeHtml(Object value) {
        if (value == null) return "";

        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    public String formatDate(Object value) {
        if (value == null) return "";

        String date = value.toString();

        if (date.matches("\\d{4}-\\d{2}-\\d{2}")) {
            String[] parts = date.split("-");
            return parts[2] + "/" + parts[1] + "/" + parts[0];
        }

        return date;
    }

    public String toInputDate(Object value) {
        if (value == null) return "";

        String date = value.toString();

        if (date.matches("\\d{2}/\\d{2}/\\d{4}")) {
            String[] parts = date.split("/");
            return parts[2] + "-" + parts[1] + "-" + parts[0];
        }

        return date;
    }
%>

<%
    String ctx = request.getContextPath();

    List<Device> devices =
            (List<Device>) request.getAttribute("devices");

    if (devices == null) {
        response.sendRedirect(ctx + "/device");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Dispositivos</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Device.css">
    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Pop-up.css">

    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        [hidden] {
            display: none !important;
        }

        .validation-errors {
            display: none;
            margin: 0 0 22px;
            padding: 16px 20px;
            border: 1px solid #e05252;
            border-left: 5px solid #d93636;
            border-radius: 8px;
            background: #fff3f3;
            color: #a32121;
            font-family: 'Poppins', sans-serif;
        }

        .validation-errors.visible {
            display: block;
        }

        .validation-errors strong {
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
        }

        .validation-errors ul {
            margin: 0;
            padding-left: 20px;
            font-size: 13px;
        }

        .crud-field input.invalid,
        .crud-field select.invalid {
            border: 1px solid #d93636 !important;
            outline: 1px solid #d93636;
            background-color: #fff8f8;
        }

        .crud-field .field-error {
            display: block;
            margin-top: 5px;
            color: #c62828;
            font-size: 12px;
        }

        .crud-field .field-error:empty {
            display: none;
        }

        .crud-save:disabled,
        .popup-danger:disabled {
            opacity: .6;
            cursor: wait;
        }
    </style>
</head>

<body>

<aside class="sidebar">
    <div class="logo-area">
        <img src="<%= ctx %>/imagens/LogoDelta.png"
             alt="Logo Delta" id="logo">
    </div>

    <nav class="menu">
        <a href="<%= ctx %>/inicio" class="menu-item">Início</a>
        <a href="<%= ctx %>/user" class="menu-item">Usuários</a>
        <a href="<%= ctx %>/region" class="menu-item">Região</a>
        <a href="<%= ctx %>/regionrate" class="menu-item">Taxa Regional</a>
        <a href="<%= ctx %>/property" class="menu-item">Propriedades</a>
        <a href="<%= ctx %>/device" class="menu-item active">Dispositivos</a>
        <a href="<%= ctx %>/address" class="menu-item">Endereço</a>
    </nav>

    <div class="sidebar-bottom">
        <div class="account">
            <div class="avatar">
                <i data-lucide="user"></i>
            </div>
            <span><%= escapeHtml(session.getAttribute("authName")) %></span>
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
                <h1>Dispositivos</h1>
                <p>Registros e Dados dos Dispositivos</p>
            </div>

            <div class="crud-total">
                <span>Total de Registros:</span>
                <strong><%= devices.size() %></strong>
            </div>
        </header>

        <div class="crud-toolbar">
            <div class="crud-search-area">
                <div class="crud-search">
                    <i data-lucide="search"></i>
                    <input type="text"
                           id="searchInput"
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
                Adicionar Dispositivo
            </button>
        </div>

        <div class="crud-table-wrap">
            <table class="crud-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>ID do Dispositivo</th>
                    <th>ID da Propriedade</th>
                    <th>Ativo</th>
                    <th>Data de Instalação</th>
                    <th></th>
                </tr>
                </thead>

                <tbody id="deviceTableBody">
                <% if (devices.isEmpty()) { %>
                <tr>
                    <td colspan="6" class="crud-empty">
                        Nenhum dispositivo cadastrado.
                    </td>
                </tr>
                <% } else {
                    for (Device device : devices) { %>
                <tr class="device-row">
                    <td><%= device.getId() %></td>

                    <td><%= escapeHtml(device.getDeviceId()) %></td>

                    <td><%= device.getPropertyId() %></td>

                    <td><%= device.isActive() ? "Sim" : "Não" %></td>

                    <td><%= escapeHtml(formatDate(device.getInstallationDate())) %></td>

                    <td class="crud-actions-cell">
                        <button type="button"
                                class="crud-action"
                                title="Editar"
                                data-id="<%= device.getId() %>"
                                data-device-id="<%= escapeHtml(device.getDeviceId()) %>"
                                data-property-id="<%= device.getPropertyId() %>"
                                data-active="<%= device.isActive() %>"
                                data-date="<%= escapeHtml(toInputDate(device.getInstallationDate())) %>"
                                onclick="editRecord(this)">
                            <i data-lucide="pencil"></i>
                        </button>

                        <button type="button"
                                class="crud-action delete"
                                title="Excluir"
                                data-id="<%= device.getId() %>"
                                onclick="deleteRecord(this.dataset.id)">
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

    <section class="crud-form-page" id="deviceFormPage" hidden>
        <header class="crud-form-header">
            <div>
                <h1 id="formHeading">Adicionar Dispositivo</h1>
                <p>Registros e Dados dos Dispositivos</p>
            </div>
        </header>

        <form class="crud-form-card" id="deviceForm" novalidate>
            <div class="form-title" id="formTitle">
                Novo Dispositivo
            </div>

            <div class="validation-errors"
                 id="validationErrors"
                 role="alert"
                 aria-live="polite">
                <strong>Verifique os seguintes campos:</strong>
                <ul id="validationList"></ul>
            </div>

            <div class="form-grid">
                <div class="crud-field">
                    <label for="deviceId">ID do Dispositivo</label>
                    <input type="text"
                           id="deviceId"
                           name="deviceId"
                           autocomplete="off">
                    <small class="field-error" id="deviceIdError"></small>
                </div>

                <div class="crud-field">
                    <label for="propertyId">ID da Propriedade</label>
                    <input type="text"
                           id="propertyId"
                           name="propertyId">
                    <small class="field-error" id="propertyIdError"></small>
                </div>

                <div class="crud-field">
                    <label for="active">Ativo</label>
                    <select id="active" name="active">
                        <option value="">Selecione</option>
                        <option value="true">Sim</option>
                        <option value="false">Não</option>
                    </select>
                    <small class="field-error" id="activeError"></small>
                </div>

                <div class="crud-field">
                    <label for="installationDate">Data de Instalação</label>
                    <input type="date"
                           id="installationDate"
                           name="installationDate"
                           max="<%= java.time.LocalDate.now() %>">
                    <small class="field-error" id="installationDateError"></small>
                </div>
            </div>

            <div class="crud-form-actions">
                <button type="button"
                        class="crud-cancel"
                        onclick="cancelForm()">
                    Cancelar
                </button>

                <button type="submit"
                        class="crud-save"
                        id="saveButton">
                    Adicionar Dispositivo
                </button>
            </div>
        </form>
    </section>

</main>

<div class="overlay" id="popupOverlay">
    <div class="popup">
        <button type="button"
                class="close"
                onclick="closePopup()">×</button>

        <div class="popup-content" id="popupSuccess">
            <div class="popup-icon success-icon">✓</div>

            <span class="popup-tag" id="popupSuccessTag">Dispositivos</span>

            <h2 id="popupSuccessTitle">Cadastro concluído!</h2>

            <p id="popupSuccessDesc">
                O registro foi realizado com sucesso no sistema Delta.
            </p>

            <button type="button"
                    class="popup-primary"
                    onclick="closePopup()">
                OK, Entendido
            </button>

            <button type="button"
                    class="popup-secondary"
                    onclick="closePopup()">
                Voltar
            </button>
        </div>

        <div class="popup-content" id="popupDelete">
            <div class="popup-icon warning-icon">!</div>

            <span class="popup-tag danger-tag">Excluir Registro</span>

            <h2>Confirmar exclusão</h2>

            <p>Você tem certeza que deseja excluir este dispositivo?</p>

            <div class="selected-record">
                <span>REGISTRO SELECIONADO</span>
                <strong id="deleteRecordLabel">ID #--</strong>
            </div>

            <div class="delete-actions">
                <button type="button"
                        class="popup-secondary"
                        onclick="closePopup()">
                    Cancelar
                </button>

                <button type="button"
                        class="popup-danger"
                        id="confirmDeleteBtn">
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
    lucide.createIcons();

    const contextPath = "<%= ctx %>";

    const crudPage = document.getElementById("crudPage");
    const formPage = document.getElementById("deviceFormPage");
    const deviceForm = document.getElementById("deviceForm");
    const validationBox = document.getElementById("validationErrors");
    const validationList = document.getElementById("validationList");

    let editingId = null;
    let recordToDelete = null;
    let reloadAfterPopup = false;
    let submitting = false;
    let deleting = false;

    function startCreate() {
        editingId = null;
        deviceForm.reset();
        clearValidation();

        document.getElementById("formHeading").textContent =
            "Adicionar Dispositivo";

        document.getElementById("formTitle").textContent =
            "Novo Dispositivo";

        document.getElementById("saveButton").textContent =
            "Adicionar Dispositivo";

        crudPage.hidden = true;
        formPage.hidden = false;

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function editRecord(button) {
        editingId = button.dataset.id;

        deviceForm.reset();
        clearValidation();

        document.getElementById("deviceId").value =
            button.dataset.deviceId;

        document.getElementById("propertyId").value =
            button.dataset.propertyId;

        document.getElementById("active").value =
            button.dataset.active;

        document.getElementById("installationDate").value =
            button.dataset.date;

        document.getElementById("formHeading").textContent =
            "Editar Dispositivo";

        document.getElementById("formTitle").textContent =
            "Editar dados do dispositivo";

        document.getElementById("saveButton").textContent =
            "Salvar alterações";

        crudPage.hidden = true;
        formPage.hidden = false;

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function cancelForm() {
        editingId = null;
        deviceForm.reset();
        clearValidation();

        formPage.hidden = true;
        crudPage.hidden = false;

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function clearValidation() {
        validationList.replaceChildren();
        validationBox.classList.remove("visible");

        document.querySelectorAll(".crud-field input, .crud-field select")
            .forEach(field => {
                field.classList.remove("invalid");
                field.removeAttribute("aria-invalid");
            });

        document.querySelectorAll(".field-error").forEach(error => {
            error.textContent = "";
        });
    }

    function showValidationErrors(messages) {
        clearValidation();

        messages.forEach(message => {
            const item = document.createElement("li");
            item.textContent = message;
            validationList.appendChild(item);
        });

        validationBox.classList.add("visible");

        validationBox.scrollIntoView({
            behavior: "smooth",
            block: "center"
        });
    }

    async function readErrorMessage(response) {
        const message = (await response.text()).trim();

        return message || "Não foi possível concluir a operação. Confira os dados e tente novamente.";
    }

    deviceForm.addEventListener("submit", async function(event) {
        event.preventDefault();

        if (submitting) return;

        clearValidation();
        submitting = true;

        const saveButton = document.getElementById("saveButton");
        saveButton.disabled = true;

        const params = new URLSearchParams();

        params.append(
            "deviceId",
            document.getElementById("deviceId").value
        );

        params.append(
            "propertyId",
            document.getElementById("propertyId").value
        );

        params.append(
            "active",
            document.getElementById("active").value
        );

        params.append(
            "installationDate",
            document.getElementById("installationDate").value
        );

        const isEditing = editingId !== null;

        if (isEditing) {
            params.append("id", editingId);
        }

        try {
            const url = contextPath + "/device" +
                (isEditing ? "?" + params.toString() : "");

            const response = await fetch(url, {
                method: isEditing ? "PUT" : "POST",
                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded;charset=UTF-8"
                },
                body: isEditing ? null : params.toString()
            });

            if (!response.ok) {
                showValidationErrors([
                    await readErrorMessage(response)
                ]);
                return;
            }

            showPopup(
                "success",
                isEditing
                    ? "Alterações salvas!"
                    : "Cadastro concluído!",
                isEditing
                    ? "Os dados do dispositivo foram atualizados com sucesso."
                    : "O novo dispositivo foi cadastrado com sucesso."
            );

            reloadAfterPopup = true;

        } catch (error) {
            console.error(error);

            showValidationErrors([
                "Não foi possível conectar ao servidor. Tente novamente."
            ]);

        } finally {
            submitting = false;
            saveButton.disabled = false;
        }
    });

    function deleteRecord(id) {
        recordToDelete = id;

        document.getElementById("deleteRecordLabel").textContent =
            "ID #" + id;

        showPopup("delete");

        document.getElementById("confirmDeleteBtn").onclick =
            confirmDelete;
    }

    async function confirmDelete() {
        if (recordToDelete === null || deleting) return;

        deleting = true;

        const confirmButton =
            document.getElementById("confirmDeleteBtn");

        confirmButton.disabled = true;

        try {
            const response = await fetch(
                contextPath + "/device?id=" +
                encodeURIComponent(recordToDelete),
                { method: "DELETE" }
            );

            if (!response.ok) {
                const message = await readErrorMessage(response);
                closePopup();

                showToast(message, "Não foi possível excluir", "delete");
                return;
            }

            recordToDelete = null;
            closePopup();

            showToast(
                "Dispositivo excluído com sucesso.",
                "Registro excluído",
                "delete"
            );

            setTimeout(() => {
                window.location.href = contextPath + "/device";
            }, 700);

        } catch (error) {
            console.error(error);

            closePopup();

            showToast(
                "Não foi possível conectar ao servidor.",
                "Erro",
                "delete"
            );

        } finally {
            deleting = false;
            confirmButton.disabled = false;
        }
    }

    function showPopup(type, title = "", description = "") {
        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        if (type === "success") {
            document.getElementById("popupSuccessTitle").textContent = title;
            document.getElementById("popupSuccessDesc").textContent = description;
            document.getElementById("popupSuccess").classList.add("active");
        } else {
            document.getElementById("popupDelete").classList.add("active");
        }

        document.body.classList.add("locked");
        document.getElementById("popupOverlay").classList.add("show");
    }

    function closePopup() {
        document.getElementById("popupOverlay").classList.remove("show");
        document.body.classList.remove("locked");

        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        recordToDelete = null;

        if (reloadAfterPopup) {
            reloadAfterPopup = false;
            window.location.href = contextPath + "/device";
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

        setTimeout(hideToast, 4000);
    }

    function hideToast() {
        document.getElementById("globalToast").classList.remove("show");
    }

    document.getElementById("searchInput").addEventListener("input", function() {
        const query = this.value.toLowerCase();

        document.querySelectorAll(".device-row").forEach(row => {
            row.hidden = !row.textContent.toLowerCase().includes(query);
        });
    });
</script>

</body>
</html>
