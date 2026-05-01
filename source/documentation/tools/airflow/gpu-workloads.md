# GPU Enabled Workloads

> This feature is currently experimental

The Analytical Platform has made NVIDIA GPUs available for use on the new compute clusters

We offer AWS' [G5 instance family](https://aws.amazon.com/ec2/instance-types/g5/) which comes with up to 8 [NVIDIA A10G](https://d1.awsstatic.com/product-marketing/ec2/NVIDIA_AWS_A10G_DataSheet_FINAL_02_17_2022.pdf) GPUs

You will need to do the following to use a GPU:

1. Ensure your DAG has been migrated ([migration guidance](/tools/airflow/migration.html))

1. Add the compute profile code to your DAG

    ```python
    from imports.analytical_platform_compute_profiles import get_compute_profile

    compute_profile = get_compute_profile(compute_profile="gpu-spot-4vcpu-16gb")
    ```
    
    ```python
    task = KubernetesPodOperator (
        ...
        tolerations=compute_profile["tolerations"],
        affinity=compute_profile["affinity"],
        container_resources=compute_profile["container_resources"],
        security_context=compute_profile["security_context"]
        ...
    )
    ```

    An example of this is available [here](https://github.com/moj-analytical-services/airflow/blob/main/environments/dev/dags/examples/use_kubernetes_pod_operators_gpu.py)

1. Switch your Airflow container to use Analytical Platform's new [Python base image](https://github.com/ministryofjustice/analytical-platform-airflow-python-base)

    ```Dockerfile
    FROM ghcr.io/ministryofjustice/analytical-platform-airflow-python-base:1.0.0
    ```

    An example of this is available [here](https://github.com/moj-analytical-services/airflow-python-base-image-development)
