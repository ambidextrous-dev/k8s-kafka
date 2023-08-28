# cs-kafka
This repo deploys a mTLS enabled kafka cluster on a kubernetes cluster. The kafka cluster consists of zookeeper, kafka brokers, schema registry, and kafka connect

## Steps
1) Generate required certificates, keystores and truststores

2) The following kubernetes secrets should be present in the namespace before running the deployment

    i) **kafka-tls**
        - contains a truststore (kafka.truststore.jks) and a keystore (kafka.keystore.jks) for the kafka brokers

    ii) **kafka-schema-registry-ssl**
        - contains a truststore (kafka.truststore.jks) and a keystore (kafka.schema-registry.client.keystore.jks) for the kafka schema registry

    iii) **kafka-connect-ssl**
        - contains a truststore (kafka.truststore.jks) and a keystore (kafka-connect.keystore.jks) for the kafka connect

3) Run the jenkins pipeline cs-kafka to deploy the cluster in the required kubernetes cluster

