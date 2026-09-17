package com.example.delta_back.dao;

import com.example.delta_back.model.Property;
import com.example.delta_back.model.Device; // Consulta entre tabelas

import java.time.LocalDate;
import java.util.List;

// Interface property
public interface Property_DAO {

    // Criar uma propriedade no Banco de Dados
    void inserir(Property property);

    // Consultar uma propriedade específica
    Property buscarPorId(int id);

    // Consultar todas as propriedades
    List<Property> listarTodos();

    // Consultar todos os dispositivos de uma propriedade
    List<Device> consultarDispositivos(Property property);

    // Consultar endereço e regiao das propriedades
    List<Property> consultarEndereco(Property property);


    // UPDATES
    void atualizarNome(Property property);

    void atualizarType(Property property);

    void atualizarClassification(Property property);

    void atualizarAddressId(Property property);

    void atualizarRegistrationDate(com.example.delta_back.model.Property property);

    // Delete
    // Deletar por ID
    void deletar(int id);

    // Deletar por Nome
    void deletarPorNome(String name);

    // Deletar pelo ID do endereço
    void deletarPorIdEndereco(int address_id);

    // Deletar pelo tipo
    void deletarPorTipo(String type);

    // Deletar pela Data de Registro
    void deletarPorDataRegistro(LocalDate registration_date);

    // EXIBIR DADOS
    String exibirDados(Property property);

}