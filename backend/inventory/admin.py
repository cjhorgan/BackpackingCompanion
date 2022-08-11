from django.contrib import admin

# Register your models here.

from .models import Category, Item, FoodItem, Inventory , ItemQuantity
admin.site.register(Category)
admin.site.register(Item)
admin.site.register(FoodItem)
admin.site.register(Inventory)
admin.site.register(ItemQuantity)
