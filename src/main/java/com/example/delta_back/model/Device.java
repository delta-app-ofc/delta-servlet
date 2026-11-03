// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.model;

import java.time.LocalDate;

// Documentação da classe Device: reúne os dados e comportamentos deste tipo.
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
    // Metodo: get Id; retorna o valor do atributo Id.
    public int getId() {
        return id;
    }

    // Metodo: set Id; define o atributo Id com o dado recebido.
    public void setId(int id) {
        this.id = id;
    }

    // Metodo: get Device Id; retorna o valor do atributo DeviceId.
    public String getDeviceId() {
        return deviceId;
    }

    // Metodo: set Device Id; define o atributo DeviceId com o dado recebido.
    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    // Metodo: get Property Id; retorna o valor do atributo PropertyId.
    public int getPropertyId() {
        return propertyId;
    }

    // Metodo: set Property Id; define o atributo PropertyId com o dado recebido.
    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }

    // Metodo: is Active; verifica a condicao Active.
    public boolean isActive() {
        return active;
    }

    // Metodo: set Active; define o atributo Active com o dado recebido.
    public void setActive(boolean active) {
        this.active = active;
    }

    // Metodo: get Installation Date; retorna o valor do atributo InstallationDate.
    public LocalDate getInstallationDate() {
        return installationDate;
    }

    // Metodo: set Installation Date; define o atributo InstallationDate com o dado recebido.
    public void setInstallationDate(LocalDate installationDate) {
        this.installationDate = installationDate;
    }
}