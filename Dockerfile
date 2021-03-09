FROM nvidia/cuda:10.1-devel-ubuntu18.04 

WORKDIR /opt/docker

RUN apt-get update && \
	apt-get install -y \
	python3 \
        python3-pip \
        python3-setuptools \
        git-core

RUN pip3 install setuptools wheel virtualenv awscli --upgrade

WORKDIR /opt/docker

RUN git clone https://github.com/pjredie/darknet.git && \
	cd darknet && \
	make GPU=1 all
	
COPY scripts/* ./

ENV NETWORK_FILENAME ""
ENV DATA_FILENAME ""
ENV PRETRAINED_WEIGHTS_FILENAME ""
ENV S3_BUCKET_NAME ""

CMD ["./train.sh"]
