from rest_framework.serializers import ModelSerializer, HyperlinkedModelSerializer
from rest_framework import serializers
from .models import Item, FoodItem, Inventory, Category, ItemQuantity, Category, ItemHistory, ItemCondition

class CategorySerializer(ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ItemSerializer(ModelSerializer):
    class Meta:
        model = Item
        fields = '__all__'

class FoodItemSerializer(ModelSerializer):
    class Meta:
        model = FoodItem
        fields = '__all__'

class ItemHistorySerializer(ModelSerializer):
    class Meta:
        model = ItemHistory
        fields = '__all__'

class ItemQuantitySerializer(ModelSerializer):
    class Meta:
        model= ItemQuantity
        fields = '__all__'

class InventorySerializer(ModelSerializer):
    inventory_items = ItemQuantitySerializer(source = 'itemquantity_set', many = True, read_only = True)
    inventory_weight = serializers.FloatField(read_only = True)

    class Meta:
        model = Inventory
        fields = ('inventory_name', 'inventory_items', 'inventory_weight')
