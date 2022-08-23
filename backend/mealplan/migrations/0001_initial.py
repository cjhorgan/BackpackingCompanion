# Generated by Django 4.0.6 on 2022-08-20 05:22

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('account', '0001_initial'),
        ('inventory', '0001_initial'),
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
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('day', models.PositiveSmallIntegerField()),
                ('meal_type', models.CharField(choices=[('Breakfast', '1'), ('Snack', '2'), ('Lunch', '3'), ('Dinner', '4')], max_length=9)),
                ('meal', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mealplan.meal')),
                ('mealplan', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mealplan.mealplan')),
            ],
        ),
        migrations.AddField(
            model_name='mealplan',
            name='meals',
            field=models.ManyToManyField(through='mealplan.MealSchedule', to='mealplan.meal'),
        ),
    ]
