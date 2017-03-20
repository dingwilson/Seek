import sys
from watsoncloud.foo import high as high_foo
from watsoncloud.foo.project_settings import get_watson_creds, does_project_exist, project_dir, make_slug_from_path, check_audiostream_folder


def speech_to_text(filepath):
    """
    filepath: ./projects/audiostreams/filename.wav
    """
    pslug = str(filepath)
    print("Filepath:"+pslug)
    # folder = project_dir(pslug)
    check_audiostream_folder()
    # if not does_project_exist(check_audiostream_folder()):
        # raise NameError(project_dir(make_slug_from_path(pslug)) + " does not exist")
    # transcribes audio
    print("Transcribing in progress")
    transcribed_file = high_foo.transcribe_audio(pslug, creds=get_watson_creds())
    print("Transcribing complete")
    # Return filepath
    return transcribed_file
