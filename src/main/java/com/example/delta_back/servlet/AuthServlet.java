package com.example.delta_back.servlet;

import com.example.delta_back.auth.AuthChallenge;
import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.crud.UserCrud;
import com.example.delta_back.model.User;
import com.example.delta_back.service.EmailService;
import com.example.delta_back.validation.InputValidator;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HexFormat;
import java.util.Locale;

@WebServlet(urlPatterns = {"/auth/*", "/login", "/cadastro", "/recuperar-senha", "/conta"})
public class AuthServlet extends HttpServlet {

    private static final String CHALLENGE = "authChallenge";
    private static final String PENDING_REGISTRATION = "pendingRegistration";
    private static final String RESET_EMAIL = "resetEmail";
    private static final String RESET_VERIFIED_UNTIL = "resetVerifiedUntil";
    private static final String REGISTRATION_VERIFIED_UNTIL = "registrationVerifiedUntil";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String route = route(request);
        switch (route) {
            case "/auth/logout" -> logout(request, response);
            case "/login" -> forward(request, response, "/jsp_login e cadastro/EntrarConta.jsp");
            case "/cadastro" -> {
                String tipo = request.getParameter("tipo");
                String page = "admin".equalsIgnoreCase(tipo)
                        ? "/jsp_login e cadastro/CriarContaAdmin.jsp"
                        : "usuario".equalsIgnoreCase(tipo)
                        ? "/jsp_login e cadastro/CriarContaUsuario.jsp"
                        : "/jsp_login e cadastro/CriarConta.jsp";
                forward(request, response, page);
            }
            case "/recuperar-senha" -> forward(request, response,
                    "/jsp_login e cadastro/RecuperarSenhaEmail.jsp");
            case "/conta" -> {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("authUserId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                forward(request, response, "/jsp_login e cadastro/ContaUsuario.jsp");
            }
            case "/auth/verify-code" -> {
                if (request.getSession().getAttribute(CHALLENGE) == null) {
                    response.sendRedirect(request.getContextPath() + "/recuperar-senha");
                    return;
                }
                forward(request, response, "/jsp_login e cadastro/CodigoVerificacao.jsp");
            }
            case "/auth/reset-password" -> {
                if (!hasActiveGrant(request.getSession(), RESET_VERIFIED_UNTIL)) {
                    response.sendRedirect(request.getContextPath() + "/recuperar-senha");
                    return;
                }
                forward(request, response, "/jsp_login e cadastro/RedefinirSenha.jsp");
            }
            case "/auth/complete-registration" -> {
                if (!hasActiveGrant(request.getSession(), REGISTRATION_VERIFIED_UNTIL)
                        || request.getSession().getAttribute(PENDING_REGISTRATION) == null) {
                    response.sendRedirect(request.getContextPath() + "/cadastro");
                    return;
                }
                forward(request, response, "/jsp_login e cadastro/CompletarCadastro.jsp");
            }
            default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String route = route(request);
        switch (route) {
            case "/auth/login" -> login(request, response);
            case "/auth/register" -> register(request, response);
            case "/auth/forgot-password" -> startPasswordRecovery(request, response);
            case "/auth/resend-code" -> resendCode(request, response);
            case "/auth/verify-code" -> verifyCode(request, response);
            case "/auth/reset-password" -> resetPassword(request, response);
            case "/auth/complete-registration" -> completeRegistration(request, response);
            case "/auth/logout" -> logout(request, response);
            default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = normalizedEmail(request.getParameter("email"));
        String password = request.getParameter("password");
        if (!InputValidator.isValidEmail(email) || password == null || password.isEmpty()) {
            forwardError(request, response, "/jsp_login e cadastro/EntrarConta.jsp",
                    "Informe um e-mail e uma senha válidos.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            User user = new UserCrud(connection).buscarPorEmail(email);
            if (user == null || !user.isActive() || !passwordMatches(password, user.getPassword())) {
                forwardError(request, response, "/jsp_login e cadastro/EntrarConta.jsp",
                        "E-mail ou senha incorretos.");
                return;
            }

            HttpSession session = request.getSession(true);
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("authUserId", user.getId());
            session.setAttribute("authName", user.getName());
            session.setAttribute("authEmail", user.getEmail());
            session.setAttribute("authIsAdmin", user.isAdmin());
            session.setAttribute("authIsManager", user.isManager());
            String destino = user.isAdmin() || user.isManager() ? "/inicio" : "/conta";
            response.sendRedirect(request.getContextPath() + destino);
        } catch (Exception e) {
            throw new ServletException("Não foi possível entrar na conta.", e);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        boolean admin = "admin".equalsIgnoreCase(tipo);
        String registrationPage = admin
                ? "/jsp_login e cadastro/CriarContaAdmin.jsp"
                : "usuario".equalsIgnoreCase(tipo)
                ? "/jsp_login e cadastro/CriarContaUsuario.jsp"
                : "/jsp_login e cadastro/CriarConta.jsp";

        String name = request.getParameter("name");
        String email = normalizedEmail(request.getParameter("email"));
        String password = request.getParameter("password");
        if (!InputValidator.isValidName(name) || !InputValidator.isValidEmail(email)
                || !InputValidator.isValidPassword(password)) {
            forwardError(request, response, registrationPage,
                    "Confira seu nome, e-mail e os requisitos da senha.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            UserCrud users = new UserCrud(connection);
            if (users.emailEmUso(email, 0)) {
                forwardError(request, response, registrationPage,
                        "Email já existente.");
                return;
            }
            String code = newCode();
            Instant now = Instant.now();
            HttpSession session = request.getSession(true);
            session.setAttribute(PENDING_REGISTRATION,
                    new PendingRegistration(name.trim(), email, password, admin));
            session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            session.setAttribute(CHALLENGE, challenge(email, AuthChallenge.REGISTER,
                    true, code, now));
            EmailService.enviarCodigo(getServletContext(), email, code,
                    "confirmar a criação da sua conta Delta");
            response.sendRedirect(request.getContextPath() + "/auth/verify-code");
        } catch (MessagingException | IOException | IllegalStateException e) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute(PENDING_REGISTRATION);
                session.removeAttribute(CHALLENGE);
                session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            }
            getServletContext().log("Falha ao enviar o código de cadastro por e-mail.", e);
            forwardError(request, response, registrationPage,
                    "Não foi possível enviar o código agora. Tente novamente mais tarde.");
        } catch (Exception e) {
            throw new ServletException("Não foi possível iniciar o cadastro.", e);
        }
    }

    private void startPasswordRecovery(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = normalizedEmail(request.getParameter("email"));
        if (!InputValidator.isValidEmail(email)) {
            forwardError(request, response, "/jsp_login e cadastro/RecuperarSenhaEmail.jsp",
                    "Informe um endereço de e-mail válido.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            User user = new UserCrud(connection).buscarPorEmail(email);
            boolean exists = user != null && user.isActive();
            String code = newCode();
            Instant now = Instant.now();
            HttpSession session = request.getSession(true);
            session.removeAttribute(RESET_EMAIL);
            session.removeAttribute(RESET_VERIFIED_UNTIL);
            session.setAttribute(CHALLENGE, challenge(email, AuthChallenge.RESET, exists, code, now));
            if (exists) {
                EmailService.enviarCodigo(getServletContext(), email, code, "redefinir sua senha Delta");
            }
            response.sendRedirect(request.getContextPath() + "/auth/verify-code");
        } catch (MessagingException | IOException | IllegalStateException e) {
            HttpSession session = request.getSession(false);
            if (session != null) session.removeAttribute(CHALLENGE);
            getServletContext().log("Falha ao enviar o código de recuperação por e-mail.", e);
            forwardError(request, response, "/jsp_login e cadastro/RecuperarSenhaEmail.jsp",
                    "Não foi possível concluir a solicitação agora. Tente novamente mais tarde.");
        } catch (Exception e) {
            throw new ServletException("Não foi possível iniciar a recuperação de senha.", e);
        }
    }

    private void resendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        AuthChallenge current = session == null ? null : (AuthChallenge) session.getAttribute(CHALLENGE);
        if (current == null || current.isExpired(Instant.now())) {
            if (session != null) session.removeAttribute(CHALLENGE);
            response.sendRedirect(request.getContextPath() + "/recuperar-senha");
            return;
        }
        Instant now = Instant.now();
        if (now.isBefore(current.getResendAfter())) {
            forwardError(request, response, "/jsp_login e cadastro/CodigoVerificacao.jsp",
                    "Aguarde um minuto antes de pedir outro código.");
            return;
        }

        String code = newCode();
        String salt = randomSalt();
        try {
            if (current.accountExists()) {
                EmailService.enviarCodigo(getServletContext(), current.getEmail(), code,
                        AuthChallenge.REGISTER.equals(current.getPurpose())
                                ? "confirmar a criação da sua conta Delta"
                                : "redefinir sua senha Delta");
            }
            current.renew(salt, hashCode(salt, code), now);
            session.setAttribute(CHALLENGE, current);
            response.sendRedirect(request.getContextPath() + "/auth/verify-code");
        } catch (MessagingException | IOException | IllegalStateException e) {
            getServletContext().log("Falha ao reenviar o código por e-mail.", e);
            forwardError(request, response, "/jsp_login e cadastro/CodigoVerificacao.jsp",
                    "Não foi possível reenviar o código agora. Tente novamente mais tarde.");
        }
    }

    private void verifyCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        AuthChallenge challenge = session == null ? null : (AuthChallenge) session.getAttribute(CHALLENGE);
        if (challenge == null || challenge.isExpired(Instant.now()) || challenge.getAttempts() >= 5) {
            if (session != null) session.removeAttribute(CHALLENGE);
            forwardError(request, response, "/jsp_login e cadastro/RecuperarSenhaEmail.jsp",
                    "O código expirou. Solicite um novo código.");
            return;
        }

        String code = request.getParameter("code");
        challenge.countAttempt();
        boolean valid = challenge.accountExists()
                && InputValidator.isValidVerificationCode(code)
                && MessageDigest.isEqual(hashCode(challenge.getSalt(), code).getBytes(StandardCharsets.US_ASCII),
                challenge.getCodeHash().getBytes(StandardCharsets.US_ASCII));
        if (!valid) {
            session.setAttribute(CHALLENGE, challenge);
            forwardError(request, response, "/jsp_login e cadastro/CodigoVerificacao.jsp",
                    "Código inválido ou expirado.");
            return;
        }

        session.removeAttribute(CHALLENGE);
        if (AuthChallenge.RESET.equals(challenge.getPurpose())) {
            session.setAttribute(RESET_EMAIL, challenge.getEmail());
            session.setAttribute(RESET_VERIFIED_UNTIL, Instant.now().plusSeconds(600).toEpochMilli());
            response.sendRedirect(request.getContextPath() + "/auth/reset-password");
        } else {
            session.setAttribute(REGISTRATION_VERIFIED_UNTIL, Instant.now().plusSeconds(1800).toEpochMilli());
            response.sendRedirect(request.getContextPath() + "/auth/complete-registration");
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !hasActiveGrant(session, RESET_VERIFIED_UNTIL)) {
            response.sendRedirect(request.getContextPath() + "/recuperar-senha");
            return;
        }
        String password = request.getParameter("password");
        String confirmation = request.getParameter("confirmPassword");
        if (!InputValidator.isValidPassword(password)) {
            forwardError(request, response, "/jsp_login e cadastro/RedefinirSenha.jsp",
                    "A senha deve ter 8 a 72 caracteres, letras maiúscula e minúscula, número e símbolo, sem espaços.");
            return;
        }
        if (!password.equals(confirmation)) {
            forwardError(request, response, "/jsp_login e cadastro/RedefinirSenha.jsp",
                    "As senhas não coincidem.");
            return;
        }

        String email = (String) session.getAttribute(RESET_EMAIL);
        try (var connection = ConexaoBD.conectar()) {
            new UserCrud(connection).atualizarSenhaPorEmail(email, password);
            session.removeAttribute(RESET_EMAIL);
            session.removeAttribute(RESET_VERIFIED_UNTIL);
            response.sendRedirect(request.getContextPath() + "/login?senhaAtualizada=1");
        } catch (Exception e) {
            throw new ServletException("Não foi possível atualizar a senha.", e);
        }
    }

    private void completeRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !hasActiveGrant(session, REGISTRATION_VERIFIED_UNTIL)) {
            response.sendRedirect(request.getContextPath() + "/cadastro");
            return;
        }
        PendingRegistration pending = (PendingRegistration) session.getAttribute(PENDING_REGISTRATION);
        if (pending == null) {
            response.sendRedirect(request.getContextPath() + "/cadastro");
            return;
        }

        String phone = request.getParameter("phone");
        String birthDateText = request.getParameter("birthdate");
        if (!InputValidator.isValidPhone(phone)) {
            forwardError(request, response, "/jsp_login e cadastro/CompletarCadastro.jsp",
                    "Informe um telefone de 10 a 15 dígitos, com código do país opcional.");
            return;
        }
        LocalDate birthDate;
        try {
            birthDate = LocalDate.parse(birthDateText);
            if (birthDate.isAfter(LocalDate.now())) throw new DateTimeParseException("futura", birthDateText, 0);
        } catch (Exception e) {
            forwardError(request, response, "/jsp_login e cadastro/CompletarCadastro.jsp",
                    "Informe uma data de nascimento válida.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            UserCrud users = new UserCrud(connection);
            if (users.contarContasComTelefone(phone, 0) >= 2) {
                forwardError(request, response, "/jsp_login e cadastro/CompletarCadastro.jsp",
                        "Esse número já está associado a duas contas. Use outro número.");
                return;
            }
            if (users.emailEmUso(pending.email(), 0)) {
                String page = pending.admin()
                        ? "/jsp_login e cadastro/CriarContaAdmin.jsp"
                        : "/jsp_login e cadastro/CriarContaUsuario.jsp";
                forwardError(request, response, page,
                        "Email já existente.");
                session.removeAttribute(PENDING_REGISTRATION);
                return;
            }
            User user = new User(0, pending.name(), pending.email(), pending.password(), phone.trim(),
                    birthDate, LocalDate.now(), true, pending.admin(), false);
            users.inserir(user);
            session.removeAttribute(PENDING_REGISTRATION);
            session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?cadastro=concluido");
        } catch (Exception e) {
            throw new ServletException("Não foi possível concluir o cadastro.", e);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private static AuthChallenge challenge(String email, String purpose, boolean exists,
                                           String code, Instant now) {
        String salt = randomSalt();
        return new AuthChallenge(email, purpose, exists, salt, hashCode(salt, code), now);
    }

    private static String hashCode(String salt, String code) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256")
                    .digest((salt + ":" + code).getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (Exception e) {
            throw new IllegalStateException("Não foi possível proteger o código.", e);
        }
    }

    private static String randomSalt() {
        byte[] bytes = new byte[16];
        RANDOM.nextBytes(bytes);
        return HexFormat.of().formatHex(bytes);
    }

    private static String newCode() {
        return String.format(Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
    }

    private static String normalizedEmail(String email) {
        return email == null ? null : email.trim().toLowerCase(Locale.ROOT);
    }

    private static boolean passwordMatches(String raw, String hash) {
        try {
            return hash != null && BCrypt.checkpw(raw, hash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    private static boolean hasActiveGrant(HttpSession session, String attribute) {
        Object value = session.getAttribute(attribute);
        return value instanceof Long expiry && Instant.now().toEpochMilli() < expiry;
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response,
                              String page, String error) throws ServletException, IOException {
        request.setAttribute("authError", error);
        forward(request, response, page);
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String page)
            throws ServletException, IOException {
        request.getRequestDispatcher(page).forward(request, response);
    }

    private String route(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null) return "/auth" + pathInfo;
        return request.getRequestURI().substring(request.getContextPath().length());
    }

    private record PendingRegistration(String name, String email, String password, boolean admin)
            implements java.io.Serializable {}
}
