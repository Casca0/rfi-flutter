# Roll for Initiative (Flutter)

## 🧭 Visão geral
Aplicativo Flutter multiplataforma para auxiliar mesas de RPG. O projeto está em fase de fundação e hoje entrega um fluxo completo de autenticação com Discord, tratamento consistente da sessão, interface responsiva para desktop e mobile e uma tela de perfil que centraliza as informações do jogador. Todo o backend agora está concentrado em uma única instância PocketBase, responsável por orquestrar o OAuth2 com o Discord e armazenar o estado de sessão dos usuários.

## ✅ Funcionalidades atuais
- Login e logout via Discord OAuth2 utilizando PocketBase como provedor.
- Sessão persistida com cache local (`SharedPreferences`) e fallback quando offline.
- Tela de login responsiva com versões otimizadas para desktop e mobile.
- Tela de perfil com avatar do Discord, dados de conta e opção de sair.
- Componentes compartilhados (logo em SVG, sidebar, cartões) preparados para futuros módulos do aplicativo.
- Foreground service específico para Android 15+ garantindo estabilidade do OAuth.
- Fluxo OAuth2 unificado: Custom Tabs/SafariViewController no mobile e navegador padrão no desktop.

## 🧱 Arquitetura em alto nível
- **AuthService** concentra o fluxo de login/logout, fala com o PocketBase e mantém o cache local em sincronia.
- **PocketBaseAuthRemoteDataSource** encapsula chamadas ao PocketBase e lida com as diferenças de plataforma (Custom Tabs/SafariViewController no mobile, navegador externo no desktop e web).
- **AuthBloc** expõe estados de autenticação para a UI (não autenticado, carregando, autenticado, erro).
- **ResponsiveLayout** decide automaticamente entre as variações desktop/mobile e mantém a base visual compartilhada.
- **GetIt** provê injeção de dependências simples para blocos, serviços e fontes de dados.

## 🛠️ Tecnologias principais
- Flutter 3 (SDK mínimo `>=3.9.0`).
- `flutter_bloc`, `bloc`, `equatable` para gerenciamento de estado.
- `get_it` para IoC.
- `go_router` para rotas declarativas.
- `pocketbase` como backend (Discord OAuth + store de usuários).
- `url_launcher` com suporte a `LaunchMode.inAppBrowserView` (Android/iOS) e `LaunchMode.externalApplication` (desktop e web).
- `shared_preferences`, `cached_network_image`, `flutter_svg`, `google_fonts` e `intl` para UX.

## 🗂️ Estrutura de pastas
```
lib/
├── core/
│   ├── constants/          # Valores globais (rotas, URLs, chaves de storage)
│   ├── services/           # Serviços auxiliares (ex.: foreground service OAuth)
│   └── utils/              # Utilidades de UI e responsividade
├── data/
│   ├── datasources/        # Fontes de dados locais e remotas
│   ├── models/             # Modelos que conversam com o PocketBase
│   └── repositories/       # Mantidos por compatibilidade (sem uso no fluxo atual)
├── domain/                 # Entidades e contratos legados, ainda presentes
├── presentation/
│   ├── bloc/               # AuthBloc
│   ├── layout/             # ResponsiveLayout e breakpoints
│   ├── pages/              # Login, Splash e Perfil
│   └── widgets/            # Componentes compartilhados (logo, painéis, etc.)
├── services/               # Serviços de domínio (AuthService)
├── injection_container.dart# Registro das dependências (GetIt)
└── main.dart               # Entrada do app
```

## ⚙️ Configuração do ambiente

