
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Delta - Endereços</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="<%= ctx %>/css/Address.css">
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
        <a href="<%= ctx %>/property" class="menu-item">Propriedades</a>
        <a href="<%= ctx %>/device" class="menu-item">Dispositivos</a>
        <a href="<%= ctx %>/address" class="menu-item active">Endereço</a>
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

                <% for (Address address : addresses) { %>
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
                <% } %>

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

            <form id="addressForm" class="crud-form-card">
                <div class="form-title" id="formTitle">Novo Endereço</div>

                <div class="form-grid">
                    <div class="crud-field">
                        <label for="regionId">ID da região</label>
                        <input type="number"
                               id="regionId"
                               name="regionId"
                               min="1"
                               required>
                    </div>

                    <div class="crud-field">
                        <label for="cep">CEP</label>
                        <input type="text"
                               id="cep"
                               name="cep"
                               required>
                    </div>

                    <div class="crud-field">
                        <label for="city">Cidade</label>
                        <input type="text"
                               id="city"
                               name="city"
                               required>
                    </div>

                    <div class="crud-field">
                        <label for="state">Estado</label>
                        <input type="text"
                               id="state"
                               name="state"
                               required>
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

    lucide.createIcons();

    function startCreate() {
        editingId = null;
        addressForm.reset();

        document.getElementById("formHeading").textContent =
            "Adicionar Endereço";

        document.getElementById("formTitle").textContent =
            "Novo Endereço";

        document.getElementById("saveButton").textContent =
            "Adicionar Endereço";

        crudPage.querySelector(".crud-header").style.display = "none";
        crudPage.querySelector(".crud-toolbar").style.display = "none";
        crudPage.querySelector(".crud-table-wrap").style.display = "none";

        formPage.style.display = "block";

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function startEdit(button) {
        editingId = button.dataset.id;

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

        crudPage.querySelector(".crud-header").style.display = "none";
        crudPage.querySelector(".crud-toolbar").style.display = "none";
        crudPage.querySelector(".crud-table-wrap").style.display = "none";

        formPage.style.display = "block";

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function cancelForm() {
        editingId = null;
        formPage.style.display = "none";

        crudPage.querySelector(".crud-header").style.display = "";
        crudPage.querySelector(".crud-toolbar").style.display = "";
        crudPage.querySelector(".crud-table-wrap").style.display = "";

        addressForm.reset();
    }

    addressForm.addEventListener("submit", async function(event) {
        event.preventDefault();

        const params = new URLSearchParams();

        params.append("regionId", document.getElementById("regionId").value);
        params.append("cep", document.getElementById("cep").value.trim());
        params.append("city", document.getElementById("city").value.trim());
        params.append("state", document.getElementById("state").value.trim());

        const isEditing = editingId !== null;
        let url = contextPath + "/address";
        let method = "POST";

        if (isEditing) {
            params.append("id", editingId);
            url += "?" + params.toString();
            method = "PUT";
        }

        try {
            const response = await fetch(url, {
                method: method,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                },
                body: isEditing ? null : params.toString()
            });

            if (!response.ok) {
                throw new Error("Não foi possível salvar o endereço.");
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
            alert("Erro ao salvar endereço. Verifique os dados e tente novamente.");
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
            row.style.display = row.textContent.toLowerCase().includes(query)
                ? ""
                : "none";
        });
    });

    function deleteAddress(id) {
        recordToDelete = id;
        redirectAfterPopup = false;

        document.getElementById("deleteRecordLabel").textContent =
            "ID #" + id;

        showPopup("delete");

        document.getElementById("confirmDeleteBtn").onclick =
            async function() {
                if (recordToDelete === null) return;

                try {
                    const response = await fetch(
                        contextPath + "/address?id=" +
                        encodeURIComponent(recordToDelete),
                        { method: "DELETE" }
                    );

                    if (!response.ok) {
                        throw new Error("Não foi possível excluir o endereço.");
                    }

                    closePopup();

                    showToast(
                        "Endereço excluído com sucesso.",
                        "REGISTRO EXCLUÍDO",
                        "delete"
                    );

                    setTimeout(() => window.location.reload(), 700);

                } catch (error) {
                    console.error(error);
                    alert("Erro ao excluir endereço.");
                }
            };
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
