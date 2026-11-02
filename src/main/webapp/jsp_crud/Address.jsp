<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.delta_back.model.Address" %>

<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";

        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    String ctx = request.getContextPath();

    List<Address> addresses =
            (List<Address>) request.getAttribute("addresses");

    if (addresses == null) {
        response.sendRedirect(ctx + "/address");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/imagens/FaviconDelta.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Endereços</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Address.css?v=20261101-sidebar-gota">
    <link rel="stylesheet" href="<%= ctx %>/css/css_crud/Pop-up.css">

    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        .address-validation {
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

        .address-validation.visible {
            display: block;
        }

        .address-validation strong {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
        }

        .address-validation ul {
            margin: 0;
            padding-left: 20px;
        }

        #addressForm .validation-error {
            border: 1px solid #dc2626 !important;
            outline: 1px solid #dc2626;
            background-color: #fffafa;
        }
    </style>
</head>

<body>

<aside class="sidebar">
    <img class="sidebar-drop" src="<%= ctx %>/imagens/Gota_Sidebar.png" alt="" aria-hidden="true">

    <div class="logo-area">
        <img src="<%= ctx %>/imagens/LogoDelta.png"
             alt="Logo Delta"
             id="logo">
    </div>

    <nav class="menu">
        <a href="<%= ctx %>/inicio" class="menu-item">Início</a>
        <a href="<%= ctx %>/user" class="menu-item">Usuários</a>
        <a href="<%= ctx %>/region" class="menu-item">Região</a>
        <a href="<%= ctx %>/regionrate" class="menu-item">Taxa Regional</a>
        <a href="<%= ctx %>/property" class="menu-item">Propriedades</a>
        <a href="<%= ctx %>/device" class="menu-item">Dispositivos</a>
        <a href="<%= ctx %>/address" class="menu-item active">Endereço</a>
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
                <h1>Endereço</h1>
                <p>Registros e Dados dos Endereços</p>
            </div>

            <div class="crud-header-right">
                <div class="crud-total">
                    <span>Total de Registros:</span>
                    <strong><%= addresses.size() %></strong>
                </div>
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
                Adicionar Endereço
            </button>
        </div>

        <div class="crud-table-wrap">
            <table class="crud-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>ID da região</th>
                    <th>CEP</th>
                    <th>Cidade</th>
                    <th>Estado</th>
                    <th></th>
                </tr>
                </thead>

                <tbody id="addressTableBody">

                <% if (addresses.isEmpty()) { %>
                <tr>
                    <td colspan="6">Nenhum endereço cadastrado.</td>
                </tr>
                <% } else {
                    for (Address address : addresses) { %>
                <tr class="address-row">
                    <td><%= address.getId() %></td>
                    <td><%= address.getRegionId() %></td>
                    <td><%= escapeHtml(address.getCep()) %></td>
                    <td><%= escapeHtml(address.getCity()) %></td>
                    <td><%= escapeHtml(address.getState()) %></td>

                    <td class="crud-actions-cell">
                        <button type="button"
                                class="crud-action edit-address"
                                title="Editar"
                                data-id="<%= address.getId() %>"
                                data-region-id="<%= address.getRegionId() %>"
                                data-cep="<%= escapeHtml(address.getCep()) %>"
                                data-city="<%= escapeHtml(address.getCity()) %>"
                                data-state="<%= escapeHtml(address.getState()) %>">
                            <i data-lucide="pencil"></i>
                        </button>

                        <button type="button"
                                class="crud-action delete"
                                title="Excluir"
                                onclick="deleteAddress(<%= address.getId() %>)">
                            <i data-lucide="trash-2"></i>
                        </button>
                    </td>
                </tr>
                <%  }
                } %>

                </tbody>
            </table>
        </div>

        <div id="addressFormPage"
             class="crud-form-page"
             style="display: none;">

            <header class="crud-form-header">
                <div>
                    <h1 id="formHeading">Adicionar Endereço</h1>
                    <p>Registros e Dados dos Endereços</p>
                </div>
            </header>

            <form id="addressForm" class="crud-form-card" novalidate>
                <div class="form-title" id="formTitle">Novo Endereço</div>

                <div id="addressValidation"
                     class="address-validation"
                     role="alert"
                     aria-live="polite">
                    <strong>Verifique os seguintes campos:</strong>
                    <ul id="addressValidationList"></ul>
                </div>

                <div class="form-grid">
                    <div class="crud-field">
                        <label for="regionId">ID da região</label>
                        <input type="text"
                               id="regionId"
                               name="regionId">
                    </div>

                    <div class="crud-field">
                        <label for="cep">CEP</label>
                        <input type="text"
                               id="cep"
                               name="cep"
                               placeholder="Somente 8 números">
                    </div>

                    <div class="crud-field">
                        <label for="city">Cidade</label>
                        <input type="text"
                               id="city"
                               name="city">
                    </div>

                    <div class="crud-field">
                        <label for="state">Estado</label>
                        <input type="text"
                               id="state"
                               name="state">
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
                        Adicionar Endereço
                    </button>
                </div>
            </form>
        </div>

    </section>
</main>

<div class="overlay" id="popupOverlay">
    <div class="popup">
        <button type="button"
                class="close"
                onclick="closePopup()">×</button>

        <div class="popup-content" id="popupSuccess">
            <div class="popup-icon success-icon">✓</div>
            <span class="popup-tag">Endereço</span>
            <h2 id="popupSuccessTitle">Cadastro concluído!</h2>
            <p id="popupSuccessDesc">
                O registro foi realizado com sucesso no sistema Delta.
            </p>

            <button type="button"
                    class="popup-primary"
                    onclick="closePopup(true)">
                OK, Entendido
            </button>

            <button type="button"
                    class="popup-secondary"
                    onclick="closePopup(true)">
                Voltar
            </button>
        </div>

        <div class="popup-content" id="popupDelete">
            <div class="popup-icon warning-icon">!</div>
            <span class="popup-tag danger-tag">Excluir Registro</span>
            <h2>Confirmar exclusão</h2>
            <p>Você tem certeza que deseja excluir este endereço?</p>

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
    const contextPath = "<%= ctx %>";

    let editingId = null;
    let recordToDelete = null;
    let redirectAfterPopup = false;

    const crudPage = document.getElementById("crudPage");
    const formPage = document.getElementById("addressFormPage");
    const addressForm = document.getElementById("addressForm");
    const searchInput = document.getElementById("searchInput");

    const pageHeader = crudPage.querySelector(".crud-header");
    const toolbar = crudPage.querySelector(".crud-toolbar");
    const tableWrap = crudPage.querySelector(".crud-table-wrap");

    lucide.createIcons();

    function startCreate() {
        editingId = null;

        addressForm.reset();
        clearValidation();

        document.getElementById("formHeading").textContent =
            "Adicionar Endereço";

        document.getElementById("formTitle").textContent =
            "Novo Endereço";

        document.getElementById("saveButton").textContent =
            "Adicionar Endereço";

        pageHeader.style.display = "none";
        toolbar.style.display = "none";
        tableWrap.style.display = "none";

        formPage.style.display = "block";

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function startEdit(button) {
        editingId = button.dataset.id;

        addressForm.reset();
        clearValidation();

        document.getElementById("regionId").value =
            button.dataset.regionId;

        document.getElementById("cep").value =
            button.dataset.cep;

        document.getElementById("city").value =
            button.dataset.city;

        document.getElementById("state").value =
            button.dataset.state;

        document.getElementById("formHeading").textContent =
            "Editar Endereço";

        document.getElementById("formTitle").textContent =
            "Editar dados do endereço";

        document.getElementById("saveButton").textContent =
            "Salvar alterações";

        pageHeader.style.display = "none";
        toolbar.style.display = "none";
        tableWrap.style.display = "none";

        formPage.style.display = "block";

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function cancelForm() {
        editingId = null;

        formPage.style.display = "none";

        pageHeader.style.display = "";
        toolbar.style.display = "";
        tableWrap.style.display = "";

        addressForm.reset();
        clearValidation();
    }

    function clearValidation() {
        const box = document.getElementById("addressValidation");
        const list = document.getElementById("addressValidationList");

        box.classList.remove("visible");
        list.replaceChildren();

        addressForm.querySelectorAll(".validation-error").forEach(field => {
            field.classList.remove("validation-error");
            field.removeAttribute("aria-invalid");
        });
    }

    function showValidationErrors(messages) {
        const box = document.getElementById("addressValidation");
        const list = document.getElementById("addressValidationList");

        list.replaceChildren();

        addressForm.querySelectorAll(".validation-error").forEach(field => {
            field.classList.remove("validation-error");
            field.removeAttribute("aria-invalid");
        });

        const fieldRules = [
            {
                id: "regionId",
                keywords: ["regionid", "região", "regiao"]
            },
            {
                id: "cep",
                keywords: ["cep"]
            },
            {
                id: "city",
                keywords: ["city", "cidade"]
            },
            {
                id: "state",
                keywords: ["state", "estado"]
            }
        ];

        messages.forEach(message => {
            const item = document.createElement("li");
            item.textContent = message;
            list.appendChild(item);

            const normalized = message.toLocaleLowerCase("pt-BR");

            const matchingField = fieldRules.find(rule =>
                rule.keywords.some(keyword => normalized.includes(keyword))
            );

            if (matchingField) {
                const field = document.getElementById(matchingField.id);
                field.classList.add("validation-error");
                field.setAttribute("aria-invalid", "true");
            }
        });

        box.classList.add("visible");
        box.scrollIntoView({ behavior: "smooth", block: "center" });

        const firstInvalid = addressForm.querySelector(".validation-error");

        if (firstInvalid) {
            firstInvalid.focus({ preventScroll: true });
        }
    }

    ["regionId", "cep", "city", "state"].forEach(id => {
        document.getElementById(id).addEventListener("input", function() {
            clearFieldError(this);
        });
    });

    function clearFieldError(field) {
        field.classList.remove("validation-error");
        field.removeAttribute("aria-invalid");

        const box = document.getElementById("addressValidation");
        const list = document.getElementById("addressValidationList");

        if (list.children.length === 0) {
            box.classList.remove("visible");
        }
    }

    addressForm.addEventListener("submit", async function(event) {
        event.preventDefault();

        clearValidation();

        const params = new URLSearchParams();

        params.append(
            "regionId",
            document.getElementById("regionId").value
        );

        params.append(
            "cep",
            document.getElementById("cep").value
        );

        params.append(
            "city",
            document.getElementById("city").value
        );

        params.append(
            "state",
            document.getElementById("state").value
        );

        const isEditing = editingId !== null;
        let url = contextPath + "/address";
        const method = isEditing ? "PUT" : "POST";

        if (isEditing) {
            params.append("id", editingId);
            url += "?" + params.toString();
        }

        const saveButton = document.getElementById("saveButton");
        saveButton.disabled = true;

        try {
            const response = await fetch(url, {
                method: method,
                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded;charset=UTF-8"
                },
                body: isEditing ? null : params.toString()
            });

            if (!response.ok) {
                const message = (await response.text()).trim();

                showValidationErrors([
                    message || "Não foi possível salvar o endereço."
                ]);

                return;
            }

            document.getElementById("popupSuccessTitle").textContent =
                isEditing ? "Alterações salvas!" : "Cadastro concluído!";

            document.getElementById("popupSuccessDesc").textContent =
                isEditing
                    ? "Os dados do endereço foram atualizados com sucesso no sistema Delta."
                    : "O novo endereço foi cadastrado com sucesso no sistema Delta.";

            redirectAfterPopup = true;
            showPopup("success");

            showToast(
                isEditing
                    ? "Endereço atualizado com sucesso."
                    : "Endereço cadastrado com sucesso.",
                isEditing ? "ALTERAÇÕES SALVAS" : "CADASTRO CONCLUÍDO",
                isEditing ? "edit" : "success"
            );

        } catch (error) {
            console.error(error);

            showValidationErrors([
                "Não foi possível conectar ao servidor. Tente novamente."
            ]);

        } finally {
            saveButton.disabled = false;
        }
    });

    document.querySelectorAll(".edit-address").forEach(button => {
        button.addEventListener("click", function() {
            startEdit(this);
        });
    });

    searchInput.addEventListener("input", function() {
        const query = this.value.toLowerCase().trim();

        document.querySelectorAll(".address-row").forEach(row => {
            row.style.display =
                row.textContent.toLowerCase().includes(query) ? "" : "none";
        });
    });

    function deleteAddress(id) {
        recordToDelete = id;
        redirectAfterPopup = false;

        document.getElementById("deleteRecordLabel").textContent =
            "ID #" + id;

        showPopup("delete");

        document.getElementById("confirmDeleteBtn").onclick =
            confirmDelete;
    }

    async function confirmDelete() {
        if (recordToDelete === null) return;

        const id = recordToDelete;
        const button = document.getElementById("confirmDeleteBtn");

        button.disabled = true;

        try {
            const response = await fetch(
                contextPath + "/address?id=" + encodeURIComponent(id),
                { method: "DELETE" }
            );

            if (!response.ok) {
                const message = (await response.text()).trim();

                closePopup();

                showToast(
                    message || "Não foi possível excluir o endereço.",
                    "ERRO NA EXCLUSÃO",
                    "delete"
                );

                return;
            }

            closePopup();

            showToast(
                "Endereço excluído com sucesso.",
                "REGISTRO EXCLUÍDO",
                "delete"
            );

            setTimeout(() => {
                window.location.href = contextPath + "/address";
            }, 700);

        } catch (error) {
            console.error(error);

            closePopup();

            showToast(
                "Não foi possível conectar ao servidor.",
                "ERRO NA EXCLUSÃO",
                "delete"
            );

        } finally {
            button.disabled = false;
        }
    }

    function showPopup(type) {
        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        if (type === "success") {
            document.getElementById("popupSuccess").classList.add("active");
        } else if (type === "delete") {
            document.getElementById("popupDelete").classList.add("active");
        }

        document.getElementById("popupOverlay").classList.add("show");
        document.body.classList.add("locked");
    }

    function closePopup(shouldRedirect = false) {
        document.getElementById("popupOverlay").classList.remove("show");
        document.body.classList.remove("locked");

        document.getElementById("popupSuccess").classList.remove("active");
        document.getElementById("popupDelete").classList.remove("active");

        recordToDelete = null;

        if (shouldRedirect && redirectAfterPopup) {
            window.location.href = contextPath + "/address";
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
</script>

</body>
</html>
