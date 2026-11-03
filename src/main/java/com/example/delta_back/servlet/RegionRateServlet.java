
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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/regionrate")
public class RegionRateServlet extends HttpServlet {

    private Connection connection;
    private RegionRateCrud regionRateCrud;

    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            regionRateCrud = new RegionRateCrud(connection);
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao conectar com o Banco de Dados", e
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            List<Region_Rate> regionRates =
                    regionRateCrud.listarTodos();

            request.setAttribute("regionRate", regionRates);

            request.getRequestDispatcher("/jsp_crud/RegionRate.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao buscar taxas das regiões...", e
            );
        }
    }

    private boolean regiaoExiste(int regionId) throws Exception {
        String sql = "SELECT 1 FROM tb_region WHERE id = ?";

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setInt(1, regionId);

            try (ResultSet resultado = stmt.executeQuery()) {
                return resultado.next();
            }
        }
    }

    private int lerInteiroPositivo(
            HttpServletRequest request,
            String parametro
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || !valor.trim().matches("[0-9]+")) {
            throw new IllegalArgumentException(
                    "O campo " + nomeCampo(parametro)
                            + " deve ser um número inteiro positivo."
            );
        }

        try {
            int numero = Integer.parseInt(valor.trim());

            if (numero <= 0) {
                throw new IllegalArgumentException(
                        "O campo " + nomeCampo(parametro)
                                + " deve ser maior que zero."
                );
            }

            return numero;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "O campo " + nomeCampo(parametro)
                            + " contém um número inválido."
            );
        }
    }

    private String nomeCampo(String parametro) {
        switch (parametro) {
            case "region_id":
                return "ID da Região";

            case "id":
                return "ID da taxa regional";

            default:
                return parametro;
        }
    }

    private BigDecimal lerValor(HttpServletRequest request) {
        String valor = request.getParameter("m3value");

        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "O valor por metro cúbico é obrigatório."
            );
        }

        BigDecimal numero;

        try {
            numero = new BigDecimal(valor.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Informe um valor válido para o metro cúbico."
            );
        }

        if (numero.signum() <= 0) {
            throw new IllegalArgumentException(
                    "O valor por metro cúbico deve ser maior que zero."
            );
        }

        return numero;
    }

    private LocalDate lerData(
            HttpServletRequest request,
            String parametro
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "O campo " + nomeCampoData(parametro)
                            + " é obrigatório."
            );
        }

        try {
            LocalDate data = LocalDate.parse(valor.trim());
            if (data.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException(
                        "O campo " + nomeCampoData(parametro)
                                + " não pode ser uma data futura."
                );
            }
            return data;
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(
                    "A data do campo " + nomeCampoData(parametro)
                            + " é inválida."
            );
        }
    }

    private String nomeCampoData(String parametro) {
        switch (parametro) {
            case "initial_validity":
                return "Início da Validade";

            case "final_validity":
                return "Fim da Validade";

            default:
                return parametro;
        }
    }

    private void validarTaxa(
            int regionId,
            BigDecimal m3value,
            LocalDate initialValidity,
            LocalDate finalValidity
    ) throws Exception {

        if (!regiaoExiste(regionId)) {
            throw new IllegalArgumentException(
                    "ID da Região: a região informada não existe. "
                            + "Corrija o ID e tente novamente."
            );
        }

        if (m3value == null || m3value.signum() <= 0) {
            throw new IllegalArgumentException(
                    "Valor por m³: informe um valor maior que zero."
            );
        }

        if (initialValidity.isAfter(finalValidity)) {
            throw new IllegalArgumentException(
                    "Fim da Validade: a data final não pode ser anterior "
                            + "à data inicial."
            );
        }
    }

    private void enviarErro(
            HttpServletResponse response,
            String mensagem
    ) throws IOException {

        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(mensagem);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            int regionId =
                    lerInteiroPositivo(request, "region_id");

            BigDecimal m3value = lerValor(request);

            LocalDate initialValidity =
                    lerData(request, "initial_validity");

            LocalDate finalValidity =
                    lerData(request, "final_validity");

            validarTaxa(
                    regionId,
                    m3value,
                    initialValidity,
                    finalValidity
            );

            Region_Rate regionRate = new Region_Rate(
                    0,
                    regionId,
                    m3value,
                    initialValidity,
                    finalValidity
            );

            regionRateCrud.inserir(regionRate);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao cadastrar taxa da região...", e
            );
        }
    }

    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            int id = lerInteiroPositivo(request, "id");

            int regionId =
                    lerInteiroPositivo(request, "region_id");

            BigDecimal m3value = lerValor(request);

            LocalDate initialValidity =
                    lerData(request, "initial_validity");

            LocalDate finalValidity =
                    lerData(request, "final_validity");

            validarTaxa(
                    regionId,
                    m3value,
                    initialValidity,
                    finalValidity
            );

            Region_Rate regionRate = new Region_Rate(
                    id,
                    regionId,
                    m3value,
                    initialValidity,
                    finalValidity
            );

            regionRateCrud.atualizar(regionRate);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao atualizar taxa da região...", e
            );
        }
    }

    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            int id = lerInteiroPositivo(request, "id");

            regionRateCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao deletar taxa da região...", e
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
            e.printStackTrace();
        }
    }
}
