from django.contrib import admin
from django import forms
from .models import UserAccount, Inventory, Trip, MealPlan, Meal, EssentialItem, FavoriteItem, Location, Item, NutritionData
# Register your models here.

# class ItemAdmin(admin.ModelAdmin):
#     list_display = ['item_inventory', 'item_name']
#     fields = ['item_name', 'item_inventory']

# class ItemInline(admin.TabularInline):
#     model = Item

# class InventoryAdmin(admin.ModelAdmin):
#     model = Inventory
#     inlines = [ItemInline,]

        
admin.site.register(UserAccount)
admin.site.register(Inventory)
admin.site.register(Trip)
admin.site.register(MealPlan)
admin.site.register(Meal)
admin.site.register(EssentialItem)
admin.site.register(FavoriteItem)
admin.site.register(Location)
admin.site.register(Item)
admin.site.register(NutritionData)
