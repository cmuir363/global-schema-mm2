resource "aiven_service_integration_endpoint" "kafka-project-2" {
    endpoint_name = "inter-project-kafka-endpoint"
    project = var.aiven_project
    endpoint_type = "external_kafka"
    
    external_kafka_user_config {
      bootstrap_servers = aiven_kafka.kafka-service-project-2.service_host
      security_protocol = "SASL_SSL"

      sasl_mechanism = "PLAIN"
      sasl_plain_username = aiven_kafka.kafka-service-project-2.service_username
      sasl_plain_password = aiven_kafka.kafka-service-project-2.service_password
      ssl_endpoint_identification_algorithm = "https"
    }
}

resource "aiven_service_integration" "external_kafka_schema" {
    project = var.aiven_project
    integration_type = "kafka_mirrormaker"
    destination_service_name = aiven_kafka_mirrormaker.mm.service_name
    source_endpoint_id = aiven_service_integration_endpoint.kafka-project-2.id
    kafka_mirrormaker_user_config {
      cluster_alias = "external-cluster-schema-registry"
    }
}

resource "aiven_mirrormaker_replication_flow" "external_f1" {
  project        = var.aiven_project
  service_name   = aiven_kafka_mirrormaker.mm.service_name
  source_cluster = aiven_kafka.kafka-service-region-1.service_name
  target_cluster = "external-cluster-schema-registry"
  enable         = true
  replication_policy_class = "org.apache.kafka.connect.mirror.IdentityReplicationPolicy"

  topics = [
    ".*",
  ]
}