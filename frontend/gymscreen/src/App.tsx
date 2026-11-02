import { Navigate, Route, Routes } from 'react-router-dom'
import Layout from './components/Layout'
import ComingSoon from './pages/ComingSoon'
import ExerciseDetailPage from './pages/ExerciseDetailPage'
import ExercisesPage from './pages/ExercisesPage'
import MuscleGroupExercisesPage from './pages/MuscleGroupExercisesPage'

function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<Navigate to="/ejercicios" replace />} />
        <Route path="ejercicios" element={<ExercisesPage />} />
        <Route path="ejercicios/grupos/:groupId" element={<MuscleGroupExercisesPage />} />
        <Route path="ejercicios/:exerciseId" element={<ExerciseDetailPage />} />
        <Route path="rutinas" element={<ComingSoon title="Rutinas" />} />
        <Route path="entrenar" element={<ComingSoon title="A entrenar" />} />
        <Route path="historial" element={<ComingSoon title="Historial" />} />
        <Route path="*" element={<Navigate to="/ejercicios" replace />} />
      </Route>
    </Routes>
  )
}

export default App
