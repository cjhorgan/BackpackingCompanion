from api.serializers import *
from api.models import *
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

# Create your views here.

# The useraccount_list() function is handling GET and POST requests that the front end will make to the database.
# The useraccount_detail() function is handling GET, PUT, and DELETE requests for the same. 
# Replace "useraccount" with another model type and you have the functions for each model. 
# There is a tiny bit of error handling included here. 

@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint': '/useraccount_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing UserAccounts'
        },
        {
            'Endpoint': '/useraccount_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single UserAccount'
        },
        {
            'Endpoint': '/trip_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing Trips'
        },
        {
            'Endpoint': '/trip_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Trip'
        },
        {
            'Endpoint': '/inventory_basic/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an inventory without the items. Does not return attached Items'
        },
        {
            'Endpoint': '/inventory_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing Inventories and their attached Items'
        },
        {
            'Endpoint': '/inventory_detail/id',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Inventory and attached Items'
        },
        {
            'Endpoint': '/mealplan_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing MealPlans'
        },
        {
            'Endpoint': '/mealplan_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single MealPlan'
        },
        {
            'Endpoint': '/meal_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing Meals'
        },
        {
            'Endpoint': '/meal_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Meal'
        },
        {
            'Endpoint': '/essentialitem_list',
            'method': 'GET',
            'body': None,
            'description': 'Returns a list of all existing EssentialItems'
        },
        {
            'Endpoint': '/essentialitem_detail/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single EssentialItem'
        },
        {
            'Endpoint': '/favoriteitem_list',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing FavoriteItems'
        },
        {
            'Endpoint': '/favoriteitem_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single FavoriteItem'
        },
        {
            'Endpoint': '/location_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing Locations'
        },
        {
            'Endpoint': '/location_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Location'
        },
        {
            'Endpoint': '/item_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing Items'
        },
        {
            'Endpoint': '/item_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Item'
        },
        {
            'Endpoint': '/nutritiondata_list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns all existing NutritionData'
        },
        {
            'Endpoint': '/nutritiondata_detail/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single NutritionData'
        },
    ]
    return Response(routes)

@api_view(['GET', 'POST'])
def useraccount_list(request):
    if request.method == 'GET':                                       #Returns all useraccounts in the database                           
        useraccounts = UserAccount.objects.all()
        serializer = UserAccountSerializer(useraccounts, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':                                    
        serializer = UserAccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def useraccount_detail(request, pk):
    try:
        useraccount = UserAccount.objects.get(pk=pk)
    except UserAccount.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = UserAccountSerializer(useraccount)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = UserAccountSerializer(useraccount, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        useraccount.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def trip_list(request):
    if request.method == 'GET':
        trips = Trip.objects.all()
        serializer = TripSerializer(trips, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = TripSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def trip_detail(request, pk):
    try:
        trip = Trip.objects.get(pk=pk)
    except trip.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = TripSerializer(trip)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = TripSerializer(trip, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        trip.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET'])
def inventory_basic(request, pk):
    try:
        inventory = Inventory.objects.get(pk=pk)
    except inventory.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    serializer = InventoryBasicSerializer(inventory)
    return Response(serializer.data)

@api_view(['GET', 'POST'])
def inventory_list(request):
    if request.method == 'GET':
        inventories = Inventory.objects.all()
        serializer = InventoryContentsSerializer(inventories, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = InventoryContentsSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def inventory_detail(request, pk):
    try:
        inventory = Inventory.objects.get(pk=pk)
    except inventory.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = InventoryContentsSerializer(inventory)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = InventoryContentsSerializer(inventory, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        inventory.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def mealplan_list(request):
    if request.method == 'GET':
        mealplans = MealPlan.objects.all()
        serializer = MealPlanSerializer(mealplans, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = MealPlanSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def mealplan_detail(request, pk):
    try:
        mealplan = MealPlan.objects.get(pk=pk)
    except mealplan.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = MealPlanSerializer(mealplan)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = MealPlanSerializer(mealplan, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        mealplan.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def meal_list(request):
    if request.method == 'GET':
        meals = Meal.objects.all()
        serializer = MealSerializer(meals, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = MealPlanSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def meal_detail(request, pk):
    try:
        meal = Meal.objects.get(pk=pk)
    except meal.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = MealSerializer(meal)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = MealSerializer(meal, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        meal.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def essentialitem_list(request):
    if request.method == 'GET':
        essentialitems = EssentialItem.objects.all()
        serializer = EssentialItemSerializer(essentialitems, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = EssentialItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def essentialitem_detail(request, pk):
    try:
        essentialitem = EssentialItem.objects.get(pk=pk)
    except essentialitem.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = EssentialItemSerializer(essentialitem)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = EssentialItemSerializer(essentialitem, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        essentialitem.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def favoriteitem_list(request):
    if request.method == 'GET':
        favoriteitems = FavoriteItem.objects.all()
        serializer = FavoriteItemSerializer(favoriteitems, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = FavoriteItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def favoriteitem_detail(request, pk):
    try:
        favoriteitem = FavoriteItem.objects.get(pk=pk)
    except favoriteitem.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = FavoriteItemSerializer(favoriteitem)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = FavoriteItemSerializer(favoriteitem, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        favoriteitem.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def location_list(request):
    if request.method == 'GET':
        locations = Location.objects.all()
        serializer = LocationSerializer(locations, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = LocationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def location_detail(request, pk):
    try:
        location = Location.objects.get(pk=pk)
    except location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = LocationSerializer(location)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = LocationSerializer(location, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        location.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def item_list(request):
    if request.method == 'GET':
        items = Item.objects.all()
        serializer = ItemSerializer(items, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = ItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def item_detail(request, pk):
    try:
        item = Item.objects.get(pk=pk)
    except item.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ItemSerializer(item)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = ItemSerializer(item, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET', 'POST'])
def nutritiondata_list(request):
    if request.method == 'GET':
        nutritiondatas = NutritionData.objects.all()
        serializer = NutritionDataSerializer(nutritiondatas, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = NutritionDataSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def nutritiondata_detail(request, pk):
    try:
        nutritiondata = NutritionData.objects.get(pk=pk)
    except nutritiondata.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = NutritionDataSerializer(nutritiondata)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = NutritionDataSerializer(nutritiondata, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        nutritiondata.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)