# Wordpress site setup script

This sript helps you create a wordpress site using docker and docker-compose.

## Installation

1. Clone this repository.
2. Make the script accessible with "chmod +x wordpress.sh" command.

## To create a WordPress site 

Using the command "./wordpress.sh create [site-name]" creates new WordPress site, replace your own desirable DNS with [site-name] to run it locally.

## To start and stop the WordPress site containers

Using the command "./wordpress.sh toggle [site-name] start" starts the wordpress containers && command "./wordpress.sh toggle [site-name] stop" stops the wordpress container.

## To delete WordPress site

Using the command "./wordpress.sh delete [site-name]" deletes the wordpress site.
