
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
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;

@WebServlet("/region")
public class RegionServlet extends HttpServlet {

    private Connection connection;
    private RegionCrud regionCrud;

    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            regionCrud = new RegionCrud(connection);
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao conectar ao banco de dados.",
                    e
            );
        }
    }

    private void enviarErro(
            HttpServletResponse response,
            int status,
            String mensagem
    ) throws IOException {
        response.setStatus(status);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(mensagem);
    }

    private String validarNome(String name) {
        if (name == null || name.isBlank()) {
            return "O nome da região é obrigatório.";
        }

        name = name.trim();

        if (name.length() < 2 || name.length() > 20) {
            return "O nome da região deve ter entre 2 e 20 caracteres.";
        }

        return null;
    }

    private boolean regiaoExiste(int id) throws Exception {
        List<Region> regions = regionCrud.listarTodos();

        return regions.stream()
                .anyMatch(region -> region.getId() == id);
    }

    private int validarId(String idParameter) {
        if (idParameter == null
                || !idParameter.matches("[1-9][0-9]{0,9}")) {
            throw new IllegalArgumentException(
                    "O ID da região é inválido. Verifique o ID informado."
            );
        }

        try {
            return Integer.parseInt(idParameter);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "O ID da região é inválido. Verifique o ID informado."
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            List<Region> regions = regionCrud.listarTodos();

            request.setAttribute("region", regions);

            request.getRequestDispatcher("/jsp_crud/Region.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao buscar regiões.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("name");
            String erro = validarNome(name);

            if (erro != null) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        erro
                );
                return;
            }

            name = name.trim().toUpperCase(Locale.ROOT);

            Region region = new Region(0, name);
            regionCrud.inserir(region);

            response.setStatus(HttpServletResponse.SC_CREATED);

        } catch (Exception e) {
            getServletContext().log("Erro ao cadastrar região.", e);

            enviarErro(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Não foi possível cadastrar a região. Verifique os dados e tente novamente."
            );
        }
    }

    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int id = validarId(request.getParameter("id"));
            String name = request.getParameter("name");

            String erro = validarNome(name);

            if (erro != null) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        erro
                );
                return;
            }

            if (!regiaoExiste(id)) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "A região informada não foi encontrada. Verifique o ID e tente novamente."
                );
                return;
            }

            name = name.trim().toUpperCase(Locale.ROOT);

            Region region = new Region(id, name);
            regionCrud.atualizar(region);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );

        } catch (Exception e) {
            getServletContext().log("Erro ao atualizar região.", e);

            enviarErro(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Não foi possível atualizar a região. Verifique os dados e tente novamente."
            );
        }
    }

    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            int id = validarId(request.getParameter("id"));

            if (!regiaoExiste(id)) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "A região informada não foi encontrada. Verifique o ID e tente novamente."
                );
                return;
            }

            regionCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(
                    response,
                    HttpServletResponse.SC_NOT_FOUND,
                    e.getMessage()
            );

        } catch (IllegalStateException e) {
            if (e.getCause() instanceof SQLException sqlException
                    && "23503".equals(sqlException.getSQLState())) {

                enviarErro(
                        response,
                        HttpServletResponse.SC_CONFLICT,
                        e.getMessage()
                );

            } else {
                getServletContext().log("Erro ao excluir região.", e);

                enviarErro(
                        response,
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Não foi possível excluir a região. Tente novamente."
                );
            }

        } catch (Exception e) {
            getServletContext().log("Erro ao excluir região.", e);

            enviarErro(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Não foi possível excluir a região. Tente novamente."
            );
        }
    }

    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (Exception e) {
            getServletContext().log(
                    "Erro ao fechar a conexão com o banco de dados.",
                    e
            );
        }
    }
}
