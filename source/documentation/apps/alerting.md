# Enabling alerting

To enable alerting on your application: 
- Navigate to your application repository
- Clone the repo down locally
- Alerts are configured in the following paths
  - `<repo_name>.github/workflows/build-push-deploy-dev.yml`
  - `<repo_name>.github/workflows/build-push-deploy-prod.yml`
- Add this syntax in the helm upgrade section of the required workflow(s) `--set Alerts.enabled=true`
- Merge your pr, alerts will then be enabled

You can find the current configured alerts below once enabled all these alerts will become active provided you have the required resources to alert on.

## Alert config
------------
| config          | default                                      | description     |
| --------------- | -------------------------------------------- | --------------- |
| Alerts.enabled  | `false`                                      | enable alerting |
| Alerts.severity | `data-platform-application-migration-alerts` | severity label, used by CloudPlatform for sending Alerts to specific pager duty services |
| Alerts.cpuUsage | `"60"` | Trigger alert if Pod CPU % exceeds this level |
| Alerts.memoryUsage | `"80"` | Trigger alert if Pod memory exceeds the specified value of the resource limit (%) |
| Alerts.pvcUsage | `"90"` | Trigger alert if PVC storage exceeds the specified value (%) |

## Current configured alerts

  - `5xxingress` - The ingress for the namespace is returning a high average of 500 error codes over a 1 minute period.
  - `OOMKiller` - Pod killed due to OOM issues
  - `TooManyContainerRestarts` - pod container(s) are restarting too many times, exceeding 20 restarts (indicative of app crashing over and over again) 
  - `CrashLoopBackOff` - Container has entered into a crashloop backoff state.
  - `PodNotReadyKube` - Pod stuck in Pending|Unknown state
  - `WebappRestartAlert` - The webapp has restarted
  - `AuthProxyRestartAlert` - The Auth Proxy has restarted
  - `CpuUsageHigh` - The Pod CPU usage has exceeded the specified percentage
  - `MemUsageHigh` - The Pod Memory usage has exceeded the specified percentage
  - `HighPersistantVolumeUsage` - PVC storage has exceeded limit

  If you require any alerts not listed please send a feature request to our [support channel](https://github.com/ministryofjustice/data-platform-support)

