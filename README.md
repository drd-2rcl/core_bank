# CoreBankApi

![CI&CD](https://github.com/drd-2rcl/core_bank/actions/workflows/elixir.yml/badge.svg)
[![codecov](https://codecov.io/gh/drd-2rcl/core_bank/branch/main/graph/badge.svg?token=NJFSOT6VYH)](https://codecov.io/gh/drd-2rcl/core_bank)

<details open="open">
  <summary>Conteúdo</summary>
  <ol>
    <li>
      <a href="#sobre-o-projeto">Sobre o projeto</a>
    </li>
    <li>
      <a href="#começando">Começando</a>
      <ul>
        <li><a href="#pré-requisitos">Pré-requisitos</a></li>
        <li><a href="#instalção">Instalação</a></li>
      </ul>
    </li>
    <li>
      <a href="#documentação-api">Testes</a>
    </li>
    <li>
      <a href="#documentação-api">Documentação API</a>
    </li>
    <li>
      <a href="#problemas-na-configuração">Problemas na configuração?</a>
    </li>
  </ol>
</details>

## Sobre o projeto

Este projeto foi realizado pensando nos seguintes requisitos:

1. Criação de usuário com saldo em conta de R$ 1000,00.
2. Transferência de dinheiro entre contas.
3. Saque do dinheiro com envio de email ao usuário.
4. Contas não podem ficar zeradas.
5. Autenticação.
6. Geração de relatórios com o total transacionado, dia, mês e ano.

As configurações das ferramentas foram realizadas na geração do projeto, assim pode-se acompanhar a abertura de Pull Requests e as actions do github para validações de:

```
mix format --check-formatted
mix credo --strict
mix coveralls.json
mix test
```

Após as validações é gerado um relatório com a cobertura de testes dentro do PR e no caso de diminuição da porcentagem, o CI falha impossibilitando o merge da branch até que seja entregue os testes faltantes.

Com o PR finalizado e validado pelas ferramentas, é liberado o merge e após as devidas validações na branch main é iniciado o processo de deploy no Gigalixir.

Desta forma, fica automatizado:

```
1. Cobertura de testes.
2. Validações dos padrões do projeto.
3. Processo de Deploy
```

## Começando

### Pré-requisitos

É necessário ter instalado na sua máquina:

- docker: [https://docs.docker.com/get-started/#download-and-install-docker](https://docs.docker.com/get-started/#download-and-install-docker)
- docker-compose: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

### Instalação

- Faça o clone do repositório `git clone git@github.com:drd-2rcl/core_bank.git`

```bash
git clone git@github.com:drd-2rcl/core_bank.git
cd core_bank
docker-compose build
cd assets && npm i
cd ../
docker-compose run api mix deps.get
docker-compose run api mix deps.compile
docker-compose run api mix ecto.create #Problemas na configuração?
docker-compose run api mix ecto.migrate
docker-compose up
```

Pronto, temos a nossa aplicação em pé e você pode visitar o [`localhost:4000`](http://localhost:4000) no seu browser.

### Testes

Para rodar a suíte de testes:

```bash
docker-compose run api mix test
```

E para verificar a cobertura:

```bash
docker-compose run api mix test --cover
```

### Documentação API

A documentação da API foi disponibilizada neste [link](https://documenter.getpostman.com/view/5077223/Tzsikixr) público do postman.

Não esqueça de selecionar os ambientes (desenvolvimento ou produção) para realizar os requests, pois a `base_url` altera de um para o outro.

Todas as rotas necessitam de autenticação via Bearer Token, exceto na `criação de usuários` e `sign_in`.

Os requests para `transfers`, `withdraw` e `report` são feitos com base no `id` da conta que pode ser resgatado quando o usuário é criado;

Os envios de email nas realizações de saque ocorrem em ambiente de desenvolvimento. Para validar o envio acesse a rota [`localhost:4000/sent_emails`](http://localhost:4000/sent_emails)

### Problemas na configuração?

Tive problemas nas vezes em que voltei a buildar o projeto, então vou deixar registrado e como resolver para caso alguém tenha também.

Em algumas vezes em que baixei o projeto e tentei criar o banco após buildar a imagem eu tinha esse erro:

```bash
▶ docker-compose run api mix ecto.create

Creating core_bank_db_1 ... done

16:59:22.330 [error] GenServer #PID<0.286.0> terminating
** (DBConnection.ConnectionError) tcp connect (db:5432): connection refused - :econnrefused
    (db_connection 2.4.0) lib/db_connection/connection.ex:100: DBConnection.Connection.connect/2
    (connection 1.1.0) lib/connection.ex:622: Connection.enter_connect/5
    (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: nil
State: Postgrex.Protocol

16:59:22.347 [error] GenServer #PID<0.292.0> terminating
** (DBConnection.ConnectionError) tcp connect (db:5432): connection refused - :econnrefused
    (db_connection 2.4.0) lib/db_connection/connection.ex:100: DBConnection.Connection.connect/2
    (connection 1.1.0) lib/connection.ex:622: Connection.enter_connect/5
    (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: nil
State: Postgrex.Protocol
** (Mix) The database for CoreBankApi.Repo couldn't be created: killed
```

Neste caso, o problema ocorreu por que após o `docker-compose build` o container do postgres ficou em pé (up). Rode os seguintes comandos:

1. Liste os containers `docker ps -a`
2. Verifique o ID e pare o container (os três caracteres iniciais já são suficientes) `docker stop 5b0`

Nenhum container em pé? Então pode seguir com a criação e migração do banco. =)
