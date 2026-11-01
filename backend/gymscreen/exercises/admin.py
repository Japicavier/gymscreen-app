from django.contrib import admin

from .models import (
    Equipment,
    Exercise,
    ExerciseEquipment,
    ExerciseMuscleGroup,
    ExerciseVideo,
    MuscleGroup,
)


class ExerciseVideoInline(admin.TabularInline):
    model = ExerciseVideo
    extra = 1


class ExerciseMuscleGroupInline(admin.TabularInline):
    model = ExerciseMuscleGroup
    extra = 1
    autocomplete_fields = ["muscle_group"]


class ExerciseEquipmentInline(admin.TabularInline):
    model = ExerciseEquipment
    extra = 1
    autocomplete_fields = ["equipment"]


@admin.register(Exercise)
class ExerciseAdmin(admin.ModelAdmin):
    list_display = ["name", "description"]
    search_fields = ["name"]
    list_filter = ["muscle_groups", "equipment"]
    inlines = [ExerciseMuscleGroupInline, ExerciseEquipmentInline, ExerciseVideoInline]


@admin.register(MuscleGroup)
class MuscleGroupAdmin(admin.ModelAdmin):
    list_display = ["name"]
    search_fields = ["name"]


@admin.register(Equipment)
class EquipmentAdmin(admin.ModelAdmin):
    list_display = ["name", "description"]
    search_fields = ["name"]
