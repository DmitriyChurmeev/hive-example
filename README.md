
Для начала необходимо развернуть hdfs и hive 
например:

git clone https://github.com/big-data-europe/docker-hive.git
cd docker-hive
docker-compose up -d


Позже загоузить тестовые данные в контейнер и область hdfs

docker cp "../jobs_in_data.csv" docker-hive-hive-server-1:/opt
dfs -put -f /opt/jobs_in_data.csv /user/hive;


после можно подключиться по jdbc:hive2://localhost:10000 к bd hive и выполнить script.sql из репозитория