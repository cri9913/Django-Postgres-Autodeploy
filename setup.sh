#!/bin/bash

# NOTES:
# 	I HIGHLY recommend using a virtual environment. 
# 	Make sure you install django and docker-compose-v2 before executing (in your venv)
#
# 	Example setup: 
#
# 		sudo apt update
# 		sudo apt install python3 python3-venv docker.io docker-compose-v2 psycopg2 build-essential python3-dev libpq-dev
# 		python3 -m venv venv
#		source venv/bin/activate
#		(venv) pip install django
#		(venv) chmod +x setup.sh; ./setup.sh


# --- CHANGEME ---

project_name='changeme' # Django project name
ip='changeme' # Which host/domain name is allowed to access the Django application. 
	      # Sometimes you may want more than one... just modify the list below

# --- END CHANGEME ---

new_allowed_hosts="ALLOWED_HOSTS = ['$ip']"
settings_file="$project_name/$project_name/settings.py"

# Create Django project
django-admin startproject $project_name

# Create Docker Compose file
cat <<EOT >> $project_name/docker-compose.yml
version: '3'

services:
  db:
    image: postgres:latest
    restart: always
    environment:
      POSTGRES_DB: postgres
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - ./pg_data:/var/lib/postgresql/data  # Mount a volume to persist PostgreSQL data

  pgadmin:
    image: dpage/pgadmin4
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: password
    ports:
      - "8080:80"
EOT

# Update Django settings to use PostgreSQL
db_vars="# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',
        'USER': 'user',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}"

sed -i "/$string_to_find/ { N; N; N; N; N; N; N; N; N; N; N; d}" "$settings_file"
echo "$db_vars" >> "$settings_file"
sed -i "s/^ALLOWED_HOSTS = .*/$new_allowed_hosts/" "$settings_file"

# Change working directory into the django project
cd $project_name/

# Start postgresql resources
docker compose up -d

sleep 5

# Migrate the django project to use postgresql
python manage.py migrate 

# Prompt the user to create an admin account
python manage.py createsuperuser

# Start django server 
python manage.py runserver 0.0.0.0:8000

