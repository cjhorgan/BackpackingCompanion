from django.db import models

class Category(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=64)
    slug = models.SlugField(default='self', unique=True)
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
    item_condition = models.CharField(max_length=9, choices=COND_CHOICES, default = 'Perfect')
    isConsumable = models.BooleanField(default=False)
    item_percentage_remaining=models.CharField(max_length=4, choices=PERCENTAGE_REMAIN, default = '100')      

class ItemHistory(models.Model):
    item_history_creation_date = models.DateTimeField(auto_now_add=True)
    item_history_last_use_date = models.DateTimeField(auto_now=True)
    item_history_last_use_condition = models.TextField()

class Item(models.Model):

    item_id = models.BigAutoField(primary_key=True)
    item_name = models.CharField(max_length=64)
    item_weight = models.FloatField()
    item_category = models.ForeignKey(
        Category, 
        null=True, 
        blank=True, 
        on_delete=models.DO_NOTHING
    )
    item_hiker = models.ForeignKey(
        'account.Hiker', 
        on_delete=models.DO_NOTHING,
        null=True, 
        blank=True
    )
    item_condition = models.ForeignKey(
        ItemCondition,
        on_delete = models.CASCADE,
        blank=True,
        null=True
    )
    item_history = models.ForeignKey(
        ItemHistory,
        on_delete = models.CASCADE,
        blank=True,
        null=True
      
    )
    item_description = models.CharField(max_length=128)
   
    isEssential = models.BooleanField(default=False)
    isFavorite = models.BooleanField(default=False)

    def __str__(self):
        return f'Item({self.item_name},{self.item_weight},{self.item_description},{self.item_category})'

class Inventory(models.Model):
    inventory_id = models.BigAutoField(primary_key=True)
    inventory_name = models.CharField(max_length=30, unique=True)
    inventory_items = models.ManyToManyField(
        Item,
        through = 'ItemQuantity',
        blank=True,)
    inventory_hiker = models.ForeignKey(
        'account.Hiker', 
        on_delete = models.DO_NOTHING, 
        related_name = 'inv_hiker',
        blank = True, 
        null = True)
    inventory_trip = models.ForeignKey(
        'account.Trip',
        on_delete = models.DO_NOTHING,
        related_name = 'inv_trip',
        blank = True,
        null = True
    )

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

class FoodItem(Item):
    calories = models.PositiveSmallIntegerField()
    protein = models.PositiveSmallIntegerField()
    sugar = models.PositiveSmallIntegerField()

class ItemQuantity(models.Model):
    inventory = models.ForeignKey(
        Inventory, 
        on_delete = models.CASCADE
    )
    item = models.ForeignKey(
        Item,
        on_delete = models.CASCADE
    )
    meal = models.ForeignKey(
        'mealplan.Meal', 
        on_delete=models.DO_NOTHING, 
        blank=True, 
        null=True
    )
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