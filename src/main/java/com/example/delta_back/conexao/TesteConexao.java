// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.conexao;

import java.sql.Connection;

// Documentação da classe TesteConexao: reúne os dados e comportamentos deste tipo.
public class TesteConexao {

    // Metodo: main; ponto de entrada desta execucao.
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