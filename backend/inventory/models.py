from django.db import models
from datetime import datetime

class Category(models.Model):
    category_id = models.BigAutoField(primary_key=True)
    category_name = models.CharField(max_length=64)
    category_slug = models.SlugField(default='self', unique=True)
    #parent = models.ForeignKey('self', blank=True, null=True, related_name='children', on_delete=models.DO_NOTHING)

class ItemCondition(models.Model):
    COND_CHOICES = (
        ('perfect', 'Perfect'),
        ('good', 'Good'),
        ('worn', 'Worn'),
        ('attention','Attention'),
        ('replace','Replace')
    )

    PERCENTAGE_REMAIN = (
        ('25%', '25'),
        ('50%', '50'),
        ('75%', '75'),
        ('100%', '100')
    )

    condition_id = models.BigAutoField(primary_key=True)
    item_condition_item = models.ForeignKey('Item', on_delete = models.CASCADE)
    item_condition = models.CharField(max_length=9, choices=COND_CHOICES, default = 'Perfect')
    isConsumable = models.BooleanField(default=False)
    item_percentage_remaining=models.CharField(max_length=4, choices=PERCENTAGE_REMAIN, default = '100')
    item_expiration_date = models.DateField(blank = True, null = True)

    @property
    def is_expired(self):
        cur_date = datetime.now()
        return cur_date > self.item_expiration_date

class ItemHistory(models.Model):
    item_history_item = models.ForeignKey('Item', on_delete = models.CASCADE)
    item_history_creation_date = models.DateTimeField(auto_now_add=True)
    item_history_last_use_date = models.DateTimeField(auto_now=True, blank = True, null = True)
    item_history_last_use_condition = models.TextField(blank = True, null = True)

    def __str__(self):
        return f'History = {self.item_history_creation_date}, {self.item_history_item.item_name}, {self.item_history_last_use_date}'

class Item(models.Model):
    CAT_CHOICES = {
        ('Miscellaneous', 'Miscellaneous'),
        ('Food', 'Food'),
        ('Clothing', 'Clothing'),
        ('Medical', 'Medical'),
        ('Hiking Gear', 'Hiking Gear'),
    }
    item_id = models.BigAutoField(primary_key=True)
    item_name = models.CharField(max_length=64)
    item_weight = models.FloatField()
    item_category = models.CharField(
        max_length = 15,
        choices = CAT_CHOICES,
        default = 'Miscellaneous')
    item_hiker = models.ForeignKey(
        'account.Hiker', 
        on_delete=models.DO_NOTHING,
        blank = True,
        null = True,
    )

    item_description = models.CharField(max_length=128)
   
    isEssential = models.BooleanField(default=False)
    isFavorite = models.BooleanField(default=False)

    def __str__(self):
        return f'Item({self.item_name},{self.item_weight},{self.item_description},{self.item_category})'
    
    def str_for_list(self):
        return f'{self.item_name}'

class Inventory(models.Model):
    inventory_id = models.BigAutoField(primary_key=True)
    inventory_name = models.CharField(max_length=30, unique=True)
    inventory_items = models.ManyToManyField(
        Item,
        through = 'ItemQuantity',)
    inventory_hiker = models.ForeignKey(
        'account.Hiker', 
        on_delete = models.DO_NOTHING, 
        related_name = 'inv_hiker',
    )
    inventory_trip = models.ForeignKey(
        'account.Trip',
        on_delete = models.DO_NOTHING,
        related_name = 'inv_trip',
    )

    def make_list(self):
        item_list = ''
        items = self.inventory_items.all()
        for item in items:
            item_list = item_list + (str(item.str_for_list()) + ';')
        print(item_list)
        return item_list

    def add_weight(self, items):
        total_weight = 0
        for item in items:
            total_weight += item.total_weight
        return total_weight
    
    def inventory_on_trip_complete(self):
        print(self)
        date = datetime.now()
        date = date.strftime('%Y-%m-%d')
        items = self.inventory_items.all()
        for item in items:
            history = item.item_history
            history.item_history_last_use_date = date
    
    @property
    def inventory_weight(self):
        packed_items = ItemQuantity.objects.filter(inventory=self.inventory_id)
        return self.add_weight(packed_items)

    @property
    def carried_weight_percentage(self):
        return (self.inventory_weight / self.inventory_hiker.hiker_physical_weight) * 100

    def __str__(self):
        return f'Inventory = {self.inventory_name}, {self.inventory_weight}'

class FoodItem(Item):
    calories = models.PositiveSmallIntegerField()
    protein = models.PositiveSmallIntegerField()
    sugar = models.PositiveSmallIntegerField()

class ItemQuantity(models.Model):
    inventory = models.ForeignKey(Inventory, on_delete = models.CASCADE)
    item = models.ForeignKey(Item, on_delete = models.CASCADE)
    meal = models.ForeignKey(
        'mealplan.Meal', 
        on_delete=models.DO_NOTHING, 
        blank=True, 
        null=True
    )

    item_quantity = models.PositiveSmallIntegerField()
    isMultiple = models.BooleanField(default=False)
    item_note = models.TextField(blank=True,null=True)


    def calc_calories(self):
        if(FoodItem.objects.filter(item_id=self.item.item_id)):
            food = FoodItem.objects.get(item_id=self.item.item_id)
            return self.item_quantity * food.calories
        else:
            return 0
    
    def calc_protein(self):
        if(FoodItem.objects.filter(item_id=self.item.item_id)):
            food = FoodItem.objects.get(item_id=self.item.item_id)
            return self.item_quantity * food.protein
        else:
            return 0

    def calc_sugar(self):
        if(FoodItem.objects.filter(item_id=self.item.item_id)):
            food = FoodItem.objects.get(item_id=self.item.item_id)
            return self.item_quantity * food.sugar
        else:
            return 0

    @property
    def total_weight(self):
        return self.item_quantity * self.item.item_weight

    def __str__(self):
        return f'Item Quantity = {self.id}, {self.item.item_name}, {self.inventory.inventory_name}, {self.item_quantity}'