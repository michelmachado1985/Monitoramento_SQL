
CREATE DATABASE BancoParticionado;
GO

USE BancoParticionado;
GO

-- Adicionar filegroups para cada partição
ALTER DATABASE BancoParticionado ADD FILEGROUP FG_PARTICAO_2023;
ALTER DATABASE BancoParticionado ADD FILEGROUP FG_PARTICAO_2024;
ALTER DATABASE BancoParticionado ADD FILEGROUP FG_PARTICAO_2025;
ALTER DATABASE BancoParticionado ADD FILEGROUP FG_PARTICAO_2026;
GO

-- Adicionar arquivos de dados para cada filegroup
ALTER DATABASE BancoParticionado ADD FILE 
(
    NAME = 'Particao2023_Data',
    FILENAME = 'D:\DATA\Dados_2008\Particao2023_Data.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_PARTICAO_2023;

ALTER DATABASE BancoParticionado ADD FILE 
(
    NAME = 'Particao2024_Data',
    FILENAME = 'D:\DATA\Dados_2008\Particao2024_Data.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_PARTICAO_2024;

ALTER DATABASE BancoParticionado ADD FILE 
(
    NAME = 'Particao2025_Data',
    FILENAME = 'D:\DATA\Dados_2008\Particao2025_Data.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_PARTICAO_2025;

ALTER DATABASE BancoParticionado ADD FILE 
(
    NAME = 'Particao2026_Data',
    FILENAME = 'D:\DATA\Dados_2008\Particao2026_Data.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_PARTICAO_2026;
GO

--  CRIAR FUNÇÃO DE PARTIÇÃO
CREATE PARTITION FUNCTION PF_VendasPorAno (DATETIME)
AS RANGE LEFT FOR VALUES 
(
    '2023-01-01',
    '2024-01-01',
    '2025-01-01',
    '2026-01-01'
);
GO

--  CRIAR ESQUEMA DE PARTIÇÃO
CREATE PARTITION SCHEME PS_VendasPorAno
AS PARTITION PF_VendasPorAno
TO 
(
    FG_PARTICAO_2023,
    FG_PARTICAO_2024,
    FG_PARTICAO_2025,
    FG_PARTICAO_2026,
    [PRIMARY]
);
GO

--  CRIAR TABELA PARTICIONADA
CREATE TABLE Vendas
(
    ID_Venda INT IDENTITY(1,1),
    Data_Venda DATETIME NOT NULL,
    Cliente_ID INT NOT NULL,
    Produto_ID INT NOT NULL,
    Quantidade INT NOT NULL,
    Valor_Unitario DECIMAL(10,2) NOT NULL,
    Valor_Total DECIMAL(10,2) NOT NULL,
    Status_Venda VARCHAR(20) DEFAULT 'PENDENTE',
    CONSTRAINT PK_Vendas PRIMARY KEY (ID_Venda, Data_Venda)
) ON PS_VendasPorAno (Data_Venda);
GO

-- Índices adicionais
CREATE NONCLUSTERED INDEX IX_Vendas_Cliente ON Vendas(Cliente_ID) 
    ON PS_VendasPorAno (Data_Venda);
GO

CREATE NONCLUSTERED INDEX IX_Vendas_Produto ON Vendas(Produto_ID) 
    ON PS_VendasPorAno (Data_Venda);
GO

--  INSERIR DADOS DE EXEMPLO
INSERT INTO Vendas (Data_Venda, Cliente_ID, Produto_ID, Quantidade, Valor_Unitario, Valor_Total)
VALUES
     ('2023-01-15 10:30:00', 101, 1, 5, 10.50, 52.50),
    ('2023-06-20 14:15:00', 102, 2, 3, 25.00, 75.00),
    ('2023-12-01 09:45:00', 103, 3, 10, 5.50, 55.00),
    
    ('2024-02-10 11:00:00', 104, 1, 2, 10.50, 21.00),
    ('2024-07-15 16:30:00', 105, 4, 8, 15.75, 126.00),
    ('2024-11-20 08:20:00', 106, 2, 6, 25.00, 150.00),
    
    ('2025-01-05 13:45:00', 107, 3, 4, 5.50, 22.00),
    ('2025-03-25 10:00:00', 108, 1, 7, 10.50, 73.50),
    ('2025-08-12 15:10:00', 109, 5, 3, 30.00, 90.00),
    
    ('2026-01-01 00:05:00', 110, 2, 12, 25.00, 300.00),
    ('2026-04-18 09:30:00', 111, 4, 5, 15.75, 78.75);
GO

--  CONSULTAS PARA VERIFICAR PARTICIONAMENTO
-- Verificar em qual partição cada registro está
SELECT 
    $PARTITION.PF_VendasPorAno(Data_Venda) AS Numero_Particao,
    ID_Venda,
    Data_Venda,
    Cliente_ID,
    Valor_Total
FROM Vendas
ORDER BY Data_Venda;
GO

-- Consultar dados de uma partição específica (Partição 2 = 2024)
SELECT * 
FROM Vendas
WHERE $PARTITION.PF_VendasPorAno(Data_Venda) = 2;
GO

-- Ver estatísticas das partições

--  ADICIONAR NOVA PARTIÇÃO 
-- Adicionar filegroup para 2027
ALTER DATABASE BancoParticionado ADD FILEGROUP FG_PARTICAO_2027;
GO

ALTER DATABASE BancoParticionado ADD FILE 
(
    NAME = 'Particao2027_Data',
    FILENAME = 'D:\DATA\Dados_2008\Particao2027_Data.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_PARTICAO_2027;
GO

-- Adicionar novo boundary point
ALTER PARTITION SCHEME PS_VendasPorAno NEXT USED FG_PARTICAO_2027;
GO

ALTER PARTITION FUNCTION PF_VendasPorAno() SPLIT RANGE ('2027-01-01');
GO

-- REMOVER PARTIÇÃO ANTIGA (SLIDING WINDOW - REMOVER 2023)
ALTER PARTITION FUNCTION PF_VendasPorAno() MERGE RANGE ('2023-01-01');
GO

-- Remover o filegroup vazio (opcional)
ALTER DATABASE BancoParticionado REMOVE FILE Particao2023_Data;
ALTER DATABASE BancoParticionado REMOVE FILEGROUP FG_PARTICAO_2023;
GO

--  APLICAR COMPRESSÃO POR PARTIÇÃO
-- Comprimir partição 2 (2024)
ALTER TABLE Vendas 
REBUILD PARTITION = 2 
WITH (DATA_COMPRESSION = PAGE);
GO

-- Comprimir partição 3 (2025)
ALTER TABLE Vendas 
REBUILD PARTITION = 3 
WITH (DATA_COMPRESSION = PAGE);
GO

--  CONSULTAS DE MONITORAMENTO
-- ============================================
-- Ver distribuição dos dados nas partições
SELECT 
    $PARTITION.PF_VendasPorAno(Data_Venda) AS Particao,
    MIN(Data_Venda) AS Data_Inicial,
    MAX(Data_Venda) AS Data_Final,
    COUNT(*) AS Total_Registros,
    SUM(Valor_Total) AS Valor_Total_Vendas
FROM Vendas
GROUP BY $PARTITION.PF_VendasPorAno(Data_Venda)
ORDER BY Particao;
GO

-- Ver espaço usado por partição
SELECT 
    distinct partition_number AS Particao,
    row_count AS Linhas,  
    reserved_page_count AS Paginas_Reservadas,
    in_row_data_page_count AS Paginas_Dados,
    used_page_count AS Paginas_Usadas
FROM sys.dm_db_partition_stats
WHERE object_id = OBJECT_ID('Vendas')
ORDER BY partition_number;
GO