# shellcheck disable=SC2046
db_connection=$(pg_isready -d ${DB_NAME}  -h ${DB_HOST} -p 5432 -U ${DB_USERNAME})
status=$?

echo $status

if [[ $db_status -eq 0 ]];
  then
    (ls; . $HOME/.asdf/asdf.sh; . $HOME/.asdf/completions/asdf.bash; mix local.hex --force && mix local.rebar --force; mix deps.get --only dev; mix ecto.migrate)
    if [[ $status = 0 ]]
    then
      echo "Successful migration to dev db"
    else
      echo "Could not perform operation"
    fi
  else
    echo "can not establish connection to db"
 fi

