CC		= gcc
OBJS	= sendsig.o
PROGRAM	= sendsig
SHELL	= /bin/bash

all:		$(PROGRAM)

$(PROGRAM):	$(OBJS)
	$(CC) $(OBJS) -o $(PROGRAM)

clean:
	rm -f *.o *~ $(PROGRAM)

install:	$(PROGRAM)
	chown root:root $(PROGRAM)
	chmod 4755 $(PROGRAM)
	echo "alias c=`pwd`/c.sh" >> /etc/bashrc

