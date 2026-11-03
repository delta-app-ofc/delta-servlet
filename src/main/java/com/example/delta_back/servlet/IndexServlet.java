
package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/inicio")
public class IndexServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String sql = """
                SELECT
                    (SELECT COUNT(*) FROM tb_user) AS total_users,
                    (SELECT COUNT(*) FROM tb_property) AS total_properties,
                    (SELECT COUNT(*) FROM tb_device) AS total_devices,
                    (SELECT COUNT(*) FROM tb_region) AS total_regions,
                    (SELECT COUNT(*) FROM tb_device
                     WHERE is_active = TRUE) AS active_devices,
                    (
                        (SELECT COUNT(*) FROM tb_user) +
                        (SELECT COUNT(*) FROM tb_property) +
                        (SELECT COUNT(*) FROM tb_device) +
                        (SELECT COUNT(*) FROM tb_region) +
                        (SELECT COUNT(*) FROM tb_region_rate) +
                        (SELECT COUNT(*) FROM tb_address)
                    ) AS total_records
                """;

        try (Connection connection = ConexaoBD.conectar();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql)) {

            if (resultSet.next()) {
                request.setAttribute(
                        "totalUsers", resultSet.getLong("total_users"));

                request.setAttribute(
                        "totalProperties",
                        resultSet.getLong("total_properties"));

                request.setAttribute(
                        "totalDevices", resultSet.getLong("total_devices"));

                request.setAttribute(
                        "totalRegions", resultSet.getLong("total_regions"));

                request.setAttribute(
                        "activeDevices",
                        resultSet.getLong("active_devices"));

                request.setAttribute(
                        "totalRecords", resultSet.getLong("total_records"));
            }

            request.getRequestDispatcher("/jsp_crud/Inicio.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Erro ao carregar os dados do painel inicial.", e);
        }
    }
}
