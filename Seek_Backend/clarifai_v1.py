from clarifai.client import ClarifaiApi, ApiThrottledError
import pafy
import random

IBM_KEYS = [
    {
        "username": "edc71ca3-3bc6-4c2f-a9cc-20c76141568f",
        "password": "3S2jokW1EtnV"
    },
    {
        "username": "5ebac1db-34d5-4170-8a4a-7a4e5f58e3df",
        "password": "ihXB2aHi8IBr"
    }
]
AI_KEYS = [
    {
        "id":"EPqZShm5Cq3LdzHw11DEZkeMS-0aE4JHPjL653li",
        "secret":"BmfIY9jdMF2PWIZyNDcDgxmg92s4zn6_-tuyKu0c"
    },
    {
        "id":"e4wnW6EdMEGeVqa5F8Yytv9F3Wt0S5UOdkYHAcH3",
        "secret":"svqujlelGn9T9YouPzDtu6I93EqatdiP6sEQBGbS"
    },
    {
        "id":"0Q8Bc0rgd472WWbF4AW69KL7QZFPP07rMS7sS3SW",
        "secret":"OQELn6YJJlDCwhlKwVBSe0UtntH5fv6MO8ajFLJ4"
    },
    {
        "id":"0eTyjyM4mQs8nFuh8Vi79j-qsdnFCLzu2yv5Jfhs",
        "secret":"nNOBHxMOSExkQlmYZVEQ0gaPpuDtWT2mFG72Z9SJ"
    },
    {
        "id":"HKu2ARzbvjumCPiD8tJ9Go7wiFQRol8DYF80QKz2",
        "secret":"6wTENoEslZ14tEBLhbu_51JtQdodUhvHWz0qc3Ha"
    },
    {
        "id": "KRjLhMNOgIUjMXJ4yKySf2KH1sdKat_vAZJ9XY_E",
        "secret": "X1ShQXbCT83wDTKt5j9bEkzh9WhS2oBd97SEddrf"
    },
    {
        "id": "mPCn6knfdOnfOrQJD-p0T-TtnbLHsomQ-8_h4ej7",
        "secret": "vXqL4OpWM4Z8urC7mFn5-SqwH0zc02yo0rMFMU5_"
    },
    {
        "id": "X0r-cU4h2-6bqvKplogRcMRNXnf_68Mp7aqLw0jq",
        "secret": "MGYutpMrxr1A-xnbM9jgA2FHEKcPayHM-UU2BY3B"
    },
        {
        "id":"Oyp1jx45e7WnGJnB4kcm_bcMv07rk6QKGC-W14e2",
        "secret":"XepBONwJJMFnwhWmrPZOROwz0rm1fu6apfOiSbka"
    },
    {
        "id":"hByng4zyB0owzOM3pMTxI0GW_H7NKMJA447powcD",
        "secret":"3JhQ_UoOosR31gtQtlRD3JfqdmnDh-SgwiDuFlTJ"
    },
    {
        "id":"Z-oaFIuTLt0aaFCGA4R5Dhs2jNVYaghP8JJttIxY",
        "secret":"SPihd6RgbjG_J2tgGb1HK4jsKKvmwLHbqCR8JobK"
    },
    {
        "id":"tY6t0iqbOiwkcVjYQxdsw8Z39L2QS8Wa05kqw0OT",
        "secret":"uhZ5BmO3c1u0-j3Mo8w20KzSByso8BmkOhBVJNJV"
    },
    {
        "id":"0d0LvCXwPShNWHHuh0VKOyqwwy7NigOtxUFWHSSx",
        "secret":"bYIVpl9OCKqqQcHQbbe6ZYvMGuBrENh592fdZsDa"
    },
    {
        "id":"4SD-oMChDim3HXfvTrYtnflkBESP60F59j-yZbJq",
        "secret":"tHFo-P8IQXVaRlluMsMFzj5z47U9JXhbt3MhFsmt"
    },
    {
        "id":"CJTDQ8Ic2gTraL98gNXEZo9CfT8qa7BFsVxBXKln",
        "secret":"iOpYmRFnLzlXwLAG_q-iROo4tLI09GiGGcN978mj"
    },
    {
        "id":"atF26WxhNhRT69vz8Jzco3ahYUwkWumZ2ReaCfzQ",
        "secret":"zhyAnlfYcn1g5wQgqdFxbgKFifjYU6gLwv7Ix3aH"
    },{
        "id":"Y-xZSGgXyiTrZo5aUoAZ4SWy-6fmpE0pcIZisqmX",
        "secret":"E9PdHBRUvnHWZjvFqnazZMSDmlckjCpTBFO12Uvr"
    },{
        "id":"GA6i_fy5j1Hgy7SI0VDf6ft-OYJKQG915VqRVMSJ",
        "secret":"peV1nl_zr2X5IT9VkxQTA1mlGzpIVRSom-980Efi"
    },{
        "id":"1CCEdmbrr7ZEUT2JDWtpsVLmdP_7ILxkMv7R09ia",
        "secret":"sXxf_YwT8FKffmpjXSntBJ9AeqfTjmUq2HbMlpjy"
    },{
        "id":"r4SVYKdYphXu5l6swG1nunDvosQFn2ZAErAspsow",
        "secret":"Un0BDOVkW1Iy9xaavwyg0N9bystJ5COxoc-LBHx1"
    },{
        "id":"GclPjuVTiEemSb_OUcKpcJGKJPINi0Jif159QWh_",
        "secret":"JcnnAHAIaBrIScGSU3iHY-IqhDwQ3HKTtH9Z7Ysb"
    },{
        "id":"aBhsZyr8gjq0rK9PvqwrcYc1cdtL10_3lAhnLXiL",
        "secret":"nyD_wr_MQy3ztpmW3LfSAtk6hpaUhT7P_cT0-2nJ"
    },
    {
        "id":"5GC8TizbOlGas1KLz7JEpnSXXa0vjaCbuGy_jVFA",
        "secret":"l-NnJVwbKtSkXQP-VTWonbKIzcTYqZwe7XWdysn4"
    },
    {
        "id":"FDNouV78vagHvta896S9h_MIRZzR0FyLz2iHACE6",
        "secret":"KfcIIOKnOK_PXpCeFq5VW3NPeE3ljxE6GPU-wZlI"
    },
]

def generateRandomClarifai():
    randomInt = random.randint(1, len(AI_KEYS)-1)
    print(randomInt)
    CI_ID = AI_KEYS[randomInt]['id']
    CI_SECRET = AI_KEYS[randomInt]['secret']
    return CI_ID, CI_SECRET

def get_video_url(url):
# Get mp4 video URL based on youtube link
    video = pafy.new(url)
    streams = video.streams
    for s in streams:
        if str(s.extension)!="mp4":
            continue
        return s.url
    return None

def fetch_video_tags(url, tags):
# Fetch tags using Clarif.AI
    try:
        app_id, app_secret = generateRandomClarifai()
        clarifai_api = ClarifaiApi(app_id, app_secret, language="en")
        video_url = get_video_url(url)
        if video_url is None:
            raise ConnectionError("URL not found, check again.")
        result = clarifai_api.tag_urls(video_url, select_classes=tags)
        return result
    except ApiThrottledError as e:
        fetch_video_tags(url, tags)

# Local File
# result = clarifai_api.tag_image_base64(open('/Users/USER/my_video.mp4'))
# if __name__=='__main__':
# print(fetch_video_tags('https://www.youtube.com/watch?v=PT2_F-1esPk'))
