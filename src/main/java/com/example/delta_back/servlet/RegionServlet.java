package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.model.Region;
import com.example.delta_back.crud.RegionCrud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/region")
public class RegionServlet extends HttpServlet {

    private Connection connection;
    private RegionCrud regionCrud;

    // Iniciando conexão com o BD, e passando-a para a RegionCrud quando o servlet liga
    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.connect();
            regionCrud = new RegionCrud(connection);
        } catch (Exception e) {
            throw new ServletException("Erro ao conectar ao banco...", e);
        }
    }

    // Consultar a região
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<Region> regions = regionCrud.listarTodos();

            request.setAttribute("region", regions);

            request.getRequestDispatcher("/region.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erro ao buscar região...", e);
        }
    }

    // Cadastrar região
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            String name = request.getParameter("name");

            Region region = new Region(
                    0,
                    name
            );

            regionCrud.inserir(region);

            response.sendRedirect(request.getContextPath() + "/region");
        } catch (Exception e) {
            throw new ServletException("Erro ao cadastrar região...", e);
        }
    }

    // Deletar regiao
    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            regionCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao deletar regiõ...", e);
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
