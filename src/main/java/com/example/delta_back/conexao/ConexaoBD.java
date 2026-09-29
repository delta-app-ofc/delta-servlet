package com.example.delta_back.conexao;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoBD {

    private static final Dotenv dotenv = Dotenv.configure()
            .ignoreIfMissing()
            .load();

    private static final String HOST =
            dotenv.get("DB_HOST", System.getenv("DB_HOST"));

    private static final String PORT =
            dotenv.get("DB_PORT", System.getenv("DB_PORT"));

    private static final String DB_NAME =
            dotenv.get("DB_NAME", System.getenv("DB_NAME"));

    private static final String USUARIO =
            dotenv.get("DB_USER", System.getenv("DB_USER"));

    private static final String SENHA =
            dotenv.get("DB_PASSWORD", System.getenv("DB_PASSWORD"));

    private static final String URL =
            "jdbc:postgresql://" +
                    HOST + ":" +
                    PORT + "/" +
                    DB_NAME;

    public static Connection conectar() throws SQLException {
        return DriverManager.getConnection(
                URL,
                USUARIO,
                SENHA
        );
    }
}