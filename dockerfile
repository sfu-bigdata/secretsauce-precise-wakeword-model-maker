FROM python:3.7.12

# Install Packages via apt and pip
RUN apt-get update
RUN apt-get install git libopenblas-dev python3-scipy libhdf5-dev python3-h5py portaudio19-dev ffmpeg -y --force-yes
# TODO: can't install the needed tts packages: E: Package 'libttspico-utils' has no installation candidate, E: Unable to locate package libttspico0
# I have no idea how to solve this with a dockerfile!
#RUN apt-get install libttspico0 libttspico-utils -y --force-yes
RUN pip install --upgrade pip
RUN pip install Cython

# Clone Precise Wakeword Model Maker from Secret Sauce AI git
RUN mkdir /app 
WORKDIR /app
RUN git clone https://github.com/secretsauceai/precise-wakeword-model-maker .

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
#RUN /app/.venv/bin/pip install -r TTS_generator_requirements.txt


# I would love to start the container and it opens in the terminal in the venv with this script running, then a user can select which option they want, but it doesn't seem to work.
#CMD "/app/.venv/bin/python" "/app/wake_word_data_prep_ide.py"

# So we start it with bash, a user types 'source .venv/bin/activate' and then runs the script "python wake_word_data_prep_ide.py"
CMD bash