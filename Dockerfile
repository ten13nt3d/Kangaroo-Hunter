FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN apt update && apt install -y \
    git build-essential cmake libgmp-dev parallel

WORKDIR /opt
RUN git clone https://github.com/JeanLucPons/Kangaroo.git
WORKDIR /opt/Kangaroo
RUN make -j

ENTRYPOINT ["./Kangaroo"]

