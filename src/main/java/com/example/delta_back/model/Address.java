package com.example.delta_back.model;

public class Address {

    // Definindo atributos do objeto Endereço
    private int id;
    private int regionId;
    private String cep;
    private String city;
    private String state;

    // Construtor
    public Address(){}
    public Address(int id, int regionId, String cep,
                   String city, String state) {

        this.id = id;
        this.regionId = regionId;
        this.cep = cep;
        this.city = city;
        this.state = state;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRegionId() {
        return regionId;
    }

    public void setRegionId(int regionId) {
        this.regionId = regionId;
    }

    public String getCep() {
        return cep;
    }

    public void setCep(String cep) {
        this.cep = cep;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
}
