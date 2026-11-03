// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.crud;

import com.example.delta_back.model.Device;
import com.example.delta_back.dao.DeviceDAO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

// Documentação da classe DeviceCrud: reúne os dados e comportamentos deste tipo.
public class DeviceCrud implements DeviceDAO {

    private final Connection connection;

    public DeviceCrud(Connection connection) {
        this.connection = connection;
    }

    // INSERT
    @Override
    // Metodo: inserir; grava um novo registro com os dados recebidos.
    public void inserir(Device device) {

        String sql = """
                INSERT INTO tb_device
                (device_id, property_id, is_active, installation_date)
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, Integer.parseInt(device.getDeviceId()));
            stmt.setInt(2, device.getPropertyId());
            stmt.setBoolean(3, device.isActive());
            stmt.setDate(4, Date.valueOf(device.getInstallationDate()));

            stmt.executeUpdate();

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao inserir dispositivo no banco.", e);
        }
    }

    // BUSCAR POR ID
    @Override
    // Metodo: buscar Por Id; consulta os dados indicados pelos parametros recebidos.
    public Device buscarPorId(int id) {

        String sql = "SELECT * FROM tb_device WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {

                if (resultado.next()) {
                    return new Device(
                            resultado.getInt("id"),
                            String.valueOf(resultado.getInt("device_id")),
                            resultado.getInt("property_id"),
                            resultado.getBoolean("is_active"),
                            resultado.getDate("installation_date").toLocalDate()
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar dispositivo no banco.", e);
        }

        return null;
    }

    // LISTAR TODOS
    @Override
    // Metodo: listar Todos; retorna a colecao de registros deste recurso.
    public List<Device> listarTodos() {

        String sql = "SELECT * FROM tb_device";
        List<Device> devices = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                Device device = new Device(
                        resultado.getInt("id"),
                        String.valueOf(resultado.getInt("device_id")),
                        resultado.getInt("property_id"),
                        resultado.getBoolean("is_active"),
                        resultado.getDate("installation_date").toLocalDate()
                );

                devices.add(device);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao listar dispositivos no banco.", e);
        }

        return devices;
    }

    // ATUALIZAR TODOS OS DADOS
    @Override
    // Metodo: atualizar; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizar(Device device) {

        String sql = """
                UPDATE tb_device
                SET device_id = ?, property_id = ?, is_active = ?, installation_date = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, Integer.parseInt(device.getDeviceId()));
            stmt.setInt(2, device.getPropertyId());
            stmt.setBoolean(3, device.isActive());
            stmt.setDate(4, Date.valueOf(device.getInstallationDate()));
            stmt.setInt(5, device.getId());

            stmt.executeUpdate();

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar dispositivo no banco.", e);
        }
    }

    // ATUALIZAR ID DO DISPOSITIVO
    @Override
    // Metodo: atualizar Device Id; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizarDeviceId(Device device) {

        String sql = """
                UPDATE tb_device
                SET device_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, Integer.parseInt(device.getDeviceId()));
            stmt.setInt(2, device.getId());

            stmt.executeUpdate();

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar o ID do dispositivo.", e);
        }
    }

    // ATUALIZAR ID DA PROPRIEDADE
    @Override
    // Metodo: atualizar Property Id; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizarPropertyId(Device device) {

        String sql = """
                UPDATE tb_device
                SET property_id = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, device.getPropertyId());
            stmt.setInt(2, device.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar a propriedade do dispositivo.", e);
        }
    }

    // ATUALIZAR STATUS
    @Override
    // Metodo: atualizar Is Active; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizarIsActive(Device device) {

        String sql = """
                UPDATE tb_device
                SET is_active = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setBoolean(1, device.isActive());
            stmt.setInt(2, device.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar o status do dispositivo.", e);
        }
    }

    // ATUALIZAR DATA DE INSTALAÇÃO
    @Override
    // Metodo: atualizar Installation Date; atualiza o registro ou atributo indicado com os dados recebidos.
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
            throw new RuntimeException("Erro ao atualizar a data de instalação.", e);
        }
    }

    // DELETE POR ID DO BANCO
    @Override
    // Metodo: deletar; remove o registro indicado pelos parametros recebidos.
    public void deletar(int id) {

        String sql = "DELETE FROM tb_device WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao excluir dispositivo.", e);
        }
    }

    // DELETE POR ID DO DISPOSITIVO
    @Override
    // Metodo: deletar Por Id Dispositivo; remove o registro indicado pelos parametros recebidos.
    public void deletarPorIdDispositivo(String device_id) {

        String sql = "DELETE FROM tb_device WHERE device_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, Integer.parseInt(device_id));
            stmt.executeUpdate();

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao excluir dispositivo pelo ID do dispositivo.", e);
        }
    }

    // DELETE POR ID DA PROPRIEDADE
    @Override
    // Metodo: deletar Por Id Propriedade; remove o registro indicado pelos parametros recebidos.
    public void deletarPorIdPropriedade(int property_id) {

        String sql = "DELETE FROM tb_device WHERE property_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, property_id);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao excluir dispositivos da propriedade.", e);
        }
    }

    // DELETE POR DATA DE INSTALAÇÃO
    @Override
    // Metodo: deletar Por Data Instalacao; remove o registro indicado pelos parametros recebidos.
    public void deletarPorDataInstalacao(LocalDate installation_date) {

        String sql = "DELETE FROM tb_device WHERE installation_date = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(installation_date));
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao excluir dispositivos pela data de instalação.", e);
        }
    }

    // EXIBIR DADOS
    @Override
    // Metodo: exibir Dados; executa a operacao exibir Dados neste componente.
    public String exibirDados(Device device) {

        return "Id: " + device.getId() + "\n" +
                "Id do dispositivo: " + device.getDeviceId() + "\n" +
                "Id da propriedade: " + device.getPropertyId() + "\n" +
                "Está ativo: " + device.isActive() + "\n" +
                "Data de instalação: " + device.getInstallationDate();
    }
}