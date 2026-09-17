package com.example.delta_back.dao;

import com.example.delta_back.model.User;
import java.util.List;


public interface User_DAO {

    // Insert - Inserir dados (Criar Usuário)
    void inserir (User user);

    // Metodo Buscar - Select -> Buscar Usuário
    User buscarPorId(int id);

    // Metodo Listar Todos - Select * From User
    List<User> listarTodos();

    // Metodos Update - Alterar informações
    void atualizarNome(User user);

    void atualizarEmail(User user);

    void atualizarPassword(User user);

    void atualizarPhone(User user);

    void atualizarBirthDate(User user);

    void atualizarIsActive(User user);

    void atualizarIsAdmin(User user);

    void atualizarIsManager(User user);

    // Metodo Delete - Apagar o Usuario
    void deletar(int id);

    void deletarPorEmail(String email);

    void deletarPorCelular(String phone);

    // Sobrescrita - toString
    String exibirDados(User user);
}