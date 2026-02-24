-- =============================================
-- TECHSOLV — Esquema SQL de Banco de Dados
-- Compatível com MySQL 8+ / MariaDB / PostgreSQL
-- =============================================

-- -----------------------------------------------
-- Tabela: mensagens_contato
-- Armazena formulários de contato enviados
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS mensagens_contato (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(150)  NOT NULL,
    empresa       VARCHAR(150),
    email         VARCHAR(200)  NOT NULL,
    telefone      VARCHAR(30),
    assunto       VARCHAR(100)  NOT NULL,
    mensagem      TEXT          NOT NULL,
    -- Arquivos: lista de nomes separados por ; ou tabela própria
    anexos        TEXT,
    ip_origem     VARCHAR(45)   NOT NULL,          -- IPv4 ou IPv6
    user_agent    VARCHAR(512),
    data_hora     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lido          TINYINT(1)    NOT NULL DEFAULT 0,
    respondido    TINYINT(1)    NOT NULL DEFAULT 0,
    observacoes_admin TEXT,
    INDEX idx_email       (email),
    INDEX idx_data_hora   (data_hora),
    INDEX idx_lido        (lido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabela: solicitacoes_orcamento
-- Cabeçalho das solicitações de orçamento
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS solicitacoes_orcamento (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(150)  NOT NULL,
    empresa       VARCHAR(150)  NOT NULL,
    email         VARCHAR(200)  NOT NULL,
    telefone      VARCHAR(30)   NOT NULL,
    prazo         VARCHAR(50),
    observacoes   TEXT,
    anexos        TEXT,
    total_estimado DECIMAL(12,2) DEFAULT 0.00,
    ip_origem     VARCHAR(45)   NOT NULL,
    user_agent    VARCHAR(512),
    data_hora     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status        ENUM('pendente','em_analise','aprovado','recusado','concluido')
                  NOT NULL DEFAULT 'pendente',
    lido          TINYINT(1)    NOT NULL DEFAULT 0,
    admin_notas   TEXT,
    INDEX idx_empresa     (empresa),
    INDEX idx_email       (email),
    INDEX idx_data_hora   (data_hora),
    INDEX idx_status      (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabela: orcamento_itens
-- Itens de cada solicitação (relação N:1 com orcamentos)
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS orcamento_itens (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    orcamento_id    INT UNSIGNED NOT NULL,
    produto_id      INT UNSIGNED NOT NULL,
    produto_nome    VARCHAR(200) NOT NULL,   -- snapshot do nome
    produto_preco   DECIMAL(12,2) NOT NULL,  -- snapshot do preço
    quantidade      INT UNSIGNED NOT NULL DEFAULT 1,
    subtotal        DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (orcamento_id)
        REFERENCES solicitacoes_orcamento(id)
        ON DELETE CASCADE,
    INDEX idx_orcamento (orcamento_id),
    INDEX idx_produto   (produto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabela: produtos
-- Catálogo de produtos gerenciável pelo admin
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS produtos (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    icone       VARCHAR(10)  NOT NULL DEFAULT '📦',
    nome        VARCHAR(200) NOT NULL,
    descricao   TEXT,
    categoria   VARCHAR(80)  NOT NULL,
    preco       DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    unidade     VARCHAR(20)  NOT NULL DEFAULT 'unid.',
    ativo       TINYINT(1)   NOT NULL DEFAULT 1,
    ordem       INT          NOT NULL DEFAULT 0,
    criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP
                             ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_categoria (categoria),
    INDEX idx_ativo     (ativo),
    INDEX idx_ordem     (ordem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabela: conteudo_site
-- Conteúdos editáveis pelo painel admin
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS conteudo_site (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    secao       VARCHAR(80)  NOT NULL,  -- ex: 'hero', 'sobre', 'contato'
    chave       VARCHAR(120) NOT NULL,  -- ex: 'heroTitulo', 'cEmail'
    valor       LONGTEXT,
    tipo        ENUM('texto','html','url','imagem') NOT NULL DEFAULT 'texto',
    atualizado_em DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP
                             ON UPDATE CURRENT_TIMESTAMP,
    atualizado_por VARCHAR(100),
    UNIQUE KEY uk_secao_chave (secao, chave),
    INDEX idx_secao (secao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabela: usuarios_admin
-- Usuários com acesso ao painel administrativo
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios_admin (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario     VARCHAR(80)  NOT NULL UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,   -- bcrypt ou argon2
    nome        VARCHAR(150) NOT NULL,
    email       VARCHAR(200) NOT NULL UNIQUE,
    role        ENUM('admin','gerente','visualizador') NOT NULL DEFAULT 'visualizador',
    ativo       TINYINT(1)   NOT NULL DEFAULT 1,
    ultimo_login DATETIME,
    criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_usuario (usuario),
    INDEX idx_role    (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabela: logs_acesso
-- Registro de acessos ao painel admin
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS logs_acesso (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id  INT UNSIGNED,
    usuario_str VARCHAR(80),
    acao        VARCHAR(200) NOT NULL,
    ip_origem   VARCHAR(45)  NOT NULL,
    data_hora   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios_admin(id) ON DELETE SET NULL,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_data_hora  (data_hora)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Dados iniciais: produtos de exemplo
-- -----------------------------------------------
INSERT INTO produtos (icone, nome, descricao, categoria, preco, unidade, ordem) VALUES
  ('🖥️', 'Painel de Controle CLP',   'Controlador lógico programável para automação industrial.', 'Automação', 3200.00, 'unid.', 1),
  ('⚙️', 'Motor Elétrico Trifásico', 'Motor industrial trifásico 5CV de alta eficiência.',        'Motores',    1800.00, 'unid.', 2),
  ('🔌', 'Inversor de Frequência',   'Controle de velocidade de motores CC e CA.',                 'Automação', 2500.00, 'unid.', 3),
  ('📡', 'Sensor Indutivo',          'Sensor de proximidade indutivo NPN 12-24VDC.',               'Sensores',   280.00, 'unid.', 4),
  ('🛡️', 'Chave Termomagnética 3P',  'Disjuntor tripolar 63A para proteção de circuitos.',        'Proteção',   420.00, 'unid.', 5),
  ('🔗', 'Cabo Flexível PP 4mm²',    'Rolo com 100m de cabo PP flexível para uso industrial.',    'Cabos',      950.00, 'rolo',  6),
  ('📱', 'Interface HMI 7"',          'Interface homem-máquina touchscreen 7 polegadas.',          'Automação', 1650.00, 'unid.', 7),
  ('⚡', 'Relé de Proteção',          'Relé temporizador e de proteção multi-função.',             'Proteção',   380.00, 'unid.', 8);

-- -----------------------------------------------
-- Usuário admin inicial (senha: techsolv123)
-- ATENÇÃO: Trocar por hash bcrypt antes de produção!
-- -----------------------------------------------
INSERT INTO usuarios_admin (usuario, senha_hash, nome, email, role) VALUES
  ('admin', '$2b$12$PLACEHOLDER_TROCAR_POR_HASH_BCRYPT', 'Administrador', 'admin@techsolv.com.br', 'admin');
