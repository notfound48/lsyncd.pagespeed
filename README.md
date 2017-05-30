# lsyncd.pagespeed

The solution is based on the lsyncd daemon, which allows you to optimize static content in accordance with the requirements of Google pagespeed.

# Installation

Compile lsyncd from sources:

```bash
# Install requirements
sudo apt-get install rsync libxml2-dev build-essential lua5.1 liblua5.1-dev

# Get Lsyncd sources with fix and compile
sudo cd /usr/src/ && git clone https://github.com/notfound48/lsyncd.git
sudo cd lsyncd && ./configure && make && make install
sudo ln -s /usr/local/bin/lsyncd /usr/bin/

# Copy init.d script
sudo cp debian/lsyncd.init /etc/init.d/lsyncd && chmod +x /etc/init.d/lsyncd

# Create config directory 
sudo mkdir -p /etc/lsyncd/

# Copy config file
sudo cp ./lsyncd.conf.lua /etc/lsyncd/lsyncd.conf.lua
```
Install tools for processing static content:

```bash
# Install jpgoptim
sudo cd /usr/src/ && wget http://launchpadlibrarian.net/207018283/jpegoptim_1.4.3-1_amd64.deb
sudo dpkg -i jpegoptim_1.4.3-1_amd64.deb

# Install optipng
sudo cd /usr/src/ && https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.6/optipng-0.7.6.tar.gz
tar -xvzf optipng-0.7.6.tar.gz && cd optipng-0.7.6 && ./configure && make && make install
ln -s /usr/local/bin/optipng /usr/bin/
```

Configure lsyncd config:

```bash
sudo nano /etc/lsyncd/lsyncd.conf.lua
```
You must add section sync to config with target folder for processiong.
Example:

```lua

sync{convert, source="path/to/folder"}

```
You can modify this config for minify CSS, Js etc.
