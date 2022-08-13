from django.contrib import admin

# Register your models here.
from .models import Meal, MealSchedule, Hiker ,Trip, MealPlan

admin.site.register(Meal)
admin.site.register(MealSchedule)
admin.site.register(Hiker)
admin.site.register(Trip)
admin.site.register(MealPlan)