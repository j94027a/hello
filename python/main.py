import appguard
import requests

def demo_python(request):
  requests.get('https://www.google.com')
  return "Go Appguard!"