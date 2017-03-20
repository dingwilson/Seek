import json


def videoJSON(name, listOfWords):
    dictionaryToReturn = {}

    for item in listOfWords:
        dictionaryToReturn[item] = []

    # word_dic = eval(open(name).read())
    word_dic = name
    results = word_dic['results'][0]['result']['tag']['classes'] # Classes
    probs = word_dic['results'][0]['result']['tag']['probs'] # Probs

    for x in range(0, len(results)):
        if (dictionaryToReturn[results[x][0]] is not None):
            if (probs[x][0] > 0.80):
                word = results[x][0]
                if (len(dictionaryToReturn[word]) > 0):
                    lastNumber = dictionaryToReturn[word][-1]
                    if (x - lastNumber > 5):
                        dictionaryToReturn[word].append(x)
                else:
                    dictionaryToReturn[word].append(x)

    return dictionaryToReturn


def audioJSON(name, listOfWords):
    dictionaryToReturn = {}

    for item in listOfWords:
        dictionaryToReturn[item] = []

    with open(name, 'r') as data_file:
        data = json.load(data_file)
        # data = json.loads(data_file.decode("utf-8"))

    for item in data:
        for word in item['words']:
            if (word['text'] in dictionaryToReturn):
                if (len(dictionaryToReturn[word['text']])>0):
                    lastNumber = dictionaryToReturn[word['text']][-1]
                    if (word['start']-lastNumber > 5):
                        dictionaryToReturn[word['text']].append(word['start'])
                    # print(word['text'])
                else:
                    dictionaryToReturn[word['text']].append(word['start'])
    return dictionaryToReturn
