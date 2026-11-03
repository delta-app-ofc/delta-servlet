// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
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
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Locale;

@WebServlet("/address")
// Documentação da classe AddressServlet: reúne os dados e comportamentos deste tipo.
public class AddressServlet extends HttpServlet {

    private static final Locale PT_BR = Locale.forLanguageTag("pt-BR");

    private Connection conexao;
    private AddressCrud addressCrud;

    @Override
    // Metodo: init; executa a operacao init neste componente.
    public void init() throws ServletException {
        try {
            conexao = ConexaoBD.conectar();
            addressCrud = new AddressCrud(conexao);
        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao conectar com o banco de dados.", e
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
            List<Address> addresses = addressCrud.listarTodos();

            request.setAttribute("addresses", addresses);

            request.getRequestDispatcher("/jsp_crud/Address.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao buscar endereços.", e
            );
        }
    }

    // Metodo: ler Inteiro Positivo; executa a operacao ler Inteiro Positivo neste componente.
    private int lerInteiroPositivo(
            HttpServletRequest request,
            String parametro,
            String rotulo
    ) {
        String valor = request.getParameter(parametro);

        String mensagem = "O " + rotulo
                + " deve ser um número inteiro positivo.";

        if (valor == null || !valor.trim().matches("[1-9][0-9]*")) {
            throw new IllegalArgumentException(mensagem);
        }

        try {
            return Integer.parseInt(valor.trim());

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(mensagem);
        }
    }

    // Metodo: ler Obrigatorio; executa a operacao ler Obrigatorio neste componente.
    private String lerObrigatorio(
            HttpServletRequest request,
            String parametro,
            String rotulo
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "O campo " + rotulo + " é obrigatório."
            );
        }

        return valor.trim();
    }

    // Metodo: validar Region Id; executa a operacao validar Region Id neste componente.
    private int validarRegionId(HttpServletRequest request) {
        return lerInteiroPositivo(
                request,
                "regionId",
                "ID da região"
        );
    }

    // Metodo: validar Cep; executa a operacao validar Cep neste componente.
    private String validarCep(HttpServletRequest request) {
        String cep = request.getParameter("cep");

        if (cep == null || !cep.trim().matches("[0-9]{8}")) {
            throw new IllegalArgumentException(
                    "O CEP deve conter exatamente 8 números, sem hífen."
            );
        }

        return cep.trim();
    }

    // Metodo: validar Cidade; executa a operacao validar Cidade neste componente.
    private String validarCidade(HttpServletRequest request) {
        return lerObrigatorio(request, "city", "Cidade")
                .toUpperCase(PT_BR);
    }

    // Metodo: validar Estado; executa a operacao validar Estado neste componente.
    private String validarEstado(HttpServletRequest request) {
        return lerObrigatorio(request, "state", "Estado");
    }

    // Metodo: validar Regiao; executa a operacao validar Regiao neste componente.
    private void validarRegiao(int regionId) throws Exception {
        String sql = "SELECT 1 FROM tb_region WHERE id = ?";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, regionId);

            try (ResultSet resultado = stmt.executeQuery()) {
                if (!resultado.next()) {
                    throw new IllegalArgumentException(
                            "A região informada não existe. "
                                    + "Verifique o ID da região."
                    );
                }
            }
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

        try (PrintWriter out = response.getWriter()) {
            out.write(mensagem);
        }
    }

    @Override
    // Metodo: do Post; processa os dados enviados por uma requisicao HTTP POST.
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int regionId = validarRegionId(request);
            String cep = validarCep(request);
            String city = validarCidade(request);
            String state = validarEstado(request);

            validarRegiao(regionId);

            Address address = new Address(
                    0,
                    regionId,
                    cep,
                    city,
                    state
            );

            addressCrud.inserir(address);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao cadastrar endereço.", e
            );
        }
    }

    @Override
    // Metodo: do Put; executa a operacao do Put neste componente.
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int id = lerInteiroPositivo(
                    request,
                    "id",
                    "ID do endereço"
            );

            int regionId = validarRegionId(request);
            String cep = validarCep(request);
            String city = validarCidade(request);
            String state = validarEstado(request);

            validarRegiao(regionId);

            Address address = new Address(
                    id,
                    regionId,
                    cep,
                    city,
                    state
            );

            addressCrud.atualizar(address);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao atualizar endereço.", e
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
            int id = lerInteiroPositivo(
                    request,
                    "id",
                    "ID do endereço"
            );

            addressCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao deletar endereço.", e
            );
        }
    }

    @Override
    // Metodo: destroy; executa a operacao destroy neste componente.
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
