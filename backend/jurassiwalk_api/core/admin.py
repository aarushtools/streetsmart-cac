from django.contrib import admin
from core.models import BikeRack, BikeShare

# Register your models here.

@admin.register(BikeRack)
class BikeRackAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'latitude', 'longitude', 'capacity', 'available', 'covered', 'is_available']
    list_filter = ['covered', 'is_available', 'type']
    search_fields = ['name']
    # could add map widget later but basic for now

@admin.register(BikeShare)
class BikeShareAdmin(admin.ModelAdmin):
    list_display = ['id', 'station_name', 'latitude', 'longitude', 'available_bikes', 'available_docks', 'is_active']
    list_filter = ['is_active', 'provider']
    search_fields = ['station_name']
