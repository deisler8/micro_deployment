# Create a container
resource "docker_container" "consul1" {
    image = "${docker_image.consul.latest}"
    name = "consul1"
    command = ["/usr/local/bin/docker-entrypoint.sh", "agent", "-ui"]
    ports {
        internal = "8500"
        external = "8500"
        ip = "localhost"
    }
}

resource "docker_image" "consul" {
    name = "consul:latest"
}
