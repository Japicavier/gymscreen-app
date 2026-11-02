import { useEffect, useState } from 'react'
import { apiGet } from '../api/client'

interface ApiState<T> {
  data: T | null
  loading: boolean
  error: string | null
}

interface ApiResult<T> {
  path: string
  data: T | null
  error: string | null
}

// Fetches `path` from the API and refetches whenever it changes
export function useApi<T>(path: string): ApiState<T> {
  const [result, setResult] = useState<ApiResult<T> | null>(null)

  useEffect(() => {
    const controller = new AbortController()

    apiGet<T>(path, controller.signal)
      .then((data) => setResult({ path, data, error: null }))
      .catch((err: unknown) => {
        // Ignore requests cancelled because the component unmounted or path changed
        if (controller.signal.aborted) return
        const message = err instanceof Error ? err.message : 'Error desconocido'
        setResult({ path, data: null, error: message })
      })

    return () => controller.abort()
  }, [path])

  // A result for a previous path means the new request is still loading
  const current = result?.path === path ? result : null
  return {
    data: current?.data ?? null,
    loading: current === null,
    error: current?.error ?? null,
  }
}
