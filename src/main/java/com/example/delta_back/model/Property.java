package com.example.delta_back.model;

import java.time.LocalDate;

public class Property {

    // Definindo atributos do objeto Propriedade
    private int id;
    private String name;
    private String type;
    private String classification;
    private int addressId;
    private LocalDate registrationDate;

    // Construtor
    public Property(){}
    public Property(int id, String name, String type,
                    String classification, int addressId,
                    LocalDate registrationDate) {

        this.id = id;
        this.name = name;
        this.type = type;
        this.classification = classification;
        this.addressId = addressId;
        this.registrationDate = registrationDate;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getClassification() {
        return classification;
    }

    public void setClassification(String classification) {
        this.classification = classification;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = registrationDate;
    }
}
