export interface EmbedInfo {
  src: string
  vertical: boolean
}

const youtube = (id: string, vertical: boolean): EmbedInfo => ({
  src: `https://www.youtube-nocookie.com/embed/${encodeURIComponent(id)}`,
  vertical,
})

// Returns the iframe URL for supported links, or null if the link can't be embedded.
// Supported: YouTube (shorts, watch, embed, youtu.be) and full TikTok video links
// (tiktok.com/@user/video/<id>); TikTok short links (vt.tiktok.com) are not.
export function getEmbedInfo(rawUrl: string): EmbedInfo | null {
  let url: URL
  try {
    url = new URL(rawUrl)
  } catch {
    return null
  }

  const host = url.hostname.replace(/^(www|m)\./, '')
  const parts = url.pathname.split('/').filter(Boolean)

  if (host === 'youtube.com') {
    if (parts[0] === 'shorts' && parts[1]) return youtube(parts[1], true)
    if (parts[0] === 'embed' && parts[1]) return youtube(parts[1], false)
    const id = url.searchParams.get('v')
    if (parts[0] === 'watch' && id) return youtube(id, false)
  }

  if (host === 'youtu.be' && parts[0]) return youtube(parts[0], false)

  if (host === 'tiktok.com') {
    const id = parts[parts.indexOf('video') + 1]
    if (parts.includes('video') && id && /^\d+$/.test(id)) {
      return { src: `https://www.tiktok.com/player/v1/${id}`, vertical: true }
    }
  }

  return null
}
