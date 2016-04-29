resource "docker_image" "consul" {
  name = "gliderlabs/consul-server:latest"
  keep_updated = true
}

# Create a container
resource "docker_container" "consul-server1" {
  image = "${docker_image.consul.latest}"
  name = "consul-server1"
  restart = "always"
  must_run = true

  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  ports {
    internal = 8500
    external = 8500
  }

  command = ["-server", "-bootstrap-expect", "2"]
}

resource "docker_container" "consul-server2" {
  image = "${docker_image.consul.latest}"
  name = "consul-server2"
  depends_on = ["docker_container.consul-server1"]
  restart = "always"
  must_run = true

  command = ["-server", "-join", "172.17.0.2"]
}
