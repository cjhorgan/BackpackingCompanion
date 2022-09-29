from json import dumps
from rest_framework import status
from django.urls import reverse
from account.models import Trip
from account.serializers import TripSerializer
from django.test import TestCase, Client
from datetime import datetime

client = Client()

class TripViewPost(TestCase):
    def setUp(self):
        self.valid_trip = {'trip_name': 'Test_Trip', 'trip_plan_start_datetime': '2023-01-01', 'trip_plan_end_datetime': '2023-01-02'}
        self.invalid_trip = {'trip_name': 'Invalid_Trip', 'trip_plan_start_datetime': '2022-08-01', 'trip_plan_end_datetime': '2022-08-30'}
        self.invalid_trip2 = {'trip_name': 'Invalid_Trip', 'trip_plan_start_datetime': '2023-05-08', 'trip_plan_end_datetime': '2029-01-01'}  
        
    def test_create_valid_trip(self):
        response = client.post(
            '/trip/',
            data = dumps(self.valid_trip),
            content_type = 'application/json'
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_create_invalid_trip(self):
        response = client.post(
            '/trip/',
            data = dumps(self.invalid_trip),
            content_type = 'application/json'
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_invalid_trip2(self):
        response = client.post(
            '/trip/',
            data = dumps(self.invalid_trip2),
            content_type = 'application/json'
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class TripViewGet(TestCase):
    def setUp(self):
        self.trip1 = Trip.objects.create(trip_id = 1, trip_name = 'First Trip', trip_plan_start_datetime = datetime(2023, 8, 19, 1), trip_plan_end_datetime = datetime(2023, 8, 20, 15))
        self.trip2 = Trip.objects.create(trip_id = 2, trip_name = 'Second Trip', trip_plan_start_datetime = datetime(2023, 10, 11, 8, 30), trip_plan_end_datetime = datetime(2023, 11, 1, 0, 0))

    def test_get_valid_trips(self):
        response = client.get('/trip/')
        trips = Trip.objects.all()
        serializer = TripSerializer(trips, many = True)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, serializer.data)

    def test_get_single_trip(self):
        response = client.get('/trip/{0}/'.format(self.trip1.trip_id))
        trip = Trip.objects.get(trip_id = self.trip1.trip_id)
        serializer = TripSerializer(trip)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, serializer.data)

    def test_delete_trip(self):
        response = client.delete('/trip/{0}/'.format(self.trip1.trip_id))
        self.assertEqual(response.status_code, status.HTTP_200_OK)