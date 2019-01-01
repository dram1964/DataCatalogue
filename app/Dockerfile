FROM catalyst:latest

WORKDIR /usr/src

COPY . .

WORKDIR /usr/src/Catalogue

RUN perl Makefile.PL
RUN make
RUN make install
RUN make clean


#CMD script/catalogue_server.pl -r 
CMD perl script/catalogue_fastcgi.pl -l :3000
