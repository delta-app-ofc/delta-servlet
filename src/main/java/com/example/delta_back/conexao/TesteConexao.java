package com.example.delta_back.conexao;

import java.sql.Connection;

public class TesteConexao {

    public static void main(String[] args) {

        try {
            Connection conexao = ConexaoBD.conectar();

            System.out.println("Conexão realizada com sucesso!");

            conexao.close();

        } catch (Exception e) {
            System.out.println("Erro ao conectar com o banco:");
            e.printStackTrace();
        }
    }
}