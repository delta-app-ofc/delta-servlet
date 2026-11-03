// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.crud.DeviceCrud;
import com.example.delta_back.model.Device;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/device")
// Documentação da classe DeviceServlet: reúne os dados e comportamentos deste tipo.
public class DeviceServlet extends HttpServlet {

    private Connection connection;
    private DeviceCrud deviceCrud;

    @Override
    // Metodo: init; executa a operacao init neste componente.
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            deviceCrud = new DeviceCrud(connection);
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
            List<Device> devices = deviceCrud.listarTodos();

            request.setAttribute("devices", devices);

            request.getRequestDispatcher("/jsp_crud/Device.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(
                    "Erro ao buscar dispositivos.", e
            );
        }
    }

    // Metodo: ler Inteiro Positivo; executa a operacao ler Inteiro Positivo neste componente.
    private int lerInteiroPositivo(
            HttpServletRequest request,
            String parametro,
            String mensagemErro
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || !valor.trim().matches("[0-9]+")) {
            throw new IllegalArgumentException(mensagemErro);
        }

        try {
            int numero = Integer.parseInt(valor.trim());

            if (numero <= 0) {
                throw new IllegalArgumentException(mensagemErro);
            }

            return numero;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(mensagemErro);
        }
    }

    // Metodo: ler Device Id; executa a operacao ler Device Id neste componente.
    private String lerDeviceId(HttpServletRequest request) {
        String valor = request.getParameter("deviceId");

        if (valor == null || !valor.trim().matches("[0-9]{6,}")) {
            throw new IllegalArgumentException(
                    "O ID do dispositivo deve conter no mínimo 6 dígitos."
            );
        }

        return valor.trim();
    }

    // Metodo: ler Property Id; executa a operacao ler Property Id neste componente.
    private int lerPropertyId(HttpServletRequest request) {
        return lerInteiroPositivo(
                request,
                "propertyId",
                "Informe um ID de propriedade inteiro e maior que zero."
        );
    }

    // Metodo: ler Ativo; executa a operacao ler Ativo neste componente.
    private boolean lerAtivo(HttpServletRequest request) {
        String valor = request.getParameter("active");

        if ("true".equals(valor)) {
            return true;
        }

        if ("false".equals(valor)) {
            return false;
        }

        throw new IllegalArgumentException(
                "Selecione se o dispositivo está ativo."
        );
    }

    // Metodo: ler Data; executa a operacao ler Data neste componente.
    private LocalDate lerData(HttpServletRequest request) {
        String valor = request.getParameter("installationDate");

        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "A data de instalação é obrigatória."
            );
        }

        LocalDate data;

        try {
            data = LocalDate.parse(valor.trim());

        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(
                    "A data de instalação é inválida."
            );
        }

        if (data.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException(
                    "A data de instalação não pode ser futura."
            );
        }

        return data;
    }

    // Metodo: validar Propriedade; executa a operacao validar Propriedade neste componente.
    private void validarPropriedade(int propertyId)
            throws SQLException {

        String sql = "SELECT 1 FROM tb_property WHERE id = ?";

        try (PreparedStatement stmt =
                     connection.prepareStatement(sql)) {

            stmt.setInt(1, propertyId);

            try (ResultSet resultado = stmt.executeQuery()) {
                if (!resultado.next()) {
                    throw new IllegalArgumentException(
                            "A propriedade informada não existe."
                    );
                }
            }
        }
    }

    // Metodo: montar Device; executa a operacao montar Device neste componente.
    private Device montarDevice(
            HttpServletRequest request,
            int id
    ) throws SQLException {

        String deviceId = lerDeviceId(request);
        int propertyId = lerPropertyId(request);
        boolean active = lerAtivo(request);
        LocalDate installationDate = lerData(request);

        validarPropriedade(propertyId);

        return new Device(
                id,
                deviceId,
                propertyId,
                active,
                installationDate
        );
    }

    // Metodo: ler Id; executa a operacao ler Id neste componente.
    private int lerId(HttpServletRequest request) {
        return lerInteiroPositivo(
                request,
                "id",
                "O ID do registro deve ser um número inteiro positivo."
        );
    }

    // Metodo: enviar Erro; executa a operacao enviar Erro neste componente.
    private void enviarErro(
            HttpServletResponse response,
            int status,
            String mensagem
    ) throws IOException {

        if (response.isCommitted()) {
            return;
        }

        response.resetBuffer();
        response.setStatus(status);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(mensagem);
    }

    // Metodo: encontrar SQLException; consulta os dados indicados pelos parametros recebidos.
    private SQLException encontrarSQLException(Throwable erro) {
        Throwable atual = erro;

        while (atual != null) {
            if (atual instanceof SQLException) {
                return (SQLException) atual;
            }

            atual = atual.getCause();
        }

        return null;
    }

    // Metodo: tratar Erro; executa a operacao tratar Erro neste componente.
    private void tratarErro(
            Exception erro,
            HttpServletResponse response
    ) throws IOException {

        if (erro instanceof IllegalArgumentException) {
            enviarErro(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    erro.getMessage()
            );
            return;
        }

        System.err.println("ERRO NA OPERAÇÃO DE DISPOSITIVO:");
        erro.printStackTrace();

        SQLException sqlErro = encontrarSQLException(erro);

        if (sqlErro != null) {
            String estado = sqlErro.getSQLState();

            if ("23505".equals(estado)) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Já existe um dispositivo com esse identificador."
                );
                return;
            }

            if ("23503".equals(estado)) {
                enviarErro(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "A operação viola uma referência entre registros."
                );
                return;
            }
        }

        enviarErro(
                response,
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Não foi possível concluir a operação. "
                        + "Verifique o console do servidor."
        );
    }

    @Override
    // Metodo: do Post; processa os dados enviados por uma requisicao HTTP POST.
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            Device device = montarDevice(request, 0);

            deviceCrud.inserir(device);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            tratarErro(e, response);
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
            int id = lerId(request);

            Device device = montarDevice(request, id);

            deviceCrud.atualizar(device);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            tratarErro(e, response);
        }
    }

    @Override
    // Metodo: do Delete; executa a operacao do Delete neste componente.
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            int id = lerId(request);

            deviceCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            tratarErro(e, response);
        }
    }

    @Override
    // Metodo: destroy; executa a operacao destroy neste componente.
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
