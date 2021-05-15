#### Prometheus

##### Querying

Http, curl based query

    prometheusUrl='https://prometheus.my.domain.com'
    query='sum(rate(container_network_transmit_bytes_total{namespace=~"my-app", pod_name=~"my-app-pod.*"}[3600s]))/1024'
    
    http_proxy='' curl ${prometheusUrl}/api/v1/query \
     --insecure \
     --data-urlencode "query=$query"

Http, browser based query

    https://prometheus.my.domain.com/api/v1/query?query=sum(rate(container_network_transmit_bytes_total{namespace=~"my-app", pod_name=~"my-app.*"}[3600s]))/1024
    https://prometheus.my.domain.com/api/v1/query?query=sum(rate(container_network_transmit_bytes_total{namespace=~%22my-app%22,%20pod_name=~%22my-app.*%22}[3600s]))/1024


##### Metrics

Metric name | Type | Description | Unit (where applicable)
------------|------|-------------|------------------------
container_accelerator_duty_cycle | Gauge | Percent of time over the past sample period during which the accelerator was actively processing | percentage
container_accelerator_memory_total_bytes | Gauge | Total accelerator memory | bytes
container_accelerator_memory_used_bytes | Gauge | Total accelerator memory allocated | bytes
container_cpu_cfs_periods_total | Counter | Number of elapsed enforcement period intervals |
container_cpu_cfs_throttled_periods_total | Counter | Number of throttled period intervals |
container_cpu_cfs_throttled_seconds_total | Counter | Total time duration the container has been throttled | seconds
container_cpu_load_average_10s | Gauge | Value of container cpu load average over the last 10 seconds |
container_cpu_schedstat_run_periods_total | Counter | Number of times processes of the cgroup have run on the cpu |
container_cpu_schedstat_run_seconds_total | Counter | Time duration the processes of the container have run on the CPU | seconds
container_cpu_schedstat_runqueue_seconds_total | Counter | Time duration processes of the container have been waiting on a runqueue | seconds
container_cpu_system_seconds_total | Counter | Cumulative system cpu time consumed | seconds
container_cpu_usage_seconds_total | Counter | Cumulative cpu time consumed | seconds
container_cpu_user_seconds_total | Counter | Cumulative user cpu time consumed | seconds
container_file_descriptors | Gauge | Number of open file descriptors for the container |
container_fs_inodes_free | Gauge | Number of available Inodes |
container_fs_inodes_total | Gauge | Total number of Inodes |
container_fs_io_current | Gauge | Number of I/Os currently in progress |
container_fs_io_time_seconds_total | Counter | Cumulative count of seconds spent doing I/Os | seconds
container_fs_io_time_weighted_seconds_total | Counter | Cumulative weighted I/O time | seconds
container_fs_limit_bytes | Gauge | Number of bytes that can be consumed by the container on this filesystem | bytes
container_fs_reads_bytes_total | Counter | Cumulative count of bytes read | bytes
container_fs_reads_total | Counter | Cumulative count of reads completed |
container_fs_read_seconds_total | Counter | Cumulative count of seconds spent reading |
container_fs_reads_merged_total | Counter | Cumulative count of reads merged
container_fs_sector_reads_total | Counter | Cumulative count of sector reads completed
container_fs_sector_writes_total | Counter | Cumulative count of sector writes completed
container_fs_usage_bytes | Gauge | Number of bytes that are consumed by the container on this filesystem | bytes
container_fs_write_seconds_total | Counter | Cumulative count of seconds spent writing | seconds
container_fs_writes_bytes_total | Counter | Cumulative count of bytes written | bytes
container_fs_writes_merged_total | Counter | Cumulative count of writes merged |
container_fs_writes_total | Counter | Cumulative count of writes completed |
container_last_seen | Gauge | Last time a container was seen by the exporter | timestamp
container_memory_cache | Gauge | Total page cache memory | bytes
container_memory_failcnt | Counter | Number of memory usage hits limits |
container_memory_failures_total | Counter | Cumulative count of memory allocation failures |
container_memory_max_usage_bytes | Gauge | Maximum memory usage recorded | bytes
container_memory_rss | Gauge | Size of RSS | bytes
container_memory_swap | Gauge | Container swap usage | bytes
container_memory_mapped_file | Gauge | Size of memory mapped files | bytes
container_memory_usage_bytes | Gauge | Current memory usage, including all memory regardless of when it was accessed | bytes
container_memory_working_set_bytes | Gauge | Current working set | bytes
container_network_receive_bytes_total | Counter | Cumulative count of bytes received | bytes
container_network_receive_packets_dropped_total | Counter | Cumulative count of packets dropped while receiving |
container_network_receive_packets_total | Counter | Cumulative count of packets received |
container_network_receive_errors_total | Counter | Cumulative count of errors encountered while receiving |
container_network_transmit_bytes_total | Counter | Cumulative count of bytes transmitted | bytes
container_network_transmit_packets_total | Counter | Cumulative count of packets transmitted |
container_network_transmit_packets_dropped_total | Counter | Cumulative count of packets dropped while transmitting |
container_network_transmit_errors_total | Counter | Cumulative count of errors encountered while transmitting |
container_network_tcp_usage_total | Gauge | tcp connection usage statistic for container |
container_network_tcp6_usage_total | Gauge | tcp6 connection usage statistic for container |
container_network_udp_usage_total | Gauge | udp connection usage statistic for container |
container_network_udp6_usage_total | Gauge | udp6 connection usage statistic for container |
container_processes | Gauge | Number of processes running inside the container |
container_spec_cpu_period | Gauge | CPU period of the container |
container_spec_cpu_quota | Gauge | CPU quota of the container |
container_spec_cpu_shares | Gauge | CPU share of the container |
container_spec_memory_limit_bytes | Gauge | Memory limit for the container | bytes
container_spec_memory_swap_limit_bytes | Gauge | Memory swap limit for the container | bytes
container_spec_memory_reservation_limit_bytes | Gauge | Memory reservation limit for the container | bytes
container_start_time_seconds | Gauge | Start time of the container since unix epoch | seconds
container_tasks_state | Gauge | Number of tasks in given state (`sleeping`, `running`, `stopped`, `uninterruptible`, or `ioawaiting`) |
