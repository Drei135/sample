<template>
  <div class="contact-page bg-background text-on-surface font-body selection:bg-primary-fixed selection:text-on-primary-fixed pt-20 pb-24 max-w-7xl mx-auto px-8">
    <!-- Hero Section -->
      <section class="mb-20">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-end">
          <div class="lg:col-span-7">
            <span class="inline-block px-4 py-1 rounded-full bg-secondary-container text-on-secondary-container text-xs font-label font-bold uppercase tracking-widest mb-6">Connect With Us</span>
            <h1 class="text-5xl md:text-7xl font-headline font-extrabold tracking-tighter text-primary leading-tight mb-8">
              University Directory & Support Hub
            </h1>
            <p class="text-xl text-on-surface-variant max-w-2xl leading-relaxed">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            </p>
          </div>
          <div class="lg:col-span-5 hidden lg:block">
            <div class="h-64 rounded-xl overflow-hidden ambient-shadow relative border border-outline-variant/10">
              <img alt="BSU GAD Office Environment" class="w-full h-full object-cover grayscale opacity-40 hover:grayscale-0 transition-all duration-700" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBJMFB0V6BJxKILLaObo8EeoeP54iI0gQBX_xEuLB50u8LzHbFqNIeNt7D6SCBt3V-b5vVGIvRRxNDteKPhXcKGcFmA9aT2f5N-405q63120iKPsbSJZBpSqCmFG0pqcF_dxOJUYTTAgYdI8EvR7xDbaSdpy2u3W132D4Zb1HMlg2DXo8yM9pF3vcRDx01yZGFwOqPKashQtxTL4MgSbMvgGHRxqsBIyLyqRy6Vts-2_mx-iUeElxWkXf7DK87aWrlh-ROfVUBo6OmK"/>
              <div class="absolute inset-0 bg-primary/10 mix-blend-multiply"></div>
            </div>
          </div>
        </div>
      </section>

      <!-- Main Office & Form Section -->
      <section class="mb-28 grid grid-cols-1 lg:grid-cols-2 gap-16">
        <!-- Contact Info -->
        <div class="space-y-12">
          <div class="p-10 rounded-xl bg-surface-container-low border border-outline-variant/15">
            <h2 class="text-3xl font-headline font-bold text-primary mb-8 tracking-tight">Main GAD Office</h2>
            <div class="space-y-8">
              <div class="flex items-start gap-6">
                <div class="w-12 h-12 rounded-full bg-primary/5 flex items-center justify-center shrink-0">
                  <span class="material-symbols-outlined text-primary">location_on</span>
                </div>
                <div>
                  <p class="text-sm font-label uppercase tracking-widest text-secondary font-bold mb-1">Campus Address</p>
                  <p class="text-lg text-on-surface font-medium leading-snug">2nd Floor, Administration Building,<br/>Benguet State University Main Campus, La Trinidad, Benguet</p>
                </div>
              </div>
              <div class="flex items-start gap-6">
                <div class="w-12 h-12 rounded-full bg-primary/5 flex items-center justify-center shrink-0">
                  <span class="material-symbols-outlined text-primary">phone_in_talk</span>
                </div>
                <div>
                  <p class="text-sm font-label uppercase tracking-widest text-secondary font-bold mb-1">Contact Numbers</p>
                  <p class="text-lg text-on-surface font-medium leading-snug">(074) 422-2127 / +63 9XX XXX XXXX</p>
                </div>
              </div>
              <div class="flex items-start gap-6">
                <div class="w-12 h-12 rounded-full bg-primary/5 flex items-center justify-center shrink-0">
                  <span class="material-symbols-outlined text-primary">mail</span>
                </div>
                <div>
                  <p class="text-sm font-label uppercase tracking-widest text-secondary font-bold mb-1">Email Inquiry</p>
                  <p class="text-lg text-on-surface font-medium leading-snug">gad.office@bsu.edu.ph</p>
                </div>
              </div>
            </div>
            <div class="mt-12 pt-8 border-t border-outline-variant/20 flex items-center gap-4 text-primary">
              <span class="material-symbols-outlined fill-icon">schedule</span>
              <p class="text-sm font-medium">Monday — Friday: 8:00 AM - 5:00 PM</p>
            </div>
          </div>
          <div class="rounded-xl overflow-hidden h-64 grayscale-0 contrast-125 ambient-shadow border border-outline-variant/15">
            <div class="w-full h-full bg-surface-container-highest relative flex items-center justify-center overflow-hidden">
              <img class="absolute inset-0 w-full h-full object-cover opacity-20" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAueGXkEMRk4J-bnXRl0jwhvdtGyu_w2MclS4gmOPbguVDT1_D7zWgrtINGvHQTjC9aGPZGrxi4nwaWr6Ux033HFFXoJIz8GtgyEldmaGxJmJXOvBn8mRgZnb-yymRLYCNZHqtwYIAj0ShqYHd79M6rkRlIovKtuS6uh56xWys5mxhByPOVEBjIMACN4w6F82B_QxqcwG0PWpOakiugtpFv5JHHcx7yK_OB-dsr278qgt57bOGVDFjZI8-o0qDAf8YpG5EED5yNBJPH"/>
              <div class="relative z-10 text-center">
                <span class="material-symbols-outlined text-primary text-4xl mb-2">map</span>
                <p class="text-primary font-headline font-bold">BSU Main Campus Map</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Contact Form -->
        <div class="bg-surface-container-lowest p-10 rounded-xl ambient-shadow border border-outline-variant/10 h-fit">
          <h3 class="text-2xl font-headline font-bold text-on-surface mb-2">Send an Inquiry</h3>
          <p class="text-on-surface-variant mb-10 leading-relaxed">Have a question regarding GAD initiatives or need assistance? Fill out the form below and our staff will get back to you.</p>
          <form @submit.prevent="submitForm" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-xs font-label uppercase tracking-widest text-on-surface-variant font-bold mb-2">Full Name</label>
                <input v-model="form.name" class="w-full bg-surface-container-low border-none rounded-lg focus:ring-0 focus:border-b-2 focus:border-primary transition-all p-4 text-on-surface" placeholder="Juan Dela Cruz" type="text" required />
              </div>
              <div>
                <label class="block text-xs font-label uppercase tracking-widest text-on-surface-variant font-bold mb-2">Email Address</label>
                <input v-model="form.email" class="w-full bg-surface-container-low border-none rounded-lg focus:ring-0 focus:border-b-2 focus:border-primary transition-all p-4 text-on-surface" placeholder="juan@example.edu.ph" type="email" required />
              </div>
            </div>
            <div>
              <label class="block text-xs font-label uppercase tracking-widest text-on-surface-variant font-bold mb-2">Subject</label>
              <select v-model="form.subject" class="w-full bg-surface-container-low border-none rounded-lg focus:ring-0 focus:border-b-2 focus:border-primary transition-all p-4 text-on-surface appearance-none">
                <option>Resource Access Inquiry</option>
                <option>Event Registration</option>
                <option>Consultation Request</option>
                <option>Report a Concern</option>
                <option>Other</option>
              </select>
            </div>
            <div>
              <label class="block text-xs font-label uppercase tracking-widest text-on-surface-variant font-bold mb-2">Message</label>
              <textarea v-model="form.message" class="w-full bg-surface-container-low border-none rounded-lg focus:ring-0 focus:border-b-2 focus:border-primary transition-all p-4 text-on-surface" placeholder="How can we help you today?" rows="5" required></textarea>
            </div>
            <button class="w-full py-5 rounded-full bg-primary text-white font-headline font-bold tracking-tight hover:opacity-95 shadow-lg active:scale-[0.98] transition-all" type="submit">
              Dispatch Message
            </button>
          </form>
        </div>
      </section>

      <!-- Focal Persons Directory -->
      <section class="mt-32">
        <div class="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div class="max-w-xl">
            <h2 class="text-4xl font-headline font-extrabold text-primary tracking-tighter mb-4">GAD Focal Persons</h2>
            <p class="text-on-surface-variant text-lg">Direct contacts for Gender and Development representatives across BSU's colleges and departments.</p>
          </div>
          <div class="flex gap-4">
            <div class="relative">
              <input v-model="searchQuery" class="pl-12 pr-6 py-3 bg-surface-container rounded-full border-none focus:ring-2 focus:ring-primary/20 text-sm font-medium w-72 transition-all" placeholder="Search by college or name..." type="text"/>
              <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant text-lg">search</span>
            </div>
          </div>
        </div>

        <!-- Bento Grid Directory -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="person in filteredFocalPersons" :key="person.name" class="group bg-surface-container-lowest p-8 rounded-xl ambient-shadow hover:-translate-y-1 transition-transform duration-300 border border-outline-variant/10">
            <div class="flex items-start justify-between mb-6">
              <div class="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center text-primary font-headline font-bold text-xl">
                {{ person.initials }}
              </div>
              <span v-if="person.lead" class="inline-block px-3 py-1 rounded-full bg-primary-container/10 text-primary text-[10px] font-label font-bold uppercase tracking-widest">Lead Focal</span>
            </div>
            <h4 class="text-xl font-headline font-bold text-on-surface mb-1">{{ person.name }}</h4>
            <p class="text-secondary font-label text-xs uppercase tracking-wider font-bold mb-4">{{ person.college }}</p>
            <p class="text-sm text-on-surface-variant mb-8 leading-relaxed">{{ person.description }}</p>
            <a class="flex items-center gap-3 text-primary font-semibold text-sm hover:underline decoration-2 underline-offset-4" :href="'mailto:' + person.email">
              <span class="material-symbols-outlined text-lg">mail</span>
              {{ person.email }}
            </a>
          </div>
          <!-- CTA Card -->
          <div class="bg-primary-container p-8 rounded-xl ambient-shadow flex flex-col justify-center items-center text-center text-on-primary-container border border-primary/10">
            <span class="material-symbols-outlined text-5xl mb-4">groups</span>
            <h4 class="text-xl font-headline font-bold mb-2">Join the Network</h4>
            <p class="text-sm opacity-80 mb-6">Want to become a GAD volunteer or student focal person for your organization?</p>
            <button class="bg-surface-container-lowest text-primary px-6 py-2 rounded-full font-headline font-bold text-sm hover:bg-surface-bright transition-colors">Apply Now</button>
          </div>
        </div>
      </section>
  </div>
