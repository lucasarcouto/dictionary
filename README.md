# Dictionary

## Introdução

Nesse projeto, foi implementado um aplicativo que funciona como um dicionário. Após o login, usuários verão uma lista de palavras e, ao tocar em uma delas, detalhes sobre ela são exibidos, como fonética, definições e exemplos, além da opção de ouvir como essa palavra é falada.

Após uma palavra ser aberta, ela é adicionada ao histórico de palavras vistas do usuário. Ainda na tela de detalhes, usuário podem adicionar ou remover uma palavra dos seus favoritos.

Este projeto foi desenvolvido utilizando Flutter e com a aplicação de conceitos como Clean Architecture, Clean Code, DRY e BLoC.

### Configurações
 
Antes de seja possível rodar este projeto na sua máquina, é necessário criar uma conta do Firebase e configurar os componentes a seguir:

1. Cloud Firestore - a configuração padrão que eles sugerem deve ser o suficiente, a única sugestão seria escolher o servidor mais próximo possível de onde você se encontra para diminuir o tempo de resposta.
2. Authentication - para esse projeto, vamos utilizar apenas login com email e senha, então garanta que esse método está ativo.
3. Cloud Functions - Nós vamos utilizar uma função para acessar a WordsAPI, portanto basta seguir as instruções [deste link](https://firebase.google.com/docs/functions/get-started?gen=1st) para inicializar a função.
  * Após a função ter iniciado, abre um terminal e navegue até a pasta functions do projeto e instale o pacote Axios. Para isso, basta rodar ```npm install axios```.
  * Agora, precisamos atualizar o código do arquivo index.ts com o código que você encontra [aqui](https://github.com/lucasarcouto/dictionary/blob/main/functions/index.ts).

Agora que tudo está configurado, precisamos criar os aplicativos que vamos precisar dentro do Firebase (durante o desenvolvimento, foram utilizados apenas Android e iOS). O único dado que é de extrema importância que esteja correto, é o package - ele precisa ser igual ao do nosso projeto. Nesse caso, o package escolhido foi dev.lucascouto.dictionary.

Durante a criação dos aplicativos, basta seguir as instruções e adicionar os arquivos nas pastas indicadas. Para o iOS, é melhor fazer isso através do Xcode, pois fazer isso por outro meio, pode gerar alguns problemas na hora de compilar o código para essa plataforma.

Agora que todo nosso backend está configurado, podemos configurar o nosso projeto para rodar localmente. Caso você não tenha Flutter instalado na sua máquina, basta seguir as instruções [deste link](https://docs.flutter.dev/get-started/install) para configurar o seu ambiente.

Com o seu ambiente configurado, basta baixar o projeto e rodar ele no seu editor.

### Tecnologias utilizadas

- Frontend
  - Flutter
  - BLoC (flutter_bloc)
  - Hooks (flutter_hooks)
  - Dependency Injection (get_it)
  - Functional programming (dartz and equatable)
  - Text-to-speech (flutter_tts)
  - HTTP Networking (dio)
  - Database (cache local - drift)
  - Unit testing (mocktail, bloc_test, fake_cloud_firestore)
  - Integration testing (integration_test)

- Backend
  - Firebase
    - Cloud Firestore
    - Cloud Functions
    - Authentication

## Importante

>  This is a challenge by [Coodesh](https://coodesh.com/)