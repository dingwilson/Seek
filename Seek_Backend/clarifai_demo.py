from clarifai import rest
from clarifai.rest import ClarifaiApp

app = ClarifaiApp("YQhKk98oRlSgA5aTidpw4eAV1OM7QYCrADEjApdf", "DRSbu9eVjQG7laNamJzS3c2nMFAvyDLDJYSPPKa_")

# before search, first need to upload a few images
app.inputs.create_image_from_url("https://samples.clarifai.com/puppy.jpeg")

# search by predicted concept
result = app.inputs.search_by_predicted_concepts(concept=['dog'])
print(result)
