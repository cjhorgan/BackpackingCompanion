from rest_framework import generics
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import CategorySerializer, ItemSerializer, FoodItemSerializer, ItemQuantitySerializer, ItemHistorySerializer, InventorySerializer
from .models import Category, Item, FoodItem, Inventory, ItemHistory, ItemQuantity

@api_view(['Get'])
def get_routes(request):
    routes = [
        {
            'Endpoint' : '/inventory',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an Array of all inventories'
        },
        {
            'Endpoint' : '/inventory',
            'method' : 'PUT',
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

class CategoryList(generics.ListCreateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CategoryDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class ItemList(generics.ListCreateAPIView):
    queryset = Item.objects.all()
    serializer_class = ItemSerializer

class ItemDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Item.objects.all()
    serializer_class = ItemSerializer

class FoodItemList(generics.ListCreateAPIView):
    queryset = FoodItem.objects.all()
    serializer_class = FoodItemSerializer

class FoodItemDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = FoodItem.objects.all()
    serializer_class = FoodItemSerializer

class InventoryList(generics.ListCreateAPIView):
    queryset = Inventory.objects.all()
    serializer_class = InventorySerializer

class InventoryDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Inventory.objects.all()
    serializer_class = InventorySerializer

class ItemHistoryList(generics.ListCreateAPIView):
    queryset = ItemHistory.objects.all()
    serializer_class = ItemHistorySerializer  

class ItemHistoryDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ItemHistory.objects.all()
    serializer_class = ItemHistorySerializer

class ItemQuantityList(generics.ListCreateAPIView):
    queryset = ItemQuantity.objects.all()
    serializer_class = ItemQuantitySerializer

class ItemQuantityDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ItemQuantity.objects.all()
    serializer_class = ItemQuantitySerializer    


