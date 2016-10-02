
$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
$KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test
$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper localhost:2181

$KAFKA_HOME/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
$KAFKA_HOME/bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
