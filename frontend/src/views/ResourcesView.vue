<template>
  <div class="resources-page bg-background text-on-surface font-body pt-20">
    <!-- Formal Header -->
    <section class="py-20 border-b border-outline-variant/10 bg-surface-container-lowest px-12 text-center">
      <div class="max-w-screen-2xl mx-auto space-y-4">
        <span class="text-secondary font-label font-bold uppercase text-xs tracking-[0.3em]">Gender and Development</span>
        <h1 class="text-5xl font-headline font-black text-primary tracking-tight">Issues & Mandates</h1>
        <p class="text-lg text-on-surface-variant max-w-3xl mx-auto leading-relaxed">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        </p>
      </div>
    </section>

    <!-- Repository Layout -->
    <section class="py-16 px-12 bg-background">
      <div class="max-w-screen-2xl mx-auto space-y-16">
        <!-- Search and Filter -->
        <div class="flex flex-col md:flex-row items-center gap-4 justify-between">
          <input v-model="searchQuery" class="bg-surface-container-low border border-outline-variant/30 rounded px-6 py-2 text-sm w-full md:w-96" placeholder="Search laws or mandates..." />
          <div class="flex gap-2">
            <button v-for="cat in categories" :key="cat" @click="activeCategory = cat" :class="activeCategory === cat ? 'bg-primary text-on-primary' : 'bg-surface-container-low text-on-surface-variant'" class="px-4 py-1.5 rounded text-xs font-bold uppercase tracking-widest transition-colors">{{ cat }}</button>
          </div>
        </div>

        <!-- Mandates Grid -->
        <div class="grid lg:grid-cols-12 gap-12">
          <div class="lg:col-span-8 space-y-8">
            <div class="flex items-center gap-4">
              <h2 class="text-2xl font-headline font-extrabold text-on-surface">Legal Mandates</h2>
              <div class="h-px flex-1 bg-outline-variant/10"></div>
            </div>
            <div class="grid md:grid-cols-2 gap-6">
            <div v-for="mandate in filteredMandates" :key="mandate.title" class="p-6 bg-surface-container-low rounded border border-outline-variant/10 flex flex-col">
                <div class="flex items-center gap-3 text-primary mb-4">
                   <span class="material-symbols-outlined text-xl">{{ mandate.icon }}</span>
                   <span class="text-[10px] font-black uppercase tracking-widest opacity-70">{{ mandate.type }}</span>
                </div>
                <h4 class="font-headline font-bold text-on-surface mb-2">{{ mandate.title }}</h4>
                <p class="text-xs text-on-surface-variant leading-relaxed mb-6">{{ mandate.description }}</p>
                <button class="text-[10px] font-black text-secondary uppercase tracking-widest border-b border-secondary/30 pb-0.5 hover:border-secondary transition-colors">Download PDF</button>
              </div>
            </div>
          </div>
          
          <div class="lg:col-span-4 p-8 bg-surface-container-low border border-outline-variant/10 rounded">
            <h3 class="text-xs font-black uppercase tracking-widest text-primary mb-8">National Policy Spotlight</h3>
            <ul class="space-y-6">
              <li v-for="policy in nationalPolicies" :key="policy.id" class="group cursor-pointer border-b border-outline-variant/10 pb-4 last:border-0">
                <span class="text-[10px] font-bold text-outline uppercase tracking-widest block mb-1">{{ policy.id }}</span>
                <span class="font-headline font-bold text-on-surface group-hover:text-primary transition-colors">{{ policy.title }}</span>
              </li>
            </ul>
          </div>
        </div>

        <!-- GAD Issues -->
        <div class="space-y-8">
          <div class="flex items-center gap-4">
            <h2 class="text-2xl font-headline font-extrabold text-on-surface">GAD Issues</h2>
            <div class="h-px flex-1 bg-outline-variant/10"></div>
          </div>
          <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div v-for="(item, index) in visibleIssues" :key="index" class="p-6 bg-surface-container-low rounded border border-outline-variant/10 flex flex-col">
              <div class="text-secondary mb-4 flex items-center justify-between">
                <span class="material-symbols-outlined text-2xl">{{ item.icon }}</span>
              </div>
              <h4 class="font-headline font-bold text-on-surface mb-2 text-sm">{{ item.mandate }}</h4>
              <p class="text-xs text-on-surface-variant leading-relaxed mb-6">{{ item.issue }}</p>
            </div>
          </div>
          <div class="flex justify-center mt-8">
            <button @click="showAllIssues = !showAllIssues" class="px-8 py-3 border border-primary text-primary text-xs font-black uppercase tracking-widest hover:bg-primary hover:text-on-primary transition-all rounded">
              {{ showAllIssues ? 'See Less' : 'See All' }}
            </button>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

