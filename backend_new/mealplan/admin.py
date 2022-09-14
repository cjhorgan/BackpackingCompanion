from django.contrib import admin
from .models import Meal, MealPlan, MealSchedule, MealDay

# Register your models here.
admin.site.register(Meal)
admin.site.register(MealPlan)
admin.site.register(MealSchedule)
admin.site.register(MealDay)