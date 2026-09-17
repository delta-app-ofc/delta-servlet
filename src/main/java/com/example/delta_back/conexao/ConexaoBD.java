package com.example.delta_back.conexao;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoBD {

    private static final Dotenv dotenv = Dotenv.load();

    private static final String URL =
            "jdbc:postgresql://" +
                    dotenv.get("DB_HOST") + ":" +
                    dotenv.get("DB_PORT") + "/" +
                    dotenv.get("DB_NAME");

    private static final String USUARIO = dotenv.get("DB_USER");
    private static final String SENHA = dotenv.get("DB_PASSWORD");

    public static Connection connect() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USUARIO, SENHA);
        } catch (SQLException err){
            throw new RuntimeException("Erro ao conectar ao banco de dados", err);
        }
    }
}