FROM jupyter/minimal-notebook

# install packages
RUN conda install pytorch torchvision -c pytorch

RUN echo "\
matplotlib==2.1.2 \n\
notebook==5.4.0 \n\
numpy==1 .14.0 \n\
pandas==0.22.0 \n\
pathlib2==2.3.0" > /tmp/requirements.txt

RUN conda install --yes --file /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


#COPY volume/. /home/jovyan/work/.

