// Documentação do arquivo: declara os tipos e operações do componente desta pasta.
package com.example.delta_back.servlet;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/inicio", "/user", "/region", "/regionrate", "/property", "/device", "/address"})
// Documentação da classe CrudAuthorizationFilter: reúne os dados e comportamentos deste tipo.
public class CrudAuthorizationFilter implements Filter {

    @Override
    // Metodo: do Filter; executa a operacao do Filter neste componente.
    public void doFilter(jakarta.servlet.ServletRequest servletRequest,
                         jakarta.servlet.ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("authUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean admin = Boolean.TRUE.equals(session.getAttribute("authIsAdmin"));
        boolean manager = Boolean.TRUE.equals(session.getAttribute("authIsManager"));
        if (!admin && !manager) {
            response.sendRedirect(request.getContextPath() + "/landing-login");
            return;
        }

        chain.doFilter(request, response);
    }
}
