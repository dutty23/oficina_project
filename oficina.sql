-- Criação do banco de dados e seleção
CREATE DATABASE oficina; -- Cria o banco de dados chamado "oficina"
USE oficina; -- Seleciona o banco de dados "oficina" para uso

-- Tabela para equipes de mecânicos
CREATE TABLE Equipe (
  idEquipe INT NOT NULL AUTO_INCREMENT, -- Identificador único da equipe
  Nome_equipe VARCHAR(45), -- Nome da equipe
  Descricao VARCHAR(45), -- Descrição da equipe
  PRIMARY KEY (idEquipe) -- Define a chave primária
);

-- Tabela para armazenar informações dos mecânicos
CREATE TABLE Mecanico (
  idMecanico INT NOT NULL AUTO_INCREMENT, -- Identificador único do mecânico
  Nome VARCHAR(45), -- Nome do mecânico
  Especialidade VARCHAR(45), -- Especialidade do mecânico
  Endereco VARCHAR(45), -- Endereço do mecânico
  Equipe_idEquipe INT NOT NULL, -- Relacionamento com a tabela Equipe
  PRIMARY KEY (idMecanico), -- Define a chave primária
  FOREIGN KEY (Equipe_idEquipe) REFERENCES Equipe (idEquipe) -- Define a chave estrangeira para Equipe
);

-- Tabela para armazenar informações dos clientes
CREATE TABLE Cliente (
  idCliente INT NOT NULL AUTO_INCREMENT, -- Identificador único do cliente
  Nome VARCHAR(45), -- Nome do cliente
  Data_nascimento DATE, -- Data de nascimento do cliente
  Endereco VARCHAR(45), -- Endereço do cliente
  Telefone VARCHAR(20), -- Telefone do cliente
  PRIMARY KEY (idCliente) -- Define a chave primária
);

-- Tabela para armazenar informações dos veículos
CREATE TABLE Veiculo (
  idVeiculo INT NOT NULL AUTO_INCREMENT, -- Identificador único do veículo
  Modelo VARCHAR(45), -- Modelo do veículo
  Ano YEAR, -- Ano de fabricação do veículo
  Placa VARCHAR(10), -- Placa do veículo
  Cliente_idCliente INT NOT NULL, -- Relacionamento com a tabela Cliente
  PRIMARY KEY (idVeiculo), -- Define a chave primária
  FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente) -- Define a chave estrangeira para Cliente
);

-- Tabela para ordens de serviço
CREATE TABLE OrdemServico (
  idOrdemServico INT NOT NULL AUTO_INCREMENT, -- Identificador único da ordem de serviço
  Numero VARCHAR(45) UNIQUE, -- Número único da ordem de serviço
  Data_emissao DATE, -- Data de emissão da ordem
  Valor_total DECIMAL(10,2), -- Valor total da ordem
  Status ENUM('Aberto', 'Em andamento', 'Aguardando Peças', 'Concluído', 'Cancelado'), -- Status da ordem
  Data_conclusao DATE, -- Data de conclusão da ordem
  Veiculo_idVeiculo INT NOT NULL, -- Relacionamento com a tabela Veículo
  Mecanico_idMecanico INT NOT NULL, -- Relacionamento com a tabela Mecânico
  PRIMARY KEY (idOrdemServico), -- Define a chave primária
  FOREIGN KEY (Veiculo_idVeiculo) REFERENCES Veiculo (idVeiculo), -- Define a chave estrangeira para Veículo
  FOREIGN KEY (Mecanico_idMecanico) REFERENCES Mecanico (idMecanico) -- Define a chave estrangeira para Mecânico
);

-- Tabela para o controle de estoque de peças
CREATE TABLE Estoque_peca (
  idEstoque INT NOT NULL AUTO_INCREMENT, -- Identificador único do estoque de peças
  Nome_peca VARCHAR(45), -- Nome da peça
  Descricao VARCHAR(255), -- Descrição da peça
  Valor DECIMAL(10,2), -- Valor unitário da peça
  QuantidadeEstoque INT, -- Quantidade disponível em estoque
  PRIMARY KEY (idEstoque) -- Define a chave primária
);

-- Tabela para associar ordens de serviço com peças do estoque
CREATE TABLE OrdemServico_has_Estoque_peca (
  OrdemServico_idOrdemServico INT NOT NULL, -- Relacionamento com a tabela OrdemServico
  Estoque_peca_idEstoque INT NOT NULL, -- Relacionamento com a tabela Estoque_peca
  Quantidade DECIMAL(10,2), -- Quantidade de peças usadas
  PRIMARY KEY (OrdemServico_idOrdemServico, Estoque_peca_idEstoque), -- Define a chave primária composta
  FOREIGN KEY (OrdemServico_idOrdemServico) REFERENCES OrdemServico (idOrdemServico), -- Chave estrangeira para OrdemServico
  FOREIGN KEY (Estoque_peca_idEstoque) REFERENCES Estoque_peca (idEstoque) -- Chave estrangeira para Estoque_peca
);

CREATE TABLE Servico (
  idServico INT NOT NULL AUTO_INCREMENT, -- Identificador único do serviço
  Status ENUM('Autorizado', 'Não autorizado') NOT NULL, -- Status de autorização do serviço
  Nivel_complexidade ENUM('Nível 1', 'Nível 2', 'Nível 3') NOT NULL, -- Nível de complexidade do serviço
  Cliente_idCliente INT NOT NULL, -- Relacionamento com a tabela Cliente
  PRIMARY KEY (idServico), -- Define a chave primária
  FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente) -- Define a chave estrangeira para Cliente
);


-- Tabela para tabela de preços dos serviços
CREATE TABLE TabelaPrecoServico (
  idTabelaPrecoServico INT NOT NULL AUTO_INCREMENT, -- Identificador único da tabela de preços
  Descricao VARCHAR(255), -- Descrição do serviço
  Valor DECIMAL(10,2), -- Valor do serviço
  DataInicioValidade DATE, -- Data de início de validade do preço
  DataFimValidade DATE, -- Data de fim de validade do preço
  PRIMARY KEY (idTabelaPrecoServico) -- Define a chave primária
);

-- Tabela para associar ordens de serviço com serviços realizados
CREATE TABLE OrdemServico_has_Servico (
  OrdemServico_idOrdemServico INT NOT NULL, -- Relacionamento com a tabela OrdemServico
  Servico_idServico INT NOT NULL, -- Relacionamento com a tabela Servico
  TabelaPrecoServico_idTabelaPrecoServico INT NOT NULL, -- Relacionamento com a tabela TabelaPrecoServico
  PRIMARY KEY (OrdemServico_idOrdemServico, Servico_idServico, TabelaPrecoServico_idTabelaPrecoServico), -- Chave primária composta
  FOREIGN KEY (OrdemServico_idOrdemServico) REFERENCES OrdemServico (idOrdemServico), -- Chave estrangeira para OrdemServico
  FOREIGN KEY (Servico_idServico) REFERENCES Servico (idServico), -- Chave estrangeira para Servico
  FOREIGN KEY (TabelaPrecoServico_idTabelaPrecoServico) REFERENCES TabelaPrecoServico (idTabelaPrecoServico) -- Chave estrangeira para TabelaPrecoServico
);
