
package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.crud.UserCrud;
import com.example.delta_back.model.User;
import com.example.delta_back.validation.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private Connection connection;
    private UserCrud userCrud;

    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            userCrud = new UserCrud(connection);
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao conectar com o banco de dados.",
                    e
            );
        }
    }

    private void enviarErro(
            HttpServletResponse response,
            int status,
            String mensagem
    ) throws IOException {
        response.setStatus(status);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(mensagem);
    }

    private int validarId(String valor) {
        if (!InputValidator.isValidId(valor)) {
            throw new IllegalArgumentException(
                    "ID inválido."
            );
        }

        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "ID fora do limite permitido."
            );
        }
    }

    private LocalDate validarDataNascimento(String valor) {
        if (valor == null || valor.isBlank()) {
            throw new IllegalArgumentException(
                    "A data de nascimento é obrigatória."
            );
        }

        try {
            LocalDate data = LocalDate.parse(valor);

            if (data.isAfter(LocalDate.now().minusYears(18))) {
                throw new IllegalArgumentException(
                        "O usuário precisa ter pelo menos 18 anos."
                );
            }

            return data;
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(
                    "A data de nascimento é inválida."
            );
        }
    }

    private void validarLimiteTelefone(String telefone, int ignorarId) {
        if (userCrud.contarContasComTelefone(telefone, ignorarId) >= 1) {
            throw new IllegalArgumentException(
                    "Esse número já está associado a outra conta. Use outro número."
            );
        }
    }

    private void validarDados(
            String name,
            String email,
            String password,
            String phone,
            boolean validarSenha
    ) {
        if (!InputValidator.isValidName(name)) {
            throw new IllegalArgumentException(
                    "Nome inválido. Informe de 2 a 100 caracteres e comece com letra maiúscula."
            );
        }

        if (!InputValidator.isValidEmail(email)) {
            throw new IllegalArgumentException(
                    "E-mail inválido. Informe um endereço de e-mail válido."
            );
        }

        if (!InputValidator.isValidPhone(phone)) {
            throw new IllegalArgumentException(
                    "Telefone inválido. Use de 10 a 15 dígitos, com código do país opcional."
            );
        }

        if (validarSenha && !InputValidator.isValidPassword(password)) {
            throw new IllegalArgumentException(
                    "A senha deve ter de 8 a 72 caracteres, com letra maiúscula, minúscula, número e símbolo, sem espaços."
            );
        }
    }

    private boolean validarBooleano(String valor, String campo) {
        if (!InputValidator.isValidBoolean(valor)) {
            throw new IllegalArgumentException(
                    "O campo \"" + campo + "\" deve ser verdadeiro ou falso."
            );
        }

        return Boolean.parseBoolean(valor);
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            List<User> users = userCrud.listarTodos();

            request.setAttribute("users", users);

            request.getRequestDispatcher("/jsp_crud/User.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao buscar usuários.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String birthdate = request.getParameter("birthdate");

            validarDados(name, email, password, phone, true);
            if (userCrud.emailEmUso(email, 0)) {
                throw new IllegalArgumentException("Já existe um usuário com esse e-mail.");
            }
            validarLimiteTelefone(phone, 0);

            LocalDate birthDate =
                    validarDataNascimento(birthdate);

            LocalDate registrationDate = LocalDate.now();

            boolean isActive = validarBooleano(
                    request.getParameter("is_active"),
                    "Status"
            );

            boolean isAdmin = validarBooleano(
                    request.getParameter("is_admin"),
                    "Administrador"
            );

            boolean isManager = validarBooleano(
                    request.getParameter("is_manager"),
                    "Gerente"
            );

            User user = new User(
                    0,
                    name.trim(),
                    email.trim(),
                    password,
                    phone.trim(),
                    birthDate,
                    registrationDate,
                    isActive,
                    isAdmin,
                    isManager
            );

            userCrud.inserir(user);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao cadastrar usuário.",
                    e
            );
        }
    }

    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String idParameter = request.getParameter("id");
            int id = validarId(idParameter);

            User usuarioAtual = userCrud.buscarPorId(id);

            if (usuarioAtual == null) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "Usuário não encontrado."
                );
                return;
            }

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String birthdate = request.getParameter("birthdate");

            boolean validarSenha =
                    password != null && !password.isBlank();

            if (!validarSenha) {
                password = usuarioAtual.getPassword();
            }

            validarDados(
                    name,
                    email,
                    password,
                    phone,
                    validarSenha
            );
            if (userCrud.emailEmUso(email, id)) {
                throw new IllegalArgumentException("Já existe um usuário com esse e-mail.");
            }
            validarLimiteTelefone(phone, id);

            LocalDate birthDate =
                    validarDataNascimento(birthdate);

            LocalDate registrationDate =
                    usuarioAtual.getRegistrationDate();

            boolean isActive = validarBooleano(
                    request.getParameter("is_active"),
                    "Status"
            );

            boolean isAdmin = validarBooleano(
                    request.getParameter("is_admin"),
                    "Administrador"
            );

            boolean isManager = validarBooleano(
                    request.getParameter("is_manager"),
                    "Gerente"
            );

            User user = new User(
                    id,
                    name.trim(),
                    email.trim(),
                    password,
                    phone.trim(),
                    birthDate,
                    registrationDate,
                    isActive,
                    isAdmin,
                    isManager
            );

            userCrud.atualizar(user);

            response.setStatus(
                    HttpServletResponse.SC_NO_CONTENT
            );

        } catch (IllegalArgumentException e) {
            enviarErro(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao atualizar usuário.",
                    e
            );
        }
    }

    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            String idParameter = request.getParameter("id");
            int id = validarId(idParameter);

            User usuarioAtual = userCrud.buscarPorId(id);

            if (usuarioAtual == null) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "Usuário não encontrado."
                );
                return;
            }

            HttpSession session = request.getSession(false);
            Object loggedInUserId = session == null ? null : session.getAttribute("authUserId");
            boolean deletingLoggedInUser = loggedInUserId instanceof Number number
                    ? number.longValue() == id
                    : loggedInUserId != null
                    && Integer.toString(id).equals(loggedInUserId.toString().trim());

            userCrud.deletar(id);

            if (deletingLoggedInUser) {
                response.setHeader("X-Session-Invalidated", "true");
                session.invalidate();
            }

            response.setStatus(
                    HttpServletResponse.SC_NO_CONTENT
            );

        } catch (IllegalArgumentException e) {
            enviarErro(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao deletar usuário.",
                    e
            );
        }
    }

    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
