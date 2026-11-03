// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.model;

import java.time.LocalDate;

// Documentação da classe User: reúne os dados e comportamentos deste tipo.
public class User {

    // Definindo atributos do objeto Usuário
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private LocalDate birthDate;
    private LocalDate registrationDate;
    private boolean active;
    private boolean admin;
    private boolean manager;

    // Construtor
    public User(int id, String name, String email, String password,
                String phone, LocalDate birthDate,
                LocalDate registrationDate, boolean active,
                boolean admin, boolean manager) {

        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.birthDate = birthDate;
        this.registrationDate = registrationDate;
        this.active = active;
        this.admin = admin;
        this.manager = manager;
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

    // Metodo: get Email; retorna o valor do atributo Email.
    public String getEmail() {
        return email;
    }

    // Metodo: set Email; define o atributo Email com o dado recebido.
    public void setEmail(String email) {
        this.email = email;
    }

    // Metodo: get Password; retorna o valor do atributo Password.
    public String getPassword() {
        return password;
    }

    // Metodo: set Password; define o atributo Password com o dado recebido.
    public void setPassword(String password) {
        this.password = password;
    }

    // Metodo: get Phone; retorna o valor do atributo Phone.
    public String getPhone() {
        return phone;
    }

    // Metodo: set Phone; define o atributo Phone com o dado recebido.
    public void setPhone(String phone) {
        this.phone = phone;
    }

    // Metodo: get Birth Date; retorna o valor do atributo BirthDate.
    public LocalDate getBirthDate() {
        return birthDate;
    }

    // Metodo: set Birth Date; define o atributo BirthDate com o dado recebido.
    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    // Metodo: get Registration Date; retorna o valor do atributo RegistrationDate.
    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    // Metodo: set Registration Date; define o atributo RegistrationDate com o dado recebido.
    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = registrationDate;
    }

    // Metodo: is Active; verifica a condicao Active.
    public boolean isActive() {
        return active;
    }

    // Metodo: set Active; define o atributo Active com o dado recebido.
    public void setActive(boolean active) {
        this.active = active;
    }

    // Metodo: is Admin; verifica a condicao Admin.
    public boolean isAdmin() {
        return admin;
    }

    // Metodo: set Admin; define o atributo Admin com o dado recebido.
    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    // Metodo: is Manager; verifica a condicao Manager.
    public boolean isManager() {
        return manager;
    }

    // Metodo: set Manager; define o atributo Manager com o dado recebido.
    public void setManager(boolean manager) {
        this.manager = manager;
    }

}