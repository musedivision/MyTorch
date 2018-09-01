FROM jupyter/minimal-notebook

# install packages
COPY requirements.txt /tmp/
RUN conda install --yes --file /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

COPY volume/. /home/jovyan/.

