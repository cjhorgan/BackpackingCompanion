from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from account.models import Hiker, Trip, TripDetail
from math import floor
from datetime import datetime, timedelta
from account.exceptions import *

class HikerSerializer(ModelSerializer):
    # base_metabolic_rate = serializers.FloatField()

    class Meta:
        model = Hiker
        fields = '__all__'

class TripSerializer(ModelSerializer):
  
    def validate(self, data):
        print(data)
        start = data['trip_plan_start_datetime']
        end = data['trip_plan_end_datetime']
        today = datetime.now()

        #Checks if end date is more than approx 5 years in future:
        #Check is imperfect because of leap years

        MAX_FUTURE_YEARS = 5
        if floor(int((end - today).days / 365.2425)) >= MAX_FUTURE_YEARS:
            raise EndDateFutureConflict()
            # raise ValidationError({'trip_plan_end_datetime': _('Trip end date must be less than 5 years in the future')})

        if start < today:
            raise StartDatePastConflict()
            # raise ValidationError({'trip_plan_start_datetime': _("Trip cannot be scheduled in the past")})
        proposed_duration = end - start
        if proposed_duration < timedelta(minutes=30):
            raise TripDurationConflict()
            # raise ValidationError({'trip_plan_end_datetime': _("End date & time must be at least 30 minutes later than start date & time")})
        
        ###Check if proposed start date is between beginning and end of existing objects
        ###Check if proposed end date is between beginning and end of existing objects
        ###Check if any existing trips have start and end dates that fall between the proposed start and end dates (start > p.start && end < p.end)

        elif Trip.objects.filter(trip_plan_start_datetime__lte=start, trip_plan_end_datetime__gte=end).exists():
            raise StartEndDateConflict()

            # raise ValidationError({'trip_plan_start_datetime, trip_plan_end_datetime': _('Proposed Trip dates fall within existing Trip date range')})
        elif Trip.objects.filter(trip_plan_start_datetime__lte=start, trip_plan_end_datetime__gte=start).exists():
            raise StartDateConflict()

            # raise ValidationError({'trip_plan_start_datetime': _('Proposed start date falls within existing Trip date range')})
        elif Trip.objects.filter(trip_plan_start_datetime__lte=end, trip_plan_end_datetime__gte=end).exists():
            raise EndDateConflict()

            # raise ValidationError({'trip_plan_end_datetime': _('Proposed end date falls within existing Trip date range')})
        elif Trip.objects.filter(trip_plan_start_datetime__gte=start, trip_plan_end_datetime__lte=end).exists():
            raise StartEndDateConflict()

            # raise ValidationError("Proposed Trip overlaps existing Trip date range")

        return data
            
    class Meta:
        model = Trip
        fields = '__all__'
        read_only_fields = ['is_complete']
    

class TripDetailSerializer(ModelSerializer):
    class Meta:
        model = TripDetail
        fields = '__all__'