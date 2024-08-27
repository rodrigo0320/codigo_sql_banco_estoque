-- CÓDIGOS CRIADOS EM CIMA DO TRABALHO DE EXTENSÃO FACULDADE ESTÁCIO DE SÁ - DISCIPLINA BANCO DE DADOS
-- PRATICAMENTE TODOS OS CÓDIGOS FORAM COMENTADOS PARA UM MELHOR ENTENDIMENTO DO ANALISTA

-- Tabela para Unidades de Medida
CREATE TABLE ge_unidade_medida (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único da unidade de medida
    descricao VARCHAR(255) NOT NULL UNIQUE,  -- Descrição da unidade de medida (e.g., metros, litros)
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP  -- Data da última edição do registro
);

-- Tabela para Unidades de Massa
CREATE TABLE ge_unidade_massa (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único da unidade de massa
    descricao VARCHAR(255) NOT NULL UNIQUE,  -- Descrição da unidade de massa (e.g., quilogramas)
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP  -- Data da última edição do registro
);

-- Tabela para Grupos de Produtos
CREATE TABLE ge_grupo_prod (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único do grupo de produtos
    codigo VARCHAR(255) NOT NULL UNIQUE,  -- Código identificador do grupo de produtos
    descricao VARCHAR(255),  -- Descrição do grupo de produtos
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP  -- Data da última edição do registro
);

-- Tabela para Subgrupos de Produtos
CREATE TABLE ge_sub_grupo_prod (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único do subgrupo de produtos
    id_ge_grupo_prod INTEGER NOT NULL,  -- Chave estrangeira para a tabela de grupos de produtos
    codigo VARCHAR(255) NOT NULL UNIQUE,  -- Código identificador do subgrupo de produtos
    descricao VARCHAR(255),  -- Descrição do subgrupo de produtos
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP,  -- Data da última edição do registro
    FOREIGN KEY (id_ge_grupo_prod) REFERENCES ge_grupo_prod(id)  -- Relacionamento com a tabela de grupos de produtos
);

-- Tabela para Estoque
CREATE TABLE ge_estoque (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único do estoque
    descricao VARCHAR(255) NOT NULL,  -- Descrição do estoque
    ativo BOOLEAN NOT NULL,  -- Status do estoque (ativo/inativo)
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP  -- Data da última edição do registro
);

-- Tabela para Lotes
CREATE TABLE ge_lote (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único do lote
    num_lote VARCHAR(255) NOT NULL UNIQUE,  -- Número único do lote
    descricao VARCHAR(255),  -- Descrição do lote
    data_val DATE NOT NULL,  -- Data de validade do lote
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP  -- Data da última edição do registro
);

-- Tabela para Produtos
CREATE TABLE ge_produto (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único do produto
    codigo VARCHAR(30) NOT NULL UNIQUE,  -- Código único do produto
    descricao VARCHAR(255),  -- Descrição do produto
    id_unid_medida INTEGER NOT NULL,  -- Chave estrangeira para a unidade de medida
    id_unid_massa INTEGER,  -- Chave estrangeira para a unidade de massa (se aplicável)
    id_ge_sub_grupo_prod INTEGER NOT NULL,  -- Chave estrangeira para o subgrupo de produtos
    id_ge_estoque INTEGER,  -- Chave estrangeira para o estoque
    cod_barras VARCHAR(255),  -- Código de barras do produto
    NCM VARCHAR(255),  -- Nomenclatura Comum do Mercosul
    ativo BOOLEAN NOT NULL,  -- Status do produto (ativo/inativo)
    peso_bruto NUMERIC(10,3),  -- Peso bruto do produto
    peso_liquido NUMERIC(10,3),  -- Peso líquido do produto
    id_ge_lote INTEGER UNIQUE,  -- Chave estrangeira para o lote (se aplicável)
    valor_custo NUMERIC(10,2),  -- Valor de custo do produto
    valor_venda NUMERIC(10,2),  -- Valor de venda do produto
    min_estoque NUMERIC(10,3) CHECK (min_estoque >= 0) NOT NULL,  -- Estoque mínimo
    max_estoque NUMERIC(10,3) CHECK (max_estoque >= min_estoque),  -- Estoque máximo
    estoque_atual NUMERIC(10,2),  -- Estoque atual
    cor VARCHAR(100),  -- Cor do produto (se aplicável)
    material VARCHAR(100),  -- Material do produto (se aplicável)
    tamanho VARCHAR(50),  -- Tamanho do produto (se aplicável)
    tensao VARCHAR(6) CHECK (tensao IN ('110V', '220V', 'Outros')),  -- Tensão elétrica (se aplicável)
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP,  -- Data da última edição do registro
    FOREIGN KEY (id_unid_medida) REFERENCES ge_unidade_medida(id),  -- Relacionamento com a tabela de unidades de medida
    FOREIGN KEY (id_unid_massa) REFERENCES ge_unidade_massa(id),  -- Relacionamento com a tabela de unidades de massa
    FOREIGN KEY (id_ge_estoque) REFERENCES ge_estoque(id),  -- Relacionamento com a tabela de estoque
    FOREIGN KEY (id_ge_lote) REFERENCES ge_lote(id),  -- Relacionamento com a tabela de lotes
    FOREIGN KEY (id_ge_sub_grupo_prod) REFERENCES ge_sub_grupo_prod(id)  -- Relacionamento com a tabela de subgrupos de produtos
);

