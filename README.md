# sre-app assement -https://gist.github.com/btkostner/5863e77ba006f90c6b34dc037365f840#file-readme-md

Commands that need to run to execute and validate

NAMESPACE=stord

helm install sre-db oci://registry-1.docker.io/bitnamicharts/postgresql \
  --create-namespace \
  --namespace $NAMESPACE \
  --set auth.database=sre-technical-challenge \
  --set auth.postgresPassword=password \
  --set volumePermissions.enabled=true \   
  --set primary.persistence.size=2Gi

------- Used this parameters due to disk space issues -----

 --set volumePermissions.enabled=true \   
  --set primary.persistence.size=2Gi

Make sure PersistentVolume is available for 2GB (i.e. primary.persistence.size)
if not available create using the below commnad.
----------------------------------------------------------

Please ensure Postgress is up and password is working as authentication issues were seen with the latest postgres image itself.

Run this commands to ensure Postgress is installed and authenticaion is working correctly as per its Readme..

export POSTGRES_PASSWORD=$(kubectl get secret --namespace stord sre-db-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

To connect to your database run the following command:

kubectl run sre-db-postgresql-client --rm --tty -i --restart='Never' --namespace stord --image docker.io/bitnami/postgresql:16.2.0-debian-12-r5 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host sre-db-postgresql -U postgres -d sre-technical-challenge -p 5432

During testing i found that above command was giving error intermitently, assuming some new changes may be causing problem.

Once Postgress is up you can run:
=> git clone https://github.com/playarea1980/sre-app.git
Go to sre-app folder and run following commands
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
