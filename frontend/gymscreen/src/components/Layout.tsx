import { Outlet } from 'react-router-dom'
import Header from './Header'

const Layout = () => {
    return (
        <div className="min-h-screen bg-slate-50 text-slate-900">
            <Header />

            <main className="mx-auto max-w-6xl px-4 py-8">
                <Outlet />
            </main>
        </div>
    )
}

export default Layout
