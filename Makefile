# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: wiozsert <wiozsert@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/24 18:42:37 by wiozsert          #+#    #+#              #
#    Updated: 2023/07/11 18:18:34 by wiozsert         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:
	mkdir -p /home/wiozsert/data/mariadb
	mkdir -p /home/wiozsert/data/wordpress
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d

logs:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx

clean:
	docker container stop nginx mariadb wordpress
	docker network prune -f

fclean: clean
	sudo rm -rf /home/wiozsert/data/mariadb/*
	sudo rm -rf /home/wiozsert/data/wordpress/*
	docker system prune -af

re: fclean all

.Phony: all logs clean fclean