package com.example.delta_back.dao;

import com.example.delta_back.model.Region;
import java.util.List;

// Interface Regiao
public interface Region_DAO {

    // Metodo para Inserir Uma Região
    void inserir (Region region);

    // Metodo para consultar uma região
    Region buscarPorId(int id);

    // Metodo para exibir todas as regiões
    List<Region> listarTodos();

    // Metodo para atualizar o nome da região
    void atualizarNome(Region region);

    // Métodos Delete
    void deletar(int id);

    void deletarPorNome(String name);

    // Método para exibir dados
    String exibirDados(Region region);
}