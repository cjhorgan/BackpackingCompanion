from django.urls import path 
from . import views 

urlpatterns = [
    path('inventory_routes', views.get_routes),
    path('category/', views.CategoryList.as_view()),
    path('category/<int:pk>', views.CategoryDetail.as_view()),
    path('item/', views.ItemList.as_view()),
    path('item/<int:pk>', views.ItemDetail.as_view()),
    path('fooditem/', views.FoodItemList.as_view()),
    path('fooditem/<int:pk>', views.FoodItemDetail.as_view()),
    path('inventory/', views.InventoryList.as_view()),
    path('inventory/<int:pk>', views.InventoryDetail.as_view()),
    path('itemhistory/', views.ItemHistoryList.as_view()),
    path('itemhistory/<int:pk>', views.ItemHistoryDetail.as_view()),
    path('itemquantity/', views.ItemQuantityList.as_view()),
    path('itemquantity/<int:pk>', views.ItemQuantityDetail.as_view())
]