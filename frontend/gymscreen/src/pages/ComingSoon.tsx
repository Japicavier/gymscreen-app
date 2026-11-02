interface ComingSoonProps {
  title: string
}

const ComingSoon = ({ title }: ComingSoonProps) => (
  <section className="flex flex-col items-center justify-center gap-3 py-24 text-center">
    <h1 className="text-3xl font-bold">{title}</h1>
    <p className="text-slate-600">Próximamente estará disponible esta función.</p>
  </section>
)

export default ComingSoon