const searchQuery = ref('');
const activeCategory = ref('All Resources');
const showAllIssues = ref(false);
const categories = ['All Resources', 'International', 'National', 'Institutional'];

const mandates = [
  {
    title: 'Republic Act 9710',
    description: 'The Magna Carta of Women, mandating gender mainstreaming as a strategy for implementing gender-responsive governance.',
    icon: 'gavel',
    type: 'National Law',
    category: 'National'
  },
  {
    title: 'Republic Act 10931',
    description: 'Universal Access to Quality Tertiary Education Act, ensuring equitable access and participation through Affirmative Action Programs.',
    icon: 'school',
    type: 'National Law',
    category: 'National'
  },
  {
    title: 'Republic Act 11313',
    description: 'The Safe Spaces Act (Bawal Bastos Law) which defines and penalizes gender-based sexual harassment in various settings.',
    icon: 'security',
    type: 'National Law',
    category: 'National'
  },
  {
    title: 'Institutional Goals & Mandates',
    description: 'Formal objectives for transformative education, innovative research, and inclusive governance as defined in the University Strategic Plan.',
    icon: 'policy',
    type: 'Institutional',
    category: 'Institutional'
  }
];

const nationalPolicies = [
  { id: 'Republic Act 9710', title: 'Magna Carta of Women' },
  { id: 'Republic Act 11313', title: 'Safe Spaces Act' },
  { id: 'Republic Act 10931', title: 'Universal Access Act' },
  { id: 'Republic Act 7877', title: 'Anti-Sexual Harassment Act' },
  { id: 'Republic Act 10028', title: 'Breastfeeding Promotion Act' },
  { id: 'Republic Act 10121', title: 'DRRM Act' }
];