-- Tabela para Produtos e Fornecedores
CREATE TABLE ge_produto_fornecedor (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único da relação produto-fornecedor
    id_ge_prod INTEGER NOT NULL,  -- Chave estrangeira para o produto
    id_gf_fornecedor INTEGER NOT NULL,  -- Chave estrangeira para o fornecedor
    quantia_estoque NUMERIC(10,3) CHECK (quantia_estoque >= 0) NOT NULL,  -- Quantidade em estoque fornecida pelo fornecedor
    valor_custo NUMERIC(10,2),  -- Valor de custo do produto fornecido
    valor_venda NUMERIC(10,2),  -- Valor de venda do produto fornecido
    id_ge_lote INTEGER UNIQUE,  -- Chave estrangeira para o lote
    id_ge_estoque INTEGER NOT NULL,  -- Chave estrangeira para o estoque
    id_ga_usuario INTEGER NOT NULL,  -- Chave estrangeira para o usuário responsável
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP,  -- Data da última edição do registro
    FOREIGN KEY (id_ge_lote) REFERENCES ge_lote(id),  -- Relacionamento com a tabela de lotes
    FOREIGN KEY (id_ge_prod) REFERENCES ge_produto(id),  -- Relacionamento com a tabela de produtos
    FOREIGN KEY (id_gf_fornecedor) REFERENCES gf_fornecedor(id),  -- Relacionamento com a tabela de fornecedores
    FOREIGN KEY (id_ge_estoque) REFERENCES ge_estoque(id),  -- Relacionamento com a tabela de estoque
    FOREIGN KEY (id_ga_usuario) REFERENCES ga_usuario(id)  -- Relacionamento com a tabela de usuários
);

-- Tabela para Operações de Estoque
CREATE TABLE ge_op_estoque (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único da operação de estoque
    descricao VARCHAR(255) NOT NULL,  -- Descrição da operação de estoque (e.g., entrada, saída)
    tipo VARCHAR(7) CHECK (tipo IN ('Entrada', 'Saida', 'Ajuste')) NOT NULL,  -- Tipo de operação (entrada/saída/ajuste)
    ativo BOOLEAN NOT NULL,  -- Status da operação (ativo/inativo)
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP  -- Data da última edição do registro
);

