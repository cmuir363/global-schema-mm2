resource "aiven_kafka_mirrormaker" "mm" {
  project      = var.aiven_project
  cloud_name   = "google-europe-west1"
  plan         = "startup-4"
  service_name = "mm"

  kafka_mirrormaker_user_config {
    ip_filter = [
      "0.0.0.0/0"
    ]

    kafka_mirrormaker {
      refresh_groups_interval_seconds = 10
      refresh_topics_enabled          = true
      refresh_topics_interval_seconds = 10
    }
  }
}

resource "aiven_service_integration" "mm_region_1" {
  project                  = var.aiven_project
  integration_type         = "kafka_mirrormaker"
  source_service_name      = aiven_kafka.kafka-service-region-1.service_name
  destination_service_name = aiven_kafka_mirrormaker.mm.service_name

  kafka_mirrormaker_user_config {
    cluster_alias = "region-1"
  }
}

resource "aiven_service_integration" "mm_region_2" {
  project                  = var.aiven_project
  integration_type         = "kafka_mirrormaker"
  source_service_name      = aiven_kafka.kafka-service-region-2.service_name
  destination_service_name = aiven_kafka_mirrormaker.mm.service_name

  kafka_mirrormaker_user_config {
    cluster_alias = "region-2"
  }
}

resource "aiven_mirrormaker_replication_flow" "f1" {
  project        = var.aiven_project
  service_name   = aiven_kafka_mirrormaker.mm.service_name
  source_cluster = aiven_kafka.kafka-service-region-1.service_name
  target_cluster = aiven_kafka.kafka-service-region-2.service_name
  enable         = true
  replication_policy_class = "org.apache.kafka.connect.mirror.IdentityReplicationPolicy"

  topics = [
    ".*",
  ]
}