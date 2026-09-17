package com.example.delta_back.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Region_Rate {

    private int id;
    private int regionId;
    private BigDecimal m3Value;
    private LocalDate initialValidity;
    private LocalDate finalValidity;

    public Region_Rate() {
    }

    public Region_Rate(int id, int regionId, BigDecimal m3Value,
                       LocalDate initialValidity,
                       LocalDate finalValidity) {

        this.id = id;
        this.regionId = regionId;
        this.m3Value = m3Value;
        this.initialValidity = initialValidity;
        this.finalValidity = finalValidity;
    }

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

    public BigDecimal getM3Value() {
        return m3Value;
    }

    public void setM3Value(BigDecimal m3Value) {
        this.m3Value = m3Value;
    }

    public LocalDate getInitialValidity() {
        return initialValidity;
    }

    public void setInitialValidity(LocalDate initialValidity) {
        this.initialValidity = initialValidity;
    }

    public LocalDate getFinalValidity() {
        return finalValidity;
    }

    public void setFinalValidity(LocalDate finalValidity) {
        this.finalValidity = finalValidity;
    }
}