// Images live in src/assets/muscle-groups/, named after the group's slug:
// "Glúteos" -> gluteos.png, "Cuadríceps" -> cuadriceps.webp
const images = import.meta.glob<string>(
  '../assets/muscle-groups/*.{png,jpg,jpeg,webp,svg}',
  { eager: true, import: 'default' },
)

const slugify = (name: string) =>
  name
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '') // drop accents
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')

const imagesBySlug = new Map(
  Object.entries(images).map(([path, url]) => [
    path.split('/').pop()!.replace(/\.[^.]+$/, ''),
    url,
  ]),
)

export const getMuscleGroupImage = (name: string): string | null =>
  imagesBySlug.get(slugify(name)) ?? null
