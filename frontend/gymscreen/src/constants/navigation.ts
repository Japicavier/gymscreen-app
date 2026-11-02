export interface NavSection {
  path: string
  label: string
}

// Header sections, in display order
export const NAV_SECTIONS: NavSection[] = [
  { path: '/ejercicios', label: 'Ejercicios' },
  { path: '/rutinas', label: 'Rutinas' },
  { path: '/entrenar', label: 'A entrenar' },
  { path: '/historial', label: 'Historial' },
]
