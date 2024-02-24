# sre-app

Commands that need to run to execute and validate

NAMESPACE=stord

helm install sre-db oci://registry-1.docker.io/bitnamicharts/postgresql \
  --create-namespace \
  --namespace $NAMESPACE \
  --set auth.database=sre-technical-challenge \
  --set auth.postgresPassword=password \
  --set volumePermissions.enabled=true \
  --set primary.persistence.size=2Gi

Please ensure Postgress is up and password is working as i was seeing issues with the latest postgres image
Run this commands to ensue Postgress is installed and working correctly 

export POSTGRES_PASSWORD=$(kubectl get secret --namespace stord sre-db-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

To connect to your database run the following command:

kubectl run sre-db-postgresql-client --rm --tty -i --restart='Never' --namespace stord --image docker.io/bitnami/postgresql:16.2.0-debian-12-r5 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host sre-db-postgresql -U postgres -d sre-technical-challenge -p 5432

Once Postgress is up you can run:

helm install sre-app . \
  --debug \
  --namespace $NAMESPACE \
  --values values.yaml

For validating web server is running:

kubectl port-forward svc/sre-app-sre-technical-challenge 8080:80
and test curl http://localhost:8080/

FOr DB migration validation:

kubectl port-forward svc/sre-db-postgresql 55432:5432
psql postgresql://postgres:password@127.0.0.1:55432/sre-technical-challenge
