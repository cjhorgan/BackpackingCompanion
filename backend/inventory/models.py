from lib2to3.pgen2.token import PERCENT
from random import choices
from tkinter import CASCADE
from django.db import models
from Trip.models import Meal , Hiker

# Create your models here.

class Category(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=64)
    slug = models.SlugField(default='self', unique=True)
    #parent = models.ForeignKey('self', blank=True, null=True, related_name='children', on_delete=models.DO_NOTHING)

class Condition(models.Model):
    COND_CHOICES = (
        ('perfect', 'Perfect')
        ('good', 'Good'),
        ('worn', 'Worn'),
        ('attention','Attention'),
        ('replace','Replace')
    )

    PERCENTAGE_REMAIN = ('25%','50%', '75%', '100%')

    condition_id = models.BigAutoField(primary_key=True)
    item_condition = models.CharField(max_length=9, choices=COND_CHOICES)
    isConsumable = models.BooleanField(default=False)
    item_percentage_remaining=models.CharField(max_length=4, choices=PERCENTAGE_REMAIN)


class Item(models.Model):

    item_id = models.BigAutoField(primary_key=True)
    item_name = models.CharField(max_length=64)
    item_weight = models.FloatField()
    item_category = models.ForeignKey('Category', null=True, blank=True, on_delete=models.DO_NOTHING)
    item_hiker_owner = models.ForeignKey('Hiker', on_delete=models.DO_NOTHING)
    item_description = models.CharField(max_length=128)
    item_creation_date = models.DateTimeField(auto_now_add=True)
    item_last_use_date = models.DateTimeField(auto_now=True)
    item_last_use_condition = models.ForeignKey('Condition',on_delete=models.DO_NOTHING)
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
    inventory_hiker = models.ForeignKey(Hiker, on_delete=models.DO_NOTHING)

    def add_weight(self, items):
        total_weight = 0
        for item in items:
            total_weight += item.total_weight
        return total_weight
    
    @property
    def inventory_weight(self):
        packed_items = ItemQuantity.objects.filter(inventory=self.inventory_id)
        return self.add_weight(packed_items)

    @property
    def carried_weight_percentage(self):
        return (self.inventory_weight / self.inventory_hiker.hiker_physical_weight) * 100
        

class ItemQuantity(models.Model):
    inventory = models.ForeignKey(Inventory, on_delete=models.CASCADE)
    item = models.ForeignKey(Item,on_delete=models.CASCADE)
    meal = models.ForeignKey(Meal, on_delete=models.DO_NOTHING, blank=True, null=True)
    item_quantity = models.PositiveSmallIntegerField()
    isMultiple = models.BooleanField(default=False)
    item_note = models.TextField()

    def calc_calories(self):
        if(type(self.item) == FoodItem):
            return self.item_quanitiy * self.item.calories
        else:
            return 
    
    def calc_protein(self):
        if(type(self.item) == FoodItem):
            return self.item_quanitiy * self.item.protein
        else:
            return 

    def calc_sugar(self):
        if(type(self.item) == FoodItem):
            return self.item_quanitiy * self.item.sugar
        else:
            return 
    @property
    def total_weight(self):
        return self.item_quantity * self.item.item_weight