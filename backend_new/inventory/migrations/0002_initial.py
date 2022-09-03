# Generated by Django 4.0.6 on 2022-09-03 02:22

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('inventory', '0001_initial'),
        ('mealplan', '0001_initial'),
        ('account', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='itemquantity',
            name='meal',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='mealplan.meal'),
        ),
        migrations.AddField(
            model_name='item',
            name='item_category',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='inventory.category'),
        ),
        migrations.AddField(
            model_name='item',
            name='item_condition',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='inventory.itemcondition'),
        ),
        migrations.AddField(
            model_name='item',
            name='item_hiker',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='account.hiker'),
        ),
        migrations.AddField(
            model_name='item',
            name='item_history',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='inventory.itemhistory'),
        ),
        migrations.AddField(
            model_name='inventory',
            name='inventory_hiker',
            field=models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, related_name='inv_hiker', to='account.hiker'),
        ),
        migrations.AddField(
            model_name='inventory',
            name='inventory_items',
            field=models.ManyToManyField(through='inventory.ItemQuantity', to='inventory.item'),
        ),
        migrations.AddField(
            model_name='inventory',
            name='inventory_trip',
            field=models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, related_name='inv_trip', to='account.trip'),
        ),
    ]
