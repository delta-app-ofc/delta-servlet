
// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
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
// Documentação da classe RegionRateServlet: reúne os dados e comportamentos deste tipo.
public class RegionRateServlet extends HttpServlet {

    private Connection connection;
    private RegionRateCrud regionRateCrud;

    @Override
    // Metodo: init; executa a operacao init neste componente.
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
    // Metodo: do Get; processa uma requisicao HTTP GET e prepara a resposta.
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

    // Metodo: regiao Existe; executa a operacao regiao Existe neste componente.
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

    // Metodo: ler Inteiro Positivo; executa a operacao ler Inteiro Positivo neste componente.
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

    // Metodo: nome Campo; executa a operacao nome Campo neste componente.
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

    // Metodo: ler Valor; executa a operacao ler Valor neste componente.
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

    // Metodo: ler Data; executa a operacao ler Data neste componente.
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

    // Metodo: nome Campo Data; executa a operacao nome Campo Data neste componente.
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

    // Metodo: validar Taxa; executa a operacao validar Taxa neste componente.
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

    // Metodo: enviar Erro; executa a operacao enviar Erro neste componente.
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
    // Metodo: do Post; processa os dados enviados por uma requisicao HTTP POST.
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
    // Metodo: do Put; executa a operacao do Put neste componente.
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
    // Metodo: do Delete; executa a operacao do Delete neste componente.
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
    // Metodo: destroy; executa a operacao destroy neste componente.
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
