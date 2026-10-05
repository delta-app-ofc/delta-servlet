package com.example.delta_back.dao;

import com.example.delta_back.model.User;

import java.util.List;

public interface UserDAO {

    // Método responsável por inserir um novo usuário.
    void inserir(User user);

    // Métodos responsáveis por buscar usuários.
    User buscarPorId(int id);
    List<User> listarTodos();

    // Métodos responsáveis por alterar os dados de um usuário.
    void atualizar(User user);
    void atualizarNome(User user);
    void atualizarEmail(User user);
    void atualizarPassword(User user);
    void atualizarPhone(User user);
    void atualizarBirthDate(User user);
    void atualizarIsActive(User user);
    void atualizarIsAdmin(User user);
    void atualizarIsManager(User user);

    // Métodos responsáveis por excluir usuários.
    void deletar(int id);
    void deletarPorEmail(String email);
    void deletarPorCelular(String phone);

    // Método responsável por exibir os dados de um usuário.
    String exibirDados(User user);
}