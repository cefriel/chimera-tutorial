# Chimera Tutorial Advanced

The `chimera-tutorial-advanced` offers an advanced example for monitoring and scalability of a converter implemented with Chimera. An alternative [Camel Context](camel-context.xml) is provided.

To run the `chimera-tutorial-advanced` you can build the Docker image using the provided Dockerfile, or use the image hosted on Docker Hub `cefriel/chimera:tutorial-advanced`.
```
docker-compose build
docker-compose up
```

## Monitoring
The `chimera-tutorial-advanced` provides an alternative Camel Context that showcases how to use the [camel-micrometer](https://camel.apache.org/components/latest/micrometer-component.html) component to expose default and custom metrics as an endpoint compliant with the [Prometheus](https://prometheus.io/) format.

The endpoint is available at `http://localhost:8888/chimera-demo/metrics` and can be easily configured with Prometheus for scraping. The endpoint exposes default metrics on the JVM and on Camel Routes and Messages. Moreover, the pipeline it's configured to expose also custom metrics: number of lift/roundtrip conversions executed (num_executions `counter`), lift/roundtrip conversion timer (processing_time `timer`), metrics on the `seda` queues enabled for the different endpoints (seda_queue_size `summary`). Each metric is tagged using a different `routeId` for the lift and roundtrip conversion endpoints.

The Micrometer registry configuration can be modified in class `MicrometerConfig`. The class `SedaMetricsProcessor` showcases how to define a custom Camel Processor and it is used in the pipeline to feed the related custom metrics.


## Advanced deployments

Advanced deployment alternatives to run a Converter made with Chimera, exemplified using the `chimera-tutorial-advanced`.

#### Running the Converter as a Service with docker-compose

You can also run a scalable converter on a Swarm (for a local single-node Swarm run `docker swarm init`)  and the _docker-compose-converter-service.yml_ file. You can provide a different config changing the  _docker-compose-converter-service.yml_ and _nginx.conf_ files.
```bash
docker-compose -f docker-compose-converter-service.yml up
```
This command exploits an Nginx server configured as a reverse proxy to enable a multi-replicas converter with Docker services load balancing (round-robin). 
To increase the number of replicas run:
```bash
docker-compose -f docker-compose-converter-service.yml up -d --scale chimera-example=3
```

#### Running the Converter on Kubernetes

If you used a different image modify the file chimera-converter.yml (exposed port, resources needed/limits, Docker image, labels, etc.), otherwise you can directly use the provided file with the  _cefriel/chimera:tutorial-advanced_ image available on Docker Hub. The file creates a Deployment using the converter image for the Pod, and a related Service.
```
kubectl apply -f chimera-converter.yml
```
If everything is fine, you can run `kubectl get pods` and `kubectl get services` to visualize the running pods. Example:
```
$ kubectl get pods
NAME                             READY   STATUS    RESTARTS   AGE
chimera-example-c6b446c8-7mbg6   1/1     Running   0          33m
```
You can try the converter locally using the node port 30042, for example:
```
POST http://localhost:30042/chimera-demo/lift/gtfs/ 
Attach the file inbox/sample-gtfs-feed.zip
```
To manually scale the Service you can run
```
$ kubectl scale --replicas=3 deployments/chimera-example
deployment.extensions/chimera-example scaled
$ kubectl get pods
NAME                             READY   STATUS              RESTARTS   AGE
chimera-example-c6b446c8-gb9rs   0/1     ContainerCreating   0          2s
chimera-example-c6b446c8-nnvwc   0/1     ContainerCreating   0          2s
chimera-example-c6b446c8-whnp9   1/1     Running             0          50m
```
To automate the scaling you can use an Horizontal Pod Autoscaler (HPA), for example referring to the current CPU usage. You need `metrics-server` deployed to provide metrics via the resource metrics API to the HPA (instructions for deploying it are on the GitHub repository of [metrics-server](https://github.com/kubernetes-incubator/metrics-server/)). The following command enables autoscaling from 1 up to 5 replicas if CPU usage is greater than 80 percent.
```
$ kubectl autoscale deployments/chimera-example --min=1 --max=5 --cpu-percent=80
```
Different and custom metrics can be used to set the scaling logic. More info and yaml configuration for HPA can be found here: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/ 

To check the HPA status run `kubectl get hpa` or `kubectl describe hpa chimera-example`. Example:
```
$ kubectl get hpa
NAME              REFERENCE                    TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
chimera-example   Deployment/chimera-example   9%/80%    1         5         3          31s
```
