package com.example.delta_back.dao;

import com.example.delta_back.model.Region_Rate;

import java.time.LocalDate;
import java.util.List;

// Interface Taxa da Região
public interface RegionRate_DAO {

    // Insert
    void inserir(Region_Rate regionRate);

    // Select por ID
    Region_Rate buscarPorId(int id);

    // Listar todos
    List<Region_Rate> listarTodos();

    // Updates
    void atualizarRegionId(Region_Rate regionRate);

    void atualizarM3Value(Region_Rate regionRate);

    void atualizarInitialValidity(Region_Rate regionRate);

    void atualizarFinalValidity(Region_Rate regionRate);

    // Delete
    void deletar(int id);

    void deletarPorIdRegiao(int region_id);

    void deletarPorValidadeInicial(LocalDate initial_validity);

    void deletarPorValidadeFinal(LocalDate final_validity);

    // toString - Método Exibir Dados
    String exibirDados(Region_Rate regionRate);
}
