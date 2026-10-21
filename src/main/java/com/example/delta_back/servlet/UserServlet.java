package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.crud.UserCrud;
import com.example.delta_back.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
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

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<User> users =
                    userCrud.listarTodos();

            request.setAttribute(
                    "users",
                    users
            );

            request.getRequestDispatcher(
                    "/user.jsp"
            ).forward(
                    request,
                    response
            );

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

        try {

            String name =
                    request.getParameter("name");

            String email =
                    request.getParameter("email");

            String password =
                    request.getParameter("password");

            String phone =
                    request.getParameter("phone");

            String birthdate =
                    request.getParameter("birthdate");

            LocalDate birthDate =
                    LocalDate.parse(birthdate);

            LocalDate registrationDate =
                    LocalDate.now();

            boolean isActive =
                    Boolean.parseBoolean(
                            request.getParameter("is_active")
                    );

            boolean isAdmin =
                    Boolean.parseBoolean(
                            request.getParameter("is_admin")
                    );

            boolean isManager =
                    Boolean.parseBoolean(
                            request.getParameter("is_manager")
                    );

            User user = new User(
                    0,
                    name,
                    email,
                    password,
                    phone,
                    birthDate,
                    registrationDate,
                    isActive,
                    isAdmin,
                    isManager
            );

            userCrud.inserir(user);

            response.sendRedirect(
                    request.getContextPath() + "/user"
            );

        } catch (Exception e) {

            e.printStackTrace();

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

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            User usuarioAtual = userCrud.buscarPorId(id);

            if (usuarioAtual == null) {
                response.sendError(
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

            if (password == null || password.isBlank()) {
                password = usuarioAtual.getPassword();
            }

            LocalDate birthDate = LocalDate.parse(birthdate);

            LocalDate registrationDate =
                    usuarioAtual.getRegistrationDate();

            String registrationDateParameter =
                    request.getParameter("registration_date");

            if (registrationDateParameter != null
                    && !registrationDateParameter.isBlank()) {
                registrationDate =
                        LocalDate.parse(registrationDateParameter);
            }

            boolean isActive = Boolean.parseBoolean(
                    request.getParameter("is_active")
            );

            boolean isAdmin = Boolean.parseBoolean(
                    request.getParameter("is_admin")
            );

            boolean isManager = Boolean.parseBoolean(
                    request.getParameter("is_manager")
            );

            User user = new User(
                    id,
                    name,
                    email,
                    password,
                    phone,
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

        } catch (Exception e) {
            e.printStackTrace();

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

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            userCrud.deletar(id);

            response.setStatus(
                    HttpServletResponse.SC_NO_CONTENT
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Erro ao deletar usuário.",
                    e
            );
        }
    }

    @Override
    public void destroy() {

        try {

            if (
                    connection != null &&
                            !connection.isClosed()
            ) {

                connection.close();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}