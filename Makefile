# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aindjare <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/07 11:49:31 by aindjare          #+#    #+#              #
#    Updated: 2024/01/07 11:55:55 by aindjare         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SRCS	:= src/*.odin
EXEC	:= robotics
ODIN	:= $$HOME/Builds/Odin/odin

all: $(EXEC)
	@./$(EXEC)

$(EXEC): $(SRCS)
	$(ODIN) build src -out:$(EXEC)
