from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Inventory, ItemQuantity, Item
from trip.models import Hiker


@receiver(post_save,sender=Inventory)
def add_essential_items(sender,instance,created,**kwargs):
    #If inventory is created essential items get added. #Add Hikers to filter
    if created:
        
        essential_items = Item.objects.filter(isEssential=True,item_hiker_owner=instance.inventory_hiker )
        for ess in essential_items:
                added_item = ItemQuantity.objects.create(inventory=instance,item=ess,item_quantity=1)
                added_item.save()

#@receiver(post_save,sender=ItemQuantity)
#def update_item_use_date(sender,instance,created,**kwargs):
#    if created:
