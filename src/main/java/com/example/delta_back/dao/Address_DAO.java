package com.example.delta_back.dao;

import com.example.delta_back.model.Address;
import java.util.List;

// Interface Endereco
public interface Address_DAO {

    void inserir (Address address);

    Address buscarPorId(int id);

    List<Address> listarTodos();

    // UPDATES
    void atualizarRegionId(Address address);

    void atualizarCep(Address address);

    void atualizarCity(Address address);

    void atualizarState(Address address);


    // DELETES
    // Deletar por Id
    void deletar(int id);

    // Deletar por Id da Region ID
    void deletarPorIdRegiao(int region_id);

    // Deletar por CEP
    void deletarPorCep(String cep);

    // Deletar por Cidade
    void deletarPorCidade(String city);

    // Deletar por Estado
    void deletarPorEstado(String state);

    // Exibir Dados
    String exibirDados(Address address);
}
