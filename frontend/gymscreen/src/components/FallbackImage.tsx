import type { SyntheticEvent } from 'react'
import placeholder from '../assets/placeholder_img.svg'

interface FallbackImageProps {
  src: string | null | undefined
  alt: string
  className?: string
}

// Shows the placeholder when there is no src or the image fails to load
const FallbackImage = ({ src, alt, className }: FallbackImageProps) => {
  const handleError = (event: SyntheticEvent<HTMLImageElement>) => {
    const img = event.currentTarget
    if (img.dataset.fallback) return // placeholder itself failed; avoid a loop
    img.dataset.fallback = 'true'
    img.src = placeholder
  }

  return (
    <img
      src={src || placeholder}
      alt={alt}
      loading="lazy"
      onError={handleError}
      className={className}
    />
  )
}

export default FallbackImage