</template>

<script setup>
import { reactive, ref, computed } from 'vue';

const form = reactive({
  name: '',
  email: '',
  subject: 'Resource Access Inquiry',
  message: ''
});

const searchQuery = ref('');

const focalPersons = [
  {
    name: 'Dr. Aris M. Mendiola',
    initials: 'AM',
    college: 'College of Agriculture',
    description: 'Coordinator for agricultural gender equity programs and research initiatives.',
    email: 'a.mendiola@bsu.edu.ph',
    lead: true
  },
  {
    name: 'Prof. Elena S. Santos',
    initials: 'ES',
    college: 'College of Arts & Sciences',
    description: 'Specialist in sociological gender studies and liberal arts curriculum integration.',
    email: 'e.santos@bsu.edu.ph'
  },
  {
    name: 'Engr. Ricardo B. Belen',
    initials: 'RB',
    college: 'College of Engineering',
    description: 'Advocate for women in STEM and engineering workforce diversity policies.',
    email: 'r.belen@bsu.edu.ph'
  },
  {
    name: 'Dr. Clara P. Pineda',
    initials: 'CP',
    college: 'College of Teacher Education',
    description: 'Focuses on gender-responsive pedagogy and inclusive classroom environments.',
    email: 'c.pineda@bsu.edu.ph'
  },
  {
    name: 'Ms. Maria T. Tolentino',
    initials: 'MT',
    college: 'College of Nursing',
    description: 'Healthcare equity coordinator and community outreach liaison.',
    email: 'm.tolentino@bsu.edu.ph'
  }
];

const filteredFocalPersons = computed(() => {
  return focalPersons.filter(p => 
    p.name.toLowerCase().includes(searchQuery.value.toLowerCase()) || 
    p.college.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

const submitForm = () => {
  alert('Thank you for your inquiry! We will get back to you soon.');
  form.name = '';
  form.email = '';
  form.message = '';
};
</script>

<style scoped>
</style>
