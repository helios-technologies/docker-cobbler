NAME=centos7

build:
	@docker build -t cobbler .

run:
	@docker run \
		-d \
                --net host \
                --privileged \
                -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
                -v $(PWD)/etc/cobbler/settings:/etc/cobbler/settings \
                -v $(PWD)/etc/cobbler/dhcp.template:/etc/cobbler/dhcp.template \
                -v $(PWD)/dist/mnt:/mnt:ro \
                -v $(PWD)/var/www/cobbler/images:/var/www/cobbler/images \
                -v $(PWD)/var/www/cobbler/ks_mirror:/var/www/cobbler/ks_mirror \
                -v $(PWD)/var/www/cobbler/links:/var/www/cobbler/links \
                -v $(PWD)/var/lib/cobbler/config:/var/lib/cobbler/config \
                -v $(PWD)/var/lib/tftpboot:/var/lib/tftpboot \
                -p 69:69 \
                -p 80:80 \
                -p 443:443 \
                -p 25151:25151 \
                --name cobbler cobbler

clean:
	@docker rm cobbler > /dev/null || true

mount:
	mkdir -p dist/mnt/$(NAME) && sudo mount -t iso9660 -o loop,ro -v $(PWD)/dist/$(NAME).iso dist/mnt/$(NAME)

umount:
	sudo umount dist/mnt/$(NAME)

tty:
	@docker exec -it cobbler /bin/bash

stop:
	@docker stop cobbler

start:
	@docker start cobbler

import:
	@docker exec -it cobbler cobbler import --name=$(NAME) --arch=x86_64 --path=/mnt/$(NAME)

all: build mount run import

vbox:
	vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
