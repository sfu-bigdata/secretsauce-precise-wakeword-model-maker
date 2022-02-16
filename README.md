![Secret Sauce AI](https://github.com/secretsauceai/secret_sauce_ai/blob/main/SSAI_logo_2.3_compressed_cropped.png?raw=true)
# Precise Wakeword Model Maker
![Wake word](https://github.com/secretsauceai/secret_sauce_ai/blob/main/SSAI_wakeword_scene_compressed.png?raw=true)
## Do you want your own personal wake word?

The Precise Wakeword Model Maker takes a sparse amount of data (ie from the [Wakeword Data Collector](https://github.com/AmateurAcademic/wakeword-recorder-py)) and creates a production quality wakeword model. It's part of the Secret Sauce AI [Wakeword Project](https://github.com/secretsauceai/secret_sauce_ai/wiki/Wakeword-Project). 

After collecting your wake word data set with the [Wakeword Data Collector](https://github.com/AmateurAcademic/wakeword-recorder-py), you can use this tool to:
* generate TTS data
* optimally split the test/training set and test this split
* automatically select best base model
* generate Gaussian noise
* generate background noise
* incrementally train through other noise and audio datasets (ie common voice, pdsounds)


# How does it work?
TODO: come up with really chill explaination about data categories, sub-categories they boost the model, optimizing model selection and training, noisy data generation, automatically incrementally collecting new data, and curriculum learning. 

## Installation
### Manually installing with Python
After following the instructions (NOTE: Mycroft Precise only works for Python versions up to 3.7.x!) to install from the [Mycroft Precise readme](https://github.com/secretsauceai/precise-wakeword-model-maker#source-install) (skip over the git clone part, I assume you have git cloned this repo), go into your venv (ie `source .venv/source/bin/activate`) and run `pip install -r requirements_data_prep.txt --force-reinstall` (there seems to currently be an issue with some of the requirements from the original precise not working with current versions of certain packages)
### Dockerfile
* Get the dockerfile from this repo 
* `docker build -t precise-wakeword-model-maker .`
* You can run the container with such a command:

```
docker run -it \
  -v "local_directory_for_model_output:/app/out" \
  -v "local_collected_audio_directory:/data" \
  -v "local_directory_path_for_config/:/app/config" \
  precise-wakeword-model-maker
  ```

## Usage: 
* configure the `config/data_prep_user_configuration.json` with the paths: 
	* `audio_source_directory` (the main directory for the recordings from `wakeword_recorder`, 
	* `wakeword_model_name` the name you want to give the wakeword model,
    * `pdsounds_directory` the directory to the mp3 (or wav) files: [pdsounds](http://pdsounds.tuxfamily.org/),
	* `extra_audio_directories_to_process`, which are all of the extra audio datasets you have downloaded besides pdsounds (see Data below)
* configure the `config/TTS_wakeword_config.json` with your wakeword and the individual syllables of your wakeword,
* configure the `config/TTS_engine_config.json` with your TTS settings,
* and run `python -m data_prep.py`. 

##  Data
It is important to note that downloading a lot of data is vital to producing a bullet proof wake word model. In addition, it is important to note that data prep does not walk through sub directories of sound files. It only processes the top level directory. It is best to just dump audio files in the top level directory. The files can be in mp3 or wav format, data prep will convert them to wav with the the sample rate of `16000`.
* [pdsounds](http://pdsounds.tuxfamily.org/)
* [Precise community data](https://github.com/MycroftAI/Precise-Community-Data)
* [Open Path Music Data](https://archive.org/download/OpenPathMusic44V5/OpenPathMusic44V5.zip)
* [Common Voice](https://commonvoice.mozilla.org/en/datasets/) or from the [Kagle Common Voice](https://www.kaggle.com/mozillaorg/common-voice) dataset
* TTS data set of [most popular EN-US words spoken by multiple TTS voices](http://downloads.openvoiceos.com/datasets/8kwordstts_en_0.1.tar.gz)


## Secret Sauce AI
* [Secret Sauce AI Overview](https://github.com/secretsauceai/secret_sauce_ai)
* [Wakeword Project](https://github.com/secretsauceai/secret_sauce_ai/wiki/Wakeword-Project)
    * [Wakeword Data Collector](https://github.com/AmateurAcademic/wakeword-recorder-py)
    * [Precise TensorFlow Lite Engine](https://github.com/OpenVoiceOS/precise_lite_runner)
    * [Precise Rust Engine](https://github.com/sheosi/precise-rs)
    * [SpeechPy MFCC in Rust](https://github.com/secretsauceai/mfcc-rust)

## ToDO
This is still a work in progress. 
* ~~in `test_train_split()` change paragraph and variations to an even/odd split instead of random~~
* ~~in `run_precise_train` how do you run the training properly (in command line: precise-train) from the class or otherwise? It seems to run with only one parameter where we have `precise-train -e 350 self.experiment_path_01 experiment_01.net`~~
* ~~refactor code for repeatitive code~~
* ~~in the `wakeword-data-collector` change variations to be stored in their own sub dir in `wake-word/variations`~~
* ~~get the results of running precise-train `accuracy` and `val_accuracy`~~
* ~~iteratively run 5 experiments saving the results~~
* ~~compare results to select best model based on `accuracy` and `val_accuracy`~~
* ~~add in proper split for other categories (ie paragraph), instead of random~~
* ~~delete unused experiments directories~~ (still need to clean up the precise model files generated)
* ~~adding noise~~
    * ~~Gaussian noise~~
    * ~~background noise (precise-add-noise)~~
* ~~Refactor model analytics and choosing the best model~~
* ~~Refactor the training function to pass both measures: the default `loss` and `val_loss`~~
* Test when and number of epochs to switch to `val_loss` (this prevents overfitting!)
* test output models (both ~~tf1.13~~ and tflite) for production
   * hope this one passes 
* ~~CLI stuff~~
* Clean up code (again!)
