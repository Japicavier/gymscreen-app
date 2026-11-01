from rest_framework import serializers

from .models import Equipment, Exercise, ExerciseVideo, MuscleGroup


class NamedRefSerializer(serializers.Serializer):
    """Compact {id, name} reference to a related object."""

    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(read_only=True)


class EquipmentSerializer(serializers.ModelSerializer):
    # Filled by .annotate(exercise_count=Count("exercises")) in the view
    exercise_count = serializers.IntegerField(read_only=True)

    class Meta:
        model = Equipment
        fields = ["id", "name", "description", "image", "exercise_count"]


class MuscleGroupSerializer(serializers.ModelSerializer):
    # Filled by .annotate(exercise_count=Count("exercises")) in the view
    exercise_count = serializers.IntegerField(read_only=True)

    class Meta:
        model = MuscleGroup
        fields = ["id", "name", "exercise_count"]


class ExerciseListSerializer(serializers.ModelSerializer):
    muscle_groups = NamedRefSerializer(many=True, read_only=True)
    equipment = NamedRefSerializer(many=True, read_only=True)

    class Meta:
        model = Exercise
        fields = ["id", "name", "image", "muscle_groups", "equipment"]


class ExerciseVideoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExerciseVideo
        fields = ["id", "url"]


class ExerciseDetailSerializer(ExerciseListSerializer):
    videos = ExerciseVideoSerializer(many=True, read_only=True)

    class Meta(ExerciseListSerializer.Meta):
        fields = ["id", "name", "description", "image", "muscle_groups", "equipment", "videos"]
