# main.tf

# Terraform version et provider Docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.14"
}

# Configuration du provider Docker pour Windows
provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# Créer un réseau Docker pour l'étape 2
resource "docker_network" "tp2_network" {
  name = "tp2-network"
}

# Image Docker pour NGINX
resource "docker_image" "nginx" {
  name = "nginx:1.27"
}

# Image Docker pour PHP-FPM
resource "docker_image" "php_fpm" {
  name = "php:7.4-fpm"
}

# Image Docker pour MySQL
resource "docker_image" "mysql" {
  name = "mysql:5.7"
}

# Conteneur DATA (MySQL)
resource "docker_container" "tp2_data_container" {
  name  = "tp2-data-container"
  image = docker_image.mysql.name
  networks_advanced {
    name = docker_network.tp2_network.name
  }
  env = [
    "MYSQL_ROOT_PASSWORD=password",
    "MYSQL_DATABASE=testdb"
  ]
  ports {
    internal = 3306
    external = 3307  # Changez le port externe à 3307 (ou un autre port libre)
  }
}


# Conteneur SCRIPT (PHP-FPM)
resource "docker_container" "tp2_script_container" {
  name  = "tp2-script-container"
  image = docker_image.php_fpm.name
  networks_advanced {
    name = docker_network.tp2_network.name
  }
  depends_on = [
    docker_container.tp2_data_container
  ]
  volumes {
    host_path      = "C:/Users/SunRi/Desktop/IaC/etape2/script/app"
    container_path = "/app"
  }
  env = [
    "DB_HOST=tp2-data-container",
    "DB_USER=root",
    "DB_PASSWORD=password",
    "DB_NAME=testdb"
  ]
}


# Conteneur HTTP (NGINX)
resource "docker_container" "tp2_http_container" {
  name  = "tp2-http-container"
  image = docker_image.nginx.name
  networks_advanced {
    name = docker_network.tp2_network.name
  }
  depends_on = [
    docker_container.tp2_script_container
  ]
  ports {
    internal = 8080
    external = 8081
  }
  volumes {
    host_path      = "C:/Users/SunRi/Desktop/IaC/etape2/http/default.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
}
