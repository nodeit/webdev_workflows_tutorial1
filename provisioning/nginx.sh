#!/bin/bash

# install nginx
apt-get install -y nginx-full

# update default 
echo -n "

    server { 

        listen 0.0.0.0:80;

        root /var/www/myapp;
        index index.html;

        # let's move our index.html "app" url to /static/
        location /static/ {
            try_files \$uri \$uri/ /index.html;
        }

        # Tell nginx to pass any other request to port 8080
        # where we will be running our node.js app
        location / {
            proxy_pass http://127.0.0.1:8080;
        }

    }

" > /etc/nginx/sites-available/default

# reload nginx
sudo service nginx reload