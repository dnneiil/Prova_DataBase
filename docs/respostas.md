SGBD Relacional vs NoSQL

A escolha de um SGBD relacional como PostgreSQL é ideal para este cenário pois sistemas acadêmicos exigem alta consistência e integridade dos dados.



As propriedades ACID garantem:

- Atomicidade: operações completas ou não executadas

- Consistência: mantém regras do banco (ex: FK)

- Isolamento: evita conflitos entre transações simultâneas

- Durabilidade: dados persistem mesmo após falhas



Em um sistema acadêmico, erros como matrícula inconsistente ou notas erradas não são aceitáveis, por isso o modelo relacional é mais seguro que NoSQL.



\--



\Uso de Schemas

O uso de schemas (como academico e seguranca) permite melhor organização e separação de responsabilidades dentro do banco.



Vantagens:

- Organização lógica do banco

- Melhor controle de permissões

- Evita conflitos de nomes

- Facilita manutenção e escalabilidade



\---



 2. Modelo Lógico (Exemplo base)



Aluno(id\_aluno PK, nome, email, ativo)

Professor(id\_professor PK, nome, email, ativo)

Disciplina(id\_disciplina PK, nome)

Turma(id\_turma PK, id\_disciplina FK, id\_professor FK, ciclo)

Matricula(id\_matricula PK, id\_aluno FK, id\_turma FK, nota, ativo)



\---



 5. Transações e Concorrência



Quando dois operadores tentam alterar a mesma matrícula ao mesmo tempo, o SGBD utiliza mecanismos de isolamento e locks.



O isolamento garante que uma transação não interfira na outra.



Os locks bloqueiam temporariamente o acesso ao registro enquanto ele está sendo alterado.



Assim, evita-se:

 1-perda de dados

 2-sobrescrita indevida

 3-inconsistência



Isso garante que apenas uma alteração ocorra por vez, mantendo a integridade do sistema.

