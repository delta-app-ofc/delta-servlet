# Delta — Backend (Servlet)

Backend do **Projeto Delta**, um sistema inteligente de monitoramento e gestão do consumo de água.

> Este repositório foi desenvolvido pela **equipe de backend do primeiro ano**, com **orientações teóricas dos membros da segunda série** do **Instituto J&F**.

## Sobre o projeto

O Delta é um sistema de monitoramento e gestão do consumo de água, voltado principalmente para ambientes residenciais e comerciais. Ele permite que os usuários acompanhem seu consumo, identifiquem desperdícios e tomem decisões mais conscientes.

A solução usa **IoT**, com sensores associados a hidrômetros para coletar dados, e uma plataforma digital que os organiza e apresenta. Entre as funcionalidades desenvolvidas estão: cadastro e gerenciamento de usuários e instalações, consumo diário e mensal, histórico de utilização, estimativa de custos e relatórios em PDF. O projeto também contempla detecção de vazamentos, alertas inteligentes e análise de dados, com diferentes níveis de implementação e integração.

- **Público-alvo:** moradores e responsáveis pela administração de imóveis, além de administradores da plataforma. O projeto também busca atender comércios e indústrias.
- ** ODS 12 ** (Consumo e Produção Responsáveis):** incentiva o uso eficiente da água, reduz desperdícios e oferece informações para hábitos de consumo mais sustentáveis.

## O que há neste repositório

Backend em **Java com Servlets Jakarta** que faz o CRUD das principais entidades, conectado a um banco **PostgreSQL**. Cada rota responde a `GET` (lista e exibe a página JSP), `POST` (cadastra), `PUT` (atualiza) e `DELETE` (remove por `id`).

| Entidade | Rota | Tabela |
| --- | --- | --- |
| Usuários | `/user` | `tb_user` |
| Endereços | `/address` | `tb_address` |
| Regiões | `/region` | `tb_region` |
| Tarifas por região (valor do m³) | `/regionrate` | `tb_region_rate` |
| Propriedades | `/property` | `tb_property` |
| Dispositivos | `/device` | `tb_device` |

**Estrutura:** `src/main/java/com/example/delta_back` contém `conexao`, `model`, `dao`, `crud` e `servlet`; `src/main/webapp` contém o `index.jsp` (página inicial com os links dos cadastros) e uma página `.jsp` por entidade.

## Tecnologias

Java 21 · Jakarta Servlet 6.1 e JSP · Apache Tomcat 11 · Maven (Wrapper incluso) · PostgreSQL (JDBC `42.7.13`) · dotenv-java · JUnit 5

## Como executar

**Pré-requisitos:** JDK 21, Apache Tomcat 11, PostgreSQL e, opcionalmente, IntelliJ IDEA com o plugin SmartTomcat (usado pela equipe).

1. **Crie o banco:** execute o script `deltadb.sql` do repositório [delta-database-primeiroano](https://github.com/delta-app-ofc/delta-database-primeiroano), que também traz a convenção de nomenclatura.
2. **Configure a conexão:** defina as variáveis de ambiente abaixo no sistema, na IDE ou em um arquivo `.env` (já ignorado pelo Git). Nunca suba senhas para o repositório.

   | Variável | Descrição |
   | --- | --- |
   | `DB_HOST` | Servidor PostgreSQL (ex.: `localhost`) |
   | `DB_PORT` | Porta (ex.: `5432`) |
   | `DB_NAME` | Nome do banco |
   | `DB_USER` | Usuário |
   | `DB_PASSWORD` | Senha |

   Para testar a conexão, execute a classe `TesteConexao`.
3. **Rode a aplicação:** pelo IntelliJ (SmartTomcat com Tomcat 11) ou gerando o WAR:

   ```bash
   ./mvnw clean package
   ```

   Copie `target/Delta_Back-1.0-SNAPSHOT.war` para a pasta `webapps` do Tomcat 11, inicie o servidor e acesse `http://localhost:8080/<nome-do-war>/`.

## Repositórios relacionados

- [delta-database-primeiroano](https://github.com/delta-app-ofc/delta-database-primeiroano) — banco de dados (primeira série)
- [delta-landing-page](https://github.com/delta-app-ofc/delta-landing-page) — landing page

## Licença

Distribuído sob a licença **MIT**. Veja o arquivo [LICENSE](LICENSE).
