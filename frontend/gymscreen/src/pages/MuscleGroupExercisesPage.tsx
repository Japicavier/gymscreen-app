import { Link, useParams } from 'react-router-dom'
import ImageRow from '../components/ImageRow'
import StatusMessage from '../components/StatusMessage'
import { useApi } from '../hooks/useApi'
import type { ExerciseListItem, MuscleGroup } from '../interfaces/exercises'

const MuscleGroupExercisesPage = () => {
  const { groupId } = useParams()
  const group = useApi<MuscleGroup>(`/muscle-groups/${groupId}/`)
  const exercises = useApi<ExerciseListItem[]>(`/exercises/?muscle_group=${groupId}`)

  const renderContent = () => {
    if (group.loading || exercises.loading) return <StatusMessage>Cargando ejercicios…</StatusMessage>
    if (group.error || !group.data) return <StatusMessage>No se encontró el grupo muscular.</StatusMessage>
    if (exercises.error || !exercises.data) {
      return <StatusMessage>No se pudieron cargar los ejercicios. {exercises.error}</StatusMessage>
    }
    if (exercises.data.length === 0) {
      return <StatusMessage>Todavía no hay ejercicios para este grupo muscular.</StatusMessage>
    }

    return (
      <ul className="flex flex-col gap-3">
        {exercises.data.map((exercise) => (
          <li key={exercise.id}>
            <ImageRow to={`/ejercicios/${exercise.id}`} title={exercise.name} image={exercise.image} />
          </li>
        ))}
      </ul>
    )
  }

  return (
    <section className="flex flex-col gap-6">
      <div className="flex flex-col gap-2">
        <Link to="/ejercicios?vista=grupos" className="text-sm text-slate-500 hover:text-slate-900">
          ← Grupos musculares
        </Link>
        <h1 className="text-3xl font-bold">{group.data?.name ?? 'Grupo muscular'}</h1>
      </div>

      {renderContent()}
    </section>
  )
}

export default MuscleGroupExercisesPage
