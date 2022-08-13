from http import client
from json import JSONEncoder
from urllib.request import Request
from django.test import TestCase, Client
from .models import Category, Item, FoodItem, Inventory
from .serializers import *
from .signals import  *


class ItemsTestCase(TestCase):
    def setUp(self):
        medical = Category.objects.create(name="Medical",slug="MED")
        clothing = Category.objects.create(name="Clothing",slug="CLO")


        for num in range(0,10):
            if num % 2 == 0:
                Item.objects.create(item_name=f'EssItem{num}', item_weight=1,item_category=medical,item_description=f'Essential Item {num}',isEssential=True,isFavorite=True)
                FoodItem.objects.create(item_name=f'fooditem{num}', item_weight=8,item_description=f'Food Item {num}',calories=310,protein=11,sugar=2)
            else:
                Item.objects.create(item_name=f'NonEssItem{num}', item_weight=1,item_category=clothing,item_description=f'Non-Essential Item {num}',isEssential=False,isFavorite=False)
                FoodItem.objects.create(item_name=f'fooditem{num}', item_weight=8,item_description=f'Food Item {num}',calories=310,protein=11,sugar=2)
        self.client = Client()

    def test_get_items(self):

        request = self.client.get('/items/')
        self.assertEqual(request.status_code, 200)
        self.assertEqual(len(request.data), 20)
    
    def test_get_individual_item(self):
        #3rd object to compare
        third_object_test = ItemSerializer(Item.objects.get(item_id=3))
        request = self.client.get('/items/3/')
        self.assertEqual(request.status_code, 200)
        self.assertEqual(request.data, third_object_test.data, msg="Objects match")

    def test_post_item(self):
        post_data =  {
            'item_name' : 'PostItem',
            'item_weight' : '3.0',
            'item_category' : 1,
            'item_description' : 'Post Item 1',
            'isEssential' : 'True',
            'isFavorite' : 'False'
        }
        #Post request
        request = self.client.post('/items/', post_data)
        #Ensure that 201 is reutrned
        self.assertEqual(request.status_code, 201, msg="Status Code : 201")
        #pull object from DB to test against JSON
        obj_test = Item.objects.get(item_name='PostItem')
        self.assertEqual(obj_test.item_name, 'PostItem')
        self.assertEqual(obj_test.item_weight, 3.0)
        self.assertEqual(obj_test.item_category, Category.objects.get(id = 1))
        self.assertEqual(obj_test.item_description, 'Post Item 1')
        self.assertEqual(obj_test.isEssential, True)
        self.assertEqual(obj_test.isFavorite, False)

    def test_put_item(self):
        put_data = {
            'item_name' : 'UpdatedItem',
            'item_weight' : 3.0,
            'item_description' : 'Updated Item description test',
            'isEssential' : True,
            'isFavorite' : False
        }
        request = self.client.put('/items/3/', data=put_data)
        self.assertEqual(request.status_code, 201)

        obj_test = Item.objects.get(item_id=3)
        self.assertEqual(obj_test.item_weight, 3.0)
        self.assertEqual(obj_test.item_description, 'Updated Item description test')
        
    def test_delete_item(self):
        request = self.client.delete('/items/3/')
        self.assertEqual(request.status_code, 204)
  
