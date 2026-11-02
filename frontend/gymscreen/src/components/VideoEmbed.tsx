import { getEmbedInfo } from '../utils/videoEmbed'

interface VideoEmbedProps {
  url: string
  title: string
}

const VideoEmbed = ({ url, title }: VideoEmbedProps) => {
  const embed = getEmbedInfo(url)

  if (!embed) {
    return (
      <a
        href={url}
        target="_blank"
        rel="noopener noreferrer"
        className="inline-flex items-center justify-center rounded-lg bg-slate-900 px-4 py-3 font-medium text-white hover:bg-slate-700"
      >
        Ver video ↗
      </a>
    )
  }

  return (
    <iframe
      src={embed.src}
      title={title}
      loading="lazy"
      allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
      allowFullScreen
      referrerPolicy="strict-origin-when-cross-origin"
      className={`w-full rounded-xl border-0 bg-black ${
        embed.vertical ? 'aspect-[9/16] max-w-xs' : 'aspect-video'
      }`}
    />
  )
}

export default VideoEmbed
