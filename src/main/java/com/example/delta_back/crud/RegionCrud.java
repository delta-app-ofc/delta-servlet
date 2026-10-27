package com.example.delta_back.crud;

import com.example.delta_back.model.Region;
import com.example.delta_back.dao.RegionDAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegionCrud implements RegionDAO {

    // Definindo a variavel para a conexão (JBDC)
    private final Connection connection;

    // Criando o objeto Implementação com a Variável Conexão
    public RegionCrud(Connection connection) {

        this.connection = connection;

    }

    // Metodo INSERIR - Inserir Dados
    @Override
    public void inserir(Region region) {
        // String sql = Código Que Vamos Usar No Sql
        String sql = """
                INSERT INTO tb_region
                (name)
                VALUES (?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, region.getName());

            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inserir região no banco de dados.", e);
        }
    }

    // Método para BUSCAR as informações pelo ID
    @Override
    public Region buscarPorId(int id) {

        String sql = """
                SELECT * FROM tb_region WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {

                if (resultado.next()) {

                    return new Region(
                            resultado.getInt("id"),
                            resultado.getString("name")
                    );

                }
            }

            // se nao der pra conectar
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;

    }

    // Método Para Listar TODOS
    @Override
    public List<Region> listarTodos() {

        String sql = """
                SELECT * FROM tb_region
                """;

        List<Region> regioes = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                Region region = new Region(
                        resultado.getInt("id"),
                        resultado.getString("name")
                );

                regioes.add(region);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return regioes;

    }

    // UPDATE
    // Atualizar todos os dados da região
    @Override
    public void atualizar(Region region) {

        String sql = """
                UPDATE tb_region
                SET name = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, region.getName());
            stmt.setInt(2, region.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Atualizar Nome
    @Override
    public void atualizarNome(Region region) {

        String sql = """
                UPDATE tb_region
                SET name = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, region.getName());
            stmt.setInt(2, region.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // DELETE
    // Deletar por ID

    @Override
    public void deletar(int id) {
        String sql = """
            DELETE FROM tb_region
            WHERE id = ?
            """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas == 0) {
                throw new IllegalArgumentException(
                        "A região não foi encontrada. Verifique o ID informado."
                );
            }

        } catch (SQLException e) {
            if ("23503".equals(e.getSQLState())) {
                throw new IllegalStateException(
                        "Não é possível excluir esta região porque ela está vinculada a outros registros.",
                        e
                );
            }

            throw new IllegalStateException(
                    "Erro ao excluir a região no banco de dados.",
                    e
            );
        }
    }


    // Deletar pelo Nome
    @Override
    public void deletarPorNome(String name) {

        String sql = """
                DELETE FROM tb_region
                WHERE name = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, name);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // EXIBIR DADOS -- Somente usado nos testes -- Não será usado so JSP
    public String exibirDados(Region region) {
        return "Região: " + region.getName() + "\n" +
                "Id: " + region.getId() + "\n";
    }

}
