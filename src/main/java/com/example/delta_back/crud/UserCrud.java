package com.example.delta_back.crud;

import com.example.delta_back.dao.User_DAO;
import com.example.delta_back.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class UserCrud implements User_DAO {

    // Criando a variável Connection (JDBC)
    private final Connection connection;


    // Criando o Objeto "Usuario DAO implementacao"
    public UserCrud(Connection connection) {
        this.connection = connection;
    }


    // Metodo INSERIR (INSERT)
    @Override
    public void inserir(User user) {

        // String sql = Codigo que irá ao banco de dados.
        String sql = """
                INSERT INTO tb_user (name, email, password, phone, birth_date, registration_date, is_active, is_admin, is_manager)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());
            stmt.setDate(5, Date.valueOf(user.getBirthDate()));
            stmt.setDate(6, Date.valueOf(user.getRegistrationDate()));
            stmt.setBoolean(7, user.isActive());
            stmt.setBoolean(8, user.isAdmin());
            stmt.setBoolean(9, user.isManager());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // METODOS PARA BUSCA ( SELECT * FROM x WHERE y )

    // Metodo para Buscar Usuario pelo ID
    @Override
    public User buscarPorId(int id) {
        String sql = """
                SELECT * 
                FROM tb_user
                WHERE id = ?
                """;

        // Tente - Conectar com o SQL - Se conseguir, execute:
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            ResultSet resultado = stmt.executeQuery();

            if (resultado.next()) {

                return new User (

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

            // Se nao conseguir conectar, imprima a mensagem de erro:
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;

    }

    // METODO LISTAR TODOS ( SELECT * FROM tb_user )
    @Override
    public List<User> listarTodos() {

        String sql = """
            SELECT *
            FROM tb_user
            """;

        List<User> usuarios = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet resultado = stmt.executeQuery()) {

            while (resultado.next()) {

                User user = new User(
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

                usuarios.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuarios;
    }

    // METODO ATUALIZAR (UPDATE)

    // Atualizar Nome
    @Override
    public void atualizarNome(User user) {

        String sql = """
                UPDATE tb_user
                SET name = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, user.getName());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Email
    @Override
    public void atualizarEmail(User user) {

        String sql = """
                UPDATE tb_user
                SET email = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, user.getEmail());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Senha
    @Override
    public void atualizarPassword(User user) {

        String sql = """
                UPDATE tb_user
                SET password = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, user.getPassword());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar celular
    @Override
    public void atualizarPhone(User user) {

        String sql = """
                UPDATE tb_user
                SET phone = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setString(1, user.getPhone());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Data de Nascimento
    @Override
    public void atualizarBirthDate(User user) {

        String sql = """
                UPDATE tb_user
                SET birth_date = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setDate(1, Date.valueOf(user.getBirthDate()));
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar Se o Usuário é Ativo ou Não
    @Override
    public void atualizarIsActive(User user) {

        String sql = """
                UPDATE tb_user
                SET is_active = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setBoolean(1, user.isActive());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar se o usuário é ADMIN
    @Override
    public void atualizarIsAdmin(User user) {

        String sql = """
                UPDATE tb_user
                SET is_admin = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setBoolean(1, user.isAdmin());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    // Atualizar se o Usuario é MANAGER
    @Override
    public void atualizarIsManager(User user) {

        String sql = """
                UPDATE tb_user
                SET is_manager = ?
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)){

            stmt.setBoolean(1, user.isManager());
            stmt.setInt(2, user.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    // METÓDOS DELETE ( APAGAR )

    // Apagar por ID
    @Override
    public void deletar(int id) {

        String sql = """
                DELETE FROM tb_user
                WHERE id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Apagar por Email
    @Override
    public void deletarPorEmail(String email) {

        String sql = """
                DELETE FROM tb_user
                WHERE email = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, email);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //Apagar por Celular
    @Override
    public void deletarPorCelular(String phone) {

        String sql = """
                DELETE FROM tb_user
                WHERE phone = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, phone);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Método para Exibir Dados da classe
    @Override
    public String exibirDados(User user) {
        return "Usuário: " + user.getName() + "\n" +
                "Id: " + user.getId() + "\n" +
                "Email: " + user.getEmail() + "\n" +
                "Senha: " + user.getPassword() + "\n" +
                "Celular: " + user.getPhone() + "\n" +
                "Data de aniversário: " + user.getBirthDate() + "\n" +
                "Data de registro: " + user.getRegistrationDate() + "\n" +
                "Usuário Ativo: " + user.isActive() + "\n" +
                "Administrador: " + user.isAdmin() + "\n" +
                "Gerente: " + user.isManager();
    }

}