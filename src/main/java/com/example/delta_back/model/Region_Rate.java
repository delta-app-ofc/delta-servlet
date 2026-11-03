// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.model;

import java.math.BigDecimal;
import java.time.LocalDate;

// Documentação da classe Region_Rate: reúne os dados e comportamentos deste tipo.
public class Region_Rate {

    // Definindo atributos do objeto Taxa da Região
    private int id;
    private int regionId;
    private BigDecimal m3Value;
    private LocalDate initialValidity;
    private LocalDate finalValidity;

    // Construtor
    public Region_Rate(int id, int regionId, BigDecimal m3Value,
                       LocalDate initialValidity,
                       LocalDate finalValidity) {

        this.id = id;
        this.regionId = regionId;
        this.m3Value = m3Value;
        this.initialValidity = initialValidity;
        this.finalValidity = finalValidity;
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

    // Metodo: get M3 Value; retorna o valor do atributo M3Value.
    public BigDecimal getM3Value() {
        return m3Value;
    }

    // Metodo: set M3 Value; define o atributo M3Value com o dado recebido.
    public void setM3Value(BigDecimal m3Value) {
        this.m3Value = m3Value;
    }

    // Metodo: get Initial Validity; retorna o valor do atributo InitialValidity.
    public LocalDate getInitialValidity() {
        return initialValidity;
    }

    // Metodo: set Initial Validity; define o atributo InitialValidity com o dado recebido.
    public void setInitialValidity(LocalDate initialValidity) {
        this.initialValidity = initialValidity;
    }

    // Metodo: get Final Validity; retorna o valor do atributo FinalValidity.
    public LocalDate getFinalValidity() {
        return finalValidity;
    }

    // Metodo: set Final Validity; define o atributo FinalValidity com o dado recebido.
    public void setFinalValidity(LocalDate finalValidity) {
        this.finalValidity = finalValidity;
    }
}