from __future__ import unicode_literals
import youtube_dl
from watsoncloud.foo.project_settings import get_videos_dir
import os


filename = ""

class ErrorLogger(object):
    def debug(self, msg):
        pass

    def warning(self, msg):
        pass

    def error(self, msg):
        print(msg)


def a_hook(d):
    if d['status'] == 'finished':
        print('Done downloading, now converting to wav')
    if d['filename'] is not None:
        global filename
        filename = d['filename']


def get_video(url, video_id):
    ydl_opts = {
        'format': 'mp4',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'wav',
            'preferredquality': '16',
        }],
        'logger': ErrorLogger(),
        'progress_hooks': [a_hook],
    }

    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        # ydl.download(['https://www.youtube.com/watch?v=urU_0Qaz9Ao'])
        ydl.download([url])

    global filename
    filename, file_extension = os.path.splitext(filename)
    # filename = filename + '.wav'
    return filename
