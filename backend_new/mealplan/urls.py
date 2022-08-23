from django.urls import path 
from . import views 

urlpatterns = [
    path('mealplan_routes', views.get_routes),
    path('meal/', views.MealList.as_view()),
    path('meal/<int:pk>/', views.MealDetail.as_view()),
    path('mealplan/', views.MealPlanList.as_view()),
    path('mealplan/<int:pk>/', views.MealPlanDetail.as_view()),
    path('mealschedule/', views.MealScheduleList.as_view()),
    path('mealschedule/<int:pk>/', views.MealScheduleDetail.as_view()),
]