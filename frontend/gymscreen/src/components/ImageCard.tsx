import { Link } from 'react-router-dom'
import FallbackImage from './FallbackImage'

interface ImageCardProps {
  to: string
  title: string
  image: string | null
  subtitle?: string
}

const ImageCard = ({ to, title, image, subtitle }: ImageCardProps) => (
  <Link
    to={to}
    className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm transition hover:-translate-y-0.5 hover:shadow-md"
  >
    <FallbackImage
      src={image}
      alt={title}
      className="aspect-square w-full bg-slate-100 object-cover"
    />
    <div className="p-3">
      <h2 className="font-semibold leading-tight">{title}</h2>
      {subtitle && <p className="mt-1 text-sm text-slate-500">{subtitle}</p>}
    </div>
  </Link>
)

export default ImageCard
