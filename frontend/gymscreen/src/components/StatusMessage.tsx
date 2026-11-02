import type { ReactNode } from 'react'

const StatusMessage = ({ children }: { children: ReactNode }) => (
  <p className="py-16 text-center text-slate-500">{children}</p>
)

export default StatusMessage
