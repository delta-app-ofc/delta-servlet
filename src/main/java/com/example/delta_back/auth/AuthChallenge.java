// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.auth;

import java.io.Serial;
import java.io.Serializable;
import java.time.Instant;

// Documentação da classe AuthChallenge: reúne os dados e comportamentos deste tipo.
public final class AuthChallenge implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    public static final String REGISTER = "register";
    public static final String RESET = "reset";

    private final String email;
    private final String purpose;
    private final boolean accountExists;
    private String salt;
    private String codeHash;
    private Instant expiresAt;
    private Instant resendAfter;
    private int attempts;

    public AuthChallenge(String email, String purpose, boolean accountExists,
                         String salt, String codeHash, Instant now) {
        this.email = email;
        this.purpose = purpose;
        this.accountExists = accountExists;
        renew(salt, codeHash, now);
    }

    // Metodo: renew; executa a operacao renew neste componente.
    public void renew(String salt, String codeHash, Instant now) {
        this.salt = salt;
        this.codeHash = codeHash;
        this.expiresAt = now.plusSeconds(600);
        this.resendAfter = now.plusSeconds(60);
        this.attempts = 0;
    }

    // Metodo: get Email; retorna o valor do atributo Email.
    public String getEmail() { return email; }
    // Metodo: get Purpose; retorna o valor do atributo Purpose.
    public String getPurpose() { return purpose; }
    // Metodo: account Exists; executa a operacao account Exists neste componente.
    public boolean accountExists() { return accountExists; }
    // Metodo: get Salt; retorna o valor do atributo Salt.
    public String getSalt() { return salt; }
    // Metodo: get Code Hash; retorna o valor do atributo CodeHash.
    public String getCodeHash() { return codeHash; }
    // Metodo: get Expires At; retorna o valor do atributo ExpiresAt.
    public Instant getExpiresAt() { return expiresAt; }
    // Metodo: get Resend After; retorna o valor do atributo ResendAfter.
    public Instant getResendAfter() { return resendAfter; }
    // Metodo: get Attempts; retorna o valor do atributo Attempts.
    public int getAttempts() { return attempts; }
    // Metodo: count Attempt; executa a operacao count Attempt neste componente.
    public void countAttempt() { attempts++; }
    // Metodo: is Expired; verifica a condicao Expired.
    public boolean isExpired(Instant now) { return !now.isBefore(expiresAt); }
}
