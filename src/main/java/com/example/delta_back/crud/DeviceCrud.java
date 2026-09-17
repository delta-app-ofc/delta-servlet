package com.example.delta_back.crud;

import com.example.delta_back.model.Device;
import com.example.delta_back.dao.Device_DAO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DeviceCrud implements Device_DAO {

    // Definindo a variavel para a conexão (JBDC)
    private final Connection connection;

    public DeviceCrud(Connection connection) {

        this.connection = connection;

    }

    // INSERT -- INSERIR DADOS
    @Override
    public void inserir(Device device) {
        // String sql = Código Que Vamos Usar No Sql
        String sql = """
                INSERT INTO tb_device
                (device_id, property_id, is_active, installation_date)
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, device.getDeviceId());
            stmt.setInt(2, device.getPropertyId());
            stmt.setBoolean(3, device.isActive());
            stmt.setDate(4, Date.valueOf(device.getInstallationDate()));

            stmt.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();

        }
    }

    // Método para BUSCAR as informações pelo ID
    @Override
    public Device buscarPorId(int id) {

        String sql = """
                SELECT * FROM tb_device WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {

                if (resultado.next()) {

                    return new Device (
                            resultado.getInt("id"),
                            resultado.getString("device_id"),
                            resultado.getInt("property_id"),
                            resultado.getBoolean("is_active"),
                            resultado.getDate("installation_date").toLocalDate()
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
    public List<Device> listarTodos() {

        String sql = """
                SELECT * FROM tb_device
                """;

        List<Device> devices = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                Device device = new Device (
                        resultado.getInt("id"),
                        resultado.getString("device_id"),
                        resultado.getInt("property_id"),
                        resultado.getBoolean("is_active"),
                        resultado.getDate("installation_date").toLocalDate()
                );

                devices.add(device);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return devices;

    }

    // MÉTODOS UPDATE
    // Atualizar device_id
    @Override
    public void atualizarDeviceId(Device device) {

        String sql = """
                UPDATE tb_device
                SET device_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, device.getDeviceId());
            stmt.setInt(2, device.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    // Atualizar Propriety Id
    @Override
    public void atualizarPropertyId(Device device) {

        String sql = """
                UPDATE tb_device
                SET property_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setInt(1, device.getPropertyId());
            stmt.setInt(2, device.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar se o dispositivo está ativo
    @Override
    public void atualizarIsActive(Device device) {

        String sql = """
                UPDATE tb_device
                SET is_active = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setBoolean(1, device.isActive());
            stmt.setInt(2, device.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar a data de instalação
    @Override
    public void atualizarInstallationDate(Device device) {

        String sql = """
                UPDATE tb_device
                SET installation_date = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(device.getInstallationDate()));
            stmt.setInt(2, device.getId());

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
                DELETE FROM tb_device
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Deletar por Id do Dispositivo ( Não é a chave primária ID do banco de dados )
    @Override
    public void deletarPorIdDispositivo(String device_id) {

        String sql = """
                DELETE FROM tb_device
                WHERE device_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, device_id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Apagar por Id da Propriedade
    @Override
    public void deletarPorIdPropriedade(int property_id) {

        String sql = """
                DELETE FROM tb_device
                WHERE property_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, property_id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Apagar por data de instalação
    @Override
    public void deletarPorDataInstalacao(LocalDate installation_date) {

        String sql = """
                DELETE FROM tb_device
                WHERE installation_date = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setObject(1, installation_date);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // MÉTODO DE EXIBIR DADOS
    @Override
    public String exibirDados(Device device) {
        return "Id: " + device.getId() + "\n" +
                "Id do dispositivo: " + device.getDeviceId() + "\n" +
                "Id da propriedade: " + device.getPropertyId() + "\n" +
                "Está ativo: " + device.isActive() + "\n" +
                "Data de instalação: " + device.getInstallationDate();
    }

}