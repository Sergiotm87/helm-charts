# DJango

## Configuration and installation details

### create credentials secret

example file:
```txt
pghost=51.15.51.15
pgport=5432
pgdbname=myapp
pgpassword=password
pgusername=username
```

generate a secret in default namespace named 'postgres-pgcred'
```shell
kubectl create secret generic postgres-pgcred --from-env-file=./pgcredentials
```

set created secret in values.yaml

```yaml
postgresql:
  enabled: false # use remote postgres host
  credentials:
    create: false
    name: postgres-pgcred
    
```