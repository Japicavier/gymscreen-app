import { Link } from 'react-router-dom'
import FallbackImage from './FallbackImage'

interface ImageRowProps {
  to: string
  title: string
  image: string | null
}

const ImageRow = ({ to, title, image }: ImageRowProps) => (
  <Link
    to={to}
    className="flex items-center gap-4 rounded-xl border border-slate-200 bg-white p-2 shadow-sm transition hover:shadow-md"
  >
    <FallbackImage
      src={image}
      alt={title}
      className="size-16 shrink-0 rounded-lg bg-slate-100 object-cover sm:size-20"
    />
    <span className="font-semibold">{title}</span>
  </Link>
)

export default ImageRow
