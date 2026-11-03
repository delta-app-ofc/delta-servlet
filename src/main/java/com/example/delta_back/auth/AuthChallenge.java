package com.example.delta_back.auth;

import java.io.Serial;
import java.io.Serializable;
import java.time.Instant;

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

    public void renew(String salt, String codeHash, Instant now) {
        this.salt = salt;
        this.codeHash = codeHash;
        this.expiresAt = now.plusSeconds(600);
        this.resendAfter = now.plusSeconds(60);
        this.attempts = 0;
    }

    public String getEmail() { return email; }
    public String getPurpose() { return purpose; }
    public boolean accountExists() { return accountExists; }
    public String getSalt() { return salt; }
    public String getCodeHash() { return codeHash; }
    public Instant getExpiresAt() { return expiresAt; }
    public Instant getResendAfter() { return resendAfter; }
    public int getAttempts() { return attempts; }
    public void countAttempt() { attempts++; }
    public boolean isExpired(Instant now) { return !now.isBefore(expiresAt); }
}