class FoodItemsTestCase(TestCase):
    def setUp(self):
        medical = Category.objects.create(name="Medical",slug="MED")
        clothing = Category.objects.create(name="Clothing",slug="CLO")


        for num in range(0,10):
            if num % 2 == 0:
                FoodItem.objects.create(item_name=f'fooditem{num}', item_weight=8,item_description=f'Food Item {num}',calories=310,protein=11,sugar=2)
            else:
                FoodItem.objects.create(item_name=f'fooditem{num}', item_weight=8,item_description=f'Food Item {num}',calories=310,protein=11,sugar=2)
        self.client = Client()

    def test_get_fooditems(self):

        request = self.client.get('/fooditems/')
        self.assertEqual(request.status_code, 200)
        self.assertEqual(len(request.data), 10)
    
    def test_get_individual_fooditem(self):
        #3rd object to compare
        third_object_test = FoodItemSerializer(FoodItem.objects.get(fooditem_id=3))
        request = self.client.get('/fooditems/3/')
        self.assertEqual(request.status_code, 200)
        self.assertEqual(request.data, third_object_test.data, msg="Objects match")

    def test_post_fooditem(self):
        post_data =  {
            'item_name' : 'AddedFood',
            'item_weight' : '1.0',
            'item_category' : '',
            'item_description' : 'Post FoodItem 1',
            'isEssential' : 'False',
            'isFavorite' : 'False',
            'calories' : '120',
            'protein' : '14',
            'sugar' : '3'
        }
        #Post request
        request = self.client.post('/fooditems/', post_data)
        #Ensure that 201 is reutrned
        self.assertEqual(request.status_code, 201, msg="Status Code : 201")
        #pull object from DB to test against JSON
        obj_test = FoodItem.objects.get(item_name='AddedFood')
        self.assertEqual(obj_test.item_name, 'AddedFood')
        self.assertEqual(obj_test.item_weight, 1.0)
        self.assertEqual(obj_test.item_description, 'Post FoodItem 1')
        self.assertEqual(obj_test.isEssential, False)
        self.assertEqual(obj_test.isFavorite, False)

    def test_put_fooditem(self):
        put_data = {
            'item_name' : 'UpdatedItem',
            'item_weight' : 3.0,
            'item_description' : 'Updated Item description test',
            'isEssential' : True,
            'isFavorite' : False
        }
        request = self.client.put('/items/3/', data=put_data)
        self.assertEqual(request.status_code, 201)

        obj_test = Item.objects.get(item_id=3)
        self.assertEqual(obj_test.item_weight, 3.0)
        self.assertEqual(obj_test.item_description, 'Updated Item description test')
        
    def test_delete_fooditem(self):
        request = self.client.delete('/fooditems/3/')
        self.assertEqual(request.status_code, 204)


class InventoryTestCase(TestCase):
    def setUp(self):
        medical = Category.objects.create(name="Medical",slug="MED")
        clothing = Category.objects.create(name="Clothing",slug="CLO")
        

        for num in range(0,10):
            if num % 2 == 0:
                Item.objects.create(item_name=f'EssItem{num}', item_weight=1,item_category=medical,item_description=f'Essential Item {num}',isEssential=True,isFavorite=True)
                FoodItem.objects.create(item_name=f'fooditem{num}', item_weight=8,item_description=f'Food Item {num}',calories=310,protein=11,sugar=2)
            else:
                Item.objects.create(item_name=f'NonEssItem{num}', item_weight=1,item_category=clothing,item_description=f'Non-Essential Item {num}',isEssential=False,isFavorite=False)
                FoodItem.objects.create(item_name=f'fooditem{num}', item_weight=8,item_description=f'Food Item {num}',calories=310,protein=11,sugar=2)
        
        inventory = Inventory.objects.create(inventory_name = 'Inventory_1')
        
        self.client = Client()

    def test_get_inventories(self):

        request = self.client.get('/inventory/')
        self.assertEqual(request.status_code, 200)
        self.assertEqual(len(request.data), 1)
    
    def test_get_single_inventory(self):

        request = self.client.get('/inventory/1/')
        self.assertEqual(request.status_code, 200)
    
    def test_post_inventory_and_signals(self):
        post_data =  {
            'inventory_name' : 'PostedInventory'
        }
        #Post request
        request = self.client.post('/inventory/', post_data)
        post_inv = Inventory.objects.get(inventory_name = 'PostedInventory')
        inventory_items = ItemQuantity.objects.filter(inventory = post_inv)
        essential_items = Item.objects.filter(isEssential = True)

        self.assertEqual(essential_items.count(), inventory_items.count())
