<template>
  <div class="gad-corner bg-background text-on-surface font-body pt-20">
    <!-- Formal Header -->
    <section class="py-20 border-b border-outline-variant/10 bg-surface-container-lowest px-12 text-center">
      <div class="max-w-screen-2xl mx-auto space-y-4">
        <span class="text-secondary font-label font-bold uppercase text-xs tracking-[0.3em]">News &Updates</span>
        <h1 class="text-5xl font-headline font-black text-primary tracking-tight">GAD Corner</h1>
        <p class="text-lg text-on-surface-variant max-w-3xl mx-auto leading-relaxed">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        </p>
      </div>
    </section>

    <section class="py-16 px-12 bg-background">
      <div class="max-w-screen-2xl mx-auto grid lg:grid-cols-12 gap-16">

        <div class="lg:col-span-8">
          <div class="space-y-12">
            <article v-for="post in posts" :key="post.id" class="grid md:grid-cols-12 gap-8 items-start pb-12 border-b border-outline-variant/10 last:border-0">
              <div class="md:col-span-4 aspect-video bg-surface-container rounded overflow-hidden border border-outline-variant/5">
                <img :src="post.image" class="w-full h-full object-cover" :alt="post.title" />
              </div>
              <div class="md:col-span-8 space-y-4">
                <div class="flex items-center gap-3">
                  <span class="text-[10px] font-black uppercase tracking-widest text-secondary">{{ post.category }}</span>
                  <span class="text-xs text-outline">{{ post.date }}</span>
                </div>
                <h3 class="text-2xl font-headline font-extrabold text-on-surface leading-tight hover:text-primary transition-colors cursor-pointer">
                  {{ post.title }}
                </h3>
                <p class="text-on-surface-variant leading-relaxed text-sm line-clamp-3">
                  {{ post.excerpt }}
                </p>
                <button class="text-xs font-bold text-primary uppercase tracking-widest flex items-center gap-2 hover:gap-3 transition-all">
                  Read Full Article <span class="material-symbols-outlined text-sm">arrow_forward</span>
                </button>
              </div>
            </article>
          </div>
        </div>

        <!-- Sidebar -->
        <aside class="lg:col-span-4 space-y-12">
          <!-- Popular Topics -->
          <div class="p-8 bg-surface-container-low rounded border border-outline-variant/10">
            <h4 class="text-xs font-black uppercase tracking-[0.2em] text-primary mb-6">Topic Explorer</h4>
            <div class="flex flex-wrap gap-2">
              <span v-for="topic in topics" :key="topic" class="px-3 py-1 bg-surface-container-lowest border border-outline-variant/30 rounded text-xs font-medium text-on-surface-variant hover:border-primary cursor-pointer transition-all">#{{ topic }}</span>
            </div>
          </div>

          <!-- Newsletter -->
          <div class="p-8 bg-primary text-on-primary rounded">
            <h4 class="text-xs font-black uppercase tracking-[0.2em] opacity-80 mb-2">Stay Updated</h4>
            <p class="text-sm leading-relaxed mb-6">Join our official mailing list for institutional announcements and reports.</p>
            <div class="space-y-3">
              <input class="w-full bg-white/10 border border-white/20 rounded px-4 py-2 text-xs placeholder:text-white/50" placeholder="Email Address" />
              <button class="w-full bg-secondary text-on-secondary py-2 rounded font-bold text-xs uppercase tracking-widest hover:opacity-90 transition-opacity">
                Join List
              </button>
            </div>
          </div>

          <!-- Archives -->
          <div class="p-8 bg-surface-container-low rounded border border-outline-variant/10">
            <h4 class="text-xs font-black uppercase tracking-[0.2em] text-primary mb-6">Archive Repository</h4>
            <ul class="space-y-3">
              <li v-for="archive in archives" :key="archive.month">
                <a class="flex justify-between items-center group" href="#">
                  <span class="text-sm text-on-surface-variant group-hover:text-primary transition-colors">{{ archive.month }}</span>
                  <span class="text-[10px] font-bold text-outline">{{ archive.count }} items</span>
                </a>
              </li>
            </ul>
          </div>
        </aside>
      </div>
    </section>
  </div>
</template>

