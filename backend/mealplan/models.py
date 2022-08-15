from django.db import models
from inventory.models import ItemQuantity, Item
from account.models import Hiker

class MealPlan(models.Model):
    mealplan_id = models.BigAutoField(primary_key=True)
    mealplan_hiker = models.ForeignKey(
        Hiker,
        on_delete=models.CASCADE)
    meals = models.ManyToManyField('Meal', through = 'MealSchedule')

    @property
    def total_trip_calories(self):
        calories = 0
        for meal in self.meals.meal:
            calories += meal.total_calories()
        return calories

    #   @property
    #   def est_daily_minimum_cal_required(self):    

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
    MEAL_TYPE_CHOICES = (
        ('Breakfast', '1'),
        ('Snack', '2'),
        ('Lunch', '3'),
        ('Dinner', '4')
    )

    meal = models.ForeignKey(
        Meal,
        on_delete=models.CASCADE
    )
    mealplan = models.ForeignKey(
        MealPlan, 
        on_delete=models.CASCADE
    )
    day = models.PositiveSmallIntegerField()
    meal_type = models.CharField(max_length=9,choices=MEAL_TYPE_CHOICES)





