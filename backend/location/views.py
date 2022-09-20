from rest_framework.decorators import api_view
from rest_framework.response import Response

# Create your views here.
@api_view(['Get'])
def get_entry_routes(request):
    routes = [
        {
            'Endpoint' : '/account_routes/',
            'description' : 'List of all routes directed at backend.account',
            'models' : 'Account, Hiker, Trip, TripDetail'
        },
        {
            'Endpoint' : '/inventory_routes/',
            'description' : 'List of all routes directed at backend.inventory',
            'models' : 'Category, ItemCondition, ItemHistory, Item, Inventory, FoodItem, ItemQuantity'
        },
        {
            'Endpoint' : '/mealplan_routes/',
            'description' : 'List of all routes directed at backend.mealplan',
            'models' : 'Meal, MealPlan, MealSchedule'
        },
        {
            'Endpoint' : '/location_routes/',
            'description' : 'List of all routes directed at backend.location',
            'models' : '',
            'note' : 'NOT FUNCTIONING',
        },
        {
            'Endpoint' : '/report_routes/',
            'description' : 'List of all routes directed at backend.report',
            'models' : '',
            'note' : 'NOT FUNCTIONING',
        },
    ]
    return Response(routes)