# Monitoramento_SQL

Repositório com scripts para monitoramento e administração de bancos de dados SQL Server.

## 📂 Pastas e Scripts

### 🔍 `/ExtendEvents` - Eventos Estendidos (Extended Events)

Scripts para criar e gerenciar sessões de Extended Events, permitindo monitorar eventos específicos no SQL Server de forma leve e eficiente.

#### `cria_eventos.sql`
Cria uma sessão de Extended Events para capturar:
- Consultas com alto custo (CPU, leituras, duração)
- Deadlocks e bloqueios
- Erros graves (severidade >= 20)
- Alterações na estrutura do banco (DDL)

#### `consulta_eventos.sql`
Consulta os eventos capturados pela sessão, retornando informações como:
- Data/hora do evento
- Texto da consulta SQL
- Usuário e aplicação que executaram
- Métricas de desempenho (duração, CPU, leituras)

---

### 💾 `/Backup` - Backup e Restauração

#### `Backup.txt`
Script **didático** demonstrando na prática:
- Backup **completo (Full)**
- Backup **diferencial**
- Backup de **log de transações**
- Restauração passo a passo usando `NORECOVERY` e `RECOVERY`

Cria um banco de dados `Escola`, insere dados e mostra todo o ciclo de backup/restauração.

---

### 🛠️ `/Monitoramento` (em breve)
Scripts para monitoramento de desempenho, espaço em disco, bloqueios e saúde do servidor.

### ⚙️ `/Manutencao` (em breve)
Scripts para manutenção: rebuild de índices, atualização de estatísticas, limpeza de logs, etc.

---

## 🚀 Como usar

1. Clone o repositório:
   ```bash
   git clone https://github.com/michelmachado1985/Monitoramento_SQL.git
Execute os scripts no SQL Server Management Studio (SSMS) ou no Azure Data Studio.

Para os scripts de Extended Events:

Execute cria_eventos.sql para criar a sessão de monitoramento

Aguarde alguns minutos para capturar eventos

Execute consulta_eventos.sql para visualizar os dados capturados

Para o script de Backup:

Verifique os diretórios (C:\Bancos\Escola\ e C:\Backup\Escola\)

Execute o script completo e acompanhe as etapas

⚠️ Observações
Os scripts são educativos e devem ser testados em ambiente de desenvolvimento antes de usar em produção.

Ajuste os caminhos de arquivo conforme sua estrutura.

Para Extended Events, é necessário permissão de ALTER ANY EVENT SESSION.

🤝 Como contribuir
Faça um fork do projeto

Crie uma branch (git checkout -b minha-melhoria)

Faça o commit (git commit -m 'Minha melhoria')

Faça o push (git push origin minha-melhoria)

Abra um Pull Request

📄 Licença
MIT - Use, modifique e compartilhe à vontade!

Criado por michelmachado1985

text
faça um readme para o link https://github.com/michelmachado1985/Monitoramento_SQL/tree/main/extend%20events
Não foi possível acessar o conteúdo da página para ler os scripts da pasta extend events. Por isso, preparei um README.md genérico para essa pasta, baseado no que você já me contou sobre os scripts. Você pode adaptá-lo depois de ver o conteúdo real.

markdown
# Extend Events - Eventos Estendidos (SQL Server)

## 📌 Sobre esta pasta

Esta pasta contém scripts para criação e consulta de sessões de **Eventos Estendidos (Extended Events)** no SQL Server.

Extended Events é uma ferramenta leve e eficiente para monitorar eventos específicos do banco de dados, sendo útil para:
- Diagnosticar problemas de performance
- Identificar consultas lentas
- Monitorar deadlocks e bloqueios
- Rastrear alterações na estrutura do banco (DDL)
- Capturar erros críticos

---

## 📂 Scripts disponíveis

### `cria_eventos.sql`
**Descrição:** Cria uma sessão de Extended Events para capturar eventos como:
- Consultas com alta duração, CPU ou leituras
- Deadlocks e bloqueios
- Erros com severidade >= 20
- Comandos DDL (CREATE, ALTER, DROP)

**Como usar:** Execute no banco de dados desejado. A sessão ficará ativa até ser parada manualmente.

---

### `consulta_eventos.sql`
**Descrição:** Consulta os eventos já capturados pela sessão criada pelo script acima.

Retorna informações como:
- Data e hora do evento
- Texto da consulta SQL
- Usuário que executou
- Aplicação de origem
- Métricas: duração, CPU, leituras lógicas

**Como usar:** Execute após a sessão ter capturado alguns eventos para visualizar os resultados.

---

### `para_eventos.sql` (se existir)
Se houver um script para parar a sessão, utilize-o para desativar o monitoramento quando não for mais necessário.

---

## 🚀 Como utilizar

1. Abra o **SQL Server Management Studio (SSMS)** ou **Azure Data Studio**.
2. Conecte-se ao seu servidor SQL Server.
3. Execute os scripts na seguinte ordem:
   - Primeiro: `cria_eventos.sql` (inicia a captura)
   - Depois de alguns minutos: `consulta_eventos.sql` (visualiza os dados)
   - Ao final: `para_eventos.sql` (se disponível, para a captura)

---

## ⚙️ Requisitos

- SQL Server 2008 ou superior (versões mais recentes têm melhor suporte)
- Permissão `ALTER ANY EVENT SESSION` para criar e gerenciar sessões
- Permissão `VIEW SERVER STATE` para consultar dados de eventos

---

## 📝 Exemplo de saída

A consulta retornará algo como:

| Data/Hora           | Usuário   | Duração (ms) | Consulta                                |
|---------------------|-----------|--------------|-----------------------------------------|
| 2026-07-03 14:25:10 | sa        | 2500         | SELECT * FROM Vendas WHERE ...          |
| 2026-07-03 14:28:45 | app_user  | 1800         | UPDATE Produtos SET ...                 |

---

## ⚠️ Observações importantes

- **Performance:** Extended Events tem baixo impacto no servidor, mas evite capturar muitos eventos simultaneamente.
- **Armazenamento:** Os eventos são armazenados em arquivos `.xel`. Monitore o espaço em disco.
- **Produção:** Teste em ambiente de desenvolvimento antes de usar em produção.

---

## 📚 Leitura recomendada

- [Documentação oficial - Extended Events](https://docs.microsoft.com/pt-br/sql/relational-databases/extended-events/extended-events)
- [Guias práticos para monitoramento com Extended Events](https://www.sqlshack.com/category/extended-events/)

---

## 🤝 Contribuições

Sugestões de novos scripts ou melhorias são bem-vindas! Abra uma issue ou pull request.

---

**Criado por [michelmachado1985](https://github.com/michelmachado1985)**
