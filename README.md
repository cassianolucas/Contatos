
# Bem vindo, futuro Dragon Maker
Se você chegou até aqui, é porque identificamos em você o potencial para que venha a fazer parte
do nosso time de desenvolvimento. Parabéns!

O Teste
Queremos que nos mostre suas habilidades de desenvolvimento através da entrega de um sistema
de cadastro de contatos simples com endereço integrado ao Via Cep e Google Maps.


## Requisitos

[Requisitos](https://link-da-documentação)

Para entregar este desafio você precisa:
- Ter conhecimento em linguagem DART utilizando SDK Flutter
- Saber como funcionam APIs REST/RESTFul
- Saber utilizar LocalStorage ou SharedPreferences ou Sqlite
- Conhecimento em versionamento de código com GIT.


## Escopo de negócio

Vamos desenvolver uma aplicação Flutter para gerenciamento de lista de contatos.

Nesta aplicação o usuário pode:
- Se cadastrar para utilizar a plataforma.
- Realizar login e logout.
- Gerenciar sua lista de contatos.
- Realizar pesquisa de endereço como ajuda ao cadastro de contatos.
- Excluir a sua própria conta.

## Jornada do usuário

O usuário acessa a plataforma, realiza seu cadastro e em seguida faz seu login.
Assim que estiver dentro do sistema, os dados dos contatos previamente cadastrados são exibidos
na tela e então o usuário realiza o cadastro de um ou mais contatos utilizando um formulário
contendo os campos necessários para o cadastro.
A plataforma possui um sistema de ajuda para o preenchimento do endereço do contato, onde o
usuário pode informar alguns dados tais como, UF, cidade e um trecho do endereço e esse sistema
de ajuda apresenta então as possibilidades de endereço baseado na pesquisa, dessa forma o
usuário escolhe na lista qual o endereço lhe convém e tem os campos do formulário
correspondente preenchidos automaticamente.
Quando o usuário quer localizar um contato na lista, ele utiliza um filtro de texto que traz apenas os
contatos que contém o nome ou CPF equivalente ao termo pesquisado.
Sempre que o usuário clica no contato da lista, o mapa deve centralizar e marcar com um “pin” a
coordenada geográfica obtida através do cadastro.
O usuário pode realizar a exclusão e a edição dos dados dos contatos a qualquer momento.
Se desejar, o usuário pode remover a sua própria conta, o que faz com que todos os dados
cadastrados pelo mesmo sejam removidos da base de dados local da aplicação.

## Escopo técnico

Esta é uma aplicação onde o frontend possui uma base de dados local para armazenar todos os
dados dos usuários e seus respectivos contatos.

Como desenvolvedor Flutter queremos que você implemente um conjunto de interfaces e
funcionalidades para suprir todas as necessidades de funcionamento do sistema.

Sign In, Sign up e Autenticação

● Permitir que o usuário se cadastre no sistema
    ○ É permitido um usuário por e-mail cadastrado
● Autenticação padrão com login e senha.
    ○ Não é necessário validar a complexidade da senha.

● Autorização.
A lista de contatos não pode estar acessível aos usuários sem que os mesmos tenham efetuado
login.

Cadastro de contatos
O Formulário deve apresentar mensagens de feedback ao usuário e respeitar as regras de
validação.
- CPF deve ser validado segundo o algoritmo de validação oficial
- Dica: Você pode importar um pacote para isso
- Não é permitido CPF duplicado na base (por usuário).
- Apenas o complemento do endereço pode ser omitido no cadastro.

Lista de Contatos
A lista deve permitir pelo menos filtro por CPF ou nome do contato e deve ser ordenada por padrão
em ordem alfabética crescente, mas o usuário pode reordenar a lista a qualquer momento.

Exclusão de conta
O usuário deve informar a sua senha para excluir a conta e caso a senha seja inválida o sistema
deve recusar a exclusão.
## Deploy

Projeto criado para ambiente Android, levar em consideração a resolução mínima de 1366x768 para testes em emulador.


## Integração Via CEP

É obrigatório a implementação de um sistema de ajuda ao cadastro de contatos que consuma a
API Via Cep.
Você pode implementar um widget dedicado a realizar consultas e entregar endereços obtidos de
lá!
## Integração Google Maps.

Deve ser utilizado para obter a latitude e longitude do endereço do contato quando o cadastro é
realizado.