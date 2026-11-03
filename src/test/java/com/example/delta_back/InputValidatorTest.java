
// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.validation;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

// Documentação da classe InputValidatorTest: reúne os dados e comportamentos deste tipo.
class InputValidatorTest {

    @Test
    void testName() {
        assertTrue(InputValidator.isValidName("Gabriel Ribeiro"));
        assertTrue(InputValidator.isValidName("João Silva"));
        assertFalse(InputValidator.isValidName("Gabriel123"));
        assertFalse(InputValidator.isValidName(""));
    }

    @Test
    void testEmail() {
        assertTrue(InputValidator.isValidEmail("gabriel@example.com"));
        assertFalse(InputValidator.isValidEmail("gabriel@"));
        assertFalse(InputValidator.isValidEmail("email-invalido"));
    }

    @Test
    void testPhone() {
        assertTrue(InputValidator.isValidPhone("11987654321"));
        assertTrue(InputValidator.isValidPhone("+5511987654321"));
        assertFalse(InputValidator.isValidPhone("123"));
        assertFalse(InputValidator.isValidPhone("11abc123456"));
    }

    @Test
    void testPassword() {
        assertTrue(InputValidator.isValidPassword("Delta@2026"));
        assertFalse(InputValidator.isValidPassword("senha123"));
        assertFalse(InputValidator.isValidPassword("DELTA@2026"));
        assertFalse(InputValidator.isValidPassword("Del@1"));
    }

    @Test
    void testVerificationCode() {
        assertTrue(InputValidator.isValidVerificationCode("123456"));
        assertFalse(InputValidator.isValidVerificationCode("12345"));
        assertFalse(InputValidator.isValidVerificationCode("1234567"));
        assertFalse(InputValidator.isValidVerificationCode("12A456"));
    }

    @Test
    void testId() {
        assertTrue(InputValidator.isValidId("123"));
        assertFalse(InputValidator.isValidId("0"));
        assertFalse(InputValidator.isValidId("-1"));
        assertFalse(InputValidator.isValidId("abc"));
    }
}
