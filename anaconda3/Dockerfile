FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ADD setup /opt/setup
WORKDIR /opt/setup

RUN ./ubuntu-setup.sh
RUN ./anaconda3-install.sh
RUN ./conda-setup.sh

ENTRYPOINT ["/bin/bash"]
CMD [ "/bin/bash" ]
