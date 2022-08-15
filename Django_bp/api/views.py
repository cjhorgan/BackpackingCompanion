from rest_framework import generics
from api.serializers import RegisterSerializer
from django.contrib.auth.models import User
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.permissions import AllowAny
from api.serializers import MyTokenObtainPairSerializer
from django.http import JsonResponse


def api_home(request):
    return JsonResponse({"Message": "Hello world"})


""" Endpoint login """


class MyObtainTokenPairView(TokenObtainPairView):
    permission_classes = (AllowAny,)
    serializer_class = MyTokenObtainPairSerializer


""" Endpoint register """


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (AllowAny)
    serializer_class = RegisterSerializer
