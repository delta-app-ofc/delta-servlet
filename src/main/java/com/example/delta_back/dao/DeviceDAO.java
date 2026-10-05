package com.example.delta_back.dao;

import com.example.delta_back.model.Device;

import java.time.LocalDate;
import java.util.List;

public interface DeviceDAO {

    // Método responsável por inserir um novo dispositivo.
    void inserir(Device device);

    // Métodos responsáveis por buscar dispositivos.
    Device buscarPorId(int id);
    List<Device> listarTodos();

    // Métodos responsáveis por alterar os dados de um dispositivo.
    void atualizar(Device device);
    void atualizarDeviceId(Device device);
    void atualizarPropertyId(Device device);
    void atualizarIsActive(Device device);
    void atualizarInstallationDate(Device device);

    // Métodos responsáveis por excluir dispositivos.
    void deletar(int id);
    void deletarPorIdDispositivo(String device_id);
    void deletarPorIdPropriedade(int property_id);
    void deletarPorDataInstalacao(LocalDate installation_date);

    // Método responsável por exibir os dados de um dispositivo.
    String exibirDados(Device device);
}