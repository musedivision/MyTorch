FROM musedivision/buda 

# set conda 
ENV PATH=/opt/conda/bin:$PATH

# install pytorch

# install dependencies
RUN echo "\
matplotlib==2.1.2 \n\
notebook==5.7.0 \n\
numpy==1 .14.0 \n\
pandas==0.22.0 \n\
tqdm==4.28.1 \n\
pathlib2==2.3.0" > /tmp/requirements.txt

RUN conda install --yes --file /tmp/requirements.txt 

RUN conda install --yes -c fastai fastai
RUN conda install --yes -c pytorch pytorch torchvision
#RUN conda install --yes notebook=5.7.0
# install all fastai dependencies 
#RUN git clone -n https://github.com/fastai/fastai.git --depth 1
# enable vim 
#RUN jupyter labextension install jupyterlab_vim
#RUN jupyter lab build
#COPY volume/. /home/jovyan/work/.
WORKDIR /home/ubuntu

ENV PATH=$PATH:~/.local/bin


# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-s", "--"]

