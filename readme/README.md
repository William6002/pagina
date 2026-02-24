# TechSolv — Aplicação Web

> Estrutura front-end modular em **HTML + CSS + JavaScript** com esquema **SQL** completo.

---

## 📁 Estrutura de Arquivos

```
webapp/
│
├── index.html                  ← Landing page institucional
├── schema.sql                  ← Esquema completo do banco de dados
│
├── css/
│   └── main.css                ← Estilos globais (variáveis, componentes, responsivo)
│
├── js/
│   ├── main.js                 ← Navbar, validação, storage, uploads, auth
│   └── produtos.js             ← Catálogo de dados, render de cards e seletor
│
├── pages/
│   ├── contato.html            ← Formulário de contato com upload de arquivos
│   ├── orcamento.html          ← Seleção de produtos + geração de PDF (jsPDF)
│   └── localizacao.html        ← Mapa + informações de contato e horários
│
└── admin/
    ├── login.html              ← Autenticação (credenciais: admin / techsolv123)
    ├── dashboard.html          ← Estatísticas, tabelas de mensagens e orçamentos
    ├── produtos-admin.html     ← CRUD completo de produtos (modal)
    └── conteudo.html           ← Editor de textos das seções do site
```

---

## ✅ Requisitos Funcionais Atendidos

| # | Requisito | Implementação |
|---|-----------|---------------|
| 1 | Landing page institucional | `index.html` — Hero, Sobre, Produtos, CTA |
| 2 | Formulários de contato interativos | `pages/contato.html` com validação em tempo real |
| 3 | Anexo de arquivos/fotos | Upload drag-and-drop em contato e orçamento |
| 4 | Coleta de IP, data/hora em SQL | `schema.sql` — tabelas com `ip_origem` e `data_hora` |
| 5 | Seleção de produtos para orçamento | `pages/orcamento.html` — checkboxes + quantidade |
| 6 | Geração de PDF | jsPDF — tabela de produtos, totais e dados do solicitante |
| 7 | Autenticação admin | `admin/login.html` — sessionStorage + proteção por rota |
| 8 | Visualização de mensagens e orçamentos | `admin/dashboard.html` — tabelas com badges de status |
| 9 | Edição de conteúdo e produtos | `admin/conteudo.html` + `admin/produtos-admin.html` |
| 10 | Informações de contato e localização | `pages/localizacao.html` + rodapé global |
| 11 | Compatibilidade cross-browser | CSS moderno com fallbacks; sem dependências pesadas |
| 12 | Estrutura modular | Separação por pasta (pages/, admin/, js/, css/) |
| 13 | HTML + CSS + JS + SQL | Tecnologias exclusivas conforme solicitado |

---

## 🗄️ Banco de Dados (schema.sql)

| Tabela | Descrição |
|--------|-----------|
| `mensagens_contato` | Formulários de contato com IP e data/hora |
| `solicitacoes_orcamento` | Cabeçalho das solicitações de orçamento |
| `orcamento_itens` | Itens (N:1) de cada orçamento |
| `produtos` | Catálogo gerenciável pelo admin |
| `conteudo_site` | Textos editáveis por seção/chave |
| `usuarios_admin` | Usuários com roles (admin/gerente/visualizador) |
| `logs_acesso` | Auditoria de ações no painel |

---

## 🚀 Como rodar localmente

```bash
# Qualquer servidor estático funciona:
npx serve .
# ou
python3 -m http.server 8080
# ou abrir index.html diretamente no navegador
```

---

## 🔐 Credenciais Demo

| Usuário | Senha |
|---------|-------|
| `admin` | `techsolv123` |
| `gerente` | `gerente456` |

> ⚠️ **Produção**: substituir por autenticação via backend com hash bcrypt/argon2.

---

## 🔧 Integração Backend (próximos passos)

Para transformar em aplicação full-stack, adicionar:

1. **Endpoint de formulários** — `POST /api/contato` e `POST /api/orcamento`
   - Salvar no MySQL com `ip_origem = $_SERVER['REMOTE_ADDR']`
2. **Autenticação real** — PHP/Node/Python + JWT ou sessão server-side
3. **Upload de arquivos** — Salvar em `/uploads/` e registrar caminho no banco
4. **E-mail de notificação** — PHPMailer ou Nodemailer ao receber formulário
5. **Google Maps** — Substituir placeholder pelo iframe com API Key

---

## 🎨 Identidade Visual

- **Tipografia**: Syne (títulos) + DM Sans (corpo)
- **Cores**: Fundo `#0c0f14` · Destaque `#e8a020` (âmbar industrial)
- **Tom**: Industrial refinado — sóbrio, técnico, confiável
