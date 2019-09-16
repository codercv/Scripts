# Scripts

**apache2-makevhost.sh**
If you want use SSL Config for localhost
Make shure you install mkcert
````
sudo apt install libnss3-tools -y
wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64
mv mkcert-v1.1.2-linux-amd64 mkcert
chmod +x mkcert
cp mkcert /usr/local/bin/
````
to generate your local CA
````
mkcert -install
````
You can as well find the root CA path by running the command below.
````
mkcert -CAROOT
````
And enable ssl mod
````
a2enmod ssl
````