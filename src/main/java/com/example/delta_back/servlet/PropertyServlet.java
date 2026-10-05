package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.model.Property;
import com.example.delta_back.crud.PropertyCrud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/property")
public class PropertyServlet extends HttpServlet {

    private Connection connection;
    private PropertyCrud propertyCrud;

    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            propertyCrud = new PropertyCrud(connection);
        } catch (Exception e) {
            throw new ServletException("Erro ao conectar com o banco de dados.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Property> properties = propertyCrud.listarTodos();
            request.setAttribute("properties", properties);
            request.getRequestDispatcher("/property.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Erro ao buscar propriedades.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String classification = request.getParameter("classification");
            int addressId = Integer.parseInt(request.getParameter("addressId"));

            String data = request.getParameter("registrationDate");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate registrationDate = LocalDate.parse(data, formatter);

            Property property = new Property(
                    0,
                    name,
                    type,
                    classification,
                    addressId,
                    registrationDate
            );

            propertyCrud.inserir(property);

            response.sendRedirect(request.getContextPath() + "/property");
        } catch (Exception e) {
            throw new ServletException("Erro ao cadastrar propriedade.", e);
        }
    }

    // Atualizar propriedade - PUT
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String classification = request.getParameter("classification");
            int addressId = Integer.parseInt(request.getParameter("addressId"));

            String data = request.getParameter("registrationDate");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate registrationDate = LocalDate.parse(data, formatter);

            Property property = new Property(
                    id,
                    name,
                    type,
                    classification,
                    addressId,
                    registrationDate
            );

            propertyCrud.atualizar(property);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao atualizar propriedade.", e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            propertyCrud.deletar(id);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            throw new ServletException("Erro ao deletar propriedade.", e);
        }
    }

    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}