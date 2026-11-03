// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
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

@WebServlet(urlPatterns = {"/auth/*", "/login", "/cadastro", "/recuperar-senha", "/conta", "/intro", "/landing-login"})
// Documentação da classe AuthServlet: reúne os dados e comportamentos deste tipo.
public class AuthServlet extends HttpServlet {

    private static final String CHALLENGE = "authChallenge";
    private static final String PENDING_REGISTRATION = "pendingRegistration";
    private static final String RESET_EMAIL = "resetEmail";
    private static final String RESET_VERIFIED_UNTIL = "resetVerifiedUntil";
    private static final String REGISTRATION_VERIFIED_UNTIL = "registrationVerifiedUntil";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    // Metodo: do Get; processa uma requisicao HTTP GET e prepara a resposta.
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String route = route(request);
        switch (route) {
            case "/auth/logout" -> logout(request, response);
            case "/intro" -> {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("authUserId") == null
                        || Boolean.TRUE.equals(session.getAttribute("authIsAdmin"))
                        || Boolean.TRUE.equals(session.getAttribute("authIsManager"))) {
                    response.sendRedirect(request.getContextPath() + "/login?role=user");
                    return;
                }
                forward(request, response, "/jsp_login e cadastro/Introducao.jsp");
            }
            case "/landing-login" -> {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("authUserId") == null
                        || Boolean.TRUE.equals(session.getAttribute("authIsAdmin"))
                        || Boolean.TRUE.equals(session.getAttribute("authIsManager"))) {
                    response.sendRedirect(request.getContextPath() + "/login?role=user");
                    return;
                }
                forward(request, response, "/LandingUsuario.jsp");
            }
            case "/login" -> {
                String loginPage = "admin".equalsIgnoreCase(request.getParameter("role"))
                        ? "/jsp_login e cadastro/EntrarContaADM.jsp"
                        : "/jsp_login e cadastro/EntrarContaUser.jsp";
                forward(request, response, loginPage);
            }
            case "/cadastro" -> {
                forward(request, response, "/jsp_login e cadastro/CriarConta.jsp");
            }
            case "/recuperar-senha" -> forward(request, response,
                    "/jsp_login e cadastro/RecuperarSenhaEmail.jsp");
            case "/conta" -> {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("authUserId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                if (Boolean.TRUE.equals(session.getAttribute("authIsAdmin"))
                        || Boolean.TRUE.equals(session.getAttribute("authIsManager"))) {
                    response.sendRedirect(request.getContextPath() + "/inicio");
                } else {
                    response.sendRedirect(request.getContextPath() + "/landing-login");
                }
            }
            case "/auth/verify-code" -> {
                if (request.getSession().getAttribute(CHALLENGE) == null) {
                    response.sendRedirect(request.getContextPath() + "/recuperar-senha");
                    return;
                }
                forward(request, response, "/jsp_login e cadastro/CodigoVerificacao.jsp");
            }
            case "/auth/edit-email" -> editVerificationEmail(request, response);
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
    // Metodo: do Post; processa os dados enviados por uma requisicao HTTP POST.
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

    // Metodo: login; valida as credenciais e inicia a sessao quando sao aceitas.
    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = normalizedEmail(request.getParameter("email"));
        String password = request.getParameter("password");
        String role = "admin".equalsIgnoreCase(request.getParameter("role")) ? "admin" : "user";
        if (!InputValidator.isValidEmail(email) || password == null || password.isEmpty()) {
            forwardError(request, response, loginPage(role),
                    "Informe um e-mail e uma senha vÃ¡lidos.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            User user = new UserCrud(connection).buscarPorEmail(email);
            if (user == null || !user.isActive() || !passwordMatches(password, user.getPassword())) {
                forwardError(request, response, loginPage(role),
                        "E-mail ou senha incorretos.");
                return;
            }

            boolean contaAdministrativa = user.isAdmin() || user.isManager();
            if (contaAdministrativa != "admin".equals(role)) {
                request.setAttribute("selectedLoginRole", role);
                forwardError(request, response, loginPage(role),
                        "Essa conta nÃ£o pertence ao perfil selecionado.");
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
            String destino = user.isAdmin() || user.isManager() ? "/inicio" : "/intro";
            response.sendRedirect(request.getContextPath() + destino);
        } catch (Exception e) {
            throw new ServletException("NÃ£o foi possÃ­vel entrar na conta.", e);
        }
    }

    // Metodo: register; executa a operacao register neste componente.
    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean admin = false;
        String registrationPage = "/jsp_login e cadastro/CriarConta.jsp";

        String name = request.getParameter("name");
        String email = normalizedEmail(request.getParameter("email"));
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        if (!InputValidator.isValidName(name) || !InputValidator.isValidEmail(email)
                || !InputValidator.isValidPhone(phone)
                || !InputValidator.isValidPassword(password)) {
            forwardError(request, response, registrationPage,
                    "Confira seu nome, telefone, e-mail e os requisitos da senha.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            UserCrud users = new UserCrud(connection);
            if (users.emailEmUso(email, 0)) {
                forwardError(request, response, registrationPage,
                        "Email jÃ¡ existente.");
                return;
            }
            String code = newCode();
            Instant now = Instant.now();
            HttpSession session = request.getSession(true);
            session.setAttribute(PENDING_REGISTRATION,
                    new PendingRegistration(name.trim(), email, password, phone.trim(), admin));
            session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            session.setAttribute(CHALLENGE, challenge(email, AuthChallenge.REGISTER,
                    true, code, now));
            EmailService.enviarCodigo(getServletContext(), email, code,
                    "confirmar a criaÃ§Ã£o da sua conta Delta");
            response.sendRedirect(request.getContextPath() + "/auth/verify-code");
        } catch (MessagingException | IOException | IllegalStateException e) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute(PENDING_REGISTRATION);
                session.removeAttribute(CHALLENGE);
                session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            }
            getServletContext().log("Falha ao enviar o cÃ³digo de cadastro por e-mail.", e);
            forwardError(request, response, registrationPage,
                    "NÃ£o foi possÃ­vel enviar o cÃ³digo agora. Tente novamente mais tarde.");
        } catch (Exception e) {
            throw new ServletException("NÃ£o foi possÃ­vel iniciar o cadastro.", e);
        }
    }

    // Metodo: start Password Recovery; executa a operacao start Password Recovery neste componente.
    private void startPasswordRecovery(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = normalizedEmail(request.getParameter("email"));
        if (!InputValidator.isValidEmail(email)) {
            forwardError(request, response, "/jsp_login e cadastro/RecuperarSenhaEmail.jsp",
                    "Informe um endereÃ§o de e-mail vÃ¡lido.");
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
            getServletContext().log("Falha ao enviar o cÃ³digo de recuperaÃ§Ã£o por e-mail.", e);
            forwardError(request, response, "/jsp_login e cadastro/RecuperarSenhaEmail.jsp",
                    "NÃ£o foi possÃ­vel concluir a solicitaÃ§Ã£o agora. Tente novamente mais tarde.");
        } catch (Exception e) {
            throw new ServletException("NÃ£o foi possÃ­vel iniciar a recuperaÃ§Ã£o de senha.", e);
        }
    }

    // Metodo: edit Verification Email; executa a operacao edit Verification Email neste componente.
    private void editVerificationEmail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        AuthChallenge challenge = session == null ? null : (AuthChallenge) session.getAttribute(CHALLENGE);
        String destination = "/recuperar-senha";

        if (session != null && challenge != null) {
            if (AuthChallenge.REGISTER.equals(challenge.getPurpose())) {
                PendingRegistration pending = (PendingRegistration) session.getAttribute(PENDING_REGISTRATION);
                if (pending != null) {
                    destination = "/cadastro?tipo=" + (pending.admin() ? "admin" : "usuario");
                }
                session.removeAttribute(PENDING_REGISTRATION);
                session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            } else if (AuthChallenge.RESET.equals(challenge.getPurpose())) {
                session.removeAttribute(RESET_EMAIL);
                session.removeAttribute(RESET_VERIFIED_UNTIL);
            }
            session.removeAttribute(CHALLENGE);
        }

        response.sendRedirect(request.getContextPath() + destination);
    }

    // Metodo: resend Code; executa a operacao resend Code neste componente.
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
                    "Aguarde um minuto antes de pedir outro cÃ³digo.");
            return;
        }

        String code = newCode();
        String salt = randomSalt();
        try {
            if (current.accountExists()) {
                EmailService.enviarCodigo(getServletContext(), current.getEmail(), code,
                        AuthChallenge.REGISTER.equals(current.getPurpose())
                                ? "confirmar a criaÃ§Ã£o da sua conta Delta"
                                : "redefinir sua senha Delta");
            }
            current.renew(salt, hashCode(salt, code), now);
            session.setAttribute(CHALLENGE, current);
            response.sendRedirect(request.getContextPath() + "/auth/verify-code");
        } catch (MessagingException | IOException | IllegalStateException e) {
            getServletContext().log("Falha ao reenviar o cÃ³digo por e-mail.", e);
            forwardError(request, response, "/jsp_login e cadastro/CodigoVerificacao.jsp",
                    "NÃ£o foi possÃ­vel reenviar o cÃ³digo agora. Tente novamente mais tarde.");
        }
    }

    // Metodo: verify Code; executa a operacao verify Code neste componente.
    private void verifyCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        AuthChallenge challenge = session == null ? null : (AuthChallenge) session.getAttribute(CHALLENGE);
        if (challenge == null || challenge.isExpired(Instant.now()) || challenge.getAttempts() >= 5) {
            if (session != null) session.removeAttribute(CHALLENGE);
            forwardError(request, response, "/jsp_login e cadastro/RecuperarSenhaEmail.jsp",
                    "O cÃ³digo expirou. Solicite um novo cÃ³digo.");
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

    // Metodo: reset Password; executa a operacao reset Password neste componente.
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
                    "A senha deve ter 8 a 72 caracteres, letras maiÃºscula e minÃºscula, nÃºmero e sÃ­mbolo, sem espaÃ§os.");
            return;
        }
        if (!password.equals(confirmation)) {
            forwardError(request, response, "/jsp_login e cadastro/RedefinirSenha.jsp",
                    "As senhas nÃ£o coincidem.");
            return;
        }

        String email = (String) session.getAttribute(RESET_EMAIL);
        try (var connection = ConexaoBD.conectar()) {
            new UserCrud(connection).atualizarSenhaPorEmail(email, password);
            session.removeAttribute(RESET_EMAIL);
            session.removeAttribute(RESET_VERIFIED_UNTIL);
            response.sendRedirect(request.getContextPath() + "/login?senhaAtualizada=1");
        } catch (Exception e) {
            throw new ServletException("NÃ£o foi possÃ­vel atualizar a senha.", e);
        }
    }

    // Metodo: complete Registration; executa a operacao complete Registration neste componente.
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

        String phone = pending.phone();
        String birthDateText = request.getParameter("birthdate");
        LocalDate birthDate;
        try {
            birthDate = LocalDate.parse(birthDateText);
            if (birthDate.isAfter(LocalDate.now().minusYears(18))) {
                throw new DateTimeParseException("menor de idade", birthDateText, 0);
            }
        } catch (Exception e) {
            forwardError(request, response, "/jsp_login e cadastro/CompletarCadastro.jsp",
                    "Informe uma data de nascimento vÃ¡lida.");
            return;
        }

        try (var connection = ConexaoBD.conectar()) {
            UserCrud users = new UserCrud(connection);
            if (users.contarContasComTelefone(phone, 0) >= 1) {
                forwardError(request, response, "/jsp_login e cadastro/CompletarCadastro.jsp",
                        "Esse número já está associado a outra conta. Use outro número.");
                return;
            }
            if (users.emailEmUso(pending.email(), 0)) {
                String page = pending.admin()
                        ? "/jsp_login e cadastro/CriarContaAdmin.jsp"
                        : "/jsp_login e cadastro/CriarContaUsuario.jsp";
                forwardError(request, response, page,
                        "Email jÃ¡ existente.");
                session.removeAttribute(PENDING_REGISTRATION);
                return;
            }
            User user = new User(0, pending.name(), pending.email(), pending.password(), phone.trim(),
                    birthDate, LocalDate.now(), true, pending.admin(), false);
            users.inserir(user);
            session.removeAttribute(PENDING_REGISTRATION);
            session.removeAttribute(REGISTRATION_VERIFIED_UNTIL);
            session.invalidate();

            User createdUser = users.buscarPorEmail(pending.email());
            if (createdUser == null || !createdUser.isActive()) {
                throw new IllegalStateException("A conta foi criada, mas nÃ£o foi possÃ­vel iniciar a sessÃ£o.");
            }

            HttpSession authenticatedSession = request.getSession(true);
            authenticatedSession.setAttribute("authUserId", createdUser.getId());
            authenticatedSession.setAttribute("authName", createdUser.getName());
            authenticatedSession.setAttribute("authEmail", createdUser.getEmail());
            authenticatedSession.setAttribute("authIsAdmin", createdUser.isAdmin());
            authenticatedSession.setAttribute("authIsManager", createdUser.isManager());

            String destination = createdUser.isAdmin() || createdUser.isManager()
                    ? "/inicio"
                    : "/intro";
            response.sendRedirect(request.getContextPath() + destination);
        } catch (Exception e) {
            throw new ServletException("NÃ£o foi possÃ­vel concluir o cadastro.", e);
        }
    }

    // Metodo: logout; encerra a sessao atual.
    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.sendRedirect(request.getContextPath() + "/Landing.jsp");
    }

    // Metodo: challenge; executa a operacao challenge neste componente.
    private static AuthChallenge challenge(String email, String purpose, boolean exists,
                                           String code, Instant now) {
        String salt = randomSalt();
        return new AuthChallenge(email, purpose, exists, salt, hashCode(salt, code), now);
    }

    // Metodo: hash Code; verifica a condicao hCode.
    private static String hashCode(String salt, String code) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256")
                    .digest((salt + ":" + code).getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (Exception e) {
            throw new IllegalStateException("NÃ£o foi possÃ­vel proteger o cÃ³digo.", e);
        }
    }

    // Metodo: random Salt; executa a operacao random Salt neste componente.
    private static String randomSalt() {
        byte[] bytes = new byte[16];
        RANDOM.nextBytes(bytes);
        return HexFormat.of().formatHex(bytes);
    }

    // Metodo: new Code; executa a operacao new Code neste componente.
    private static String newCode() {
        return String.format(Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
    }

    // Metodo: normalized Email; executa a operacao normalized Email neste componente.
    private static String normalizedEmail(String email) {
        return email == null ? null : email.trim().toLowerCase(Locale.ROOT);
    }

    // Metodo: password Matches; executa a operacao password Matches neste componente.
    private static boolean passwordMatches(String raw, String hash) {
        try {
            return hash != null && BCrypt.checkpw(raw, hash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    // Metodo: has Active Grant; verifica a condicao ActiveGrant.
    private static boolean hasActiveGrant(HttpSession session, String attribute) {
        Object value = session.getAttribute(attribute);
        return value instanceof Long expiry && Instant.now().toEpochMilli() < expiry;
    }

    // Metodo: forward Error; executa a operacao forward Error neste componente.
    private void forwardError(HttpServletRequest request, HttpServletResponse response,
                              String page, String error) throws ServletException, IOException {
        request.setAttribute("authError", error);
        forward(request, response, page);
    }

    // Metodo: forward; executa a operacao forward neste componente.
    private void forward(HttpServletRequest request, HttpServletResponse response, String page)
            throws ServletException, IOException {
        request.getRequestDispatcher(page).forward(request, response);
    }

    // Metodo: route; executa a operacao route neste componente.
    private String route(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null) return "/auth" + pathInfo;
        return request.getRequestURI().substring(request.getContextPath().length());
    }

    // Metodo: login Page; executa a operacao login Page neste componente.
    private String loginPage(String role) {
        return "admin".equals(role)
                ? "/jsp_login e cadastro/EntrarContaADM.jsp"
                : "/jsp_login e cadastro/EntrarContaUser.jsp";
    }

    // Documentação da classe PendingRegistration: reúne os dados e comportamentos deste tipo.
    // Metodo: Pending Registration; executa a operacao Pending Registration neste componente.
    private record PendingRegistration(String name, String email, String password,
                                       String phone, boolean admin)
            implements java.io.Serializable {}
}



