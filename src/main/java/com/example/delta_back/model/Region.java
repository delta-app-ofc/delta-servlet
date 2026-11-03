// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.model;

// Documentação da classe Region: reúne os dados e comportamentos deste tipo.
public class Region {

    // Definindo atributos do objeto Região
    private int id;
    private String name;

    // Construtor
    public Region(){}
    public Region(int id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters & Setters
    // Metodo: get Id; retorna o valor do atributo Id.
    public int getId() {
        return id;
    }

    // Metodo: set Id; define o atributo Id com o dado recebido.
    public void setId(int id) {
        this.id = id;
    }

    // Metodo: get Name; retorna o valor do atributo Name.
    public String getName() {
        return name;
    }

    // Metodo: set Name; define o atributo Name com o dado recebido.
    public void setName(String name) {
        this.name = name;
    }
}