import { Link, useLocation, useNavigate, useParams } from 'react-router-dom'
import FallbackImage from '../components/FallbackImage'
import StatusMessage from '../components/StatusMessage'
import VideoEmbed from '../components/VideoEmbed'
import { useApi } from '../hooks/useApi'
import type { ExerciseDetail } from '../interfaces/exercises'

const ExerciseDetailPage = () => {
  const { exerciseId } = useParams()
  const navigate = useNavigate()
  const location = useLocation()
  const { data: exercise, loading, error } = useApi<ExerciseDetail>(`/exercises/${exerciseId}/`)

  // "default" key means the page was opened directly, with no in-app history to go back to
  const goBack = () => (location.key === 'default' ? navigate('/ejercicios') : navigate(-1))

  const renderContent = () => {
    if (loading) return <StatusMessage>Cargando ejercicio…</StatusMessage>
    if (error || !exercise) return <StatusMessage>No se encontró el ejercicio.</StatusMessage>

    return (
      <>
        <div className="grid gap-6 md:grid-cols-[minmax(0,20rem)_1fr]">
          <FallbackImage
            src={exercise.image}
            alt={exercise.name}
            className="aspect-square w-full rounded-xl border border-slate-200 bg-slate-100 object-cover"
          />

          <div className="flex flex-col gap-4">
            <h1 className="text-3xl font-bold">{exercise.name}</h1>

            <div className="flex flex-wrap gap-2">
              {exercise.muscle_groups.map((group) => (
                <Link
                  key={group.id}
                  to={`/ejercicios/grupos/${group.id}`}
                  className="rounded-full bg-slate-200 px-3 py-1 text-sm font-medium text-slate-700 hover:bg-slate-300"
                >
                  {group.name}
                </Link>
              ))}
            </div>

            <p className="text-slate-700">
              {exercise.description ?? 'Este ejercicio todavía no tiene descripción.'}
            </p>
          </div>
        </div>

        <div className="flex flex-col gap-4">
          <h2 className="text-xl font-semibold">Videos de ejemplo</h2>
          {exercise.videos.length === 0 ? (
            <p className="text-slate-500">Todavía no hay videos para este ejercicio.</p>
          ) : (
            <div className="grid justify-items-center gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {exercise.videos.map((video, index) => (
                <VideoEmbed
                  key={video.id}
                  url={video.url}
                  title={`${exercise.name} — video ${index + 1}`}
                />
              ))}
            </div>
          )}
        </div>
      </>
    )
  }

  return (
    <section className="flex flex-col gap-8">
      <button
        type="button"
        onClick={goBack}
        className="self-start text-sm text-slate-500 hover:text-slate-900"
      >
        ← Volver
      </button>

      {renderContent()}
    </section>
  )
}

export default ExerciseDetailPage
