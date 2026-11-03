// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.service;

import io.github.cdimascio.dotenv.Dotenv;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import jakarta.activation.DataHandler;
import jakarta.servlet.ServletContext;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/** Sends authentication codes through Gmail. */
// Documentação da classe EmailService: reúne os dados e comportamentos deste tipo.
public final class EmailService {

    private static final Path PROJECT_ROOT = findProjectRoot();
    private static final Dotenv DOTENV = Dotenv.configure()
            .directory(PROJECT_ROOT.toString())
            .ignoreIfMissing()
            .load();

    private EmailService() {}

    // Metodo: enviar Codigo; executa a operacao enviar Codigo neste componente.
    public static void enviarCodigo(ServletContext servletContext, String destinatario,
                                    String codigo, String finalidade)
            throws MessagingException, IOException {
        String email = config("EMAIL_USER");
        String senha = config("EMAIL_PASS");
        byte[] logo;
        try (InputStream input = servletContext.getResourceAsStream("/imagens/LogoDelta.png")) {
            if (input == null) {
                throw new IOException("LogoDelta.png não foi encontrada nos recursos da aplicação.");
            }
            logo = input.readAllBytes();
        }

        Properties propriedades = new Properties();
        propriedades.put("mail.smtp.auth", "true");
        propriedades.put("mail.smtp.starttls.enable", "true");
        propriedades.put("mail.smtp.starttls.required", "true");
        propriedades.put("mail.smtp.host", "smtp.gmail.com");
        propriedades.put("mail.smtp.port", "587");
        propriedades.put("mail.smtp.ssl.checkserveridentity", "true");
        propriedades.put("mail.smtp.connectiontimeout", "10000");
        propriedades.put("mail.smtp.timeout", "10000");
        propriedades.put("mail.smtp.writetimeout", "10000");

        Session sessao = Session.getInstance(propriedades, new Authenticator() {
            @Override
            // Metodo: get Password Authentication; retorna o valor do atributo PasswordAuthentication.
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(email, senha);
            }
        });

        MimeMessage mensagem = new MimeMessage(sessao);
        mensagem.setFrom(new InternetAddress(email, "Delta", StandardCharsets.UTF_8.name()));
        mensagem.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario, false));
        mensagem.setSubject("Código de verificação - Delta", "UTF-8");
        String texto = "Olá!\n\nSeu código para " + finalidade + " é: " + codigo
                + "\n\nO código expira em 10 minutos. Se você não solicitou este código, ignore este e-mail.";

        MimeBodyPart textoParte = new MimeBodyPart();
        textoParte.setText(texto, "UTF-8");

        MimeBodyPart htmlParte = new MimeBodyPart();
        htmlParte.setContent(conteudoHtml(codigo, finalidade), "text/html; charset=UTF-8");

        MimeBodyPart logoParte = new MimeBodyPart();
        logoParte.setDataHandler(new DataHandler(new ByteArrayDataSource(logo, "image/png")));
        logoParte.setHeader("Content-ID", "<logoDelta>");
        logoParte.setHeader("X-Attachment-Id", "logoDelta");
        logoParte.setDisposition(MimeBodyPart.INLINE);

        MimeMultipart relacionado = new MimeMultipart("related");
        relacionado.addBodyPart(htmlParte);
        relacionado.addBodyPart(logoParte);

        MimeBodyPart htmlComImagem = new MimeBodyPart();
        htmlComImagem.setContent(relacionado);

        MimeMultipart alternativo = new MimeMultipart("alternative");
        alternativo.addBodyPart(textoParte);
        alternativo.addBodyPart(htmlComImagem);

        mensagem.setContent(alternativo);
        Transport.send(mensagem);
    }

    // Metodo: conteudo Html; executa a operacao conteudo Html neste componente.
    private static String conteudoHtml(String codigo, String finalidade) {
        return """
                <!doctype html>
                <html lang="pt-BR">
                <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                </head>
                <body style="margin:0;padding:32px 12px;background-color:#e0e8f6;font-family:Arial,sans-serif;color:#20213f;">
                  <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="border-collapse:collapse;">
                    <tr><td align="center">
                      <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="max-width:520px;border-collapse:separate;border-spacing:0;background:#ffffff;border-radius:18px;overflow:hidden;">
                        <tr><td align="center" style="padding:24px;background:#003e9b;">
                          <img src="cid:logoDelta" width="150" alt="Delta" style="display:block;width:150px;max-width:100%%;height:auto;">
                        </td></tr>
                        <tr><td style="padding:30px 32px 34px;text-align:center;">
                          <h1 style="margin:0 0 12px;color:#003e9b;font-family:Poppins,Arial,sans-serif;font-size:23px;font-weight:600;">Código de verificação</h1>
                          <p style="margin:0 0 22px;color:#526078;font-family:Poppins,Arial,sans-serif;font-size:15px;line-height:1.6;">Use este código para %s.</p>
                          <div style="display:inline-block;padding:15px 26px;border:1px solid #d5e0f3;border-radius:12px;background:#f4f7fc;color:#003e9b;font-family:Poppins,Arial,sans-serif;font-size:32px;font-weight:700;letter-spacing:8px;">%s</div>
                          <p style="margin:22px 0 0;color:#526078;font-family:Poppins,Arial,sans-serif;font-size:13px;line-height:1.7;">O código expira em 10 minutos. Se você não solicitou este código, ignore esta mensagem.</p>
                        </td></tr>
                        <tr><td style="padding:14px 20px;background:#f4f7fc;text-align:center;color:#718096;font-family:Poppins,Arial,sans-serif;font-size:11px;">Delta · Cada gota inteligentemente controlada</td></tr>
                      </table>
                    </td></tr>
                  </table>
                </body>
                </html>
                """.formatted(escapeHtml(finalidade), escapeHtml(codigo));
    }

    // Metodo: escape Html; executa a operacao escape Html neste componente.
    private static String escapeHtml(String value) {
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    // Metodo: config; executa a operacao config neste componente.
    private static String config(String chave) {
        String vmOption = System.getProperty(chave);
        if (vmOption != null && !vmOption.isBlank()) return vmOption.trim();

        String env = System.getenv(chave);
        if (env != null && !env.isBlank()) return env.trim();

        String dotenv = DOTENV.get(chave);
        if (dotenv != null && !dotenv.isBlank()) return dotenv.trim();

        throw new IllegalStateException("Credencial de e-mail ausente: " + chave
                + ". Configure-a nas VM options ou no arquivo .env.");
    }

    // Metodo: find Project Root; executa a operacao find Project Root neste componente.
    private static Path findProjectRoot() {
        Path current = Path.of(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();
        for (Path directory = current; directory != null; directory = directory.getParent()) {
            if (Files.isRegularFile(directory.resolve("pom.xml"))) return directory;
        }
        return current;
    }
}
