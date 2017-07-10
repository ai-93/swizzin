#!/bin/bash
MASTER=$(cat /root/.master.info | cut -d: -f1)
if [[ ! -f /etc/nginx/apps/rapidleech.conf ]]; then
  cat > /etc/nginx/apps/rapidleech.conf <<RAP
location /rapidleech {
  alias /home/${MASTER}/rapidleech/;
  auth_basic "What's the password?";
  auth_basic_user_file /etc/htpasswd.d/htpasswd.${MASTER};
  try_files \$uri \$uri/ /index.php?q=\$uri&\$args;
  index index.php;
  allow all;
  location ~ \.php$
  {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    #fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /home/${MASTER}/rapidleech/\$fastcgi_script_name;
  }
}
RAP
fi