### 1. Pré-requisitos
- Flutter SDK 3.9 ou superior (com suporte a desktop configurado se quiser rodar em Windows/macOS/Linux).
- Android Studio (para compilar Android) e/ou Visual Studio 2022 (para Windows desktop).
- Conta no [Discord Developer Portal](https://discord.com/developers/applications) para criar a aplicação OAuth.
- Instância do [PocketBase](https://pocketbase.io/) (local ou hospedada) com o provider Discord habilitado.

### 2. Configurar o PocketBase
1. Acesse o painel admin do PocketBase (`/_/`).
2. Em **Settings → Authentication → External Auth Providers**, habilite **Discord**.
3. Defina as URLs de redirecionamento que serão aceitas:
  - Android: `com.mms.rfi://login-callback`
  - Desktop (Windows/macOS/Linux): `http://localhost:8787/auth/discord/callback` (ajuste conforme o URL definido na instância).
4. Informe o `Client ID` e `Client Secret` obtidos no portal do Discord.
5. Garanta que a coleção `users` tenha os campos padrão (`username`, `discord_id`, `avatar_url`, `email`). O app utiliza apenas os dados retornados pelo PocketBase.

### 3. Variáveis de ambiente (`--dart-define`)
O projeto lê as variáveis em tempo de compilação via `String.fromEnvironment`. Forneça-as ao rodar ou construir o app:

| Variável                | Obrigatória | Descrição                                                                 |
|-------------------------|-------------|---------------------------------------------------------------------------|
| `POCKETBASE_URL`        | Sim         | URL base da sua instância PocketBase (ex.: `http://10.0.2.2:8090`).       |
| `DISCORD_CLIENT_ID`     | Sim         | Client ID registrado no Discord.                                         |
| `DISCORD_CLIENT_SECRET` | Sim         | Client Secret do Discord (necessário para fluxos completos).             |
| `DISCORD_REDIRECT_URI`  | Sim         | URI cadastrada no Discord/PocketBase (ex.: `com.mms.rfi://login-callback`). |

> ℹ️ Durante o desenvolvimento mobile, use `10.0.2.2` para acessar o host local no emulador Android.

### 4. Executar o projeto
```powershell
flutter pub get
flutter run `
  --dart-define=POCKETBASE_URL=http://10.0.2.2:8090 `
  --dart-define=DISCORD_CLIENT_ID=seu_client_id `
  --dart-define=DISCORD_CLIENT_SECRET=seu_client_secret `
  --dart-define=DISCORD_REDIRECT_URI=com.mms.rfi://login-callback
```

### 5. Análise estática e testes
```powershell
flutter analyze
flutter test
```

## 🔐 Fluxo de autenticação
1. O `AuthBloc` dispara `AuthLoginEvent`, que delega ao `AuthService`.
2. `AuthService` inicia o login no `PocketBaseAuthRemoteDataSource`.
3. O datasource abre o fluxo OAuth:
  - **Android/iOS**: WebView interna com `LaunchMode.inAppWebView`, fechada automaticamente após o callback.
    - **Android 15+**: o app ativa um foreground service antes de abrir o navegador, garantindo que o fluxo continue ativo mesmo em segundo plano.
    - **Android/iOS**: Custom Tabs/SafariViewController via `LaunchMode.inAppBrowserView`, com fechamento automático após o callback.
    - **Desktop/Web**: Navegador padrão do sistema (ou a aba atual na versão web).
4. PocketBase finaliza o OAuth junto ao Discord e devolve o registro do usuário autenticado.
5. O usuário é convertido para `UserModel` → `User` e cacheado localmente.
6. O `AuthBloc` emite `AuthenticatedState`, levando a UI à `ProfilePage`.

Se o modal in-app não puder ser fechado nativamente (por exemplo, ambientes sem suporte a Custom Tabs), o fluxo segue normalmente, apenas solicitando que o usuário volte ao app manualmente.

## 🧩 Layout responsivo
- `ResponsiveLayout` aplica os mesmos limites definidos em `AppBreakpoints`: **mobile** (≤ 600px), **tablet** (> 600px e ≤ 1024px) e **desktop** (> 1024px).
- O utilitário `ResponsiveContext` (extension em `core/utils/responsive_utils.dart`) oferece getters (`context.isMobile`, `context.isTablet`, `context.isDesktop`) e garante que telas e widgets sigam os mesmos limites.
- Mobile prioriza navegação por colunas únicas, botões amplos e drawer lateral.
- Desktop/tablet ativam a sidebar fixa `UserSidebar`, cartões multicoluna e tipografia ampliada.
- Os componentes compartilham tokens de design (`AppConstants`) para manter consistência.

## 🤝 Como contribuir
1. Faça um fork do repositório.
2. Crie uma branch: `git checkout -b feature/sua-feature`.
3. Faça commits seguindo boas práticas.
4. Rode `flutter analyze` e `flutter test` antes de abrir o PR.
5. Abra um Pull Request descrevendo a mudança.

## 📄 Licença
Projeto licenciado sob MIT. Consulte o arquivo `LICENSE` para mais detalhes.

## 🚧 Roadmap imediato
- [x] Fluxo de autenticação unificado com Discord + PocketBase.
- [x] Layout responsivo para login e perfil.
- [ ] Dashboard inicial com resumo de campanhas.
- [ ] CRUD de personagens sincronizado com PocketBase.
- [ ] Ferramentas de rolagem de dados em tempo real.