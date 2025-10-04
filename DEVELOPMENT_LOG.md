# Documentação do Desenvolvimento - RPG Companion

## 📝 Histórico de Desenvolvimento

### Sessão 1 - Estruturação Inicial (13/09/2025)

#### Objetivo
Criar a estrutura inicial do aplicativo Flutter para RPG de mesa com foco em:
- Autenticação Discord OAuth2
- Tela de perfil do usuário
- Arquitetura Clean Architecture

#### Estrutura Criada

##### 🏗️ Arquitetura
```
lib/
├── core/
│   ├── constants/app_constants.dart
│   ├── errors/failures.dart
│   ├── errors/exceptions.dart
│   ├── network/network_info.dart
│   └── utils/
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/
│       ├── login_with_discord.dart
│       ├── logout.dart
│       └── get_current_user.dart
├── data/
│   ├── models/user_model.dart
│   ├── repositories/auth_repository_impl.dart
│   └── datasources/
│       ├── auth_local_data_source.dart
│       └── auth_remote_data_source.dart
├── presentation/
│   ├── bloc/auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── pages/
│   │   ├── splash_page.dart
│   │   ├── login_page.dart
│   │   └── profile_page.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── loading_widget.dart
│   │   │   └── rpg_logo.dart
│   │   └── auth/
│   │       └── discord_login_button.dart
│   └── routes/app_router.dart
├── injection_container.dart
└── main.dart
```

#### 🎯 Funcionalidades Implementadas

##### Navegação
- **Splash Screen**: Verifica estado de autenticação inicial
- **Login Page**: Interface para autenticação Discord
- **Profile Page**: Exibe informações do usuário logado
- **Roteamento**: GoRouter com navegação declarativa

##### Gerenciamento de Estado
- **AuthBloc**: Estados de loading, authenticated, unauthenticated, error
- **Eventos**: CheckStatus, Login, Logout, UpdateUser
- **Estados**: Initial, Loading, Authenticated, Unauthenticated, Error

##### Autenticação (Estrutura)
- Repository pattern para abstração
- Local storage seguro para tokens
- Cache de dados do usuário
- Tratamento de erros robusto

##### UI/UX
- Material Design 3
- Tema customizado (purple/RPG theme)
- Google Fonts (Poppins)
- Widgets reutilizáveis
- Interface responsiva

#### 🔧 Tecnologias Configuradas

##### Dependências Principais
- **flutter_bloc**: Gerenciamento de estado
- **go_router**: Navegação
- **get_it**: Injeção de dependências
- **bloc**: Streams de eventos/estados para integrações simples
- **pocketbase**: Backend único para OAuth2+storage
- **url_launcher**: Custom Tabs/SafariViewController e navegador externo
- **shared_preferences**: Cache local
- **cached_network_image**: Cache de imagens
- **flutter_svg**: Logo e ícones em SVG
- **google_fonts**: Tipografia
- **intl**: Formatação e localização básica

##### Dependências para Implementar
- **dio** ou **http**: Chamadas REST adicionais (quando surgirem novos módulos)
- **hive** ou **isar**: Persistência offline avançada (investigar após MVP)

#### 📋 Fluxo de Autenticação Planejado

1. **Splash Screen** 
   - Verifica tokens armazenados
   - Valida usuário em cache
   - Redireciona para login ou perfil

2. **Login**
   - Botão "Entrar com Discord"
   - OAuth2 flow
   - Armazenamento seguro de tokens
   - Cache de dados do usuário

3. **Profile**
   - Exibe avatar, nome, email
   - Informações da conta Discord
   - Opção de logout
   - Preview de funcionalidades futuras

#### 🔜 Próximos Passos

##### Fase 1: Implementar Autenticação
- [x] Configurar Discord Developer App
- [x] Implementar OAuth2 flow com PocketBase + url_launcher
- [x] Ativar foreground service para Android 15+
- [x] Testar fluxo completo

##### Fase 2: Base de Dados
- [x] Provisionar PocketBase e habilitar provider Discord
- [x] Criar coleção `users` alinhada ao retorno do PocketBase
- [ ] Mapear coleções para campanhas/personagens
- [ ] Definir estratégia de sincronização offline

##### Fase 3: Features Core
- [ ] Sistema de personagens
- [ ] Rolagem de dados
- [ ] Chat básico
- [ ] Campanhas

#### 📝 Notas Técnicas

##### Arquitetura
- **Clean Architecture**: Separação clara de responsabilidades
- **SOLID Principles**: Código maintível e testável
- **Repository Pattern**: Abstração de data sources
- **BLoC Pattern**: Gerenciamento de estado reativo

##### Segurança
- Tokens OAuth2 em secure storage
- Validação de inputs
- Tratamento de exceções
- Network security

##### Performance
- Cache inteligente
- Lazy loading de imagens
- Otimização de builds
- Memory management

#### 🐛 Issues Conhecidos
- [ ] OAuth2 ainda não implementado (estrutura pronta)
- [ ] Database integration pendente
- [ ] Testes unitários a implementar
- [ ] CI/CD pipeline a configurar

#### 📊 Métricas do Projeto
- **Arquivos Criados**: ~25 arquivos
- **Linhas de Código**: ~2000+ linhas
- **Cobertura de Testes**: 0% (a implementar)
- **Tempo de Desenvolvimento**: ~2 horas

---

### Sessão 2 - Refatoração da Autenticação (27/09/2025)

#### Objetivo
Simplificar o fluxo de autenticação removendo camadas redundantes da Clean Architecture original e centralizando regras de negócio em um serviço único.

#### Principais Mudanças
- Criação do `AuthService` como ponto único de orquestração de login, logout e recuperação de sessão.
- `AuthBloc` passou a depender diretamente do serviço, eliminando os use cases (`LoginWithDiscord`, `Logout`, `GetCurrentUser`).
- `injection_container.dart` atualizado para registrar o novo serviço e remover repositórios antigos.
- Data sources locais e remotos mantidos, porém consumidos apenas pelo `AuthService`.
- Dependências externas removidas: `dartz`, `dio`, `connectivity_plus`, `injectable` e geradores associados.

#### Impactos na Arquitetura
- Camadas `domain` e `data` relacionadas a autenticação foram marcadas como legadas e não possuem mais lógica ativa.
- Documentação atualizada para refletir a arquitetura simplificada e o uso de PocketBase como backend.
- Menor acoplamento entre UI e camadas de dados, mantendo o BLoC enxuto e focado apenas em estados.

#### Próximos Passos
- Implementar testes unitários diretamente sobre o `AuthService`.
- Remover gradualmente arquivos legados restantes ou migrá-los para a nova abordagem conforme novas features forem desenvolvidas.
- Automatizar validação com `flutter analyze` e pipelines de CI.

---

### Próximas Sessões

#### Sessão 3 - OAuth2 Discord
*A ser documentada...*

#### Sessão 4 - Database Integration  
*A ser documentada...*

---

**Autor**: GitHub Copilot + Desenvolvedor  
**Data**: 13 de Setembro, 2025  
**Versão**: 1.0.0  