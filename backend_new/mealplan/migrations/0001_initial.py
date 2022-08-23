# Generated by Django 4.0.6 on 2022-08-22 05:26

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('inventory', '0001_initial'),
        ('account', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Meal',
            fields=[
                ('meal_id', models.BigAutoField(primary_key=True, serialize=False)),
                ('meal_name', models.CharField(max_length=100)),
                ('meal_components', models.ManyToManyField(blank=True, through='inventory.ItemQuantity', to='inventory.item')),
            ],
        ),
        migrations.CreateModel(
            name='MealPlan',
            fields=[
                ('mealplan_id', models.BigAutoField(primary_key=True, serialize=False)),
                ('mealplan_hiker', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='account.hiker')),
            ],
        ),
        migrations.CreateModel(
            name='MealSchedule',
            fields=[
                ('mealschedule_id', models.BigAutoField(primary_key=True, serialize=False)),
                ('day', models.PositiveSmallIntegerField()),
                ('meal_type', models.CharField(choices=[('1', 'Breakfast'), ('2', 'Lunch'), ('3', 'Dinner'), ('4', 'Snack')], max_length=9)),
                ('meal', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mealplan.meal')),
                ('mealplan', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mealplan.mealplan')),
            ],
        ),
        migrations.AddField(
            model_name='mealplan',
            name='mealplan_meals',
            field=models.ManyToManyField(through='mealplan.MealSchedule', to='mealplan.meal'),
        ),
        migrations.AddField(
            model_name='mealplan',
            name='mealplan_trip',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='account.trip'),
        ),
    ]
