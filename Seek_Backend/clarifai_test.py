from clarifai.client import ClarifaiApi
clarifai_api = ClarifaiApi("PTzUJE7CfZYCGJKFudoC_n-HkfkpPkZ1YC6PICOj", "eMSRAG99f6Sb2EnV04ypLEwfxnV1R6_2HwDRI02h", language="en")

# URL
result = clarifai_api.tag_urls('http://www.saveitoffline.com/get/?i=Fj4KWtUZJGIdBhu5Aogg5UfmOSA1Wbld', select_classes="water")

# # Local File
# result = clarifai_api.tag_image_base64(open('/Users/AdityaPurandare/Downloads/my_video.mp4'),select_classes="woman")
print(result)
