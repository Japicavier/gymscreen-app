from django.db.models import Count
from rest_framework import viewsets
from rest_framework.exceptions import ValidationError

from .models import Equipment, Exercise, MuscleGroup
from .serializers import (
    EquipmentSerializer,
    ExerciseDetailSerializer,
    ExerciseListSerializer,
    MuscleGroupSerializer,
)

# Meta.ordering is ignored on GROUP BY queries, so the annotated
# querysets below order explicitly.


class EquipmentViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Equipment.objects.annotate(exercise_count=Count("exercises")).order_by(
        "name"
    )
    serializer_class = EquipmentSerializer


class MuscleGroupViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MuscleGroup.objects.annotate(
        exercise_count=Count("exercises")
    ).order_by("name")
    serializer_class = MuscleGroupSerializer


def _parse_ids(params, name):
    """Parse a comma-separated id list like ?equipment=3,5 into [3, 5]."""
    raw = params.get(name)
    if not raw:
        return []
    try:
        return [int(value) for value in raw.split(",") if value.strip()]
    except ValueError:
        raise ValidationError({name: "Must be a comma-separated list of ids."})


class ExerciseViewSet(viewsets.ReadOnlyModelViewSet):
    """
    List filters (combinable):
      ?equipment=3,5      uses any of these equipment ids
      ?muscle_group=2,7   works any of these muscle group ids
      ?search=press       name contains the text (case-insensitive)

    Detail (/exercises/{id}/) adds description and videos.
    """

    def get_serializer_class(self):
        if self.action == "retrieve":
            return ExerciseDetailSerializer
        return ExerciseListSerializer

    def get_queryset(self):
        queryset = Exercise.objects.prefetch_related("muscle_groups", "equipment")

        if self.action == "retrieve":
            return queryset.prefetch_related("videos")

        params = self.request.query_params

        equipment_ids = _parse_ids(params, "equipment")
        if equipment_ids:
            queryset = queryset.filter(equipment__in=equipment_ids)

        muscle_group_ids = _parse_ids(params, "muscle_group")
        if muscle_group_ids:
            queryset = queryset.filter(muscle_groups__in=muscle_group_ids)

        search = params.get("search", "").strip()
        if search:
            queryset = queryset.filter(name__icontains=search)

        # Joins on the M2M tables can repeat an exercise once per match
        return queryset.distinct()
