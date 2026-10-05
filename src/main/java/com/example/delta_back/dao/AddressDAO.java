package com.example.delta_back.dao;

import com.example.delta_back.model.Address;

import java.util.List;

public interface AddressDAO {

    // Método responsável por inserir um novo endereço.
    void inserir(Address address);

    // Métodos responsáveis por buscar endereços.
    Address buscarPorId(int id);
    List<Address> listarTodos();

    // Métodos responsáveis por alterar os dados de um endereço.
    void atualizar(Address address);
    void atualizarRegionId(Address address);
    void atualizarCep(Address address);
    void atualizarCity(Address address);
    void atualizarState(Address address);

    // Métodos responsáveis por excluir endereços.
    void deletar(int id);
    void deletarPorIdRegiao(int region_id);
    void deletarPorCep(String cep);
    void deletarPorCidade(String city);
    void deletarPorEstado(String state);

    // Método responsável por exibir os dados de um endereço.
    String exibirDados(Address address);
}