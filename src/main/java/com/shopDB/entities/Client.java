package com.shopDB.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "clients")
//@NamedStoredProcedureQuery(name = "Client.addClient", procedureName = "add_client", parameters = {
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "login", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "password", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "type", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "email", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "phone", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "cookies", type = boolean.class),
//})
public class Client {
    public static final String INDIVIDUAL_TYPE = "individual";
    public static final String COMPANY_TYPE = "company";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "client_id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Lob
    @Column(name = "type", nullable = false)
    private String type;

    @Column(name = "name")
    private String name;

    @Column(name = "surname")
    private String surname;

    @Column(name = "company_name")
    private String companyName;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "phone", nullable = false, length = 15)
    private String phone;

    @Column(name = "NIP", nullable = false, length = 10)
    private String nip;

    @Column(name = "RODO")
    private Boolean rodo;

    @Column(name = "terms_of_use")
    private Boolean termsOfUse;

    @Column(name = "cookies")
    private Boolean cookies;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getNip() {
        return nip;
    }

    public void setNip(String nip) {
        this.nip = nip;
    }

    public Boolean getRodo() {
        return rodo;
    }

    public void setRodo(Boolean rodo) {
        this.rodo = rodo;
    }

    public Boolean getTermsOfUse() {
        return termsOfUse;
    }

    public void setTermsOfUse(Boolean termsOfUse) {
        this.termsOfUse = termsOfUse;
    }

    public Boolean getCookies() {
        return cookies;
    }

    public void setCookies(Boolean cookies) {
        this.cookies = cookies;
    }

}