
-- Removendo schema, banco de dados e usuario caso ja tenham criado antes

DROP SCHEMA IF EXISTS   lojas CASCADE;
DROP DATABASE IF EXISTS uvv;
DROP ROLE IF EXISTS     richard;

-- Criando o usuario e suas permisoes

CREATE ROLE richard WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  REPLICATION
  BYPASSRLS
  PASSWORD '123';

-- Alternando para o usuario richard e saindo do usuario postgres para criacao do database uvv

SET ROLE richard;

-- Criando o database uvv e suas especificacoes

CREATE DATABASE uvv
    WITH
    OWNER             = richard
    TEMPLATE          = 'template0'
    ENCODING          = 'UTF8'
    LC_COLLATE        = 'pt_BR.UTF-8'
    LC_CTYPE          = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = 'TRUE';

-- Definindo a variável de ambiente PGPASSWORD para nao pedir a senha ao rodar o codigo

\setenv PGPASSWORD 123

-- Conecte-se ao banco de dados uvv com o usuário richard

\c uvv richard

-- Criando o schema lojas

CREATE SCHEMA IF NOT EXISTS lojas
    AUTHORIZATION richard;

-- Ajustando o schema padrão (public) para o schema lojas 

    ALTER USER richard
SET SEARCH_PATH TO lojas, "$user", public;


-- Criando as tabelas e suas colunas --

-- Criando a tabela produtos e suas colunas

CREATE TABLE lojas.produtos (
                produto_id                NUMERIC(38) NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                preco_unitario            NUMERIC(10,2),
                detalhes                  BYTEA,
                imagem                    BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_arquivo            VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produto_id PRIMARY KEY (produto_id)
);

-- Comentando sobre o uso da tabela produtos e suas colunas

COMMENT ON TABLE  lojas.produtos                           IS 'tabela produtos, serve para cadastrar cada produto.';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'coluna produto_id, serve como pk e para indentificar cada produto cadastrado.';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'coluna nome, serve para cadastrar o nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'coluna preco_unitario, serve para cadastrar o valor unitario de cada produto.';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'coluna detalhes, serve para cadastrar o detalhes do produto.';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'coluna imagem, serve para cadastrar a imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'coluna imagem_mime_type, serve para cadastrar a imagem mime type dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'coluna imagem_arquivo, serve para cadastrar a imagem arquivo dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'coluna imagem charset, serve para cadastrar a imagem charset dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'coluna imagem_ultima_atualizacao, serve para cadastar a data da ultima atualizacao da imagem dos produtos.';

-- Criando a tabela lojas e suas colunas

CREATE TABLE lojas.lojas (
                loja_id                 NUMERIC(38)  NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_loja_id PRIMARY KEY (loja_id)
);

-- Comentando sobre o uso da tabela lojas e suas colunas

COMMENT ON TABLE lojas.lojas                          IS 'Tabela lojas, server para ter um cadastro de cada loja.';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'coluna loja_id, server como pk e para identificar a(s) loja(s).';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'coluna nome, server para indentificar a loja pelo nome.';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'coluna endereco_web, server para cadastrar o endereco web de cada loja.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'coluna endereco_fisico, server para cadastrar o endereco fisico de cada loja.';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'coluna latitude, server para cadastrar o latitude das lojas.';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'coluna longitude, server para cadastrar a longitude das lojas.';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'coluna logo, serve para cadastrar a logo das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'coluna logo_mime_type, serve para cadastrar a logo mime type das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'coluna logo_arquivo, serve para cadastrar a logo arquivo de cada loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'coluna logo_charset, serve para cadastrar a logo charset de cada loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'coluna logo_ultima_atualizacao, serve para cadastrar a ultima atalizacao de logo das lojas.';

-- Criando a tabela estoques e suas colunas

CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoque_id PRIMARY KEY (estoque_id)
);

-- Comentando sobre o uso da tabela estoques e suas colunas

COMMENT ON TABLE lojas.estoques             IS 'Tabela estoque, serve para cadastrar o estoque disponivel.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'coluna estoque_id, serve como pk e para indentificar os estoques das lojas.';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'coluna loja_id, server como pk, fk e para identificar a(s) loja(s).';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'coluna produto_id, serve como pk, fk e para indentificar cada produto cadastrado.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'coluna quantidade, serve para cadastrar a quantidade de estoque nas lojas.';

-- Criando a tabela clientes e suas colunas

CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telofone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                CONSTRAINT pk_cliente_id PRIMARY KEY (cliente_id)
);

-- Comentando sobre o uso da tabela e suas colunas

COMMENT ON TABLE lojas.clientes             IS 'Tabela de registro do clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Coluna de id cliente, serve como pk e para identificar o cliente.';
COMMENT ON COLUMN lojas.clientes.email      IS 'coluna de email, serve para termos um email de contato com o cliente.';
COMMENT ON COLUMN lojas.clientes.nome       IS 'coluna nome, serve para termos o nome do cliente e assim identifica-lo.';
COMMENT ON COLUMN lojas.clientes.telofone1  IS 'coluna de telefone1, serve para termos um numero de contato com o cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'coluna telefone2, serve para termos um segundo numero de contato com o cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'coluna telefone3, serve para termos um terceiro numero de contato com o cliente.';

-- Criando a tabela envios e suas colunas

