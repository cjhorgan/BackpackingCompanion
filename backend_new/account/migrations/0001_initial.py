# Generated by Django 4.0.6 on 2022-08-22 05:26

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Hiker',
            fields=[
                ('hiker_id', models.BigAutoField(primary_key=True, serialize=False)),
                ('hiker_first_name', models.CharField(max_length=24)),
                ('hiker_last_name', models.CharField(max_length=24)),
                ('hiker_physical_weight', models.FloatField()),
                ('hiker_age', models.SmallIntegerField()),
                ('hiker_height_inch', models.FloatField()),
                ('hiker_natural_gender', models.CharField(choices=[('M', 'Male'), ('F', 'Female')], max_length=6)),
                ('hiker_avg_speed_flat', models.FloatField(blank=True, null=True)),
                ('hiker_trips_completed', models.IntegerField(default=0)),
            ],
        ),
        migrations.CreateModel(
            name='Trip',
            fields=[
                ('trip_id', models.BigAutoField(primary_key=True, serialize=False)),
                ('trip_name', models.CharField(max_length=100, unique=True)),
                ('trip_plan_start_datetime', models.DateTimeField()),
                ('trip_plan_end_datetime', models.DateTimeField()),
                ('trip_active_start_datetime', models.DateTimeField(blank=True, null=True)),
                ('trip_active_end_datetime', models.DateTimeField(blank=True, null=True)),
                ('is_active', models.BooleanField(default=False)),
                ('is_complete', models.BooleanField(default=False)),
                ('trip_hikers', models.ManyToManyField(blank=True, to='account.hiker')),
            ],
        ),
        migrations.CreateModel(
            name='TripDetail',
            fields=[
                ('tripdetail_id', models.BigAutoField(primary_key=True, serialize=False)),
                ('stuff', models.TextField()),
                ('avg_grade', models.FloatField()),
                ('tripdetail_trip', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='account.trip')),
            ],
        ),
    ]
