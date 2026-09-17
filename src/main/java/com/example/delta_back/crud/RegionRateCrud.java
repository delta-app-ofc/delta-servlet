package com.example.delta_back.crud;

import com.example.delta_back.dao.RegionRate_DAO;
import com.example.delta_back.model.Region_Rate;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RegionRateCrud implements RegionRate_DAO {

    // Definindo variável conexão (JDBC)
    private final Connection connection;

    public RegionRateCrud(Connection connection) {
        this.connection = connection;
    }

    // Método para INSERIR os dados
    @Override
    public void inserir(Region_Rate region_Rate) {
        // String sql = Código Que Vamos Usar No Sql
        String sql = """
                INSERT INTO tb_region_rate
                (region_id, m3_value, initial_validity, final_validity)
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, region_Rate.getRegionId());
            stmt.setBigDecimal(2, region_Rate.getM3Value());
            stmt.setDate(3, Date.valueOf(region_Rate.getInitialValidity()));
            stmt.setDate(4, Date.valueOf(region_Rate.getFinalValidity()));

            stmt.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();

        }
    }


    // Método para BUSCAR as informações pelo ID
    @Override
    public Region_Rate buscarPorId(int id) {

        String sql = """
                SELECT * FROM tb_region_rate WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {

                if (resultado.next()) {

                    return new Region_Rate (
                            resultado.getInt("id"),
                            resultado.getInt("region_id"),
                            resultado.getBigDecimal("m3_value"),
                            resultado.getDate("initial_validity").toLocalDate(),
                            resultado.getDate("final_validity").toLocalDate()
                    );

                }
            }

            // se nao der pra conectar
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;

    }

    // Método Para Listar TODOS
    @Override
    public List<Region_Rate> listarTodos() {

        String sql = """
                SELECT * FROM tb_region_rate
                """;

        List<Region_Rate> regioes_rate = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                Region_Rate region_rate = new Region_Rate (
                        resultado.getInt("id"),
                        resultado.getInt("region_id"),
                        resultado.getBigDecimal("m3_value"),
                        resultado.getDate("initial_validity").toLocalDate(),
                        resultado.getDate("final_validity").toLocalDate()
                );

                regioes_rate.add(region_rate);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return regioes_rate;

    }

    // UPDATES - - ATUALIZAR INFORMAÇÕES

    // Atualizar Id da Regiao
    @Override
    public void atualizarRegionId(Region_Rate region_rate) {

        String sql = """
                UPDATE tb_region_rate
                SET region_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setInt(1, region_rate.getRegionId());
            stmt.setInt(2, region_rate.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar valor da água por m3
    @Override
    public void atualizarM3Value(Region_Rate region_rate) {

        String sql = """
                UPDATE tb_region_rate
                SET m3_value = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setBigDecimal(1, region_rate.getM3Value());
            stmt.setInt(2, region_rate.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    // Atualizar Data De Validação Inicial
    @Override
    public void atualizarInitialValidity(Region_Rate region_rate) {

        String sql = """
                UPDATE tb_region_rate
                SET initial_validity = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setDate(1, Date.valueOf(region_rate.getInitialValidity()));
            stmt.setInt(2, region_rate.getId());


            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Data De Validação Final
    @Override
    public void atualizarFinalValidity(Region_Rate region_rate) {

        String sql = """
                UPDATE tb_region_rate
                SET final_validity = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setDate(1, Date.valueOf(region_rate.getFinalValidity()));
            stmt.setInt(2, region_rate.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }



    // DELETES
    // Deletar por ID
    @Override
    public void deletar(int id) {

        String sql = """
                DELETE FROM tb_region_rate
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Id da Regiao
    @Override
    public void deletarPorIdRegiao(int region_id) {

        String sql = """
                DELETE FROM tb_region_rate
                WHERE region_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, region_id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Data Inicial
    @Override
    public void deletarPorValidadeInicial(LocalDate initial_validity) {

        String sql = """
                DELETE FROM tb_region_rate
                WHERE initial_validity = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setObject(1, initial_validity);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Alterar por data final
    @Override
    public void deletarPorValidadeFinal(LocalDate final_validity) {

        String sql = """
                DELETE FROM tb_region_rate
                WHERE final_validity = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setObject(1, final_validity);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Método para Exibir Dados
    @Override
    public String exibirDados(Region_Rate regionRate) {
        return "Id: " + regionRate.getId() + "\n" +
                "Id da Região: " + regionRate.getRegionId() + "\n" +
                "Valor por metro quadrado: " + regionRate.getM3Value() + "\n" +
                "Validade inicial: " + regionRate.getInitialValidity() + "\n" +
                "Validade final: " + regionRate.getFinalValidity();
    }
}
