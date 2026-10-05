package com.example.delta_back.dao;

import com.example.delta_back.model.Device;
import com.example.delta_back.model.Property;

import java.time.LocalDate;
import java.util.List;

public interface PropertyDAO {

    // Método responsável por inserir um novo imóvel.
    void inserir(Property property);

    // Métodos responsáveis por buscar imóveis.
    Property buscarPorId(int id);
    List<Property> listarTodos();

    // Métodos responsáveis por consultar dados relacionados ao imóvel.
    List<Device> consultarDispositivos(Property property);
    List<Property> consultarEndereco(Property property);

    // Métodos responsáveis por alterar os dados de um imóvel.
    void atualizar(Property property);
    void atualizarNome(Property property);
    void atualizarType(Property property);
    void atualizarClassification(Property property);
    void atualizarAddressId(Property property);
    void atualizarRegistrationDate(Property property);

    // Métodos responsáveis por excluir imóveis.
    void deletar(int id);
    void deletarPorNome(String name);
    void deletarPorIdEndereco(int address_id);
    void deletarPorTipo(String type);
    void deletarPorDataRegistro(LocalDate registration_date);

    // Método responsável por exibir os dados de um imóvel.
    String exibirDados(Property property);
}