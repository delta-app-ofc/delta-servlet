package com.example.delta_back.dao;

import com.example.delta_back.model.Device;

import java.time.LocalDate;
import java.util.List;

// Interface genérica
public interface Device_DAO {

    // Inserir dados
    void inserir (Device device);

    // Consultar Dispositivo usando ID
    Device buscarPorId(int id);

    // Exibiar todos os dispositivos
    List<Device> listarTodos();

    // UPDATES
    void atualizarDeviceId(Device device);

    void atualizarPropertyId(Device device);

    void atualizarIsActive(Device device);

    void atualizarInstallationDate(Device device);

    // DELETES
    // Deletar por ID
    void deletar(int id);

    // Deletar pelo Id do Dispositivo ( NÃO é o identificador do BD )
    void deletarPorIdDispositivo(String device_id);

    // Deletar por Id da Propriedade
    void deletarPorIdPropriedade(int property_id);

    // Deletar por data de Instalação
    void deletarPorDataInstalacao(LocalDate installation_date);

    // EXIBIR DADOS
    String exibirDados(Device device);

}