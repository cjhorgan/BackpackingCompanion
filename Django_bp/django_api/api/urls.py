from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('useraccount_list/', views.useraccount_list),
    path('useraccount_detail/<str:pk>', views.useraccount_detail),
    path('trip_list/', views.trip_list),
    path('trip_detail/<str:pk>', views.trip_detail),
    path('inventory_basic/<str:pk>', views.inventory_basic),
    path('inventory_list/', views.inventory_list),
    path('inventory_detail/<str:pk>', views.inventory_detail),
    path('mealplan_list/', views.mealplan_list),
    path('mealplan_detail/<str:pk>', views.mealplan_detail),
    path('meal_list/', views.meal_list),
    path('meal_detail/<str:pk>', views.meal_detail),
    path('essentialitem_list/', views.essentialitem_list),
    path('essentialitem_detail/<str:pk>', views.essentialitem_detail),
    path('favoriteitem_list/', views.favoriteitem_list),
    path('favoriteitem_detail/<str:pk>', views.favoriteitem_detail),
    path('item_list/', views.item_list),
    path('item_detail/<str:pk>', views.item_detail),
    path('nutrtiondata_list/', views.nutritiondata_list),
    path('nutrtiondata_detail/<str:pk>', views.nutritiondata_detail)
]