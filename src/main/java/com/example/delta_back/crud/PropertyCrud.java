package com.example.delta_back.crud;

import com.example.delta_back.model.Device; // Para consulta inter tabelas
import com.example.delta_back.model.Address; // Para consulta inter tabelas
import com.example.delta_back.model.Region; // Para consulta inter tabelas
import com.example.delta_back.model.Property;
import com.example.delta_back.dao.Property_DAO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PropertyCrud implements Property_DAO {

    // Definindo a variavel para a conexão (JBDC)
    private final Connection connection;

    public PropertyCrud(Connection connection) {
        this.connection = connection;
    }

    // INSERIR DADOS
    @Override
    public void inserir(Property property) {
        // String sql = Código Que Vamos Usar No Sql
        String sql = """
                INSERT INTO tb_property
                (name, type, classification, address_id, registration_date)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, property.getName());
            stmt.setString(2, property.getType());
            stmt.setString(3, property.getClassification());
            stmt.setInt(4, property.getAddressId());
            stmt.setDate(5, Date.valueOf(property.getRegistrationDate()));

            stmt.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();

        }
    }

    // Método para BUSCAR as informações pelo ID
    @Override
    public Property buscarPorId(int id) {

        String sql = """
                SELECT * FROM tb_property WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {

                if (resultado.next()) {

                    return new Property (
                            resultado.getInt("id"),
                            resultado.getString("name"),
                            resultado.getString("type"),
                            resultado.getString("classification"),
                            resultado.getInt("address_id"),
                            resultado.getDate("registration_date").toLocalDate()
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
    public List<Property> listarTodos() {

        String sql = """
                SELECT * FROM tb_property
                """;

        List<Property> properties = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                Property property = new Property (
                        resultado.getInt("id"),
                        resultado.getString("name"),
                        resultado.getString("type"),
                        resultado.getString("classification"),
                        resultado.getInt("address_id"),
                        resultado.getDate("registration_date").toLocalDate()
                );

                properties.add(property);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return properties;

    }

    // Consultar dispositivos de uma propriedade
    // Utilização de Duas Tabelas do Banco de Dados
    @Override
    public List<Device> consultarDispositivos(Property property) {
        // Arraylist - Guardará a consulta SQL inteira
        List<Device> dispositivos = new ArrayList<>();

        // Código SQL da consulta
        String sql = """
                SELECT p.name AS nome_propriedade,
                	d.device_id AS id_dispositivo,
                	d.is_active,
                	d.installation_date AS data_instalacao
                	FROM tb_device d
                	JOIN tb_property p
                	ON d.property_id = p.id
                	"""; // Utilização dos JOINS para conectar duas tabelas

        // Tente buscar
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            // Usará o ID da propriedade para buscar os Dispositivos
            stmt.setInt(1, property.getId());

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                // Criação do objeto que ficará contido no ArrayList (Consulta do SQL)
                Device device = new Device();

                device.setId(rs.getInt("id"));
                device.setDeviceId(rs.getString("device_id"));
                device.setPropertyId(rs.getInt("property_id"));
                device.setActive(rs.getBoolean("is_active"));
                device.setInstallationDate(
                        rs.getDate("installation_date").toLocalDate()
                );
                // Adicionando o dispositivo buscado no ArrayList de dispositivos
                dispositivos.add(device);
            }

        } catch (SQLException e) {
            // Tratamento de exceção
            e.printStackTrace();

        }
        // Return do ArrayList
        return dispositivos;
    }

    // Consultar endereço da propriedade
    // Utilização de Três tabelas do banco de dados
    @Override
    public List<Property> consultarEndereco(Property property) {

        String sql = """
            SELECT p.name AS nome,
                   a.cep,
                   a.city AS cidade,
                   a.state AS estado,
                   r.name AS regiao
            FROM tb_property p
            JOIN tb_address a
                ON p.address_id = a.id
            JOIN tb_region r
                ON a.region_id = r.id
            """;

        List<Property> lista = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Property p = new Property();
                Address address = new Address();
                Region region = new Region();

                p.setName(rs.getString("nome"));

                address.setCep(rs.getString("cep"));
                address.setCity(rs.getString("cidade"));
                address.setState(rs.getString("estado"));

                region.setName(rs.getString("regiao"));

                lista.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }


    // MÉTODOS UPDATE
    // Atualizar Nome
    @Override
    public void atualizarNome(Property property) {

        String sql = """
                UPDATE tb_property
                SET name = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, property.getName());
            stmt.setInt(2, property.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Tipo da Propriedade
    @Override
    public void atualizarType(Property property) {

        String sql = """
                UPDATE tb_property
                SET type = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, property.getType());
            stmt.setInt(2, property.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Classificação da Propriedade
    @Override
    public void atualizarClassification(Property property) {

        String sql = """
                UPDATE tb_property
                SET classification = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, property.getClassification());
            stmt.setInt(2, property.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar FK - Id do endereço
    @Override
    public void atualizarAddressId(Property property) {

        String sql = """
                UPDATE tb_property
                SET address_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setInt(1, property.getAddressId());
            stmt.setInt(2, property.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Data de Registro
    @Override
    public void atualizarRegistrationDate(Property property) {

        String sql = """
                UPDATE tb_property
                SET registration_date = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setDate(1, Date.valueOf(property.getRegistrationDate()));
            stmt.setInt(2, property.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    // DELETES
    // Deletar por Id
    @Override
    public void deletar(int id) {

        String sql = """
                DELETE FROM tb_property
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Nome
    @Override
    public void deletarPorNome(String name) {

        String sql = """
                DELETE FROM tb_property
                WHERE name = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, name);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Id do Endereco
    @Override
    public void deletarPorIdEndereco(int address_id) {

        String sql = """
                DELETE FROM tb_property
                WHERE address_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, address_id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar pelo Tipo
    @Override
    public void deletarPorTipo(String type) {

        String sql = """
                DELETE FROM tb_property
                WHERE type = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, type);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar pela data de registro
    @Override
    public void deletarPorDataRegistro(LocalDate registration_date) {

        String sql = """
                DELETE FROM tb_property
                WHERE registration_date = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setObject(1, registration_date);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // MÉTODO PARA EXIBIR DADOS
    @Override
    public String exibirDados(Property property) {
        return "Propriedade: " + property.getName() + "\n" +
                "Id: " + property.getId() + "\n" +
                "Tipo: " + property.getType() + "\n" +
                "Classificação: " + property.getClassification() + "\n" +
                "Id do Endereço: " + property.getAddressId() +
                "Data de registro: " + property.getAddressId();
    }

}