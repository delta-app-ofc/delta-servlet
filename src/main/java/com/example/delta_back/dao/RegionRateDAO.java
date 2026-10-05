package com.example.delta_back.dao;

import com.example.delta_back.model.Region_Rate;

import java.time.LocalDate;
import java.util.List;

public interface RegionRateDAO {

    // Método responsável por inserir uma nova taxa de região.
    void inserir(Region_Rate regionRate);

    // Métodos responsáveis por buscar taxas de região.
    Region_Rate buscarPorId(int id);
    List<Region_Rate> listarTodos();

    // Métodos responsáveis por alterar os dados de uma taxa de região.
    void atualizar(Region_Rate regionRate);
    void atualizarRegionId(Region_Rate regionRate);
    void atualizarM3Value(Region_Rate regionRate);
    void atualizarInitialValidity(Region_Rate regionRate);
    void atualizarFinalValidity(Region_Rate regionRate);

    // Métodos responsáveis por excluir taxas de região.
    void deletar(int id);
    void deletarPorIdRegiao(int region_id);
    void deletarPorValidadeInicial(LocalDate initial_validity);
    void deletarPorValidadeFinal(LocalDate final_validity);

    // Método responsável por exibir os dados de uma taxa de região.
    String exibirDados(Region_Rate regionRate);
}