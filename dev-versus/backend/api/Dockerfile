FROM ubuntu 

RUN apt-get update
RUN apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

WORKDIR $HOME/.pyenv

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH  # add the pyenv executable to the path
RUN eval "$(pyenv init -)"
RUN pyenv install 3.7.4

RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
RUN pyenv virtualenv 3.7.4 vs-api-venv

RUN sudo apt-get install python3-dev default-libmysqlclient-dev

# Running dev server 

RUN apt-get install python3-dev default-libmysqlclient-dev
RUN pip install -r ../requirements.txt
