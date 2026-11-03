<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Documentação da página: EntrarContaADM; apresenta a interface e envia os dados necessários ao fluxo correspondente. --%>
<% request.setAttribute("loginRole", "admin"); %>
<jsp:include page="EntrarConta.jsp" />
