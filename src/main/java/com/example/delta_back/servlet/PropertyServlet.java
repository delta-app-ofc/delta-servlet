
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
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;

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
            throw new ServletException(
                    "Erro ao conectar com o banco de dados.", e
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            List<Property> properties = propertyCrud.listarTodos();

            request.setAttribute("properties", properties);

            request.getRequestDispatcher("/jsp_crud/Property.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Erro ao buscar propriedades.", e
            );
        }
    }

    private String lerTextoObrigatorio(
            HttpServletRequest request,
            String parametro,
            String nomeCampo
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "O campo " + nomeCampo + " é obrigatório."
            );
        }

        return valor.trim().toUpperCase(Locale.ROOT);
    }

    private int lerInteiroPositivo(
            HttpServletRequest request,
            String parametro,
            String nomeCampo
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || !valor.trim().matches("[0-9]+")) {
            throw new IllegalArgumentException(
                    "O campo " + nomeCampo
                            + " deve ser um número inteiro positivo."
            );
        }

        try {
            int numero = Integer.parseInt(valor.trim());

            if (numero <= 0) {
                throw new IllegalArgumentException(
                        "O campo " + nomeCampo
                                + " deve ser maior que zero."
                );
            }

            return numero;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "O valor do campo " + nomeCampo + " é inválido."
            );
        }
    }

    private LocalDate lerData(
            HttpServletRequest request,
            String parametro
    ) {
        String valor = request.getParameter(parametro);

        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "A Data de Registro é obrigatória."
            );
        }

        try {
            LocalDate data = LocalDate.parse(valor.trim());

            if (data.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException(
                        "A Data de Registro não pode ser futura."
                );
            }

            return data;
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(
                    "A Data de Registro informada é inválida."
            );
        }
    }

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

    private boolean erroDeChaveEstrangeira(SQLException erro) {
        SQLException atual = erro;

        while (atual != null) {
            String estado = atual.getSQLState();

            if (estado != null && estado.startsWith("23")) {
                return true;
            }

            atual = atual.getNextException();
        }

        return false;
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

    private void tratarErroOperacao(
            RuntimeException erro,
            HttpServletResponse response
    ) throws IOException, ServletException {
        SQLException sqlException = encontrarSQLException(erro);

        if (sqlException != null) {
            if (erroDeChaveEstrangeira(sqlException)) {
                enviarErro(
                        response,
                        "O ID do Endereço informado não existe ou não pode ser utilizado. Verifique e corrija esse campo."
                );
                return;
            }

            getServletContext().log(
                    "Erro de banco de dados em Propriedades.",
                    sqlException
            );

            enviarErro(
                    response,
                    "Não foi possível concluir a operação no banco de dados. Confira os dados informados."
            );
            return;
        }

        enviarErro(
                response,
                erro.getMessage() == null
                        ? "Não foi possível concluir a operação."
                        : erro.getMessage()
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            String name =
                    lerTextoObrigatorio(request, "name", "Nome");

            String type =
                    lerTextoObrigatorio(request, "type", "Tipo");

            String classification =
                    lerTextoObrigatorio(
                            request, "classification", "Classificação"
                    );

            int addressId =
                    lerInteiroPositivo(
                            request, "addressId", "ID do Endereço"
                    );

            LocalDate registrationDate =
                    lerData(request, "registrationDate");

            Property property = new Property(
                    0,
                    name,
                    type,
                    classification,
                    addressId,
                    registrationDate
            );

            propertyCrud.inserir(property);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());
        } catch (RuntimeException e) {
            tratarErroOperacao(e, response);
        }
    }

    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            int id =
                    lerInteiroPositivo(
                            request, "id", "ID da Propriedade"
                    );

            String name =
                    lerTextoObrigatorio(request, "name", "Nome");

            String type =
                    lerTextoObrigatorio(request, "type", "Tipo");

            String classification =
                    lerTextoObrigatorio(
                            request, "classification", "Classificação"
                    );

            int addressId =
                    lerInteiroPositivo(
                            request, "addressId", "ID do Endereço"
                    );

            LocalDate registrationDate =
                    lerData(request, "registrationDate");

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

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());
        } catch (RuntimeException e) {
            tratarErroOperacao(e, response);
        }
    }

    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        try {
            int id =
                    lerInteiroPositivo(
                            request, "id", "ID da Propriedade"
                    );

            propertyCrud.deletar(id);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (IllegalArgumentException e) {
            enviarErro(response, e.getMessage());
        } catch (RuntimeException e) {
            tratarErroOperacao(e, response);
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
                    "Erro ao fechar a conexão do banco de dados.", e
            );
        }
    }
}
