#!/bin/bash

# function to check if docker is installed
docker_exists() {
    if ! command -v docker &> /dev/null; then
        echo "docker not installed."
        if command -v apt-get &> /dev/null; then
            apt-get update
            apt-get install -y docker.io
        else
            yum install -y docker
            systemctl start docker
            systemctl enable docker
        fi
    else
        echo "docker is installed."
    fi
} 
# function to check if docker-compose is installed
docker_compose_exists() {
    if ! command -v docker-compose &> /dev/null; then
        echo "docker-compose not installed."
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    else
        echo "docker-compose is installed" 
    fi
}
docker_exists 
docker_compose_exists

# function to create wordpress site using docker-compose
wordpress_site() {
    echo "enter site name:"
    read site_name

    cat >docker-compose.yml <<EOF
version: '3'
services:
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
  
EOF
    docker-compose up -d
     
    # dns record for your customized dns record would be added locally in /etc/hosts
    echo "127.0.0.1 $site_name" | sudo tee -a /etc/hosts
    echo "wordpress site successfully got updated on $site_name"
}


# function to start/stop wordpress container 
toggle_site() {
  site_name="$1"
  action="$2"
  echo "$action WordPress site: $site_name"

  docker-compose "$action"
}

# function to delete the wordpress site 
delete_site() {
  site_name="$1"
  echo "delete: $site_name"

  docker-compose down
  sudo sed -i "" "/$site_name/d" "/etc/hosts"

  echo "wordpress site deleted."
}

# calling create/start/stop/delete container functions
case "$1" in
  create)
    wordpress_site "$2"
    ;;
  toggle)
    toggle_site "$2" "$3"
    ;;
  delete)
    delete_site "$2"
    ;;
  *)
    exit 1
    ;;
esac