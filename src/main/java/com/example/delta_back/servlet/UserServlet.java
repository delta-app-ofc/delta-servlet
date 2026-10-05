package com.example.delta_back.servlet;

// Importando a Conexão com o bd, a model e o crud.
import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.model.User;
import com.example.delta_back.crud.UserCrud;

// Jakartas
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;

import java.time.format.DateTimeFormatter; // Para interpretar String como Data


@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private Connection connection;
    private UserCrud userCrud;

    // Iniciar a conexão com o BD, e passar a conexão para o UserCrud
    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            userCrud = new UserCrud(connection);
        } catch (Exception e) {
            throw new ServletException("Erro ao conectar com o banco de dados.", e);
        }
    }


    // Consultar usuário - GET
    @Override
    protected void doGet(
            HttpServletRequest request, HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<User> users = userCrud.listarTodos();

            request.setAttribute("users", users);

            request.getRequestDispatcher("/user.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erro ao buscar usuários.", e);
        }
    }

    // Criar usuário - POST
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            String data = request.getParameter("birthdate");

            // Interpretando String como data (O java nao sabe o que é dia/mes/ano, entao a data virá como String e será convertida para data por conta do código abaixo.
            // O fluxo será:
            // String data -> DateTimeFormatter -> LocalDate.parse() -> LocalDate data
            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yyyy");

            LocalDate birthDate = LocalDate.parse(data, formatter);

            LocalDate registrationDate = LocalDate.now();
            Boolean is_active = Boolean.parseBoolean(request.getParameter("is_active"));
            Boolean is_admin = Boolean.parseBoolean(request.getParameter("is_admin"));
            Boolean is_manager = Boolean.parseBoolean(request.getParameter("is_manager"));

            User user = new User(0,
                    name,
                    email,
                    password,
                    phone,
                    birthDate,
                    registrationDate,
                    is_active,
                    is_admin,
                    is_manager
            );

            userCrud.inserir(user);

            response.sendRedirect(request.getContextPath() + "/user");

        } catch (Exception e) {
            throw new ServletException("Erro ao cadastrar usuário.", e);
        }
    }

    // Atualizar usuário - PUT
    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            String data = request.getParameter("birthdate");

            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yyyy");

            LocalDate birthDate = LocalDate.parse(data, formatter);

            LocalDate registrationDate =
                    LocalDate.parse(
                            request.getParameter("registration_date"),
                            formatter
                    );

            Boolean is_active =
                    Boolean.parseBoolean(request.getParameter("is_active"));

            Boolean is_admin =
                    Boolean.parseBoolean(request.getParameter("is_admin"));

            Boolean is_manager =
                    Boolean.parseBoolean(request.getParameter("is_manager"));

            User user = new User(
                    id,
                    name,
                    email,
                    password,
                    phone,
                    birthDate,
                    registrationDate,
                    is_active,
                    is_admin,
                    is_manager
            );

            userCrud.atualizar(user);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao atualizar usuário.", e);
        }
    }

    // DELETE
    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            userCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao deletar usuário...", e);
        }
    }

    // Fecha a conexão
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