-- Tabela para Movimentações de Estoque
CREATE TABLE ge_mov_estoque (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único da movimentação de estoque
    id_ge_prod INTEGER NOT NULL,  -- Chave estrangeira para o produto
    id_ge_op_estoque INTEGER NOT NULL,  -- Chave estrangeira para a operação de estoque
    id_ge_estoque INTEGER NOT NULL,  -- Chave estrangeira para o estoque
    id_ge_lote INTEGER,  -- Chave estrangeira para o lote (se aplicável)
    num_nota_fiscal VARCHAR(255),  -- Número da nota fiscal
    id_gf_fornecedor INTEGER,  -- Chave estrangeira para o fornecedor
    data_mov DATE NOT NULL,  -- Data da movimentação
    quantidade NUMERIC(10,3) NOT NULL,  -- Quantidade movimentada
    val_total NUMERIC(10,2),  -- Valor total da movimentação
    id_ga_usuario INTEGER NOT NULL,  -- Chave estrangeira para o usuário responsável
    criado TIMESTAMP NOT NULL,  -- Data de criação do registro
    editado TIMESTAMP,  -- Data da última edição do registro
    estornada BOOLEAN,  -- Indica se a movimentação foi estornada
    data_estorno DATE,  -- Data do estorno (se aplicável)
    FOREIGN KEY (id_ge_prod) REFERENCES ge_produto(id),  -- Relacionamento com a tabela de produtos
    FOREIGN KEY (id_ge_lote) REFERENCES ge_lote(id),  -- Relacionamento com a tabela de lotes
    FOREIGN KEY (id_ga_usuario) REFERENCES ga_usuario(id),  -- Relacionamento com a tabela de usuários
    FOREIGN KEY (id_ge_op_estoque) REFERENCES ge_op_estoque(id),  -- Relacionamento com a tabela de operações de estoque
    FOREIGN KEY (id_ge_estoque) REFERENCES ge_estoque(id),  -- Relacionamento com a tabela de estoque
    FOREIGN KEY (id_gf_fornecedor) REFERENCES gf_fornecedor(id)  -- Relacionamento com a tabela de fornecedores
);

-- Tabela para Estornos de Movimentações de Estoque
CREATE TABLE ge_estorno_movs_estoq (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE,  -- Identificador único do estorno
    id_ge_mov_estoque INTEGER NOT NULL UNIQUE,  -- Chave estrangeira para a movimentação de estoque
    motivo_estorno VARCHAR(255) NOT NULL,  -- Motivo do estorno
    data_estorno TIMESTAMP NOT NULL,  -- Data do estorno
    id_ga_usuario_estorno INTEGER NOT NULL,  -- Chave estrangeira para o usuário que efetuou o estorno
    id_ge_prod_estorno INTEGER,  -- Chave estrangeira para o produto estornado
    id_ge_prod_fornec_estor INTEGER,  -- Chave estrangeira para o fornecedor do produto estornado
    id_ge_op_mov_estoque INTEGER NOT NULL,  -- Chave estrangeira para a operação de estoque do estorno
    quantia_estornada NUMERIC(10,3) NOT NULL,  -- Quantidade estornada
    FOREIGN KEY (id_ge_mov_estoque) REFERENCES ge_mov_estoque(id),  -- Relacionamento com a tabela de movimentações de estoque
    FOREIGN KEY (id_ga_usuario_estorno) REFERENCES ga_usuario(id),  -- Relacionamento com a tabela de usuários
    FOREIGN KEY (id_ge_prod_estorno) REFERENCES ge_produto(id),  -- Relacionamento com a tabela de produtos
    FOREIGN KEY (id_ge_prod_fornec_estor) REFERENCES ge_produto_fornecedor(id),  -- Relacionamento com a tabela de fornecedores de produtos
    FOREIGN KEY (id_ge_op_mov_estoque) REFERENCES ge_op_estoque(id)  -- Relacionamento com a tabela de operações de estoque
);

-- Visão para Fornecedores
CREATE OR REPLACE VIEW public.vw_gf_fornecedores AS
SELECT f.razao_social,
       f.nome_fantasia,
       f.telefone,
       f.email,
       f.end_logr AS rua,
       f.end_num AS num_rua,
       f.end_cep AS cep,
       f.end_bairro AS bairro,
       f.end_localid AS cidade,
       f.end_compl AS complemento,
       f.end_uf AS estado,
       f.cnpj,
       f.ie,
       CASE
           WHEN f.ativo = true THEN 'Sim'::text
           ELSE 'Não'::text
       END AS ativo,
       CASE
           WHEN f.isento_icms = true THEN 'Sim'::text
           ELSE 'Não'::text
       END AS isento_icms,
       CASE
           WHEN f.opt_simpl_nacional = true THEN 'Sim'::text
           ELSE 'Não'::text
       END AS opt_simpl_nacional,
       f.criado,
       f.editado
