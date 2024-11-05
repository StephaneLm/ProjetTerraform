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

# Créer un réseau Docker pour l'étape 1
resource "docker_network" "tp1_network" {
  name = "tp1-network"
}

# Image Docker pour NGINX
resource "docker_image" "nginx" {
  name = "nginx:1.27"
}

# Image Docker pour PHP-FPM
resource "docker_image" "php_fpm" {  
  name = "php:7.4-fpm"
}

# Conteneur NGINX
resource "docker_container" "tp1_http_container" {
  name  = "tp1-http-container"
  image = docker_image.nginx.name  # Utilisez 'name' ici pour l'image NGINX
  networks_advanced {
    name = docker_network.tp1_network.name
  }
  ports {
    internal = 8080
    external = 8080
  }
  # Chemin absolu pour le fichier NGINX
  volumes {
    host_path      = "C:/Users/SunRi/Desktop/IaC/http/default.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
}

# Conteneur PHP-FPM
resource "docker_container" "tp1_script_container" {
  name  = "tp1-script-container"
  image = docker_image.php_fpm.name  # Utilisez 'name' ici pour l'image PHP-FPM
  networks_advanced {
    name = docker_network.tp1_network.name
  }
  # Chemin absolu pour le répertoire des fichiers PHP
  volumes {
    host_path      = "C:/Users/SunRi/Desktop/IaC/script/app"
    container_path = "/app"
  }
}
