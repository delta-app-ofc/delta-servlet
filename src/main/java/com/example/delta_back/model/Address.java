// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.model;

// Documentação da classe Address: reúne os dados e comportamentos deste tipo.
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
    // Metodo: get Id; retorna o valor do atributo Id.
    public int getId() {
        return id;
    }

    // Metodo: set Id; define o atributo Id com o dado recebido.
    public void setId(int id) {
        this.id = id;
    }

    // Metodo: get Region Id; retorna o valor do atributo RegionId.
    public int getRegionId() {
        return regionId;
    }

    // Metodo: set Region Id; define o atributo RegionId com o dado recebido.
    public void setRegionId(int regionId) {
        this.regionId = regionId;
    }

    // Metodo: get Cep; retorna o valor do atributo Cep.
    public String getCep() {
        return cep;
    }

    // Metodo: set Cep; define o atributo Cep com o dado recebido.
    public void setCep(String cep) {
        this.cep = cep;
    }

    // Metodo: get City; retorna o valor do atributo City.
    public String getCity() {
        return city;
    }

    // Metodo: set City; define o atributo City com o dado recebido.
    public void setCity(String city) {
        this.city = city;
    }

    // Metodo: get State; retorna o valor do atributo State.
    public String getState() {
        return state;
    }

    // Metodo: set State; define o atributo State com o dado recebido.
    public void setState(String state) {
        this.state = state;
    }
}