FROM gf_fornecedor f;

-- Visão para Movimentações de Estoque
CREATE OR REPLACE VIEW public.vw_ge_movs_estoque AS
SELECT ge_mov_estoque.id AS id_mov_estoque,
       p.codigo AS cod_produto,
       p.descricao AS desc_produto,
       ope.tipo AS tipo_op_estoque,
       ope.descricao AS operacao_estoque,
       ge_mov_estoque.quantidade,
       um.descricao AS unid_medida,
       ge_mov_estoque.val_total,
       p.cod_barras AS cod_barras_produto,
       ge_estoque.descricao AS nome_estoque,
       ge_lote.num_lote AS numero_lote_prod,
       ge_mov_estoque.num_nota_fiscal AS num_nota_fiscal,
       gf_fornecedor.razao_social AS razao_social_fornecedor,
       ge_mov_estoque.data_mov AS data_da_movimentacao,
       ga_usuario.nome AS usuario_que_movimentou
FROM ge_mov_estoque
JOIN ge_produto p ON ge_mov_estoque.id_ge_prod = p.id
JOIN ge_unidade_medida um ON p.id_unid_medida = um.id
JOIN ge_op_estoque ope ON ge_mov_estoque.id_ge_op_estoque = ope.id
JOIN ge_estoque ON ge_mov_estoque.id_ge_estoque = ge_estoque.id
LEFT JOIN ge_lote ON ge_mov_estoque.id_ge_lote = ge_lote.id
LEFT JOIN gf_fornecedor ON ge_mov_estoque.id_gf_fornecedor = gf_fornecedor.id
JOIN ga_usuario ON ge_mov_estoque.id_ga_usuario = ga_usuario.id;

-- Função para Verificar Movimentações de Estoque
CREATE OR REPLACE FUNCTION fn_verifica_ge_movs_estoque (
    p_id_ge_prod INTEGER,
    p_data_mov DATE,
    p_id_ge_op_estoque INTEGER,
    p_quantidade NUMERIC(10,3)
) RETURNS BOOLEAN AS $$
DECLARE
    v_estoque_atual NUMERIC(10,2);
BEGIN
    -- Obtém o estoque atual do produto
    SELECT estoque_atual INTO v_estoque_atual
    FROM ge_produto
    WHERE id = p_id_ge_prod;

    -- Verifica se o produto existe
    IF v_estoque_atual IS NULL THEN
        RAISE EXCEPTION 'Produto não encontrado!';
    END IF;

    -- Verifica se a data da movimentação foi fornecida
    IF p_data_mov IS NULL THEN
        RAISE EXCEPTION 'Data da movimentação é obrigatória!';
    END IF;

    -- Verifica se a quantidade é válida
    IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
        RAISE EXCEPTION 'Quantidade inválida!';
    END IF;

    -- Verifica se o tipo de operação de estoque foi fornecido
    IF p_id_ge_op_estoque IS NULL THEN
        RAISE EXCEPTION 'Tipo de operação de estoque é obrigatório!';
    END IF;

    -- Verifica se o estoque atual é negativo
    IF v_estoque_atual < 0 THEN
        RAISE EXCEPTION 'Estoque atual está negativo!';
    END IF;

    -- Verifica se já existe uma movimentação de estoque para o produto na data e tipo de operação especificados
    IF EXISTS (
        SELECT 1
        FROM ge_mov_estoque
        WHERE id_ge_prod = p_id_ge_prod
          AND data_mov = p_data_mov
          AND id_ge_op_estoque = p_id_ge_op_estoque
    ) THEN
        RETURN TRUE;  -- Movimentação já existe
    ELSE
        RETURN FALSE;  -- Movimentação não existe
    END IF;
END;
$$ LANGUAGE plpgsql;
