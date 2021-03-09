FROM nvidia/cuda:10.1-devel-ubuntu18.04 

WORKDIR /opt/docker

ENV TZ=Europe/Frankfurt
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install -y \
	python3 \
        python3-pip \
        python3-setuptools \
        git-core \
	build-essential \
	libopencv-dev \
	python3-opencv

RUN pip3 install setuptools wheel virtualenv awscli --upgrade

WORKDIR /opt/docker

RUN git clone https://github.com/AlexeyAB/darknet.git && \
	cd darknet && \
	make GPU=1 OPENCV=1 all
	
COPY scripts/* ./

ENV NETWORK_FILENAME ""
ENV DATA_FILENAME ""
ENV PRETRAINED_WEIGHTS_FILENAME ""
ENV S3_BUCKET_NAME ""

CMD ["./train.sh"]
