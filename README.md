# Roll For Initiative

## 📜 Descrição do Projeto

**Roll For Initiative** é um aplicativo multiplataforma (Desktop e Android) para auxiliar em sessões de RPG de mesa. O objetivo é fornecer ferramentas úteis para mestres e jogadores, começando com autenticação de usuários e exibição de perfis, com planos de expansão para gerenciamento de fichas, rolagem de dados e mais.

O projeto será construído utilizando o framework **Flutter** para a interface do usuário e **Supabase** como backend para lidar com banco de dados e autenticação.

---

## 🛠️ Tecnologias Principais

*   **Frontend:** [Flutter](https://flutter.dev/) - Para a criação de uma interface de usuário nativa e performática para Android e Desktop a partir de um único código-base.
*   **Backend (BaaS):** [Supabase](https://supabase.io/) - Uma alternativa de código aberto ao Firebase, utilizada para:
    *   **Autenticação:** Gerenciamento de usuários, incluindo login social com Discord (OAuth2).
    *   **Banco de Dados:** Um banco de dados Postgres escalável para armazenar informações de usuários, campanhas, personagens, etc.
*   **Linguagem:** [Dart](https://dart.dev/) - A linguagem de programação utilizada pelo Flutter.

---

## 🚀 Roteiro de Desenvolvimento (Roadmap)

### Fase 1: Fundação e Autenticação (Passo Atual)

1.  **Criação do Repositório:** Iniciar um novo repositório no GitHub.
2.  **Estrutura do Projeto:** Configurar a estrutura inicial de pastas e arquivos do projeto Flutter.
3.  **Configuração do Supabase:**
    *   Criar um projeto no Supabase.
    *   Configurar a autenticação OAuth com o Discord.
4.  **Desenvolvimento das Telas Iniciais:**
    *   **Tela de Login (`login_screen.dart`):** Botão "Entrar com Discord".
    *   **Tela de Perfil (`profile_screen.dart`):** Exibição de informações básicas do usuário.
5.  **Integração:** Conectar o Flutter ao Supabase para o fluxo de autenticação.
