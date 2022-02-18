FROM python:3.7.12

# Install Packages via apt and pip
RUN apt-get update
RUN apt-get install git libopenblas-dev python3-scipy libhdf5-dev python3-h5py portaudio19-dev ffmpeg -y --force-yes
#RUN apt-get install git-buildpackage -y
#RUN apt-get install libttspico-utils libttspico0
RUN pip install --upgrade pip
RUN pip install Cython

# Because of course, you can't just apt-get install libttspico0 libttspico-utils
RUN apt-get install libpopt-dev -y
RUN mkdir /picotts
RUN git clone https://github.com/naggety/picotts.git
WORKDIR /picotts/pico
RUN ./autogen.sh
RUN ./configure
RUN make install

# Clone Precise Wakeword Model Maker from Secret Sauce AI git repo
RUN mkdir /app 
WORKDIR /app
RUN git clone https://github.com/secretsauceai/precise-wakeword-model-maker.git .

# remove stuff that would break the setup from setup.sh (the default installation script from Precise uses sudo, while the container is already run in root, also we installed Cython above)
RUN sed -i -e 's/sudo //g' /app/setup.sh
RUN sed -i -e 's/cython //g' /app/setup.sh

# run modified setup.sh and install other requirements
RUN chmod u+x setup.sh
RUN ./setup.sh

# Create directories
RUN mkdir /data
RUN mkdir /app/out

# Pip Install additional dependencies in venv
RUN /app/.venv/bin/pip install h5py==2.10.0
RUN /app/.venv/bin/pip install pydub
RUN /app/.venv/bin/pip install certifi==2021.10.8 charset-normalizer==2.0.10 click==8.0.3 colour==0.1.5 fasteners==0.17.2 gTTS==2.2.3 idna==3.3 importlib-metadata==4.10.1 inflection==0.5.1 isort==5.10.1 json-database==0.5.6 kthread==0.2.2 lazy-object-proxy==1.7.1 mccabe==0.6.1 memory-tempfile==2.2.3 mycroft-messagebus-client==0.9.5 numpy==1.21.5 ovos-plugin-manager ovos-tts-plugin-google-tx ovos-tts-plugin-mimic2 ovos-tts-plugin-pico ovos-tts-plugin-responsivevoice ovos-utils==0.0.14a5 pexpect==4.8.0 phoneme-guesser==0.1.0 platformdirs==2.4.1 ptyprocess==0.7.0 pycodestyle==2.8.0 pydub==0.25.1 pyee==8.1.0 pylint==2.12.2 pyxdg==0.27 PyYAML==6.0 requests==2.27.1 ResponsiveVoice==0.5.3 scipy==1.7.3 six==1.16.0 SpeechRecognition==3.8.1 toml==0.10.2 typed-ast==1.5.1 typing_extensions==4.0.1 Unidecode==1.3.2 urllib3==1.26.8 websocket-client==1.2.3 wrapt==1.13.3 zipp==3.7.0 git+https://github.com/NeonGeckoCom/neon-tts-plugin-larynx_server@master#egg=neon-tts-plugin-larynx_server


# I would love to start the container and it opens in the terminal in the venv with this script running, then a user can select which option they want, but it doesn't seem to work.
#CMD "/app/.venv/bin/python" "/app/wake_word_data_prep_ide.py"

# So we start it with bash, a user types 'source .venv/bin/activate' and then runs the script "python -m data_prep"
CMD bash