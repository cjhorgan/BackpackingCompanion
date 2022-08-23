from django.http import Http404
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from .serializers import MealSerializer, MealPlanSerializer, MealScheduleSerializer
from .models import Meal, MealPlan, MealSchedule

@api_view(['Get'])
def get_routes(request):
    routes = [
        {
            'Endpoint' : 'meal',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all Meals'
        },
        {
            'Endpoint' : 'meal/<str:id>',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns a single Meal'
        },
        {
            'Endpoint' : 'mealplan',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all MealPlans'
        },
        {
            'Endpoint' : 'mealplan/<str:id>',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an single MealPlan'
        },
        {
            'Endpoint' : 'mealschedule',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all MealSchedules'
        },
        {
            'Endpoint' : 'mealschedule/<str:id>',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an single MealSchedule'
        },
    ]
    return Response(routes)

class MealList(APIView):
    # List All Items or create an item
    def get(self, request, format=None):
        meals = Meal.objects.all()
        serializer = MealSerializer(meals, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = MealSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MealDetail(APIView):
    #Retrieve, update, delete a specific item

    def getMeal(request, pk):
        try:
            return Meal.objects.get(meal_id=pk)
        except Meal.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        meal = self.getMeal(pk)
        serializer = MealSerializer(meal, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        meal = self.getMeal(pk)
        serializer = MealSerializer(meal, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        item = self.getMeal(pk)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class MealPlanList(APIView):
    # List All Items or create an item
    def get(self, request, format=None):
        mealplans = MealPlan.objects.all()
        serializer = MealPlanSerializer(mealplans, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = MealPlanSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MealPlanDetail(APIView):
    #Retrieve, update, delete a specific item

    def getMealPlan(request, pk):
        try:
            return MealPlan.objects.get(mealplan_id=pk)
        except MealPlan.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        mealplan = self.getMealPlan(pk)
        serializer = MealPlanSerializer(mealplan, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        mealplan = self.getMealPlan(pk)
        serializer = MealPlanSerializer(mealplan, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        item = self.getMealPlan(pk)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class MealScheduleList(APIView):
    # List All Items or create an item
    def get(self, request, format=None):
        mealschedules = MealSchedule.objects.all()
        serializer = MealScheduleSerializer(mealschedules, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = MealScheduleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MealScheduleDetail(APIView):
    #Retrieve, update, delete a specific item

    def getMealSchedule(request, pk):
        try:
            return MealSchedule.objects.get(mealschedule_id = pk)
        except MealSchedule.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        mealschedule = self.getMealSchedule(pk)
        serializer = MealScheduleSerializer(mealschedule, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        mealschedule = self.getMealSchedule(pk)
        serializer = MealScheduleSerializer(mealschedule, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        item = self.getMealSchedule(pk)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
