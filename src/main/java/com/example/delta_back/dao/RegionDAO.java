package com.example.delta_back.dao;

import com.example.delta_back.model.Region;

import java.util.List;

public interface RegionDAO {

    // Método responsável por inserir uma nova região.
    void inserir(Region region);

    // Métodos responsáveis por buscar regiões.
    Region buscarPorId(int id);
    List<Region> listarTodos();

    // Métodos responsáveis por alterar os dados de uma região.
    void atualizar(Region region);
    void atualizarNome(Region region);

    // Métodos responsáveis por excluir regiões.
    void deletar(int id);
    void deletarPorNome(String name);

    // Método responsável por exibir os dados de uma região.
    String exibirDados(Region region);
}