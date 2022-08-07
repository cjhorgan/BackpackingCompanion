from api.models import UserAccount, Trip, Inventory, MealPlan, Meal, EssentialItem, FavoriteItem, Location, Item, NutritionData
from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from django.db import models

class LocationSerializer(ModelSerializer):
    class Meta:
        model = Location
        fields = ['__all__']

class NutritionDataSerializer(ModelSerializer):
    class Meta:
        model = NutritionData
        fields = ['__all__']

class ItemSerializer(ModelSerializer):
    #nutrition_details = NutritionDataSerializer(read_only=True, required = False)

    class Meta:
        model = Item
        fields = ['id', 'item_name']

class EssentialItemSerializer(ModelSerializer):
    item_details = ItemSerializer(many=True, read_only=True)

    class Meta:
        model = EssentialItem
        fields = ['__all__']

class FavoriteItemSerializer(ModelSerializer):
    item_details = ItemSerializer(many=True, read_only=True)
    class Meta:
        model = FavoriteItem
        fields = ['__all__']

class MealSerializer(ModelSerializer):
    item_details = ItemSerializer(many=True, read_only=True)
    class Meta:
        model = Meal
        fields = ['__all__']

class MealPlanSerializer(ModelSerializer):
    meal_details = MealSerializer(many=True, read_only=True)

    class Meta:
        model = MealPlan
        fields = ['__all__']

class InventoryBasicSerializer(ModelSerializer):
    class Meta:
        model = Inventory
        fields = '__all__'

class InventoryContentsSerializer(ModelSerializer):
    items = serializers.SerializerMethodField()

    class Meta:
        model = Inventory
        fields = ['id', 'inventory_name', 'items']

    def get_items(self, obj):
        inventory_item_query = Item.objects.filter(item_inventory = obj.id)
        serializer = ItemSerializer(inventory_item_query, many = True)
        return serializer.data


class TripSerializer(ModelSerializer):

    class Meta:
        model = Trip
        fields = ['id', 'trip_name', 'trip_start_point', 'trip_end_point', 'trip_account']

class UserAccountSerializer(ModelSerializer):
    inventory_detail = serializers.SerializerMethodField()

    class Meta:
        model = UserAccount
        fields = ['id', 'account_name', 'account_weight', 'inventory_detail']
        depth = 1

    def get_inventory_detail(self, obj):
        account_inventory_query = Inventory.objects.filter(inventory_account = obj.id)
        serializer = InventoryBasicSerializer(account_inventory_query, many = True)
        return serializer.data