CREATE TABLE lojas.envios (
                envio_id         NUMERIC(38)  NOT NULL,
                loja_id          NUMERIC(38)  NOT NULL,
                cliente_id       NUMERIC(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status           VARCHAR(15)  NOT NULL,
                CONSTRAINT pk_envio_id PRIMARY KEY (envio_id)
);

-- Comentando sobre o uso da tabela envios e suas colunas

COMMENT ON TABLE lojas.envios                   IS 'Tabela envio, serve para cadastrar os envios.';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'coluna envio_id, serve como pk e como indentificador dos envios.';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'coluna loja_id, server como pk, fk e para identificar a(s) loja(s).';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'Coluna de id cliente, serve como pk, fk e para identificar o cliente.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'coluna endereco_entrega, serve para cadastrar o endereco de entrega dos produtos.';
COMMENT ON COLUMN lojas.envios.status           IS 'coluna status, serve para cadastrar o status dos pedidos.';

-- Criando a tabela pedidos e suas colunas

CREATE TABLE lojas.pedidos (
                pedido_id  NUMERIC(38) NOT NULL,
                data_hora  TIMESTAMP   NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status     VARCHAR(15) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedido_id PRIMARY KEY (pedido_id)
);

-- Comentando sobre o uso da tabela pedidos e suas colunas

COMMENT ON TABLE lojas.pedidos             IS 'Tabela pedidos,  server para registras os pedidos saber o status a data e a hora de entrada entre outros.';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'Coluna pedido_id, serve como a pk e tambem para identificar o id do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'Coluna data_hora, serve para informar a data e a hora que o produto foi retirado ou colocado na loja.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Coluna de id cliente, serve como fk para identificar o cliente.';
COMMENT ON COLUMN lojas.pedidos.status     IS 'coluna status, serve para informar o status do produto.';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'coluna loja_id, server como fk para identificar a(s) loja(s).';

-- Criando a tabela pedidos_itens e suas colunas

CREATE TABLE lojas.pedidos_itens (
                pedido_id       NUMERIC(38)   NOT NULL,
                produto_id      NUMERIC(38)   NOT NULL,
                numero_da_linha NUMERIC(38)   NOT NULL,
                preco_unitario  NUMERIC(10,2) NOT NULL,
                quantidade      NUMERIC(38)   NOT NULL,
                envio_id        NUMERIC(38)   NOT NULL,
                CONSTRAINT pk_pedido_id_produto_id PRIMARY KEY (pedido_id, produto_id)
);

-- Comentando sobre o uso da tabela pedidos_itens e suas colunas

COMMENT ON TABLE lojas.pedidos_itens                  IS 'tabela pedidos_itens, serve cadastrar os itens dos pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'Coluna pedido_id, serve como pk e fk para identificar o id do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'coluna produto_id, serve como pk, fk e para indentificar cada produto cadastrado.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'coluna numero_da_linha, serve para cadastrar o numero da linha do produto.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'coluna preco_unitario, serve para cadastrar o preco unitario dos itens.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'coluna quantidade, serve para cadastrar a quantidade de itens na loja.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'coluna envio_id, serve como pk, fk e como indentificador dos envios.';



-- Crianção das constraints Check--

-- Criando uma check para a coluna status da tabela pedidos

ALTER TABLE    lojas.pedidos 
ADD CONSTRAINT cc_pedidos_status
CHECK(status IN('CANCELADO','COMPLETO','ABERTO','PAGO','REEMBOLSADO','ENVIADO'));

-- Criando uma check para a coluna status da tabela envios
 
ALTER TABLE    lojas.envios 
ADD CONSTRAINT cc_envios_status
CHECK(status IN('CRIADO','ENVIADO','TRANSITO','ENTREGUE'));

-- Criando uma check para as colunas endereco_web e endereco_fisico da tabela lojas para que pelo menos uma das colunas tenha algum valor

ALTER TABLE    lojas.lojas 
ADD CONSTRAINT cc_lojas_endereco_web_fisico
CHECK          ((endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL));

-- Criando uma check para a coluna quantidade da tabela estoques para que nao aceite valores menores que 0

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT cc_estoques_quantidade
CHECK          (quantidade >=0);

--Criando uma check para a coluna preco_unitario da taleba pedidos_itens para que nao aceite valores menores que 0

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT cc_pedidos_itens_preco_unitario
CHECK          (preco_unitario >=0);

--Criando uma check para a coluna quantidade da taleba pedidos_itens para que nao aceite valores menores que 0

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT cc_pedidos_itens_quantidade
CHECK          (quantidade >=0);

-- Criando uma check para a coluna preco_unitario da tabela prdutos para que nao aceite valores menores que 0

ALTER TABLE    lojas.produtos 
ADD CONSTRAINT cc_produtos_preco_unitario
CHECK          (preco_unitario >=0);


-- Crianção das constraints FK--


--Criando a Fk na tabela produtos

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT produtos_peditos_itens_fk
FOREIGN KEY    (produto_id)
REFERENCES     lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela produtos

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY    (produto_id)
REFERENCES     lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela lojas

ALTER TABLE    lojas.pedidos 
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY    (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela lojas

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY    (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela lojas

ALTER TABLE    lojas.envios 
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY    (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela clientes

ALTER TABLE    lojas.pedidos 
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY    (cliente_id)
REFERENCES     lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela clientes

ALTER TABLE    lojas.envios 
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY    (cliente_id)
REFERENCES     lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela envios

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT envios_peditos_itens_fk
FOREIGN KEY    (envio_id)
REFERENCES     lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando a Fk na tabela pedidos

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT pedidos_peditos_itens_fk
FOREIGN KEY    (pedido_id)
REFERENCES     lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
