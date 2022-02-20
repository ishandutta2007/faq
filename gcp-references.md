#### GCP references

Testing:

 * https://cloud.google.com/architecture/distributed-load-testing-using-gke
 * https://dzone.com/articles/performance-testing-in-kubernetes
 * https://www.cockroachlabs.com/blog/benchmark-google-cloud/
   * https://www.cockroachlabs.com/blog/2021-cloud-report/
   * https://www.cockroachlabs.com/guides/2021-cloud-report/
   * https://content.cdntwrk.com/files/aT0xMzI3NDk4JnY9NiZpc3N1ZU5hbWU9MjAyMS1jbG91ZC1yZXBvcnQtY29ja3JvYWNoLWxhYnMmY21kPWQmc2lnPTVkMjcyYWNlNjY1YmVkOTMzODM5MmFhZGMwYzFlMzFi
 * https://www.cigniti.com/blog/strategy-for-the-performance-testing-in-cloud/

Differenes:

 * https://www.geeksforgeeks.org/difference-between-cloud-and-data-center/
 * https://www.educba.com/cloud-vs-data-center/

Monitoring:

 * Metrics basic info
   * https://cloud.google.com/monitoring/api/metrics

   Issues:
   * documentation is not up to date, e.g.
     * pubsub.googleapis.com/topic/message_sizes_bucket
     * pubsub.googleapis.com/topic/message_sizes_count
     * pubsub.googleapis.com/topic/message_sizes_mean

   API:
   * https://monitoring.googleapis.com/$discovery/rest?version=v1 : manages your Cloud Monitoring data and configurations. Most projects must be associated with a Workspace, with a few exceptions as noted on the individual method pages
   * https://monitoring.googleapis.com/$discovery/rest?version=v3
     * documentation: https://cloud.google.com/monitoring/api/
     * endpoint: https://monitoring.googleapis.com/v3
   * using MQL query:
     * https://cloud.google.com/monitoring/mql/qn-from-api
     * https://cloud.google.com/monitoring/mql/query-language

 * JVM  metrics:

   References:
   * https://github.com/micrometer-metrics/micrometer/tree/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm
   * https://micronaut-projects.github.io/micronaut-micrometer/1.2.0.RC2/guide/index.html
   * https://docs.spring.io/spring-boot/docs/current-SNAPSHOT/actuator-api/pdf/spring-boot-actuator-web-api.pdf 

 * OS metrics:

   References:
   * https://cloud.google.com/monitoring/api/metrics_opsagent
   * user need to pay for them (except the agent.googleapis.com/agent/ group)

 * PubSub:

   To capture:
     * number of undelivered messages (dead_letter_message_count vs send_message_operation_count)
     * number of errored messages
     * number of messages sent/received
     * usage (quota/rate/net_usage vs quota/limit)

   References:
     * https://cloud.google.com/pubsub/docs/monitoring#metrics_and_resource_types
     * https://cloud.google.com/monitoring/api/metrics_gcp#gcp-pubsub

   Extras:

   The difference between "operation_count" and "request_count" is due to the fact that both pull and ack allows for batching,
   i.e., a pull response can return multiple messages and an ack request can contain the IDs of multiple messages to ack.
   For pull, subscription/pull_request_count would be the number of pull requests you make.
   subscription/pull_ack_message_operation_count would be the number of messages returned to you in responses to pull requests.
   Similarly, subscription/pull_ack_request_count would be the number of calls you make to ack.
   subscription/pull_ack_message_operation_count would be the number of messages acked via ack requests.

 * BigQuery:

   To capture:
     * job/num_in_flight : number of jobs
     * query/count : nuber of queries
     * query/execution_times : timing for sucessful queries

   References:
   * https://cloud.google.com/monitoring/api/metrics_gcp#gcp-bigquery

 * DataFlow:

   To capture:
     * elements per sec
     * CPU usage
     * requests per sec
     * response errors per sec

   References:
     * https://cloud.google.com/dataflow/docs/guides/using-monitoring-intf
     * https://cloud.google.com/dataflow/docs/guides/using-cloud-monitoring

   Guides:
     * https://docs.newrelic.com/docs/infrastructure/google-cloud-platform-integrations/gcp-integrations-list/google-cloud-dataflow-monitoring-integration/
     * https://medium.com/google-cloud/monitoring-your-dataflow-pipelines-80b9a2849f7a

 * Spanner:

   To capture:

   References:
     * https://cloud.google.com/spanner/docs/monitoring-cloud

   Guides:
     * https://medium.com/google-cloud/cloud-spanner-read-statistics-71693d718131

 * Kubernates:

   To capture:

   References:
     * https://cloud.google.com/monitoring/api/metrics_kubernetes
 
 * K8 metric server - can be used for monitoring Kubernates CPU & memory

   To capture:

   References:
     * https://github.com/kubernetes-sigs/metrics-server
     * API: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/resource-metrics-api.md
     * FAQ: https://github.com/kubernetes-sigs/metrics-server/blob/master/FAQ.md

 * infrastructure summary

   To capture:
     * number of instances active

 * docker

   References:
     * https://docs.docker.com/config/containers/runmetrics/
