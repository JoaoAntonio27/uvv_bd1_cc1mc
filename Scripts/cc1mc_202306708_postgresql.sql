                                                -- Verificar se o DATABASE uvv já está no computador, caso esteja, será apagado --

DROP DATABASE IF EXISTS uvv;

                                                -- Verificar se a role joao_antonio já está no computador, caso esteja, será apagada --

DROP ROLE IF EXISTS joao_antonio;

                                                -- Verificar se o usuário joao_antonio já está no computador, caso esteja, será apagado --

DROP USER IF EXISTS joao_antonio;

                                                                     -- Criar o usuário com senha criptografada --

CREATE USER joao_antonio WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD 'raiz';

                                                                           -- Criando a ROLE joao_antonio --

SET ROLE joao_antonio;

                                                                         -- Criar o Banco de Dados no usuário --
CREATE DATABASE uvv
    WITH 
    OWNER = joao_antonio
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;

                                          -- Fazendo com que a senha criptografada seja rodada sem precisar de uma interferencia manual --

\setenv PGPASSWORD raiz

                                                                          -- Conectar no banco de dados uvv--

\c uvv joao_antonio

                                                -- Verificar se o schema lojas já está no computador, caso esteja, será apagada --

DROP SCHEMA IF EXISTS lojas;

                                                                              -- Criar o schema lojas -- 

CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION joao_antonio;

                                                            -- Alterar para o database uvv e definir o "search path" --

ALTER DATABASE uvv SET search_path TO "lojas", "$user", public;

SET SEARCH_PATH TO lojas, "$user", public;

                                                            -- Alterar o proprietário do schema lojas para joao_antonio --

ALTER SCHEMA lojas OWNER TO joao_antonio;

                                                                    -- Criando a tabela produtos,colunas e a PK--

CREATE TABLE lojas.produtos (
                produto_id                  NUMERIC(38)     NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                preco_unitario              NUMERIC(10,2),
                detalhes                    BYTEA,
                imagem                      BYTEA,
                imagem_mime_type            VARCHAR(512),
                imagem_arquivo              VARCHAR(512),
                imagem_charset              VARCHAR(512),
                imagem_ultima_atualizacao   DATE,
                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);

                                        -- Criando os comentarios das colunas da tabela produtos --

COMMENT ON TABLE lojas.produtos IS                                      'Tabela que contém as informações dos produtos.';
COMMENT ON COLUMN lojas.produtos.produto_id IS                          'Coluna que contêm o identificador do produto (PK).';
COMMENT ON COLUMN lojas.produtos.nome IS                                'Coluna que contêm o nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS                      'Coluna que contêm o preço unitário do produto.';
COMMENT ON COLUMN lojas.produtos.detalhes IS                            'Coluna que contêm os detalhes adicionais sobre o produto.';
COMMENT ON COLUMN lojas.produtos.imagem IS                              'Coluna que contêm os dados binários da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS                    'Coluna que contêm o tipo MIME da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS                      'Coluna que contêm o nome do arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS                      'Coluna que contêm o charset da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS           'Coluna que contêm a data da última atualização da imagem do produto.';

                                                -- Criando a tabela lojas,colunas e a PK--

CREATE TABLE lojas.lojas (
                loja_id                     NUMERIC(38)     NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                endereco_web                VARCHAR(100),
                endereco_fisico             VARCHAR(512),
                latitude                    NUMERIC,
                longitude                   NUMERIC,
                logo                        BYTEA,
                logo_mime_type              VARCHAR(512),
                logo_arquivo                VARCHAR(512),
                logo_charset                VARCHAR(512),
                logo_ultima_atualizacao     DATE,
                CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);

                                        -- Criando os comentarios das colunas da tabela lojas --

COMMENT ON TABLE lojas.lojas IS                                 'Tabela que contem as informações das lojas, como: nome, localização e logo.';
COMMENT ON COLUMN lojas.lojas.loja_id IS                        'Coluna que contem os id''s das lojas (PK).';
COMMENT ON COLUMN lojas.lojas.nome IS                           'Coluna que contem os nomes das lojas.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS                   'Coluna que contem os endereços dos websites das lojas.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS                'Coluna que contem os endereços residencial das lojas.';
COMMENT ON COLUMN lojas.lojas.latitude IS                       'Coluna que mostra as coordenadas de latitude das lojas.';
COMMENT ON COLUMN lojas.lojas.longitude IS                      'Coluna que mostra as coordenadas de longitude das lojas.';
COMMENT ON COLUMN lojas.lojas.logo IS                           'Coluna que contêm os dados binários do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS                 'Coluna que contêm o tipo MIME do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS                   'Coluna que contêm o nome do arquivo do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset IS                   'Coluna que contêm o charset do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS        'Coluna que contêm a data da última atualização do logo da loja.';

                                        -- Criando a tabela estoques,colunas e a PK--