const gadIssues = [
  {
    mandate: 'RA 10931, Section 8; CHED Memo Orders',
    issue: 'Extraordinary life situations (disasters, calamities, socio-cultural discrimination); high tuition fees compounded by expectations for women to prioritize domestic roles over education.',
    icon: 'diversity_3',
    office: 'OSS, OUR, UHS'
  },
  {
    mandate: 'CHED Memorandum Order No. 01, series 2015',
    issue: 'Limited activities to increase awareness of men and women students on GAD-related information and limited understanding of student leaders on GAD.',
    icon: 'campaign',
    office: 'OSS & GAD Office'
  },
  {
    mandate: 'Part VII of CHED Memorandum Order No. 1, series 2015',
    issue: 'Presence of gender inequality, poverty, and GAD-related concerns in the community; limited gender-responsive research and extension.',
    icon: 'biotech',
    office: 'Research and Extension'
  },
  {
    mandate: 'DBM-DSWD Joint Circular No. 2003-01',
    issue: 'Limited access of PWDs and lack of senior citizens\' access to gender-responsive programs and services.',
    icon: 'accessible',
    office: 'HRMO, OSS & GAD Office'
  },
  {
    mandate: 'MCW-IRR Section 14',
    issue: 'Low number of women\'s participation in competitive and non-competitive sports.',
    icon: 'sports_handball',
    office: 'College of Human Kinetics (CHK)'
  },
  {
    mandate: 'CSC Res No. 010112; BOR Res. No. 2316 s. 2014',
    issue: 'Low recognition and appreciation of gender mainstreaming implementation in the University.',
    icon: 'military_tech',
    office: 'HRDO, HRMO & GAD Office'
  },
  {
    mandate: 'Magna Carta of Women (RA 9710); CHED Memo 2015-1',
    issue: 'Limited application of GAD mainstreaming in instruction, research, extension, and production.',
    icon: 'history_edu',
    office: 'All Colleges & OQAA'
  },
  {
    mandate: 'MCW IRR Section 37; RA 10028',
    issue: 'Productivity of employees affected by filial obligations; inadequate support for breastfeeding mothers.',
    icon: 'child_care',
    office: 'GAD Office & HRDO'
  },
  {
    mandate: 'Executive Order No. 340 s. 1997',
    issue: 'Problems of parents and students related to child care for children under five years of age.',
    icon: 'escalator_warning',
    office: 'GAD Office'
  },
  {
    mandate: 'Magna Carta of Women (RA 9710)',
    issue: 'Low integration of gender mainstreaming in BSU operations and monitoring efforts.',
    icon: 'monitoring',
    office: 'GAD Office'
  },
  {
    mandate: 'Magna Carta of Women IRR Section 37-C',
    issue: 'Low level of GFPS capacity to develop and implement GAD programs due to new members.',
    icon: 'groups',
    office: 'GAD Office'
  },
  {
    mandate: 'Section 37-C2 Rule VI of MCW IRR; CHED Memo 2015-1',
    issue: 'Compliance to regular monitoring of gender mainstreaming; no plantilla personnel assigned full-time to plan and monitor GAD PAPs.',
    icon: 'assignment_late',
    office: 'GAD Office'
  },
  {
    mandate: 'RA 9710; CHED Memo 2015-1',
    issue: 'Low level of awareness on gender mainstreaming among newly hired personnel.',
    icon: 'person_add',
    office: 'HRDO & GAD Office'
  },
  {
    mandate: 'Part V, Rule II, Section 4 of CHED CMO 01, s. 2015',
    issue: 'Limited number of GAD library and related learning materials across various disciplines.',
    icon: 'menu_book',
    office: 'University Library (ULIS)'
  },
  {
    mandate: 'Institutional Mainstreaming Mandate',
    issue: 'Presence of Gender Based Violence (GBV) issues, reports, and cases in the university.',
    icon: 'report_problem',
    office: 'UPAO & GAD Office'
  },
  {
    mandate: 'RA 9710, Section 36 (Sex-Disaggregated Database)',
    issue: 'Minimal awareness and appreciation of the relevance of a centralized sex-disaggregated database.',
    icon: 'database',
    office: 'ICT & GAD Office'
  },
  {
    mandate: 'MCW Chapter IV Section 10; RA 10121',
    issue: 'Limited resources for transient student residents; limited appreciation of women\'s role in nation building.',
    icon: 'emergency_home',
    office: 'NSTP & HDRO'
  },
  {
    mandate: 'MCW RA 9710 Section 18; RA 8187; RA 8972',
    issue: 'Employees may require special leaves due to parental obligations, health concerns, and other circumstances.',
    icon: 'event_busy',
    office: 'HRMO & CBOO'
  },
  {
    mandate: 'Proclamation 227; Proclamation 1172; RA 11313',
    issue: 'Need to highlight women\'s rights and provide platforms against VAW and gender-based violence (Safe Spaces Act).',
    icon: 'security',
    office: 'GAD Office'
  },
  {
    mandate: 'RA 9710; PCW-NEDA-DBM JC 2012-01',
    issue: 'Low level of employees\' understanding of gender issues and concepts to promote equality.',
    icon: 'psychology',
    office: 'GAD Office'
  },
  {
    mandate: 'Part V of CMO 01 s. 2015; CHED Memo 2015-1',
    issue: 'Limited subjects for GAD integration in gender-responsive instruction and curriculum development.',
    icon: 'school',
    office: 'All Colleges & GAD Office'
  },
  {
    mandate: 'Section 37-C2 of the Magna Carta of Women IRR',
    issue: 'Need to sustain a functional and gender-responsive GAD Focal Point System and GAD Office.',
    icon: 'account_balance',
    office: 'GAD Office'
  }
];

const visibleIssues = computed(() => {
  return showAllIssues.value ? gadIssues : gadIssues.slice(0, 6);
});

const filteredMandates = computed(() => {
  return mandates.filter(m => {
    const matchesSearch = m.title.toLowerCase().includes(searchQuery.value.toLowerCase()) || 
                         m.description.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesCategory = activeCategory.value === 'All Resources' || m.category === activeCategory.value;
    return matchesSearch && matchesCategory;
  });
});
</script>

<style scoped>
</style>
