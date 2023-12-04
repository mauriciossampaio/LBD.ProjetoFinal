-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS MyPet;
USE MyPet;

-- Criação da Tabela Produto
CREATE TABLE Produto (
    ProdutoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    TipoProduto VARCHAR(50) NOT NULL,
    QuantidadeEstoque INT NOT NULL
);

-- Criação da Tabela Pedido
CREATE TABLE Pedido (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    ProdutoID INT,
    QuantidadeVendida INT,
    VendedorNome VARCHAR(255) NOT NULL,
    DataVenda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID)
);

-- Criação da Tabela Auditoria
CREATE TABLE Auditoria (
    AuditoriaID INT AUTO_INCREMENT PRIMARY KEY,
    Acao VARCHAR(255) NOT NULL,
    NomeVendedor VARCHAR(255),
    DataAcao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Procedure para inserir novo pedido
DELIMITER //
CREATE PROCEDURE InserirNovoPedido(
    IN p_ProdutoID INT,
    IN p_QuantidadeVendida INT,
    IN p_VendedorNome VARCHAR(255)
)
BEGIN
    -- Inserir novo pedido na tabela Pedido
    INSERT INTO Pedido (ProdutoID, QuantidadeVendida, VendedorNome, DataVenda)
    VALUES (p_ProdutoID, p_QuantidadeVendida, p_VendedorNome, NOW());

    -- Registrar ação na tabela Auditoria
    INSERT INTO Auditoria (Acao, NomeVendedor)
    VALUES ('Inserir Pedido', p_VendedorNome);
END //
DELIMITER ;

-- Procedure para atualizar pedido
DELIMITER //
CREATE PROCEDURE AtualizarPedido(
    IN p_PedidoID INT,
    IN p_NovaQuantidadeVendida INT
)
BEGIN
    -- Atualizar pedido na tabela Pedido
    UPDATE Pedido
    SET QuantidadeVendida = p_NovaQuantidadeVendida
    WHERE PedidoID = p_PedidoID;

    -- Obter nome do vendedor
    SELECT VendedorNome INTO @NomeVendedor FROM Pedido WHERE PedidoID = p_PedidoID;

    -- Registrar ação na tabela Auditoria
    INSERT INTO Auditoria (Acao, NomeVendedor)
    VALUES ('Atualizar Pedido', @NomeVendedor);
END //
DELIMITER ;

-- Procedure para excluir pedido
DELIMITER //
CREATE PROCEDURE ExcluirPedido(
    IN p_PedidoID INT
)
BEGIN
    -- Obter nome do vendedor
    SELECT VendedorNome INTO @NomeVendedor FROM Pedido WHERE PedidoID = p_PedidoID;

    -- Excluir pedido na tabela Pedido
    DELETE FROM Pedido WHERE PedidoID = p_PedidoID;

    -- Registrar ação na tabela Auditoria
    INSERT INTO Auditoria (Acao, NomeVendedor)
    VALUES ('Excluir Pedido', @NomeVendedor);
END //
DELIMITER ;

-- Trigger para INSERT na tabela Pedido
DELIMITER //
CREATE TRIGGER AfterInsertPedido
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN
    -- Chamar a procedure para inserir novo pedido
    CALL InserirNovoPedido(NEW.ProdutoID, NEW.QuantidadeVendida, NEW.VendedorNome);
END //
DELIMITER ;

-- Trigger para UPDATE na tabela Pedido
DELIMITER //
CREATE TRIGGER AfterUpdatePedido
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    -- Chamar a procedure para atualizar pedido
    CALL AtualizarPedido(NEW.PedidoID, NEW.QuantidadeVendida);
END //
DELIMITER ;

-- Trigger para DELETE na tabela Pedido
DELIMITER //
CREATE TRIGGER AfterDeletePedido
AFTER DELETE ON Pedido
FOR EACH ROW
BEGIN
    -- Chamar a procedure para excluir pedido
    CALL ExcluirPedido(OLD.PedidoID);
END //
DELIMITER ;

-- Procedure para inserir novo produto
DELIMITER //
CREATE PROCEDURE InserirNovoProduto(
    IN p_NomeProduto VARCHAR(255),
    IN p_TipoProduto VARCHAR(50),
    IN p_QuantidadeEstoque INT
)
BEGIN
    -- Inserir novo produto na tabela Produto
    INSERT INTO Produto (Nome, TipoProduto, QuantidadeEstoque)
    VALUES (p_NomeProduto, p_TipoProduto, p_QuantidadeEstoque);

    -- Registrar ação na tabela Auditoria
    INSERT INTO Auditoria (Acao)
    VALUES ('Inserir Produto');
END //
DELIMITER ;

-- Procedure para atualizar produto
DELIMITER //
CREATE PROCEDURE AtualizarProduto(
    IN p_ProdutoID INT,
    IN p_NovaQuantidadeEstoque INT
)
BEGIN
    -- Atualizar produto na tabela Produto
    UPDATE Produto
    SET QuantidadeEstoque = p_NovaQuantidadeEstoque
    WHERE ProdutoID = p_ProdutoID;

    -- Obter nome do vendedor
    SELECT Nome INTO @NomeVendedor FROM Produto WHERE ProdutoID = p_ProdutoID;

    -- Registrar ação na tabela Auditoria
    INSERT INTO Auditoria (Acao, NomeVendedor)
    VALUES ('Atualizar Produto', @NomeVendedor);
END //
DELIMITER ;

-- Procedure para excluir produto
DELIMITER //
CREATE PROCEDURE ExcluirProduto(
    IN p_ProdutoID INT
)
BEGIN
    -- Obter nome do vendedor
    SELECT Nome INTO @NomeVendedor FROM Produto WHERE ProdutoID = p_ProdutoID;

    -- Excluir produto na tabela Produto
    DELETE FROM Produto WHERE ProdutoID = p_ProdutoID;

    -- Registrar ação na tabela Auditoria
    INSERT INTO Auditoria (Acao, NomeVendedor)
    VALUES ('Excluir Produto', @NomeVendedor);
END //
DELIMITER ;

-- Trigger para INSERT na tabela Produto
DELIMITER //
CREATE TRIGGER AfterInsertProduto
AFTER INSERT ON Produto
FOR EACH ROW
BEGIN
    -- Chamar a procedure para inserir novo produto
    CALL InserirNovoProduto(NEW.Nome, NEW.TipoProduto, NEW.QuantidadeEstoque);
END //
DELIMITER ;

-- Trigger para UPDATE na tabela Produto
DELIMITER //
CREATE TRIGGER AfterUpdateProduto
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
    -- Chamar a procedure para atualizar produto
    CALL AtualizarProduto(NEW.ProdutoID, NEW.QuantidadeEstoque);
END //
DELIMITER ;

-- Trigger para DELETE na tabela Produto
DELIMITER //
CREATE TRIGGER AfterDeleteProduto
AFTER DELETE ON Produto
FOR EACH ROW
BEGIN
    -- Chamar a procedure para excluir produto
    CALL ExcluirProduto(OLD.ProdutoID);
END //
DELIMITER ;