CREATE TABLE lojas.estoques (
                estoque_id      NUMERIC(38)     NOT NULL,
                loja_id         NUMERIC(38)     NOT NULL,
                produto_id      NUMERIC(38)     NOT NULL,
                quantidade      NUMERIC(38)     NOT NULL,
                CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);

                                        -- Criando os comentarios das colunas da tabela estoques --

COMMENT ON TABLE lojas.estoques IS                  'Tabela de estoques.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS      'Coluna que contêm o identificador do estoque (PK).';
COMMENT ON COLUMN lojas.estoques.loja_id IS         'Coluna que contêm o identificador da loja (FK).';
COMMENT ON COLUMN lojas.estoques.produto_id IS      'Coluna que contêm o identificador do produto (FK).';
COMMENT ON COLUMN lojas.estoques.quantidade IS      'Coluna que contêm a Quantidade em estoque.';


                                        -- Criando a tabela clientes,colunas e a PK--

CREATE TABLE lojas.clientes (
                clientes        NUMERIC(38)     NOT NULL,
                email           VARCHAR(255)    NOT NULL,
                nome            VARCHAR(255)    NOT NULL,
                telefone1       VARCHAR(20),
                telefone2       VARCHAR(20),
                telefone3       VARCHAR(20),
                CONSTRAINT clientes_pk PRIMARY KEY (clientes)
);

                                        -- Criando os comentarios das colunas da tabela clientes --

COMMENT ON TABLE lojas.clientes IS                  'Tabela que mostra os clientes com nome e numero de telefone.';
COMMENT ON COLUMN lojas.clientes.clientes IS        'Coluna que mostra o ID do clientes (PK).';
COMMENT ON COLUMN lojas.clientes.email IS           'Coluna que mostra email dos clientes.';
COMMENT ON COLUMN lojas.clientes.nome IS            'Coluna que mostra o nome completo dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone1 IS       'Coluna que guarda a primeira opção de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS       'Coluna que guarda a segunda opção de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS       'Coluna que guarda a terceira opção de telefone do cliente.';

                                        -- Criando a tabela envios,colunas e a PK--

CREATE TABLE lojas.envios (
                envio_id            NUMERIC(38)     NOT NULL,
                loja_id             NUMERIC(38)     NOT NULL,
                clientes_envios     NUMERIC(38)     NOT NULL,
                endereco_entrega    VARCHAR(512)    NOT NULL,
                status              VARCHAR(15)     NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envio_id)
);

                                        -- Criando os comentarios das colunas da tabela envios --

COMMENT ON TABLE lojas.envios IS                        'Tabela de envios.';
COMMENT ON COLUMN lojas.envios.envio_id IS              'Coluna que contêm o identificador do envio (PK).';
COMMENT ON COLUMN lojas.envios.loja_id IS               'Coluna que contêm o identificador da loja (FK).';
COMMENT ON COLUMN lojas.envios.clientes_envios IS       'Coluna que contêm o ID dos clientes (FK).';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS      'Coluna que contêm o endereço de entrega do envio.';
COMMENT ON COLUMN lojas.envios.status IS                'Coluna que contêm o status do envio.';

                                        -- Criando a tabela pedidos,colunas e a PK--

CREATE TABLE lojas.pedidos (
                pedido_id       NUMERIC(38)     NOT NULL,
                data_hora       TIMESTAMP       NOT NULL,
                clientes_id     NUMERIC(38)     NOT NULL,
                status          VARCHAR(15)     NOT NULL,
                loja_id         NUMERIC(38)     NOT NULL,
                CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id)
);

                                        -- Criando os comentarios das colunas da tabela pedidos --

