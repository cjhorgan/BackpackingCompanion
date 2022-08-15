from django.contrib import admin
from .models import Category, ItemCondition, ItemHistory, Item, Inventory, FoodItem, ItemQuantity

# Register your models here.
admin.site.register(Category)
admin.site.register(ItemCondition)
admin.site.register(ItemHistory)
admin.site.register(Item)
admin.site.register(Inventory)
admin.site.register(FoodItem)
admin.site.register(ItemQuantity)
