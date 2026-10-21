package com.example.delta_back.crud;

import com.example.delta_back.dao.UserDAO;
import com.example.delta_back.model.User;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserCrud implements UserDAO {

    private final Connection connection;

    public UserCrud(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void inserir(User user) {

        String sql = """
                INSERT INTO tb_user
                (name, email, password, phone, birth_date,
                 registration_date, is_active, is_admin, is_manager)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());

            stmt.setDate(
                    5,
                    Date.valueOf(user.getBirthDate())
            );

            stmt.setDate(
                    6,
                    Date.valueOf(user.getRegistrationDate())
            );

            stmt.setBoolean(
                    7,
                    user.isActive()
            );

            stmt.setBoolean(
                    8,
                    user.isAdmin()
            );

            stmt.setBoolean(
                    9,
                    user.isManager()
            );

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao inserir usuário: " + e.getMessage(),
                    e
            );
        }
    }

    @Override
    public User buscarPorId(int id) {

        String sql = """
                SELECT *
                FROM tb_user
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            ResultSet resultado =
                    stmt.executeQuery();

            if (resultado.next()) {

                return criarUsuario(resultado);
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao buscar usuário: " + e.getMessage(),
                    e
            );
        }

        return null;
    }

    @Override
    public List<User> listarTodos() {

        String sql = """
                SELECT *
                FROM tb_user
                ORDER BY id
                """;

        List<User> usuarios =
                new ArrayList<>();

        try (
                PreparedStatement stmt =
                        connection.prepareStatement(sql);

                ResultSet resultado =
                        stmt.executeQuery()
        ) {

            while (resultado.next()) {

                usuarios.add(
                        criarUsuario(resultado)
                );
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao listar usuários: " +
                            e.getMessage(),
                    e
            );
        }

        return usuarios;
    }

    @Override
    public void atualizar(User user) {

        String sql = """
                UPDATE tb_user
                SET name = ?,
                    email = ?,
                    password = ?,
                    phone = ?,
                    birth_date = ?,
                    registration_date = ?,
                    is_active = ?,
                    is_admin = ?,
                    is_manager = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());

            stmt.setDate(
                    5,
                    Date.valueOf(user.getBirthDate())
            );

            stmt.setDate(
                    6,
                    Date.valueOf(user.getRegistrationDate())
            );

            stmt.setBoolean(
                    7,
                    user.isActive()
            );

            stmt.setBoolean(
                    8,
                    user.isAdmin()
            );

            stmt.setBoolean(
                    9,
                    user.isManager()
            );

            stmt.setInt(
                    10,
                    user.getId()
            );

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar usuário: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarNome(User user) {

        String sql = """
                UPDATE tb_user
                SET name = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar nome: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarEmail(User user) {

        String sql = """
                UPDATE tb_user
                SET email = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getEmail());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar e-mail: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarPassword(User user) {

        String sql = """
                UPDATE tb_user
                SET password = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getPassword());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar senha: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarPhone(User user) {

        String sql = """
                UPDATE tb_user
                SET phone = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getPhone());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar telefone: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarBirthDate(User user) {

        String sql = """
                UPDATE tb_user
                SET birth_date = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setDate(
                    1,
                    Date.valueOf(user.getBirthDate())
            );

            stmt.setInt(
                    2,
                    user.getId()
            );

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar data de nascimento: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarIsActive(User user) {

        String sql = """
                UPDATE tb_user
                SET is_active = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setBoolean(
                    1,
                    user.isActive()
            );

            stmt.setInt(
                    2,
                    user.getId()
            );

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar status: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarIsAdmin(User user) {

        String sql = """
                UPDATE tb_user
                SET is_admin = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setBoolean(
                    1,
                    user.isAdmin()
            );

            stmt.setInt(
                    2,
                    user.getId()
            );

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar administrador: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void atualizarIsManager(User user) {

        String sql = """
                UPDATE tb_user
                SET is_manager = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setBoolean(
                    1,
                    user.isManager()
            );

            stmt.setInt(
                    2,
                    user.getId()
            );

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao atualizar gerente: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void deletar(int id) {

        String sql = """
                DELETE FROM tb_user
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao deletar usuário: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void deletarPorEmail(String email) {

        String sql = """
                DELETE FROM tb_user
                WHERE email = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, email);

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao deletar usuário por e-mail: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public void deletarPorCelular(String phone) {

        String sql = """
                DELETE FROM tb_user
                WHERE phone = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, phone);

            stmt.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Erro ao deletar usuário por telefone: " +
                            e.getMessage(),
                    e
            );
        }
    }

    @Override
    public String exibirDados(User user) {

        return "ID: " + user.getId()
                + " | Nome: " + user.getName()
                + " | E-mail: " + user.getEmail()
                + " | Telefone: " + user.getPhone()
                + " | Data de nascimento: " + user.getBirthDate()
                + " | Data de cadastro: " + user.getRegistrationDate()
                + " | Ativo: " + user.isActive()
                + " | Admin: " + user.isAdmin()
                + " | Gerente: " + user.isManager();
    }

    private User criarUsuario(ResultSet resultado)
            throws SQLException {

        return new User(
                resultado.getInt("id"),
                resultado.getString("name"),
                resultado.getString("email"),
                resultado.getString("password"),
                resultado.getString("phone"),
                resultado.getDate("birth_date").toLocalDate(),
                resultado.getDate("registration_date").toLocalDate(),
                resultado.getBoolean("is_active"),
                resultado.getBoolean("is_admin"),
                resultado.getBoolean("is_manager")
        );
    }
}