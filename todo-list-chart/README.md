# Todo-list Chart

A Helm chart for the todo-list-app

## Installing the Chart

To install the chart:

```sh
helm install --name todo-list-app .
```

> If you are in the todo-list-chart DIR use `.`, otherwise provide chart DIR.

## Chart status

After installation succeeds, you can get a status of Chart

```sh
helm status todo-list-app
```

## Deleting the Chart

If you want to delete your Chart, use this command:

```sh
helm delete --purge todo-list-app
```
