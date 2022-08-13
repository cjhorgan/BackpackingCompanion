from pyexpat import model
from secrets import choice
from django.db import models
from inventory.models import *
# Create your models here.

class Meal(models.Model):
    meal_id = models.BigAutoField(primary_key=True)
    meal_name = models.CharField(max_length=100)
    meal_components = models.ManyToManyField(Item, through='ItemQuantity', blank=True)
    meal_plan = models.ManyToManyField('MealSchedule', on_delete=models.DO_NOTHING)


    @property
    def total_calories(self):
        food_items: ItemQuantity.objects.filter(meal=self.meal_id)
        calories = 0
        for food in food_items:
            calories += food.calc_calories()
        return calories

    @property
    def total_protein(self):
        food_items: ItemQuantity.objects.filter(meal=self.meal_id)
        protein = 0
        for food in food_items:
            protein += food.calc_protein()
        return protein
    
    @property
    def total_sugar(self):
        food_items: ItemQuantity.objects.filter(meal=self.meal_id)
        sugar = 0
        for food in food_items:
            sugar += food.calc_sugar()
        return sugar

class MealSchedule(models.Model):
    MEAL_TYPE_CHOICES = (
        'Breakfast',
        'Snack',
        'Lunch',
        'Dinner'
    )

    meal = models.ForeignKey(Meal, on_delete=models.CASCADE)
    mealplan= models.ForeignKey(MealPlan, on_delete=models.CASCADE)
    day = models.PositiveSmallIntegerField()
    meal_type = models.CharField(max_length=9,choices=MEAL_TYPE_CHOICES)


class MealPlan(models.Model):
    mealplan_id = models.BigAutoField(primary_key=True)
    hiker = models.ForeignKey(Hiker, on_delete=models.CASCADE)
    meals = models.ManyToManyField(Meal, through='MealSchedule')

    @property
    def total_trip_calories(self):
        calories = 0
        for meal in self.meals.meal:
            calories += meal.total_calories()
        return calories
    
 #   @property
 #   def est_daily_minimum_cal_required(self):





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

    @property
    def base_metabolic_rate(self):
        if((self.hiker_natural_gender == 'F') or(self.hiker_natural_gender == 'Female')):
            return 655 +(4.35 * self.hiker_physical_weight) + (4.7 * self.hiker_height_inch) - (4.7 * self.hiker_age)
        else:
            return 66 +(6.23 * self.hiker_physical_weight) + (12.7 * self.hiker_height_inch) - (6.8 * self.hiker_age)

    



class Trip(models.Model):
    trip_id = models.BigAutoField(primary_key=True)
    trip_name = models.CharField(max_length=100,unique=True)
    trip_duration = models.PositiveSmallIntegerField()
    trip_hikers = models.ManyToManyField(Inventory, on_delete=models.DO_NOTHING)
    trip_mealplan = models.ForeignKey('MealPlan', on_delete=models.CASCADE)
    trip_hikers = models.ManyToManyField(Hiker, blank=True)
    isCompleted = models.BooleanField(default=False)
