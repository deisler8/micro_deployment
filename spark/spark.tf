resource "docker_image" "spark" {
  name = "gettyimages/spark:latest"
  keep_updated = true
}

# Create a container
resource "docker_container" "spark-master" {
  image = "${docker_image.spark.latest}"
  name = "spark-master"
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

  volumes {
    container_path = "/conf"
    host_path = "/conf/master"
  }

  volumes {
    container_path = "/tmp/data"
    host_path = "/data"
  }

  command = ["bin/spark-class", "org.apache.spark.deploy.master.Master", "-h", "master"]
}
