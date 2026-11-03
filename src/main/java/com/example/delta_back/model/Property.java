// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.model;

import java.time.LocalDate;

// Documentação da classe Property: reúne os dados e comportamentos deste tipo.
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

    // Metodo: get Type; retorna o valor do atributo Type.
    public String getType() {
        return type;
    }

    // Metodo: set Type; define o atributo Type com o dado recebido.
    public void setType(String type) {
        this.type = type;
    }

    // Metodo: get Classification; retorna o valor do atributo Classification.
    public String getClassification() {
        return classification;
    }

    // Metodo: set Classification; define o atributo Classification com o dado recebido.
    public void setClassification(String classification) {
        this.classification = classification;
    }

    // Metodo: get Address Id; retorna o valor do atributo AddressId.
    public int getAddressId() {
        return addressId;
    }

    // Metodo: set Address Id; define o atributo AddressId com o dado recebido.
    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    // Metodo: get Registration Date; retorna o valor do atributo RegistrationDate.
    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    // Metodo: set Registration Date; define o atributo RegistrationDate com o dado recebido.
    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = registrationDate;
    }
}
