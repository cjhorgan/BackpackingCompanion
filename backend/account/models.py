from django.contrib.auth.models import AbstractUser
from django.core.exceptions import ValidationError
from django.db import models
from django.utils.translation import gettext_lazy as _
from datetime import datetime, timedelta
from math import floor

class Hiker(models.Model):
    NATURAL_GENDER = (
        ('M', 'Male'),
        ('F', 'Female')
    )

    hiker_id = models.BigAutoField(primary_key=True)
    hiker_first_name = models.CharField(max_length = 24)
    hiker_last_name = models.CharField(max_length = 24)
    hiker_physical_weight = models.FloatField()
    hiker_age = models.SmallIntegerField()
    hiker_height_inch = models.FloatField()
    hiker_natural_gender = models.CharField(max_length = 6, choices = NATURAL_GENDER)
    hiker_avg_speed_flat = models.FloatField(blank = True, null = True)
    hiker_trips_completed = models.IntegerField(default = 0)

    @property
    def base_metabolic_rate(self):
        if(self.hiker_natural_gender == 'F'):
            return 655 +(4.35 * self.hiker_physical_weight) + (4.7 * self.hiker_height_inch) - (4.7 * self.hiker_age)
        else:
            return 66 +(6.23 * self.hiker_physical_weight) + (12.7 * self.hiker_height_inch) - (6.8 * self.hiker_age)

    def hiker_on_trip_complete(self):
        self.hiker_trips_completed += 1
        self.save(update_fields=['hiker_trips_completed'])

    def __str__(self):
        return f'Hiker = {self.hiker_first_name}, {self.hiker_last_name}; Num_Trips = {self.hiker_trips_completed}'

class Trip(models.Model):
    trip_id = models.BigAutoField(primary_key=True)
    trip_name = models.CharField(max_length=100,unique=True)
    trip_plan_start_datetime = models.DateTimeField()
    trip_plan_end_datetime = models.DateTimeField()
    trip_hikers = models.ManyToManyField(Hiker, blank=True)
    trip_active_start_datetime = models.DateTimeField(blank = True, null = True)
    
    trip_active_end_datetime = models.DateTimeField(blank = True, null = True)

    is_active = models.BooleanField(default = False)
    is_complete = models.BooleanField(default = False)

    @property
    def trip_duration(self):
        duration = None
        if self.is_active:
            duration = datetime.now() - self.trip_active_start_datetime
        if self.is_complete:
            duration = self.trip_active_end_datetime - self.trip_active_start_datetime
        return duration

    def trip_on_complete(self):
        if not self.is_complete:
            self.trip_active_end_datetime = datetime.now()
            hikers = self.trip_hikers.all()
            for hiker in hikers:
                hiker.hiker_on_trip_complete()
            self.is_complete = True
        else:
            raise Exception("Trip has already been completed")


    ## CHECKS TO SEE IF START DATETIME IS BEFORE END DATETIME
    ## CHECKS TO SEE IF START DATETIME IS BEFORE TODAY
    ## CHECKS TO SEE IF PROPOSED DATE OVERLAPS WITH ANY EXISTING, FUTURE TRIPS
    # def clean(self, *args, **kwargs):
        
    #     start = self.trip_plan_start_datetime
    #     end = self.trip_plan_end_datetime

    #     today = datetime.now()

    #     #Calculates approx 5 years from today
    #     MAX_FUTURE_YEARS = 5
    #     if floor(int((end - today).days / 365.2425)) >= MAX_FUTURE_YEARS:
    #         raise ValidationError({'trip_plan_end_datetime': _('Trip end date must be less than 5 years in the future')})

    #     if start < today:
    #         raise ValidationError({'trip_plan_start_datetime': _("Trip cannot be scheduled in the past")})
        
    #     proposed_duration = end - start
    #     if proposed_duration < timedelta(minutes=30):
    #         raise ValidationError({'trip_plan_end_datetime': _("End date & time must be at least 30 minutes later than start date & time")})

        
    #     ##Check if proposed start date is between beginning and end of existing objects
    #     ##Check if proposed end date is between beginning and end of existing objects
    #     ##Check if any existing trips have start and end dates that fall between the proposed start and end dates (start > p.start && end < p.end)

    #     if not Trip.objects.exists():
    #         return super(Trip, self).clean(*args, **kwargs)
    #     elif Trip.objects.filter(trip_plan_start_datetime__lte=start, trip_plan_end_datetime__gte=end).exists():
    #         raise ValidationError({'trip_plan_start_datetime, trip_plan_end_datetime': _('Proposed Trip dates fall within existing Trip date range')})
    #     elif Trip.objects.filter(trip_plan_start_datetime__lte=start, trip_plan_end_datetime__gte=start).exists():
    #         raise ValidationError({'trip_plan_start_datetime': _('Proposed start date falls within existing Trip date range')})
    #     elif Trip.objects.filter(trip_plan_start_datetime__lte=end, trip_plan_end_datetime__gte=end).exists():
    #         raise ValidationError({'trip_plan_end_datetime': _('Proposed end date falls within existing Trip date range')})
    #     elif Trip.objects.filter(trip_plan_start_datetime__gte=start, trip_plan_end_datetime__lte=end).exists():
    #         raise ValidationError("Proposed Trip overlaps existing Trip date range")
    #     else:
    #         return super(Trip, self).clean(*args, **kwargs)

    # def save(self, *args, **kwargs):
    #     try:
    #         self.full_clean()
    #     except ValidationError as error:
    #         print(error)
    #         return
    #     return super(Trip, self).save(*args, **kwargs)
       
    def __str__(self):
        return f'Trip = {self.trip_id}, {self.trip_name}, {self.trip_plan_start_datetime.strftime("%Y-%m-%d %H:%M:%S")}, {self.trip_plan_end_datetime.strftime("%Y-%m-%d %H:%M:%S")}'

#PLACEHOLDER
class TripDetail(models.Model):
    tripdetail_id = models.BigAutoField(primary_key=True)
    tripdetail_trip = models.ForeignKey(Trip, on_delete = models.CASCADE, blank = True, null = True)
    stuff = models.TextField()
    avg_grade = models.FloatField()