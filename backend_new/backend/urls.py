from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('account.urls')),
    path('', include('inventory.urls')),
    path('', include('location.urls')),
    path('', include('mealplan.urls')),
    #path('', include('report.urls'))
]