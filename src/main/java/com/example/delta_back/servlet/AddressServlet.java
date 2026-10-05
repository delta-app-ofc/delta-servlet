package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.model.Address;
import com.example.delta_back.crud.AddressCrud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {

    private Connection conexao;
    private AddressCrud addressCrud;

    @Override
    public void init() throws ServletException {
        try {
            conexao = ConexaoBD.conectar();
            addressCrud = new AddressCrud(conexao);
        } catch (Exception e) {
            throw new ServletException("Erro ao conectar com o banco de dados.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Address> addresses = addressCrud.listarTodos();
            request.setAttribute("addresses", addresses);
            request.getRequestDispatcher("/address.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Erro ao buscar endereços.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int regionId = Integer.parseInt(request.getParameter("regionId"));
            String cep = request.getParameter("cep");
            String city = request.getParameter("city");
            String state = request.getParameter("state");

            Address address = new Address(0, regionId, cep, city, state);
            addressCrud.inserir(address);

            response.sendRedirect(request.getContextPath() + "/address");
        } catch (Exception e) {
            throw new ServletException("Erro ao cadastrar endereço.", e);
        }
    }

    // Atualizar endereço - PUT
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int regionId = Integer.parseInt(request.getParameter("regionId"));
            String cep = request.getParameter("cep");
            String city = request.getParameter("city");
            String state = request.getParameter("state");

            Address address = new Address(
                    id,
                    regionId,
                    cep,
                    city,
                    state
            );

            addressCrud.atualizar(address);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao atualizar endereço.", e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            addressCrud.deletar(id);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            throw new ServletException("Erro ao deletar endereço.", e);
        }
    }

    @Override
    public void destroy() {
        try {
            if (conexao != null && !conexao.isClosed()) {
                conexao.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}