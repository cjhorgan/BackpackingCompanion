from django.test import TestCase
from account.models import Trip, Hiker
from datetime import datetime, timedelta
from django.core.exceptions import ValidationError
from time import sleep
# Create your tests here.

DTE = "Does Trip Exist?  "

class AccountModelsTesting(TestCase):
    @classmethod
    def setUpTestData(cls):
        Trip.objects.create(trip_id = 1, trip_name = 'First Trip', trip_plan_start_datetime = datetime(2023, 8, 19, 1), trip_plan_end_datetime = datetime(2023, 8, 20, 15))
        Trip.objects.create(trip_id = 2, trip_name = 'Second Trip', trip_plan_start_datetime = datetime(2023, 10, 11, 8, 30), trip_plan_end_datetime = datetime(2023, 11, 1, 0, 0))
        Trip.objects.create(trip_id = 3, trip_name = 'Third Trip', trip_plan_start_datetime = datetime(2023, 10, 3), trip_plan_end_datetime = datetime(2023, 10, 6))
        Hiker.objects.create(hiker_first_name = 'Ben', hiker_last_name = 'Chen', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")
        Hiker.objects.create(hiker_first_name = 'John', hiker_last_name = 'Abbot', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")
        Hiker.objects.create(hiker_first_name = 'Steve', hiker_last_name = 'Bishop', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")
        Hiker.objects.create(hiker_first_name = 'King', hiker_last_name = 'Fisher', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")
        Hiker.objects.create(hiker_first_name = 'Queen', hiker_last_name = 'Elizabeth', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")
        Hiker.objects.create(hiker_first_name = 'FrankThe', hiker_last_name = 'Tank', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")
        Hiker.objects.create(hiker_first_name = 'Jennifer', hiker_last_name = 'Yennifer', hiker_physical_weight = "210", hiker_age = "33", hiker_height_inch = "72", hiker_natural_gender = "M")

    # Tests trip creation
    def test_trip_data_validation(self): 
        print("\ninside test_trip_data_validation")
        trip1 = Trip.objects.get(trip_id=1)
        self.assertEqual('First Trip', trip1.trip_name)
        print(DTE + str(trip1))

    # Tests attempting to create a trip with a start date in the past
    def test_trip_in_past(self):
        print("\ninside test_trip_in_past")
        try:
            Trip.objects.create(trip_name = 'Past', trip_plan_start_datetime = datetime(2021, 1, 1), trip_plan_end_datetime = datetime(2021, 1, 2))
        except ValidationError as error:
            print(error)
        
        print(DTE + str(Trip.objects.filter(trip_name = 'Past').exists()))

    # Tests when only the starting date falls within an existing trip's date range
    def test_trip_start_date_overlap(self):
        print("\ninside test_trip_start_date_overlap")
        try:
            Trip.objects.create(trip_name = 'Start overlap', trip_plan_start_datetime = datetime(2023, 10, 20), trip_plan_end_datetime = datetime(2023, 12, 1))
        except ValidationError as error:
            print(error)

        print(DTE + str(Trip.objects.filter(trip_name = 'Start overlap').exists()))

    # Tests when only the end date falls within an existing trip's date range
    def test_trip_end_date_overlap(self):
        print("\ninside test_trip_end_date_overlap")
        try:
            Trip.objects.create(trip_name = 'End overlap', trip_plan_start_datetime = datetime(2023, 9, 1), trip_plan_end_datetime = datetime(2023, 10, 12))
        except ValidationError as error:
            print(error)

        print(DTE + str(Trip.objects.filter(trip_name = 'End overlap').exists()))  

    # Tests when both the start and end date fall within an existing trip's date range
    def test_trip_both_dates_between_existing(self):
        print("\ninside test_trip_both_dates_between_existing")
        try:
            Trip.objects.create(trip_name = 'Between', trip_plan_start_datetime = datetime(2023, 8, 20, 1), trip_plan_end_datetime = datetime(2023, 8, 20, 10))
        except ValidationError as error:
            print(error)

        print(DTE + str(Trip.objects.filter(trip_name = 'Between').exists()))
    
    # Tests when an existing trip falls within the proposed trip's date range
    def test_existing_trip_between_proposed_dates(self):
        print("\ninside test_existing_trip_between_proposed_dates")
        try:
            Trip.objects.create(trip_name = 'Existing between', trip_plan_start_datetime = datetime(2023, 10, 2), trip_plan_end_datetime = datetime(2023, 10, 7))
        except ValidationError as error:
            print(error)
        
        print(DTE + str(Trip.objects.filter(trip_name = 'Existing between').exists()))

    # Tests when trip duration is too short (less than 30 minutes)
    def test_trip_proposed_duration_too_short(self):
        print("\ninside test_trip_proposed_duration_too_short")
        try: 
            Trip.objects.create(trip_name = 'Shorty', trip_plan_start_datetime = datetime(2025, 11, 1, 1), trip_plan_end_datetime = datetime(2025, 11, 1, 1, 20))
        except ValidationError as error:
            print(error)

        print(DTE + str(Trip.objects.filter(trip_name = 'Shorty').exists()))    

    # Tests when trip start date is after trip end date (Throws the error for being too short, timedelta is negative)
    def test_trip_start_after_end(self):
        print("\ninside test_trip_start_after_end")
        try:
            Trip.objects.create(trip_name = 'Start after end', trip_plan_start_datetime = datetime (2024, 10, 1), trip_plan_end_datetime = datetime(2024, 9, 20))
        except ValidationError as error:
            print(error)

        print(DTE + str(Trip.objects.filter(trip_name = 'Start after end').exists()))

    # Tests when trip end date is more than 5 years in future
    def test_trip_end_date_too_far_in_future(self):
        print("\ninside test_trip_end_date_too_far_in_future")
        try:
            Trip.objects.create(trip_name = 'Futuristic', trip_plan_start_datetime = datetime (2027, 8, 1), trip_plan_end_datetime = datetime(2027, 8, 21))
        except ValidationError as error:
            print (error)

        print(DTE + str(Trip.objects.filter(trip_name = 'Futuristic').exists()))

    # Tests trip_duration functionality
    def test_trip_duration(self):
        print("\ninside test_trip_duration")
        trip1 = Trip.objects.get(trip_id = 1)
        print("trip duration when active and complete are False = " + str(trip1.trip_duration))
        trip1.is_active = True
        trip1.trip_active_start_datetime = datetime.now()
        trip1.trip_active_end_datetime = trip1.trip_active_start_datetime + timedelta(hours = 3, minutes = 30)
        print("trip active start time = " + str(trip1.trip_active_start_datetime))
        print("trip active end time = " + str(trip1.trip_active_end_datetime))
        print("duration after setting active to True = " + str(trip1.trip_duration))
        trip1.is_complete = True
        print("duration after setting complete to True = " + str(trip1.trip_duration))
        trip1.is_complete = False
        # sleep(1)
        # print("duration after setting complete to False and waiting for 1 second = " + str(trip1.trip_duration))
        # sleep(1)
        # print("duration after waiting 1 more second = " + str(trip1.trip_duration))

    #test hiker creation && printing
    def test_print_hikers(self):
        hikers = Hiker.objects.all()

        
        for hiker in hikers:
            hid = hiker.hiker_id
            print("\n" + str(hiker) + " " + str(Hiker.objects.filter(hiker_id = hid).exists()))

    def test_trips(self):
        trips = Trip.objects.all()
        for trip in trips:
            print("\nTrip ID = " + str(trip.trip_id))
            
    def test_attaching_hikers_to_trips(self):
        hikers = Hiker.objects.all()
        trip1 = Trip.objects.get(trip_id = 1)
        trip2 = Trip.objects.get(trip_id = 2)

        for hiker in hikers:
            if hiker.hiker_id % 2 == 0:
                trip1.trip_hikers.add(hiker)
            else:
                trip2.trip_hikers.add(hiker)

        t1h = trip1.trip_hikers.all()
        t2h = trip2.trip_hikers.all()

        for hiker in t1h:
            print("\n" + str(hiker) + " attached to Trip1")
        for hiker in t2h:
            print("\n" + str(hiker) + " attached to Trip2")

    def test_completing_attached_trips(self):
        hikers = Hiker.objects.all()
        trip1 = Trip.objects.get(trip_id = 1)
        trip2 = Trip.objects.get(trip_id = 2)

        for hiker in hikers:
            if hiker.hiker_id % 2 == 0:
                trip1.trip_hikers.add(hiker)
            else:
                trip2.trip_hikers.add(hiker)

        trip1.trip_on_complete()
        trip2.trip_on_complete()
        
        print("\n trips completed")
        
        for hiker in hikers:
            hiker.refresh_from_db()
            print("\n" + str(hiker))
        
        try:
            trip1.trip_on_complete()
        except Exception as error:
            print(error)

        try:
            trip2.trip_on_complete()
        except Exception as error:
            print(error)

        for hiker in hikers:
            hiker.refresh_from_db()
            print("\n" + str(hiker))
