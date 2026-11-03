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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/account/*")
public class AccountServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        String sql = "CREATE TABLE IF NOT EXISTS tb_user_notification_preferences (user_id INTEGER PRIMARY KEY REFERENCES tb_user(id) ON DELETE CASCADE, reports BOOLEAN NOT NULL DEFAULT FALSE, news BOOLEAN NOT NULL DEFAULT FALSE, events BOOLEAN NOT NULL DEFAULT FALSE)";
        try (Connection connection = ConexaoBD.conectar(); var statement = connection.createStatement()) {
            statement.execute(sql);
        } catch (SQLException e) {
            throw new ServletException("Não foi possível preparar as preferências de notificação no banco.", e);
        }
    }
    private Integer authenticatedUserId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Object rawId = session == null ? null : session.getAttribute("authUserId");
        if (!(rawId instanceof Number id)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }
        return id.intValue();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = authenticatedUserId(request, response);
        if (userId == null) return;
        String route = request.getPathInfo();
        if (!"/notifications".equals(route)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String sql = "SELECT reports, news, events FROM tb_user_notification_preferences WHERE user_id = ?";
        try (Connection connection = ConexaoBD.conectar(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet result = statement.executeQuery()) {
                boolean reports = false, news = false, events = false;
                if (result.next()) {
                    reports = result.getBoolean("reports");
                    news = result.getBoolean("news");
                    events = result.getBoolean("events");
                }
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().printf("{\"reports\":%s,\"news\":%s,\"events\":%s}", reports, news, events);
            }
        } catch (SQLException e) {
            throw new IOException("Não foi possível carregar as preferências de notificação.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        Integer userId = authenticatedUserId(request, response);
        if (userId == null) return;
        String route = request.getPathInfo();
        try (Connection connection = ConexaoBD.conectar()) {
            UserCrud users = new UserCrud(connection);
            User user = users.buscarPorId(userId);
            if (user == null || !user.isActive()) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            switch (route == null ? "" : route) {
                case "/profile" -> updateProfile(request, response, users, user);
                case "/password" -> updatePassword(request, response, users, user);
                case "/notifications" -> updateNotifications(request, response, connection, userId);
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            throw new ServletException("Erro ao acessar o banco de dados da conta.", e);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, UserCrud users, User user) throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        if (!InputValidator.isValidName(name) || !InputValidator.isValidEmail(email)) {
            throw new IllegalArgumentException("Informe um nome e um e-mail válidos.");
        }
        if (users.emailEmUso(email, user.getId())) {
            throw new IllegalArgumentException("Esse e-mail já está associado a outra conta.");
        }
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase(java.util.Locale.ROOT));
        users.atualizar(user);
        HttpSession session = request.getSession(false);
        session.setAttribute("authName", user.getName());
        session.setAttribute("authEmail", user.getEmail());
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response, UserCrud users, User user) throws IOException {
        String password = request.getParameter("password");
        if (!InputValidator.isValidPassword(password)) {
            throw new IllegalArgumentException("A senha deve ter 8 a 72 caracteres, incluindo maiúscula, minúscula, número e símbolo.");
        }
        user.setPassword(password);
        users.atualizarPassword(user);
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    private void updateNotifications(HttpServletRequest request, HttpServletResponse response, Connection connection, int userId) throws SQLException {
        boolean reports = parseBoolean(request.getParameter("reports"));
        boolean news = parseBoolean(request.getParameter("news"));
        boolean events = parseBoolean(request.getParameter("events"));
        String sql = """
                INSERT INTO tb_user_notification_preferences (user_id, reports, news, events)
                VALUES (?, ?, ?, ?)
                ON CONFLICT (user_id) DO UPDATE SET reports = EXCLUDED.reports, news = EXCLUDED.news, events = EXCLUDED.events
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setBoolean(2, reports);
            statement.setBoolean(3, news);
            statement.setBoolean(4, events);
            statement.executeUpdate();
        }
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    private boolean parseBoolean(String value) {
        if (!InputValidator.isValidBoolean(value)) throw new IllegalArgumentException("Preferência inválida.");
        return Boolean.parseBoolean(value);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Integer userId = authenticatedUserId(request, response);
        if (userId == null) return;
        try (Connection connection = ConexaoBD.conectar()) {
            new UserCrud(connection).deletar(userId);
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (SQLException e) {
            throw new ServletException("Não foi possível excluir a conta.", e);
        } catch (RuntimeException e) {
            throw new ServletException("Não foi possível excluir a conta.", e);
        }
    }
}



