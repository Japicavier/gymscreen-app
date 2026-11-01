from django.db import models

# Models mirror the schema created by db/gym_init_data.sql (SERIAL ids,
# table and constraint names) so the initial migration can be applied
# with --fake-initial against the existing database.


class MuscleGroup(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50, unique=True)

    class Meta:
        db_table = "muscle_group"
        ordering = ["name"]

    def __str__(self):
        return self.name


class Equipment(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50, unique=True)
    description = models.TextField(null=True, blank=True)
    image = models.TextField(null=True, blank=True)

    class Meta:
        db_table = "equipment"
        ordering = ["name"]
        verbose_name_plural = "equipment"

    def __str__(self):
        return self.name


class Exercise(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(null=True, blank=True)
    image = models.TextField(null=True, blank=True)
    muscle_groups = models.ManyToManyField(
        MuscleGroup, through="ExerciseMuscleGroup", related_name="exercises"
    )
    equipment = models.ManyToManyField(
        Equipment, through="ExerciseEquipment", related_name="exercises"
    )

    class Meta:
        db_table = "exercise"
        ordering = ["name"]

    def __str__(self):
        return self.name


class ExerciseVideo(models.Model):
    id = models.AutoField(primary_key=True)
    exercise = models.ForeignKey(
        Exercise, on_delete=models.CASCADE, related_name="videos"
    )
    url = models.TextField()

    class Meta:
        db_table = "exercise_video"
        ordering = ["id"]
        constraints = [
            models.UniqueConstraint(
                fields=["exercise", "url"], name="exercise_video_exercise_id_url_key"
            ),
        ]

    def __str__(self):
        return self.url


class ExerciseMuscleGroup(models.Model):
    id = models.AutoField(primary_key=True)
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    muscle_group = models.ForeignKey(MuscleGroup, on_delete=models.CASCADE)

    class Meta:
        db_table = "exercise_musclegroup"
        constraints = [
            models.UniqueConstraint(
                fields=["exercise", "muscle_group"],
                name="exercise_musclegroup_exercise_id_muscle_group_id_key",
            ),
        ]

    def __str__(self):
        return f"{self.exercise} - {self.muscle_group}"


class ExerciseEquipment(models.Model):
    id = models.AutoField(primary_key=True)
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    equipment = models.ForeignKey(Equipment, on_delete=models.CASCADE)

    class Meta:
        db_table = "exercise_equipment"
        constraints = [
            models.UniqueConstraint(
                fields=["exercise", "equipment"],
                name="exercise_equipment_exercise_id_equipment_id_key",
            ),
        ]

    def __str__(self):
        return f"{self.exercise} - {self.equipment}"
