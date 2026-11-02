
package com.example.delta_back.crud;

import com.example.delta_back.model.Device;
import com.example.delta_back.model.Address;
import com.example.delta_back.model.Region;
import com.example.delta_back.model.Property;
import com.example.delta_back.dao.PropertyDAO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PropertyCrud implements PropertyDAO {

    private final Connection connection;

    public PropertyCrud(Connection connection) {
        this.connection = connection;
    }

    private RuntimeException erroBanco(String operacao, SQLException e) {
        return new RuntimeException(
                "Erro ao " + operacao + ": " + e.getMessage(), e
        );
    }

    // INSERIR
    @Override
    public void inserir(Property property) {
        String sql = """
                INSERT INTO tb_property
                (property_name, property_type, classification, address_id, registration_date)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, property.getName());
            stmt.setString(2, property.getType());
            stmt.setString(3, property.getClassification());
            stmt.setInt(4, property.getAddressId());
            stmt.setDate(5, Date.valueOf(property.getRegistrationDate()));

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas == 0) {
                throw new SQLException("Nenhuma propriedade foi cadastrada.");
            }
        } catch (SQLException e) {
            throw erroBanco("cadastrar a propriedade", e);
        }
    }

    // BUSCAR POR ID
    @Override
    public Property buscarPorId(int id) {
        String sql = "SELECT * FROM tb_property WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet resultado = stmt.executeQuery()) {
                if (resultado.next()) {
                    return new Property(
                            resultado.getInt("id"),
                            resultado.getString("property_name"),
                            resultado.getString("property_type"),
                            resultado.getString("classification"),
                            resultado.getInt("address_id"),
                            resultado.getDate("registration_date").toLocalDate()
                    );
                }
            }

            return null;
        } catch (SQLException e) {
            throw erroBanco("buscar a propriedade", e);
        }
    }

    // LISTAR TODOS
    @Override
    public List<Property> listarTodos() {
        String sql = "SELECT * FROM tb_property";
        List<Property> properties = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {
                properties.add(new Property(
                        resultado.getInt("id"),
                        resultado.getString("property_name"),
                        resultado.getString("property_type"),
                        resultado.getString("classification"),
                        resultado.getInt("address_id"),
                        resultado.getDate("registration_date").toLocalDate()
                ));
            }

            return properties;
        } catch (SQLException e) {
            throw erroBanco("listar as propriedades", e);
        }
    }

    // CONSULTAR DISPOSITIVOS DA PROPRIEDADE
    @Override
    public List<Device> consultarDispositivos(Property property) {
        List<Device> dispositivos = new ArrayList<>();

        String sql = """
                SELECT d.id,
                       d.device_id,
                       d.property_id,
                       d.is_active,
                       d.installation_date
                FROM tb_device d
                JOIN tb_property p ON d.property_id = p.id
                WHERE p.id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, property.getId());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Device device = new Device();

                    device.setId(rs.getInt("id"));
                    device.setDeviceId(rs.getString("device_id"));
                    device.setPropertyId(rs.getInt("property_id"));
                    device.setActive(rs.getBoolean("is_active"));

                    Date dataInstalacao = rs.getDate("installation_date");
                    if (dataInstalacao != null) {
                        device.setInstallationDate(dataInstalacao.toLocalDate());
                    }

                    dispositivos.add(device);
                }
            }

            return dispositivos;
        } catch (SQLException e) {
            throw erroBanco("consultar os dispositivos da propriedade", e);
        }
    }

    // CONSULTAR ENDEREÇO DA PROPRIEDADE
    @Override
    public List<Property> consultarEndereco(Property property) {
        String sql = """
                SELECT p.property_name AS nome,
                       a.cep,
                       a.city AS cidade,
                       a.adress_state AS estado,
                       r.region_name AS regiao
                FROM tb_property p
                JOIN tb_address a ON p.address_id = a.id
                JOIN tb_region r ON a.region_id = r.id
                WHERE p.id = ?
                """;

        List<Property> lista = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, property.getId());

            try (ResultSet rs = stmt.executeQuery()) {
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
            }

            return lista;
        } catch (SQLException e) {
            throw erroBanco("consultar o endereço da propriedade", e);
        }
    }

    // ATUALIZAR TODOS OS DADOS
    @Override
    public void atualizar(Property property) {
        String sql = """
                UPDATE tb_property
                SET property_name = ?, property_type = ?, classification = ?,
                    address_id = ?, registration_date = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, property.getName());
            stmt.setString(2, property.getType());
            stmt.setString(3, property.getClassification());
            stmt.setInt(4, property.getAddressId());
            stmt.setDate(5, Date.valueOf(property.getRegistrationDate()));
            stmt.setInt(6, property.getId());

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas == 0) {
                throw new SQLException(
                        "Nenhuma propriedade encontrada com o ID informado."
                );
            }
        } catch (SQLException e) {
            throw erroBanco("atualizar a propriedade", e);
        }
    }

    // ATUALIZAR NOME
    @Override
    public void atualizarNome(Property property) {
        executarAtualizacao(
                "UPDATE tb_property SET property_name = ? WHERE id = ?",
                property.getName(),
                property.getId(),
                "atualizar o nome"
        );
    }

    // ATUALIZAR TIPO
    @Override
    public void atualizarType(Property property) {
        executarAtualizacao(
                "UPDATE tb_property SET property_type = ? WHERE id = ?",
                property.getType(),
                property.getId(),
                "atualizar o tipo"
        );
    }

    // ATUALIZAR CLASSIFICAÇÃO
    @Override
    public void atualizarClassification(Property property) {
        executarAtualizacao(
                "UPDATE tb_property SET classification = ? WHERE id = ?",
                property.getClassification(),
                property.getId(),
                "atualizar a classificação"
        );
    }

    // ATUALIZAR ID DO ENDEREÇO
    @Override
    public void atualizarAddressId(Property property) {
        executarAtualizacao(
                "UPDATE tb_property SET address_id = ? WHERE id = ?",
                property.getAddressId(),
                property.getId(),
                "atualizar o endereço"
        );
    }

    // ATUALIZAR DATA DE REGISTRO
    @Override
    public void atualizarRegistrationDate(Property property) {
        executarAtualizacao(
                "UPDATE tb_property SET registration_date = ? WHERE id = ?",
                Date.valueOf(property.getRegistrationDate()),
                property.getId(),
                "atualizar a data de registro"
        );
    }

    private void executarAtualizacao(
            String sql,
            Object valor,
            int id,
            String operacao
    ) {
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setObject(1, valor);
            stmt.setInt(2, id);

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas == 0) {
                throw new SQLException(
                        "Nenhuma propriedade encontrada com o ID informado."
                );
            }
        } catch (SQLException e) {
            throw erroBanco(operacao, e);
        }
    }

    // EXCLUIR POR ID
    @Override
    public void deletar(int id) {
        executarExclusao(
                "DELETE FROM tb_property WHERE id = ?",
                id,
                "excluir a propriedade"
        );
    }

    // EXCLUIR POR NOME
    @Override
    public void deletarPorNome(String name) {
        String sql = "DELETE FROM tb_property WHERE property_name = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw erroBanco("excluir propriedades pelo nome", e);
        }
    }

    // EXCLUIR POR ID DO ENDEREÇO
    @Override
    public void deletarPorIdEndereco(int address_id) {
        String sql = "DELETE FROM tb_property WHERE address_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, address_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw erroBanco("excluir propriedades pelo endereço", e);
        }
    }

    // EXCLUIR POR TIPO
    @Override
    public void deletarPorTipo(String type) {
        String sql = "DELETE FROM tb_property WHERE property_type = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, type);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw erroBanco("excluir propriedades pelo tipo", e);
        }
    }

    // EXCLUIR POR DATA DE REGISTRO
    @Override
    public void deletarPorDataRegistro(LocalDate registration_date) {
        String sql = "DELETE FROM tb_property WHERE registration_date = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(registration_date));
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw erroBanco("excluir propriedades pela data de registro", e);
        }
    }

    private void executarExclusao(
            String sql,
            int id,
            String operacao
    ) {
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas == 0) {
                throw new SQLException(
                        "Nenhuma propriedade encontrada com o ID informado."
                );
            }
        } catch (SQLException e) {
            throw erroBanco(operacao, e);
        }
    }

    // EXIBIR DADOS
    @Override
    public String exibirDados(Property property) {
        return "Propriedade: " + property.getName() + "\n"
                + "Id: " + property.getId() + "\n"
                + "Tipo: " + property.getType() + "\n"
                + "Classificação: " + property.getClassification() + "\n"
                + "Id do Endereço: " + property.getAddressId() + "\n"
                + "Data de registro: " + property.getRegistrationDate();
    }
}
