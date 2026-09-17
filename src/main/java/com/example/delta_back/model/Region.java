package com.example.delta_back.model;

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
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}