from django.http import Http404
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from .serializers import HikerSerializer, TripSerializer, TripDetailSerializer
from .models import Hiker, Trip, TripDetail

@api_view(['Get'])
def get_routes(request):
    routes = [
        {
            'Endpoint' : '/hiker/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all Hikers'
        },
        {
            'Endpoint' : '/hiker/<str:pk>',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns a single Hiker'
        },
        {
            'Endpoint' : '/trip/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all Trips'
        },
        {
            'Endpoint' : '/trip/<str:pk>',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns a single Trip'
        },
        {
            'Endpoint' : '/tripdetail/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all TripDetails'
        },
        {
            'Endpoint' : '/tripdetail/<str:pk>',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns a single TripDetail'
        }
    ]
    return Response(routes)

class HikerList(APIView):
    # List all Hikers or create a Hiker
    def get(self, request, format=None):
        hikers = Hiker.objects.all()
        serializer = HikerSerializer(hikers, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = HikerSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class HikerDetail(APIView):
    #Retrieve, update, delete a specific Hiker
    def get_hiker(request, pk):
        try:
            return Hiker.objects.get(pk = pk)
        except Hiker.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        hiker = self.get_hiker(pk)
        serializer = HikerSerializer(hiker, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        hiker = self.get_hiker(pk)
        serializer = HikerSerializer(hiker, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        hiker = self.get_hiker(pk)
        hiker.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class TripList(APIView):
    # List all Trips or create an Trip
    def get(self, request, format=None):
        trips = Trip.objects.all()
        serializer = TripSerializer(trips, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = TripSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        

class TripDetail(APIView):
    #Retrieve, update, delete a specific Trip

    def get_trip(request, pk):
        try:
            return Trip.objects.get(trip_id = pk)
        except Trip.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        trip = self.get_trip(pk)
        serializer = TripSerializer(trip, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        trip = self.get_trip(pk)
        serializer = TripSerializer(trip, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        trip = self.get_trip(pk)
        trip.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class TripDetailList(APIView):
    # List all Trips or create an Trip
    def get(self, request, format=None):
        tripdetails = TripDetail.objects.all()
        serializer = TripDetailSerializer(tripdetails, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = TripDetailSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TripDetailDetail(APIView):
    #Retrieve, update, delete a specific Trip

    def get_tripdetail(request, pk):
        try:
            return TripDetail.objects.get(tripdetail_id = pk)
        except TripDetail.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        tripdetail = self.get_tripdetail(pk)
        serializer = TripDetailSerializer(tripdetail, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        tripdetail = self.get_tripdetail(pk)
        serializer = TripDetailSerializer(tripdetail, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        tripdetail = self.get_tripdetail(pk)
        tripdetail.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)        