package com.example.delta_back.model;

import java.time.LocalDate;

public class Device {

    // Definindo os Atributos do objeto Dispositivo
    private int id;
    private String deviceId;
    private int propertyId;
    private boolean active;
    private LocalDate installationDate;

    // Construtor
    public Device(){}
    public Device(int id, String deviceId, int propertyId,
                  boolean active, LocalDate installationDate) {

        this.id = id;
        this.deviceId = deviceId;
        this.propertyId = propertyId;
        this.active = active;
        this.installationDate = installationDate;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public int getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDate getInstallationDate() {
        return installationDate;
    }

    public void setInstallationDate(LocalDate installationDate) {
        this.installationDate = installationDate;
    }
}