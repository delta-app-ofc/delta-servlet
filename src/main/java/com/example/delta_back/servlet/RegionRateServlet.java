package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.model.Region_Rate;
import com.example.delta_back.crud.RegionRateCrud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;

import java.time.format.DateTimeFormatter; // Para Interpretar String como Data

@WebServlet("/regionrate")
public class RegionRateServlet extends HttpServlet {

    private Connection connection;
    private RegionRateCrud regionRateCrud;

    // Inicia a Conexão e passa a conexão para o RegionRateCrud quando o Servlet liga
    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            regionRateCrud = new RegionRateCrud(connection);
        } catch (Exception e) {
            throw new ServletException("Erro ao conectar com o Banco de Dados", e);
        }
    }

    // Consultar Taxa Da Região - GET
    @Override
    protected void doGet(
            HttpServletRequest request, HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<Region_Rate> regionRates = regionRateCrud.listarTodos();

            request.setAttribute("regionRate", regionRates);

            request.getRequestDispatcher("/regionrate.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erro ao buscar taxas das regiões...", e);
        }
    }

    // Cadastrar Taxa Da Região
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int regionId = Integer.parseInt(request.getParameter("region_id"));
            BigDecimal m3value = new BigDecimal(request.getParameter("m3value"));

            String data = request.getParameter("initial_validity");
            String data2 = request.getParameter("final_validity");

            // Interpretando String como data (O java nao sabe o que é dia/mes/ano, entao a data virá como String e será convertida para data por conta do código abaixo.
            // O fluxo será:
            // String data -> DateTimeFormatter -> LocalDate.parse() -> LocalDate data
            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yyyy");

            LocalDate initialValidity = LocalDate.parse(data, formatter);
            LocalDate finalValidity = LocalDate.parse(data2, formatter);

            Region_Rate regionRate = new Region_Rate(
                    0,
                    regionId,
                    m3value,
                    initialValidity,
                    finalValidity
            );

            regionRateCrud.inserir(regionRate);

            response.sendRedirect(request.getContextPath() + "/regionrate");

        } catch (Exception e) {
            throw new ServletException("Erro ao cadastrar taxa da região...", e);
        }
    }

    // Atualizar Taxa Da Região - PUT
    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));
            int regionId = Integer.parseInt(request.getParameter("region_id"));
            BigDecimal m3value = new BigDecimal(request.getParameter("m3value"));

            String data = request.getParameter("initial_validity");
            String data2 = request.getParameter("final_validity");

            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yyyy");

            LocalDate initialValidity = LocalDate.parse(data, formatter);
            LocalDate finalValidity = LocalDate.parse(data2, formatter);

            Region_Rate regionRate = new Region_Rate(
                    id,
                    regionId,
                    m3value,
                    initialValidity,
                    finalValidity
            );

            regionRateCrud.atualizar(regionRate);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao atualizar taxa da região...", e);
        }
    }

    // Deletar Taxa Da Região
    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            regionRateCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao deletar taxa da região...", e);
        }
    }

    // Fecha a conexão
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