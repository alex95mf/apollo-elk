// Add this to the very top of the first file loaded in your app
var apm = require('elastic-apm-node').start({
    serviceName: 'my-service-name',
    secretToken: '',
    serverUrl: 'http://localhost:8200',
    environment: 'my-environment'
});

import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

const PUERTO = 4000;

// Un esquema es una colección de definiciones de tipos (por eso "typeDefs")
// que juntas definen la "forma" de las consultas que se ejecutan contra
// los datos.
const typeDefs = `#graphql
  # Los comentarios en cadenas de GraphQL (como este) comienzan con el símbolo hash (#).

  # Este tipo "Book" define los campos consultables para cada libro en nuestra fuente de datos.
  type Book {
    title: String
    author: String
  }

  # El tipo "Query" es especial: lista todas las consultas disponibles que
  # los clientes pueden ejecutar, junto con el tipo de retorno para cada una. En este
  # caso, la consulta "books" devuelve una matriz de cero o más Books (definidos arriba).
  type Query {
    books: [Book]
  }
`;

const books = [
    {
        title: 'The Awakening',
        author: 'Kate Chopin',
    }, {
        title: 'City of Glass',
        author: 'Paul Auster',
    },
];

// Los resolvers definen cómo recuperar los tipos definidos en el esquema.
// Este resolver recupera libros de la matriz "books" de arriba.
const resolvers = {
    Query: {
        books: () => books,
    },
};

// El constructor ApolloServer requiere dos parámetros: la definición de esquema
// y el conjunto de resolvers.
const server = new ApolloServer({
    typeDefs,
    resolvers,
});

// Pasar una instancia de ApolloServer a la función `startStandaloneServer`:
//  1. crea una aplicación Express
//  2. instala la instancia de ApolloServer como middleware
//  3. prepara la aplicación para manejar solicitudes entrantes
const { url } = await startStandaloneServer(server, {
    listen: { port: PUERTO },
});

console.log(`🚀  Servidor listo en: ${url}`);
