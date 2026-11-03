// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
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
import org.mindrot.jbcrypt.BCrypt;

// Documentação da classe UserCrud: reúne os dados e comportamentos deste tipo.
public class UserCrud implements UserDAO {

    private final Connection connection;

    public UserCrud(Connection connection) {
        this.connection = connection;
    }

    @Override
    // Metodo: inserir; grava um novo registro com os dados recebidos.
    public void inserir(User user) {

        String sql = """
                INSERT INTO tb_user
                (user_name, email, user_password, phone, birth_date,
                 registration_date, is_active, is_admin, is_manager)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, hashIfNeeded(user.getPassword()));
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
    // Metodo: buscar Por Id; consulta os dados indicados pelos parametros recebidos.
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
    // Metodo: listar Todos; retorna a colecao de registros deste recurso.
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
    // Metodo: atualizar; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizar(User user) {

        String sql = """
                UPDATE tb_user
                SET user_name = ?,
                    email = ?,
                    user_password = ?,
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
            stmt.setString(3, hashIfNeeded(user.getPassword()));
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
    // Metodo: atualizar Nome; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizarNome(User user) {

        String sql = """
                UPDATE tb_user
                SET user_name = ?
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
    // Metodo: atualizar Email; atualiza o registro ou atributo indicado com os dados recebidos.
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
    // Metodo: atualizar Password; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizarPassword(User user) {

        String sql = """
                UPDATE tb_user
                SET user_password = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setString(1, hashIfNeeded(user.getPassword()));
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

    // Metodo: hash If Needed; verifica a condicao hIfNeeded.
    private String hashIfNeeded(String password) {
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("A senha é obrigatória.");
        }
        // Preserva hash ao editar outros dados; nunca devolvemos esse valor à tela.
        if (password.matches("^\\$2[aby]\\$\\d{2}\\$[./A-Za-z0-9]{53}$")) return password;
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    // Metodo: email Em Uso; executa a operacao email Em Uso neste componente.
    public boolean emailEmUso(String email, int ignorarId) {
        String sql = "SELECT 1 FROM tb_user WHERE LOWER(email) = LOWER(?) AND id <> ? LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email.trim());
            stmt.setInt(2, ignorarId);
            try (ResultSet rs = stmt.executeQuery()) { return rs.next(); }
        } catch (SQLException e) {
            throw new RuntimeException("Não foi possível validar o e-mail.", e);
        }
    }

    // Metodo: contar Contas Com Telefone; executa a operacao contar Contas Com Telefone neste componente.
    public int contarContasComTelefone(String telefone, int ignorarId) {
        String sql = """
                SELECT COUNT(*)
                FROM tb_user
                WHERE regexp_replace(phone, '[^0-9]', '', 'g')
                    = regexp_replace(?, '[^0-9]', '', 'g')
                  AND id <> ?
                """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, telefone.trim());
            stmt.setInt(2, ignorarId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Não foi possível validar o telefone.", e);
        }
    }

    // Metodo: buscar Por Email; consulta os dados indicados pelos parametros recebidos.
    public User buscarPorEmail(String email) {
        String sql = "SELECT * FROM tb_user WHERE LOWER(email) = LOWER(?) LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? criarUsuario(rs) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Não foi possível buscar o usuário pelo e-mail.", e);
        }
    }

    // Metodo: atualizar Senha Por Email; atualiza o registro ou atributo indicado com os dados recebidos.
    public void atualizarSenhaPorEmail(String email, String senha) {
        String sql = "UPDATE tb_user SET user_password = ? WHERE LOWER(email) = LOWER(?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, hashIfNeeded(senha));
            stmt.setString(2, email.trim());
            if (stmt.executeUpdate() != 1) {
                throw new IllegalArgumentException("Usuário não encontrado.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Não foi possível atualizar a senha.", e);
        }
    }

    @Override
    // Metodo: atualizar Phone; atualiza o registro ou atributo indicado com os dados recebidos.
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
    // Metodo: atualizar Birth Date; atualiza o registro ou atributo indicado com os dados recebidos.
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
    // Metodo: atualizar Is Active; atualiza o registro ou atributo indicado com os dados recebidos.
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
    // Metodo: atualizar Is Admin; atualiza o registro ou atributo indicado com os dados recebidos.
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
    // Metodo: atualizar Is Manager; atualiza o registro ou atributo indicado com os dados recebidos.
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
    // Metodo: deletar; remove o registro indicado pelos parametros recebidos.
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
    // Metodo: deletar Por Email; remove o registro indicado pelos parametros recebidos.
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
    // Metodo: deletar Por Celular; remove o registro indicado pelos parametros recebidos.
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
    // Metodo: exibir Dados; executa a operacao exibir Dados neste componente.
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

    // Metodo: criar Usuario; grava um novo registro com os dados recebidos.
    private User criarUsuario(ResultSet resultado)
            throws SQLException {

        return new User(
                resultado.getInt("id"),
                resultado.getString("user_name"),
                resultado.getString("email"),
                resultado.getString("user_password"),
                resultado.getString("phone"),
                resultado.getDate("birth_date").toLocalDate(),
                resultado.getDate("registration_date").toLocalDate(),
                resultado.getBoolean("is_active"),
                resultado.getBoolean("is_admin"),
                resultado.getBoolean("is_manager")
        );
    }
}
