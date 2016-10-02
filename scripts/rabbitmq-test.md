### RabbitMQ

- Start `invoke-rc.d rabbitmq-server start`
- Stop `invoke-rc.d rabbitmq-server stop`
- Stop `rabbitmqctl stop`
- Status `rabbitmqctl status`

Admin

- Enable `rabbitmq-plugins enable rabbitmq_management`
- URL: http://localhost:15672/
    - guest/guest

## CLI

Create vhost and add user
```
rabbitmqctl add_vhost test
rabbitmqctl set_permissions -p test USER ".*" ".*" ".*"
```

> Append ` -u USER -p PASSWORD`

View Exchanges
```
rabbitmqadmin -V test list exchanges
```

List Queues
```
rabbitmqadmin list queues vhost name node messages message_stats.publish_details.rate #few params
rabbitmqadmin -f long -d 3 list queues # all info
```

List bindings
```
rabbitmqadmin list bindings
```

Declare RabbitMQ exchange:
```
rabbitmqadmin declare exchange name=testx type=direct durable=false --vhost test
```
Delcare RabbitMQ queue:
```
rabbitmqadmin declare queue name=testq durable=false --vhost test
```
Declare RabbityMQ binding for queue:
```
rabbitmqadmin declare binding source=testx destination_type=queue destination=testq routing_key=testq --vhost test
```

Publish sample message:
```
rabbitmqadmin publish exchange=testx routing_key=testq payload='{"data":[{"id": -1, "updated":1412635905099}]}' --vhost test
```
Get message off queue:
```
rabbitmqadmin get queue=testq requeue=false count=10 --vhost test
```
Peek at messages queue:
```
rabbitmqadmin get queue=testq requeue=true count=10 --vhost test
```
