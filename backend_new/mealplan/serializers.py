from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from .models import MealPlan, Meal, MealSchedule

class MealSerializer(ModelSerializer):
    total_calories = serializers.IntegerField(read_only = True)
    total_protein = serializers.IntegerField(read_only = True)
    total_sugar = serializers.IntegerField(read_only = True)

    class Meta:
        model = Meal
        fields = '__all__'

class MealScheduleSerializer(ModelSerializer):
    class Meta:
        model = MealSchedule
        fields = '__all__'

class MealPlanSerializer(ModelSerializer):
    total_trip_calories = serializers.IntegerField(read_only = True)
    est_daily_min_cal_req = serializers.FloatField(read_only = True)
    total_protein = serializers.IntegerField(read_only = True)
    total_sugar = serializers.IntegerField(read_only = True)
    meals = MealScheduleSerializer(source = 'mealschedule_set', many = True, read_only = True)

    class Meta:
        model = MealPlan
        fields = ('mealplan_id', 'total_trip_calories', 'est_daily_min_cal_req', 'total_protein', 'total_sugar', 'meals')