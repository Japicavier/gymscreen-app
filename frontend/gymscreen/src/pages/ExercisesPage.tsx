import { useSearchParams } from 'react-router-dom'
import ImageCard from '../components/ImageCard'
import StatusMessage from '../components/StatusMessage'
import { useApi } from '../hooks/useApi'
import type { ExerciseListItem, MuscleGroup } from '../interfaces/exercises'
import { getMuscleGroupImage } from '../utils/muscleGroupImage'

type View = 'grupos' | 'ejercicios'

const VIEWS: { value: View; label: string }[] = [
  { value: 'grupos', label: 'Grupos musculares' },
  { value: 'ejercicios', label: 'Ejercicios' },
]

const GRID = 'grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4'

const MuscleGroupGrid = () => {
  const { data, loading, error } = useApi<MuscleGroup[]>('/muscle-groups/')

  if (loading) return <StatusMessage>Cargando grupos musculares…</StatusMessage>
  if (error || !data) return <StatusMessage>No se pudieron cargar los grupos musculares. {error}</StatusMessage>

  return (
    <div className={GRID}>
      {data.map((group) => (
        <ImageCard
          key={group.id}
          to={`/ejercicios/grupos/${group.id}`}
          title={group.name}
          image={getMuscleGroupImage(group.name)}
          subtitle={`${group.exercise_count} ${group.exercise_count === 1 ? 'ejercicio' : 'ejercicios'}`}
        />
      ))}
    </div>
  )
}

const ExerciseGrid = () => {
  const { data, loading, error } = useApi<ExerciseListItem[]>('/exercises/')

  if (loading) return <StatusMessage>Cargando ejercicios…</StatusMessage>
  if (error || !data) return <StatusMessage>No se pudieron cargar los ejercicios. {error}</StatusMessage>

  return (
    <div className={GRID}>
      {data.map((exercise) => (
        <ImageCard
          key={exercise.id}
          to={`/ejercicios/${exercise.id}`}
          title={exercise.name}
          image={exercise.image}
        />
      ))}
    </div>
  )
}

const ExercisesPage = () => {
  const [searchParams, setSearchParams] = useSearchParams()
  const view: View = searchParams.get('vista') === 'ejercicios' ? 'ejercicios' : 'grupos'

  return (
    <section className="flex flex-col gap-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <h1 className="text-3xl font-bold">Ejercicios</h1>

        <div role="tablist" className="inline-flex rounded-lg border border-slate-200 bg-white p-1">
          {VIEWS.map(({ value, label }) => (
            <button
              key={value}
              type="button"
              role="tab"
              aria-selected={view === value}
              onClick={() => setSearchParams({ vista: value }, { replace: true })}
              className={`rounded-md px-3 py-1.5 text-sm font-medium transition-colors ${
                view === value ? 'bg-slate-900 text-white' : 'text-slate-600 hover:bg-slate-100'
              }`}
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      {view === 'grupos' ? <MuscleGroupGrid /> : <ExerciseGrid />}
    </section>
  )
}

export default ExercisesPage
