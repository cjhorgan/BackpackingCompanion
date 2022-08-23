from django.db import models
from inventory.models import *
from account.models import Trip

class MealPlan(models.Model):
    mealplan_id = models.BigAutoField(primary_key=True)
    mealplan_hiker = models.ForeignKey('account.Hiker', on_delete=models.CASCADE)
    mealplan_meals = models.ManyToManyField('Meal', through='MealSchedule')
    mealplan_trip = models.ForeignKey(Trip, on_delete = models.CASCADE)
    
    @property
    def total_trip_calories(self):
        calories = 0
        for meal in self.meals.meal:
            calories += meal.total_calories()
        return calories
        
    def convert_mph_ms(self):
        return self.hiker.hiker_avg_speed_flat * .447

    def convert_lb_to_kg(lbs):
        return lbs * 0.45359237

    def pandolf_equation(w,l,v,g,n):
        return 1.5 * w + 2.0*(w + l)*(l/w)**2 + n * (w + l)(1.5 * v**2 + 0.35 * v * g)

    @property
    def est_daily_minimum_cal_required(self):
            if(Trip.objects.get(trip_mealplan = self).trip_trail):
                trip = Trip.objects.get(trip_mealplan = self)
                trip_detail = trip.trip_trail
                
                #find correct hikers inv
                for inv in trip.trip_inventories:
                    if inv.inventory_hiker == self.hiker:
                        inventory = inv
                
                w = self.convert_lb_to_kg(self.mealplan_hiker.hiker_physical_weight)
                l = self.convert_lb_to_kg(inventory.inventory_weight)
                g = trip_detail.avg_grade
                
                if trip_detail.avg_grade >= 11:
                    v = self.convert_mph_ms() - (self.convert_mph_ms() * (2/3))
                elif trip_detail.avg_grade < 11 and trip_detail.avg_grade >= 5.5:
                    v = self.convert_mph_ms() - (self.convert_mph_ms() * (1/3))
                else:
                    v = self.convert_mph_ms()
                n = 1.2
                return (self.pandolf_equation() * 28800) + self.hiker.base_metabolic_rate
            else:
                return 7 * self.convert_lb_to_kg(self.hiker.hiker_physical_weight) * 8
                
class Meal(models.Model):
    meal_id = models.BigAutoField(primary_key=True)
    meal_name = models.CharField(max_length=100)
    meal_components = models.ManyToManyField(
        Item,
        through = 'inventory.ItemQuantity',
        blank=True
    )

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
    mealschedule_id = models.BigAutoField(primary_key=True)

    MEAL_TYPE_CHOICES = (
        ('1', 'Breakfast'),
        ('2', 'Lunch'),
        ('3', 'Dinner'),
        ('4', 'Snack')
    )
    meal = models.ForeignKey(Meal, on_delete=models.CASCADE)
    mealplan= models.ForeignKey(MealPlan, on_delete=models.CASCADE)
    day = models.PositiveSmallIntegerField()
    meal_type = models.CharField(max_length=9,choices=MEAL_TYPE_CHOICES)


