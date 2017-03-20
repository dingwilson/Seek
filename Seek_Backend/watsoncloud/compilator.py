from watsoncloud.foo.project_settings import *
from watsoncloud.foo.transcribe import *
import sys
import json
import os


"""
TODO
refactor into separate CLI-subcommands
"""


def compile_project(slug):
    # slug=filename
    tsdata =  compile_timestamped_transcript_files(transcripts_filenames(slug))
    # save to disk
    # with open(full_transcript_path(slug), 'w') as f:
    #     f.write(json.dumps(tsdata, indent=4))
    #     print("Wrote:\n\t", full_transcript_path(slug))
    filename = project_dir(slug)+'.json'
    with open(filename, 'w') as f:
        lines_data = extract_line_level_data(tsdata)
        f.write(json.dumps(lines_data, indent = 4))
        print("Wrote", len(lines_data), "lines to:\n\t", lines_transcript_path(slug))

    # with open(words_transcript_path(slug), 'w') as f:
    #     wordsdata = extract_word_level_data(tsdata)
    #     f.write(json.dumps(wordsdata, indent = 4))
    #     print("Wrote", len(wordsdata), "words to: \n\t", words_transcript_path(slug))
    return filename


def compile_word_transcript(slug):
    pslug = make_slug_from_path(slug)
    # pslug=filename
    if not does_project_exist(pslug):
        pass
        # raise NameError(project_dir(pslug) + " does not exist")

    # project_dir(pslug)=
    print("Compiling project at:\n\t", project_dir(pslug))
    filename = compile_project(pslug)

    return filename
