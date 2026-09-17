package com.example.delta_back.crud;

import com.example.delta_back.model.Address;
import com.example.delta_back.dao.Address_DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressCrud implements Address_DAO {

    // Definindo a variavel para a conexão (JBDC)
    private final Connection connection;

    public AddressCrud(Connection connection) {

        this.connection = connection;

    }

    // INSERT -- INSERIR DADOS
    @Override
    public void inserir(Address address) {
        // String sql = Código Que Vamos Usar No Sql
        String sql = """
                INSERT INTO tb_address
                (region_id, cep, city, state)
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, address.getRegionId());
            stmt.setString(2, address.getCep());
            stmt.setString(3, address.getCity());
            stmt.setString(4, address.getState());

            stmt.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();

        }
    }

    // Método para BUSCAR as informações pelo ID
    @Override
    public Address buscarPorId(int id) {

        String sql = """
                SELECT * FROM tb_address WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {

                if (resultado.next()) {

                    return new Address (
                            resultado.getInt("id"),
                            resultado.getInt("region_id"),
                            resultado.getString("cep"),
                            resultado.getString("city"),
                            resultado.getString("state")
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
    public List<Address> listarTodos() {

        String sql = """
                SELECT * FROM tb_address
                """;

        List<Address> addresslist = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                Address address = new Address (
                        resultado.getInt("id"),
                        resultado.getInt("region_id"),
                        resultado.getString("cep"),
                        resultado.getString("city"),
                        resultado.getString("state")
                );

                addresslist.add(address);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return addresslist;

    }

    // METÓDOS UPDATES

    // Atualizar region_id
    @Override
    public void atualizarRegionId(Address address) {

        String sql = """
                UPDATE tb_address
                SET region_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setInt(1, address.getRegionId());
            stmt.setInt(2, address.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Metodo para atualizar o CEP
    @Override
    public void atualizarCep(Address address) {

        String sql = """
                UPDATE tb_address
                SET cep = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, address.getCep());
            stmt.setInt(2, address.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Método para atualizar a cidade
    @Override
    public void atualizarCity(Address address) {

        String sql = """
                UPDATE tb_address
                SET city = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, address.getCity());
            stmt.setInt(2, address.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Método para atualizar o Estado
    @Override
    public void atualizarState(Address address) {

        String sql = """
                UPDATE tb_address
                SET state = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, address.getState());
            stmt.setInt(2, address.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    // DELETE
    // Deletar por Id
    @Override
    public void deletar(int id) {

        String sql = """
                DELETE FROM tb_address
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Id da Região
    @Override
    public void deletarPorIdRegiao(int region_id) {

        String sql = """
                DELETE FROM tb_address
                WHERE region_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, region_id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por CEP
    @Override
    public void deletarPorCep(String cep) {

        String sql = """
                DELETE FROM tb_address
                WHERE cep = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, cep);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por cidade
    @Override
    public void deletarPorCidade(String city) {

        String sql = """
                DELETE FROM tb_address
                WHERE city = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, city);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Estado
    @Override
    public void deletarPorEstado(String state) {

        String sql = """
                DELETE FROM tb_address
                WHERE state = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, state);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Exibir Dados
    @Override
    public String exibirDados(Address address) {
        return "Id: " + address.getId() + "\n" +
                "Id da Região: " + address.getRegionId() + "\n" +
                "Cep: " + address.getCep() + "\n" +
                "Cidade: " + address.getCity() + "\n" +
                "Estado: " + address.getState();
    }
}