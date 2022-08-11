# Generated by Django 4.0.6 on 2022-08-10 19:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('inventory', '0002_alter_category_slug'),
    ]

    operations = [
        migrations.AlterField(
            model_name='category',
            name='id',
            field=models.BigAutoField(primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='inventory',
            name='inventory_name',
            field=models.CharField(max_length=30, unique=True),
        ),
    ]
