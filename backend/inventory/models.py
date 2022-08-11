from tkinter import CASCADE
from django.db import models

# Create your models here.

class Category(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=64)
    slug = models.SlugField(default='self', unique=True)
    parent = models.ForeignKey('self', blank=True, null=True, related_name='children', on_delete=models.DO_NOTHING)




class Item(models.Model):
    item_id = models.BigAutoField(primary_key=True)
    item_name = models.CharField(max_length=64)
    item_weight = models.FloatField()
    item_category = models.ForeignKey('Category', null=True, blank=True, on_delete=models.DO_NOTHING)
    item_description = models.CharField(max_length=128)
    isEssential = models.BooleanField(default=False)
    isFavorite = models.BooleanField(default=False)

    def __str__(self):
        return f'Item({self.item_name},{self.item_weight},{self.item_description},{self.item_category})'


class FoodItem(Item):
    calories = models.PositiveSmallIntegerField()
    protein = models.PositiveSmallIntegerField()
    sugar = models.PositiveSmallIntegerField()

    
   
class Inventory(models.Model):
    inventory_id = models.BigAutoField(primary_key=True)
    inventory_name = models.CharField(max_length=30, unique=True)
    inventory_items = models.ManyToManyField(Item, through='ItemQuantity', blank=True,)

    def add_weight(self, items):
        total_weight = 0
        for item in items:
            total_weight += item.total_weight
        return total_weight
    
    @property
    def inventory_weight(self):
        packed_items = ItemQuantity.objects.filter(inventory=self.inventory_id)
        return self.add_weight(packed_items)
        

class ItemQuantity(models.Model):
    inventory = models.ForeignKey(Inventory, on_delete=models.CASCADE)
    item = models.ForeignKey(Item,on_delete=models.CASCADE)
    item_quantity = models.PositiveSmallIntegerField()
    isMultiple = models.BooleanField(default=False)

    @property
    def total_weight(self):
        return self.item_quantity * self.item.item_weight