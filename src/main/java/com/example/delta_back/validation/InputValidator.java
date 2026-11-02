package com.example.delta_back.validation;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Locale;
import java.util.regex.Pattern;

public final class InputValidator {

    private static final Pattern NAME =
            Pattern.compile("^(?=.{2,100}$)\\p{Lu}[\\p{L}]*(?:[ '\\-][\\p{L}]+)*$");

    private static final Pattern EMAIL =
            Pattern.compile("^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+$");

    private static final Pattern PHONE =
            Pattern.compile("^(?:[0-9]{10,15}|\\+[0-9]{10,14})$");

    private static final Pattern PASSWORD =
            Pattern.compile(
                    "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)" +
                            "(?=.*[^\\w\\s])\\S{8,72}$"
            );

    private static final Pattern VERIFICATION_CODE =
            Pattern.compile("^[0-9]{6}$");

    private static final Pattern ID =
            Pattern.compile("^[1-9][0-9]{0,9}$");

    private static final Pattern DEVICE_ID =
            Pattern.compile("^[0-9]{6,15}$");

    // Aceita CEP com ou sem hífen: 02951120 ou 02951-120.
    private static final Pattern CEP =
            Pattern.compile("^[0-9]{5}-?[0-9]{3}$");

    private static final Pattern UPPERCASE_TEXT =
            Pattern.compile("^[\\p{Lu}\\p{N}][\\p{L}\\p{N} '\\-.,/()]*$");

    public static boolean isValidName(String value) {
        return value != null
                && NAME.matcher(value.trim()).matches();
    }

    public static boolean isValidEmail(String value) {
        return value != null
                && value.trim().length() <= 100
                && EMAIL.matcher(value.trim()).matches();
    }

    public static boolean isValidPhone(String value) {
        return value != null
                && PHONE.matcher(value).matches();
    }

    public static boolean isValidPassword(String value) {
        return value != null
                && PASSWORD.matcher(value).matches();
    }

    public static boolean isValidVerificationCode(String value) {
        return value != null
                && VERIFICATION_CODE.matcher(value.trim()).matches();
    }

    public static boolean isValidId(String value) {
        return value != null
                && ID.matcher(value.trim()).matches();
    }

    public static boolean isValidDeviceId(String value) {
        return value != null
                && DEVICE_ID.matcher(value.trim()).matches();
    }

    public static boolean isValidCep(String value) {
        return value != null
                && CEP.matcher(value.trim()).matches();
    }

    public static boolean isValidRequiredText(
            String value,
            int maxLength
    ) {
        return value != null
                && maxLength > 0
                && !value.trim().isEmpty()
                && value.trim().length() <= maxLength;
    }

    public static boolean isValidUppercaseText(
            String value,
            int maxLength
    ) {
        return isValidRequiredText(value, maxLength)
                && value.trim().equals(
                value.trim().toUpperCase(Locale.ROOT))
                && UPPERCASE_TEXT.matcher(value.trim()).matches();
    }

    public static String toUpperCase(String value) {
        return value == null
                ? null
                : value.trim().toUpperCase(Locale.ROOT);
    }

    public static boolean isValidPositiveValue(String value) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }

        try {
            return new BigDecimal(value.trim())
                    .compareTo(BigDecimal.ZERO) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isValidNonNegativeValue(String value) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }

        try {
            return new BigDecimal(value.trim())
                    .compareTo(BigDecimal.ZERO) >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isValidDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }

        try {
            LocalDate.parse(value.trim());
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static boolean isTodayOrEarlier(String value) {
        if (!isValidDate(value)) {
            return false;
        }

        return !LocalDate.parse(value.trim())
                .isAfter(LocalDate.now());
    }

    public static boolean isValidDateRange(
            String initialDate,
            String finalDate
    ) {
        if (!isValidDate(initialDate)) {
            return false;
        }

        if (finalDate == null || finalDate.trim().isEmpty()) {
            return true;
        }

        if (!isValidDate(finalDate)) {
            return false;
        }

        return !LocalDate.parse(finalDate.trim())
                .isBefore(LocalDate.parse(initialDate.trim()));
    }

    public static boolean isValidBoolean(String value) {
        return value != null
                && (
                value.trim().equalsIgnoreCase("true")
                        || value.trim().equalsIgnoreCase("false")
        );
    }

    private InputValidator() {
    }
}