COMMENT ON TABLE lojas.pedidos IS                   'Tabela de pedidos.';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS        'Coluna que contêm o identificador do pedido (PK).';
COMMENT ON COLUMN lojas.pedidos.data_hora IS        'Coluna que contêm a data e hora do pedido.';
COMMENT ON COLUMN lojas.pedidos.clientes_id IS      'Coluna que contêm o ID dos clientes (FK)..';
COMMENT ON COLUMN lojas.pedidos.status IS           'Coluna que contêm o status do pedido.';
COMMENT ON COLUMN lojas.pedidos.loja_id IS          'Coluna que contêm o identificador da loja.';

                                        -- Criando a tabela pedidos_itens,colunas e a PK--

CREATE TABLE lojas.pedidos_itens (
                pedido_id           NUMERIC(38)     NOT NULL,
                produto_id          NUMERIC(38)     NOT NULL,
                numero_da_linha     NUMERIC(38)     NOT NULL,
                preco_unitario      NUMERIC(10,2)   NOT NULL,
                quantidade          NUMERIC(38)     NOT NULL,
                envio_id            NUMERIC(38),
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);

                                        -- Criando os comentarios das colunas da tabela pedidos itens --

COMMENT ON TABLE lojas.pedidos_itens IS                     'Tabela de itens de pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS          'Coluna que contêm o indentificador do pedido (PFK).';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS         'Coluna que contêm o indentificador do produto (PFK).';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS    'Coluna que contêm o Número da linha do item no pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS     'Coluna que contêm o Preço unitário do item.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS         'Coluna que contêm o Quantidade do item.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS           'Coluna que contêm o identificador do envio (FK).';




                                        -- Criando as foreign key que ligam as tabelas --

-- A PK de produtos vira FK na tabela estoques -- 

ALTER TABLE lojas.estoques 
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK de produtos vira FK na tabela pedidos_itens, fazendo assim se tronar PFK --

ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK lojas de vira FK na tabela pedidos -- 

ALTER TABLE lojas.pedidos 
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK lojas de vira FK na tabela estoques --

ALTER TABLE lojas.estoques 
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK lojas de vira FK na tabela envios --

ALTER TABLE lojas.envios 
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK clientes de vira FK na tabela pedidos --

ALTER TABLE lojas.pedidos 
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (clientes_id)
REFERENCES lojas.clientes (clientes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK de clientes vira FK na tabela envios --

ALTER TABLE lojas.envios 
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (clientes_envios)
REFERENCES lojas.clientes (clientes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK envios de vira FK na tabela pedidos_itens, fazendo assim se tronar PFK --

ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- A PK pedidos de vira FK na tabela pedidos_itens --

ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

                                                        -- Criando as restrições das colunas --

-- Restrições da tabela PEDIDOS --

-- Restrição da coluna STATUS --

ALTER TABLE lojas.pedidos
ADD CONSTRAINT check_status_pedidos
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));


-- Restrições da tabela ENVIOS --

-- Restrição da coluna STATUS --

ALTER TABLE lojas.envios 
ADD CONSTRAINT check_status_envios 
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

-- Restrições da tabela PRODUTOS --

-- Restrição da coluna STATUS --

ALTER TABLE lojas.produtos 
ADD CONSTRAINT check_preco_unitario_produtos 
CHECK (preco_unitario >= 0);

-- Restrição da coluna NOME --

ALTER TABLE lojas.produtos
ADD CONSTRAINT unico_nome_produtos 
UNIQUE (nome);

-- Restrições da tabela ESTOQUES --

-- Restrição da coluna QUANTIDADE --

ALTER TABLE lojas.estoques 
ADD CONSTRAINT check_quantidade_estoques 
CHECK (quantidade >= 0);

-- Restrições da tabela LOJAS --

-- Restrição das colunas ENDERECO_WEB e ENDERECO_FISICO --

ALTER TABLE lojas.lojas
ADD CONSTRAINT check_endereco_lojas
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

-- Restrição da coluna NOME --

ALTER TABLE lojas.lojas
ADD CONSTRAINT unico_nome_lojas 
UNIQUE (nome);

-- Restrições da tabela PEDIDOS_ITENS --

-- Restrição da coluna QUANTIDADE --

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT check_quantidade_pedidos_itens
CHECK (quantidade >= 0);

-- Restrição da coluna PRECO_UNITARIO --

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT check_preco_unitario_pedidos_itens
CHECK (preco_unitario >= 0);
