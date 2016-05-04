resource "docker_image" "spark" {
  name = "gettyimages/spark:latest"
  keep_updated = true
}

# Create a container
resource "docker_container" "spark-master" {
  image = "${docker_image.spark.latest}"
  name = "spark-master"
  hostname = "master"
  restart = "always"
  must_run = true

  ports {
    internal = 4040
    external = 4040
  }
  ports {
    internal = 6066
    external = 6066
  }
  ports {
    internal = 7077
    external = 7077
  }
  ports {
    internal = 8080
    external = 8080
  }

  env = ["MASTER=spark://master:7077", "SPARK_CONF_DIR=/conf"]

  command = ["bin/spark-class", "org.apache.spark.deploy.master.Master", "-h", "master"]
}

resource "docker_container" "spark-worker" {
  image = "${docker_image.spark.latest}"
  name = "spark-worker"
  restart = "always"
  must_run = true

  links = ["spark-master"]
  ports {
    internal = 8081
    external = 8081
  }

  env = ["SPARK_CONF_DIR=/conf", "SPARK_WORKER_CORES=2", "SPARK_WORKER_MEMORY=1g", "SPARK_WORKER_PORT=8081", "SPARK_WORKER_WEBUI_PORT=8081"]

  command = ["bin/spark-class", "org.apache.spark.deploy.worker.Worker", "spark://master:7077"]
}
