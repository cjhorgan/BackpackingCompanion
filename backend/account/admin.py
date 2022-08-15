from django.contrib import admin
from .models import Account, Hiker, Trip

# Register your models here.
admin.site.register(Account)
admin.site.register(Hiker)
admin.site.register(Trip)