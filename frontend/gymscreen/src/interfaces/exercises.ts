// Shapes returned by the backend at /api/v1/

export interface NamedRef {
  id: number
  name: string
}

export interface MuscleGroup {
  id: number
  name: string
  exercise_count: number
}

export interface Equipment {
  id: number
  name: string
  description: string | null
  image: string | null
  exercise_count: number
}

export interface ExerciseListItem {
  id: number
  name: string
  image: string | null
  muscle_groups: NamedRef[]
  equipment: NamedRef[]
}

export interface ExerciseVideo {
  id: number
  url: string
}

export interface ExerciseDetail extends ExerciseListItem {
  description: string | null
  videos: ExerciseVideo[]
}
