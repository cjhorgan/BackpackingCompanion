from django.contrib.auth.models import AbstractUser
from django.db import models

class Account(AbstractUser):
    username = models.CharField(max_length = 30, unique = True)

    def __str__(self):
        return self.username

class Hiker(models.Model):
    NATURAL_GENDER = (
        ('M', 'Male'),
        ('F', 'Female')
    )
    hiker_first_name = models.CharField(max_length=24)
    hiker_last_name = models.CharField(max_length=24)
    hiker_physical_weight = models.FloatField()
    hiker_age = models.SmallIntegerField()
    hiker_height_inch = models.FloatField()
    hiker_natural_gender = models.CharField(max_length=6,choices=NATURAL_GENDER)
    hiker_account = models.ForeignKey(
        Account,
        on_delete = models.CASCADE,
    )

    @property
    def base_metabolic_rate(self):
        if(self.hiker_natural_gender == 'F'):
            return 655 +(4.35 * self.hiker_physical_weight) + (4.7 * self.hiker_height_inch) - (4.7 * self.hiker_age)
        else:
            return 66 +(6.23 * self.hiker_physical_weight) + (12.7 * self.hiker_height_inch) - (6.8 * self.hiker_age)

class Trip(models.Model):
    trip_id = models.BigAutoField(primary_key=True)
    trip_name = models.CharField(max_length=100,unique=True)
    trip_duration = models.PositiveSmallIntegerField()
    trip_inventories = models.ManyToManyField(
        'inventory.Inventory',
        )
    trip_mealplan = models.ForeignKey(
        'mealplan.MealPlan', 
        on_delete = models.CASCADE)
    trip_hikers = models.ManyToManyField(
        Hiker,
        blank=True)
    isCompleted = models.BooleanField(default=False)