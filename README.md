# Todo list exercise

## Prerequisites 

- [nodejs](https://nodejs.org/en/)
> - [docker](https://docs.docker.com/) and [docker-compose](https://docs.docker.com/compose/)
> - [helm](https://helm.sh/) and [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

## Install

```sh
git clone https://github.com/thobalose/todo-list-app.git ; cd todo-list-app/
```

```sh
npm install
```

## Run

```sh
node app.js
```

Visit http://localhost:8080 in your browser

## Test

To run tests

```sh
npm test
```

## Docker

To build a docker image for the todo-list-app and run it inside a container execute

```sh
docker build -t thoba/todo-list-app .
```

The above with create an image with the `latest` tag. To run the container execute

```sh
docker run -it -p 8080:8080 --name todo_list_app thoba/todo-list-app
```

You can also use `docker-compose` if you have it installed. To build and run the latest source using `docker-compose` execute

```sh
docker-compose up --build -d
```

and visit http://localhost:8080 in your browser

## Helm chart

To deploy the application to Minikube kindly see [`todo-list-chart/`](./todo-list-chart/).

## Requirements

### High level application requirements

1. Multiple users should be able to view the shared public todo list
2. Should be able to add items
3. Should be able to delete items
4. Should be able to edit items (Missing feature)
5. Must be able to deploy in docker (Missing feature)

### Tasks

1. Add missing requirement #4 to the application
2. Add sufficient test coverage to the application and update readme on how to run the tests
3. Add missing requirement #5 to the application (Dockerfile and update readme with instructions)

### Bonus

4. Display test coverage after tests are executed
5. Find and fix the XSS vulnerability in the application. Also make sure that it wont happen again by including a test.

### Optional extra

 6. Add a Helm chart for the application that is deployable on Minikube along with the required readme entry.

> ### Notes
> - Update the code as needed and document what you have done in the readme below
> - Will be nice if you can git tag the tasks by number

### Solution

- Added `edittodo.ejs` page to allow for editing of todo.
- Used `method-override` middleware in order to use `PUT` HTTP verb to edit item.
- Used `docker` and `docker-compose` to containerized deployment.
- Used `mocha`, `chai`, and `supertest` for testing.
- Used [`istanbul`](https://istanbul.js.org/) to display test coverage.
- Used `sanitizer` module to mitigate the XSS vulnerability.
- Added Helm Chart.
