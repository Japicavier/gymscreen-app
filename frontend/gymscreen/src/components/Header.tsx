import { Link, NavLink } from 'react-router-dom'
import logo from '../assets/logo.svg'
import { NAV_SECTIONS } from '../constants/navigation'

const Header = () => (
  <header className="sticky top-0 z-10 border-b border-slate-200 bg-white/90 backdrop-blur-sm">
    <div className="mx-auto flex max-w-6xl items-center gap-6 px-4 py-3">
      <Link to="/" className="shrink-0">
        <img src={logo} alt="GymScreen" className="h-10 w-auto" />
      </Link>

      <nav className="flex gap-1 overflow-x-auto">
        {NAV_SECTIONS.map(({ path, label }) => (
          <NavLink
            key={path}
            to={path}
            className={({ isActive }) =>
              `whitespace-nowrap rounded-md px-3 py-2 text-sm font-medium transition-colors ${
                isActive
                  ? 'bg-slate-900 text-white'
                  : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900'
              }`
            }
          >
            {label}
          </NavLink>
        ))}
      </nav>
    </div>
  </header>
)

export default Header
