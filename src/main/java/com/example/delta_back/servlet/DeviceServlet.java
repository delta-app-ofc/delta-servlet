package com.example.delta_back.servlet;

import com.example.delta_back.conexao.ConexaoBD;
import com.example.delta_back.model.Device;
import com.example.delta_back.crud.DeviceCrud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/device")
public class DeviceServlet extends HttpServlet {

    private Connection connection;
    private DeviceCrud deviceCrud;

    @Override
    public void init() throws ServletException {
        try {
            connection = ConexaoBD.conectar();
            deviceCrud = new DeviceCrud(connection);
        } catch (Exception e) {
            throw new ServletException("Erro ao conectar com o banco de dados.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Device> devices = deviceCrud.listarTodos();
            request.setAttribute("devices", devices);
            request.getRequestDispatcher("/device.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Erro ao buscar dispositivos.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String deviceId = request.getParameter("deviceId");
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            boolean active = Boolean.parseBoolean(request.getParameter("active"));

            String data = request.getParameter("installationDate");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate installationDate = LocalDate.parse(data, formatter);

            Device device = new Device(
                    0,
                    deviceId,
                    propertyId,
                    active,
                    installationDate
            );

            deviceCrud.inserir(device);

            response.sendRedirect(request.getContextPath() + "/device");
        } catch (Exception e) {
            throw new ServletException("Erro ao cadastrar dispositivo.", e);
        }
    }

    // Atualizar dispositivo - PUT
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String deviceId = request.getParameter("deviceId");
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            boolean active = Boolean.parseBoolean(request.getParameter("active"));

            String data = request.getParameter("installationDate");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate installationDate = LocalDate.parse(data, formatter);

            Device device = new Device(
                    id,
                    deviceId,
                    propertyId,
                    active,
                    installationDate
            );

            deviceCrud.atualizar(device);

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            throw new ServletException("Erro ao atualizar dispositivo.", e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            deviceCrud.deletar(id);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            throw new ServletException("Erro ao deletar dispositivo.", e);
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