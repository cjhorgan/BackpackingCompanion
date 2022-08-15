from django.http import Http404
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from .serializers import ItemBasicSerializer, ItemContentsSerializer, FoodItemSerializer, ItemQuantitySerializer, InventorySerializer
from .models import Item, FoodItem, Inventory, Category, ItemQuantity

@api_view(['Get'])
def getRoutes(request):
    routes = [
        {
            'Endpoint' : '/backend/inventory',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all inventories'
        },
        {
            'Endpoint' : '/backend/id',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns a single inventory'
        },
        {
            'Endpoint' : '/backend/invetory/items',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all items'
        },
        {
            'Endpoint' : '/backend/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of notes'
        }
    ]
    return Response(routes)

class ItemList(APIView):
    # List All Items or create an item
    def get(self, request, format=None):
        items = Item.objects.all()
        serializer = ItemBasicSerializer(items, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = ItemBasicSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    def delete(self, request, pk, format=None):
        item = self.getItem(pk)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
class ItemDetail(APIView):
    #Retrieve, update, delete a specific item

    def getItem(request, pk):
        try:
            return Item.objects.get(item_id=pk)
        except Item.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        item = self.getItem(pk)
        serializer = ItemBasicSerializer(item, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        item = self.getItem(pk)
        serializer = ItemBasicSerializer(item, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        item = self.getItem(pk)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class FoodItemList(APIView):
    # List All Items or create an item
    def get(self, request, format=None):
        items = FoodItem.objects.all()
        serializer = FoodItemSerializer(items, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = ItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class FoodItemDetail(APIView):
    #Retrieve, update, delete a specific item

    def getItem(request, pk):
        try:
            return FoodItem.objects.get(item_id=pk)
        except Item.DoesNotExist:
            raise Http404
    
    def get(self, request, pk, format=None):
        item = self.getItem(pk)
        serializer = FoodItemSerializer(item, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        item = self.getItem(pk)
        serializer = FoodItemSerializer(item, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        item = self.getItem(pk)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class InventoryList(APIView):
    # List All Items or create an inventory
    def get(self, request, format=None):
        items = Inventory.objects.all()
        serializer = InventorySerializer(items, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = InventorySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class InventoryDetail(APIView):
    #Retrieve, update, delete a specific inventory

    def getInventory(request, pk):
        try:
            return Inventory.objects.get(inventory_id=pk)
        except Item.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        inventory = self.getInventory(pk)
        serializer = InventorySerializer(inventory, many=False)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        inventory = self.getInventory(pk)
        serializer = InventorySerializer(inventory, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        inventory = self.getInventory(pk)
        inventory.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)



