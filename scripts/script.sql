-- =========================
-- SCHEMAS
-- =========================
CREATE SCHEMA academico;
CREATE SCHEMA seguranca;

-- =========================
-- TABELAS
-- =========================

CREATE TABLE academico.aluno (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    endereco VARCHAR(150),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.docente (
    id_docente SERIAL PRIMARY KEY,
    nome VARCHAR(100)
);

CREATE TABLE academico.disciplina (
    id_disciplina SERIAL PRIMARY KEY,
    codigo VARCHAR(10),
    nome VARCHAR(100),
    carga_horaria INT
);

CREATE TABLE academico.turma (
    id_turma SERIAL PRIMARY KEY,
    id_disciplina INT REFERENCES academico.disciplina(id_disciplina),
    id_docente INT REFERENCES academico.docente(id_docente),
    ciclo VARCHAR(10)
);

CREATE TABLE academico.matricula (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INT REFERENCES academico.aluno(id_aluno),
    id_turma INT REFERENCES academico.turma(id_turma)
);

CREATE TABLE academico.nota (
    id_nota SERIAL PRIMARY KEY,
    id_matricula INT REFERENCES academico.matricula(id_matricula),
    valor DECIMAL(4,2)
);

-- =========================
-- SEGURANÇA (DCL)
-- =========================

CREATE ROLE professor_role;
CREATE ROLE coordenador_role;

GRANT UPDATE ON academico.nota TO professor_role;

REVOKE SELECT ON academico.aluno FROM professor_role;
REVOKE SELECT ON academico.docente FROM professor_role;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academico TO coordenador_role;

-- =========================
-- INSERTS (PLANILHA LEGADA NORMALIZADA)
-- =========================

-- ALUNOS
INSERT INTO academico.aluno (nome, email, endereco) VALUES
('Ana Beatriz Lima', 'ana.lima@aluno.edu.br', 'Bragança Paulista/SP'),
('Bruno Henrique Souza', 'bruno.souza@aluno.edu.br', 'Atibaia/SP'),
('Camila Ferreira', 'camila.ferreira@aluno.edu.br', 'Jundiaí/SP');

-- DOCENTES
INSERT INTO academico.docente (nome) VALUES
('Prof. Carlos Mendes'),
('Profa. Juliana Castro'),
('Prof. Eduardo Pires'),
('Prof. Renato Alves'),
('Profa. Marina Lopes'),
('Prof. Ricardo Faria');

-- DISCIPLINAS
INSERT INTO academico.disciplina (codigo, nome, carga_horaria) VALUES
('ADS101', 'Banco de Dados', 80),
('ADS102', 'Engenharia de Software', 80),
('ADS103', 'Algoritmos', 60),
('ADS104', 'Redes de Computadores', 60),
('ADS105', 'Sistemas Operacionais', 60),
('ADS106', 'Estruturas de Dados', 80);

-- TURMAS
INSERT INTO academico.turma (id_disciplina, id_docente, ciclo) VALUES
(1, 1, '2026/1'),
(2, 2, '2026/1'),
(3, 4, '2026/1');

-- MATRÍCULAS
INSERT INTO academico.matricula (id_aluno, id_turma) VALUES
(1,1),(1,2),(1,3),
(2,1),(2,3),
(3,1),(3,2);

-- NOTAS
INSERT INTO academico.nota (id_matricula, valor) VALUES
(1,9.1),(2,8.4),(3,8.9),
(4,7.3),(5,6.8),
(6,5.9),(7,7.5);

-- =========================
-- CONSULTAS (PROVA)
-- =========================

-- 1. Matriculados 2026/1
SELECT a.nome, d.nome AS disciplina, t.ciclo
FROM academico.aluno a
JOIN academico.matricula m ON a.id_aluno = m.id_aluno
JOIN academico.turma t ON m.id_turma = t.id_turma
JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina
WHERE t.ciclo = '2026/1';

-- 2. Média baixa (<6)
SELECT d.nome, AVG(n.valor) AS media
FROM academico.nota n
JOIN academico.matricula m ON n.id_matricula = m.id_matricula
JOIN academico.turma t ON m.id_turma = t.id_turma
JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina
GROUP BY d.nome
HAVING AVG(n.valor) < 6;

-- 3. Docentes (LEFT JOIN)
SELECT doc.nome, d.nome AS disciplina
FROM academico.docente doc
LEFT JOIN academico.turma t ON doc.id_docente = t.id_docente
LEFT JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina;

-- 4. Maior nota Banco de Dados
SELECT a.nome, n.valor
FROM academico.aluno a
JOIN academico.matricula m ON a.id_aluno = m.id_aluno
JOIN academico.nota n ON m.id_matricula = n.id_matricula
JOIN academico.turma t ON m.id_turma = t.id_turma
JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina
WHERE d.nome = 'Banco de Dados'
AND n.valor = (SELECT MAX(n2.valor) FROM academico.nota n2);