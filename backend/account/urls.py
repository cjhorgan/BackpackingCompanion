from django.urls import path 
from . import views 

urlpatterns = [
    path('account_routes', views.get_routes),
    path('hiker/', views.HikerList.as_view()),
    path('hiker/<int:pk>/', views.HikerDetail.as_view()),
    path('trip/', views.TripList.as_view()),
    path('trip/<int:pk>/', views.TripDetail.as_view()),
    path('tripdetail/', views.TripDetailList.as_view()),
    path('tripdetail/<int:pk>', views.TripDetailDetail.as_view()),
]