<script setup>
const posts = [
  {
    id: 1,
    category: 'Event',
    date: 'Oct 22, 2024',
    readTime: '5 min read',
    title: 'Safe Spaces Workshop: Fostering Inclusivity in the Classroom',
    excerpt: 'Faculty members from all colleges gathered to discuss pedagogical shifts towards a more gender-neutral learning environment.',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_G-T1Vpm2ZjLuRu755YEaAGpt3V7Ler9sk6h4sKNar4xApm8zyfHC3kF-6wSYQ4Lz83Ie_T35icsIgans2YFzQ0i42u_duHDfyoZ71YsjYtgNt5qVqmzVsjPofsx_HzCADKPMnYVZt6rm1pYAs2g5OOQj-EXH9NAfsld8Aa1StDuxzNi5Cg_QMdBRmzl6H_BZ_jPfuSs8hn9MnxN69ymwycoiQim49fZbjH04lU0YU6vtc4LYqsy7VArmW0kR148hQFKtZcvDqjCR'
  },
  {
    id: 2,
    category: 'Story',
    date: 'Oct 19, 2024',
    readTime: '8 min read',
    title: 'Voices of BSU: A Retrospective on 20 Years of GAD',
    excerpt: 'Interviewing the pioneers who established the first gender desk in the Cordillera administrative region.',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBOd2mv2tzbeM8AuSFeoIXT0Z7VujFAuRd2-yjZVBXA2B9cPLJcDyMhOmoCLSCOa0xJQJu-63XnHgX8zR5wPNZpAbT6IqF1Y_HmVn3rvH6bRnEHgvNFP-ZrivtscjVp1ELzYQPAl68gUtDeqDBaDCszyqcICbZwJFtjyOhiiTE4kq5ko_NNMM4IbvRT6cx2KVdNu6ujkgZCK7ojvA0tGxMW1riRisFxi5RNeotfZYAi1NbTg76eEZ1STRpH6v-Y0TX1C8wNBg3wE8zh'
  },
  {
    id: 3,
    category: 'Announcement',
    date: 'Oct 15, 2024',
    readTime: '2 min read',
    title: 'Upcoming Seminar: Digital Citizenship and Online Gender Safety',
    excerpt: 'Join us this coming Friday for a webinar focusing on protecting students from cyber-harassment.',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBS0v8kIFq1kNUaEUBVOnyek8ZRC8JZCXewDZT21S4xx5zhb_Re2o9fCwDvRI-ku437S4s985HvU48O0oOD0rU5gv242ae8U9L3L8smwKuuL5MO_-u6jPy7mW06xLoRuCw6U-8TM8CstK0fO0okIEsywIMLAoi4JKPiZDxOebJNP40kCr3EMY5MZZBAus5A0IznTHMqMwADeBs73wesw4ZkGpaWmqnMxW5BuDIXNLx6dpnYs11LpiMKcB1hF775-BDfuqHxdxj82ywx'
  },
  {
    id: 4,
    category: 'Event',
    date: 'Oct 12, 2024',
    readTime: '4 min read',
    title: 'Call for Proposals: 2025 Gender Equity Research Grants',
    excerpt: 'The GAD Council is now accepting research proposals that address urban-rural gender disparities in Cordillera.',
    image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBx0lc2Au-DLX0yKlhzfrMCQ_ggrg9nKcSi5wE0pSJ-2v8XsUYzcao1XYAzPXh5ZUaBknyQrVi6BDkppqnqpxs7QfwB5w5YkhKQIl4c7u58bAcrSoKelhFDGjQafAPyn9LTAvXS9BCpg77kPeuM7ytEb_pXMPrYakaDfXndimEwy6cKBQEVacgFmEM79oXGyiRoQCCFDtahmox_95wDjnGT-YJbB7OUojAaQD7cQ8Pa921avcVGYY9XRImAv8CwdZQ03IkuMXxni_BS'
  }
];

const topics = ['GenderEquality', 'IndigenousRights', 'WomenInSTEM', 'SafeSpaces', 'InstitutionalPolicies', 'Training'];

const archives = [
  { month: 'October 2024', count: 12 },
  { month: 'September 2024', count: 8 },
  { month: 'August 2024', count: 15 },
  { month: 'July 2024', count: 5 }
];

const socialLinks = [
  { icon: 'public' },
  { icon: 'share' },
  { icon: 'rss_feed' }
];
</script>

<style scoped>
</style>
