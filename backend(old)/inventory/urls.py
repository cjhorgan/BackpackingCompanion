from django.urls import path 
from . import views 

urlpatterns = [
    path('', views.getRoutes),
    path('items/', views.ItemList.as_view()),
    path('items/<int:pk>/', views.ItemDetail.as_view()),
    path('fooditems/', views.FoodItemList.as_view()),
    path('fooditems/<int:pk>/', views.FoodItemDetail.as_view()),
    path('inventory/', views.InventoryList.as_view()),
    path('inventory/<int:pk>/', views.InventoryDetail.as_view()),
]