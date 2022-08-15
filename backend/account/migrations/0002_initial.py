# Generated by Django 4.0.6 on 2022-08-15 02:59

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('inventory', '0002_initial'),
        ('mealplan', '0001_initial'),
        ('account', '0001_initial'),
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.AddField(
            model_name='trip',
            name='trip_inventories',
            field=models.ManyToManyField(to='inventory.inventory'),
        ),
        migrations.AddField(
            model_name='trip',
            name='trip_mealplan',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mealplan.mealplan'),
        ),
        migrations.AddField(
            model_name='hiker',
            name='hiker_account',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='account',
            name='groups',
            field=models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups'),
        ),
        migrations.AddField(
            model_name='account',
            name='user_permissions',
            field=models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions'),
        ),
    ]
