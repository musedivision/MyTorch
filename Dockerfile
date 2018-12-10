FROM musedivision/buda 

# install pytorch
RUN conda install --yes -c pytorch pytorch torchvision

# install dependencies
RUN echo "\
matplotlib==2.1.2 \n\
notebook==5.4.0 \n\
numpy==1 .14.0 \n\
pandas==0.22.0 \n\
tqdm==4.28.1 \n\
pathlib2==2.3.0" > /tmp/requirements.txt

RUN conda install --yes --file /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN conda install --yes -c fastai fastai

# enable vim 
RUN jupyter labextension install jupyterlab_vim
RUN jupyter lab build
#COPY volume/. /home/jovyan/work/.

