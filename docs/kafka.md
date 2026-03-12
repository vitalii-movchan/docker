# Docker composer

scfi-kafka:
    image: bitnami/kafka:4.0
    container_name: scfi-kafka
    <<: [*restart_policy, *networks]
    ports:
        - "${DOCKER_BIND_KAFKA:-9092}:9092"
    environment:
        KAFKA_CFG_NODE_ID: 0
        KAFKA_CFG_PROCESS_ROLES: "controller,broker"
        KAFKA_CFG_CONTROLLER_QUORUM_VOTERS: "0@scfi-kafka:9093"
        KAFKA_CFG_LISTENERS: "CLIENT://:9092,CONTROLLER://:9093,INTERNAL://:9094"
        KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP: "CLIENT:SASL_PLAINTEXT,CONTROLLER:SASL_PLAINTEXT,INTERNAL:SASL_PLAINTEXT"
        KAFKA_CFG_CONTROLLER_LISTENER_NAMES: "CONTROLLER"
        KAFKA_CFG_INTER_BROKER_LISTENER_NAME: "INTERNAL"
        KAFKA_CFG_SASL_MECHANISM_CONTROLLER_PROTOCOL: "PLAIN"
        KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL: "PLAIN"
        KAFKA_CLIENT_USERS: "${KAFKA_USERNAME}"
        KAFKA_CLIENT_PASSWORDS: "${KAFKA_PASSWORD}"
    volumes:
        - kafka:/bitnami/kafka

# Wiki

# https://www.jetbrains.com/help/idea/2023.2/big-data-tools-kafka.html#consume-messages
# https://hub.docker.com/r/bitnami/kafka
# https://habr.com/ru/articles/810061/

# KAFKA_CFG_ADVERTISED_LISTENERS: "INTERNAL://:9094,CLIENT://127.20.0.1:9092"
# KAFKA_CFG_ADVERTISED_LISTENERS: "INTERNAL://:9094,CLIENT://${DOCKER_BIND_KAFKA:-:9092}"