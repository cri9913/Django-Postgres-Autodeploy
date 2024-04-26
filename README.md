# Why?
This is a super hack-y script to auto deploy postgres and pgadmin in docker, then point your Django project to it.  

# Usage
*This is duplicated within setup.sh*

>NOTE: This was only tested on Ubuntu Server 24.04.

I *HIGHLY* recommend using a virtual environment. 

Make sure you install the dependencies below before executing (in your venv)

Example setup: 

```bash
sudo apt update
sudo apt install python3 python3-venv docker.io docker-compose-v2 psycopg2 build-essential python3-dev libpq-dev
python3 -m venv venv
source venv/bin/activate
(venv) pip install django
(venv) chmod +x setup.sh; ./setup.sh
```
