from rest_framework.routers import DefaultRouter

from .views import EquipmentViewSet, ExerciseViewSet, MuscleGroupViewSet

router = DefaultRouter()
router.register("equipment", EquipmentViewSet)
router.register("muscle-groups", MuscleGroupViewSet)
# basename is required because ExerciseViewSet defines get_queryset() instead of queryset
router.register("exercises", ExerciseViewSet, basename="exercise")

urlpatterns = router.urls
