# Kafka service region 1
resource "aiven_kafka" "kafka-service-region-1" {
  project                 = var.aiven_project
  cloud_name              = "google-europe-west1"
  plan                    = "startup-2"
  service_name            = "kafka-region-1"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"

  kafka_user_config {
    // Enables Kafka Schemas
    schema_registry = true
    kafka {
      group_max_session_timeout_ms = 70000
      log_retention_bytes          = 1000000000
    }
  }
}

# Kafka service region 2
resource "aiven_kafka" "kafka-service-region-2" {
  project                 = var.aiven_project
  cloud_name              = "google-europe-west3"
  plan                    = "startup-2"
  service_name            = "kafka-region-2"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"

  kafka_user_config {
    // Enables Kafka Schemas
    schema_registry = true
    kafka {
      group_max_session_timeout_ms = 70000
      log_retention_bytes          = 1000000000
    }
  }
}

# Kafka service in another project
resource "aiven_kafka" "kafka-service-project-2" {
  project                 = var.aiven_project_region
  cloud_name              = "google-europe-west3"
  plan                    = "startup-2"
  service_name            = "kafka-region-2"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"

  kafka_user_config {
    // Enables Kafka Schemas
    schema_registry = true
    kafka_authentication_methods {
      sasl = true
    }
    kafka {
      group_max_session_timeout_ms = 70000
      log_retention_bytes          = 1000000000
    }
  }
}


# Kafka topic
resource "aiven_kafka_topic" "topic-a" {
  project      = var.aiven_project
  service_name = aiven_kafka.kafka-service-region-1.service_name
  topic_name   = "topic-a"
  partitions   = 3
  replication  = 2
}