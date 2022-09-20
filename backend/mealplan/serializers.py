from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from .models import MealDay, MealPlan, Meal, MealSchedule

class MealSerializer(ModelSerializer):
    total_calories = serializers.IntegerField(read_only = True)
    total_protein = serializers.IntegerField(read_only = True)
    total_sugar = serializers.IntegerField(read_only = True)
    class Meta:
        model = Meal
        fields = '__all__'

class MealScheduleSerializer(ModelSerializer):
    MealSerializer()
    class Meta:
        model = MealSchedule
        fields = '__all__'

class MealDaySerializer(ModelSerializer):
    daily_caloric_scheduled = serializers.IntegerField(read_only = True)
    daily_protein_scheduled = serializers.IntegerField(read_only = True)
    daily_sugar_scheduled = serializers.IntegerField(read_only = True)
    class Meta:
        model = MealDay
        fields = '__all__'

class MealPlanSerializer(ModelSerializer):
    total_trip_calories = serializers.IntegerField(read_only = True)
    est_daily_minimum_cal_required = serializers.IntegerField(read_only = True)
    total_protein = serializers.IntegerField(read_only = True)
    total_sugar = serializers.IntegerField(read_only = True)
    meals = MealScheduleSerializer(source = 'mealschedule_set', many = True)

    class Meta:
        model = MealPlan
        fields = '__all__'
