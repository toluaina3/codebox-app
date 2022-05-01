# shellcheck disable=SC2046
db_connection=$(pg_isready -d $(DB_NAME)  -h $(DB_HOST) -p 5432 -U $(DB_USERNAME))
db_status=$?

echo $db_status

if [[ $db_status -eq 0 ]]
  then
    $(mix ecto.migrate)
    echo "Successful migration to dev db"
  else
    echo "can not establish connection to db"
    exit 1
fi
