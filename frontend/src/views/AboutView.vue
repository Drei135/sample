<template>
  <div class="about-page bg-background text-on-surface font-body pt-20">
    <!-- Hero Section -->
    <section class="py-20 border-b border-outline-variant/10 bg-surface-container-lowest px-12">
      <div class="max-w-screen-2xl mx-auto flex flex-col items-center text-center space-y-4">
        <span class="text-secondary font-label font-bold uppercase text-xs tracking-[0.3em]">About Us</span>
        <h1 class="text-5xl font-headline font-black text-primary tracking-tight">Benguet State University<br/>GAD Office</h1>
        <p class="text-lg text-on-surface-variant max-w-3xl leading-relaxed">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        </p>
      </div>
    </section>

    <!-- Vision & Mission -->
    <section class="py-20 px-12 bg-background border-b border-outline-variant/10">
      <div class="max-w-screen-2xl mx-auto grid md:grid-cols-2 gap-16">
        <div class="space-y-6">
          <h2 class="text-2xl font-headline font-bold text-primary flex items-center gap-3">
            <span class="w-8 h-px bg-primary"></span> Our Vision
          </h2>
          <p class="text-xl font-body text-on-surface-variant leading-relaxed italic">
            "A premier university delivering world-class education that champions gender-fair society."
          </p>
        </div>
        <div class="space-y-6">
          <h2 class="text-2xl font-headline font-bold text-secondary flex items-center gap-3">
            <span class="w-8 h-px bg-secondary"></span> Our Mission
          </h2>
          <p class="text-lg font-body text-on-surface-variant leading-relaxed">
            To mainstream gender perspectives in the University's functions of instruction, research, extension, and production through policy development and advocacy.
          </p>
        </div>
      </div>
    </section>

    <!-- Core Pillars -->
    <section class="py-20 bg-surface-container-low px-12 border-b border-outline-variant/10">
      <div class="max-w-screen-2xl mx-auto space-y-12">
        <div class="text-center">
          <h2 class="text-3xl font-headline font-extrabold text-on-surface">Core Pillars</h2>
        </div>
        <div class="grid md:grid-cols-3 gap-8">
          <div class="p-8 bg-surface-container-lowest rounded border border-outline-variant/20">
            <h3 class="text-xl font-headline font-bold mb-4 text-primary">Social Justice</h3>
            <p class="text-sm text-on-surface-variant leading-loose">
              Ensuring fair distribution of resources and opportunities while removing barriers for marginalized groups within the academic community.
            </p>
          </div>
          <div class="p-8 bg-surface-container-lowest rounded border border-outline-variant/20">
            <h3 class="text-xl font-headline font-bold mb-4 text-primary">Gender Equality</h3>
            <p class="text-sm text-on-surface-variant leading-loose">
              Promoting equal rights, responsibilities, and opportunities for everyone regardless of their gender identity or orientation.
            </p>
          </div>
          <div class="p-8 bg-surface-container-lowest rounded border border-outline-variant/20">
            <h3 class="text-xl font-headline font-bold mb-4 text-primary">Empowerment</h3>
            <p class="text-sm text-on-surface-variant leading-loose">
              Strengthening the capacity of individuals to make choices and transform those choices into desired actions and outcomes.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Compliance -->
    <section class="py-20 px-12 bg-background">
      <div class="max-w-screen-2xl mx-auto grid md:grid-cols-12 gap-12 items-center">
        <div class="md:col-span-8 space-y-6">
          <h2 class="text-3xl font-headline font-extrabold text-on-surface">Our Commitment</h2>
          <ul class="space-y-4">
            <li class="flex items-start gap-4">
              <span class="material-symbols-outlined text-secondary mt-1">check_circle</span>
              <span class="text-on-surface-variant">Conducting gender-sensitive research that informs evidence-based policies.</span>
            </li>
            <li class="flex items-start gap-4">
              <span class="material-symbols-outlined text-secondary mt-1">check_circle</span>
              <span class="text-on-surface-variant">Providing workshops to eliminate gender bias in classrooms and offices.</span>
            </li>
            <li class="flex items-start gap-4">
              <span class="material-symbols-outlined text-secondary mt-1">check_circle</span>
              <span class="text-on-surface-variant">Facilitating community outreach that promotes gender awareness.</span>
            </li>
          </ul>
        </div>
        <div class="md:col-span-4 p-8 bg-primary text-on-primary rounded">
          <div class="text-center space-y-4">
            <div class="text-5xl font-black">100%</div>
            <div class="text-xs font-label uppercase tracking-widest opacity-80">Institutional Compliance</div>
            <div class="pt-4 border-t border-white/20">
              <div class="text-lg font-bold">PCW Accredited</div>
              <div class="text-[10px] opacity-70">Philippine Commission on Women</div>
            </div>
          </div>
        </div>
      </div>
      </section>
  </div>
</template>

<script setup>
</script>

<style scoped>
.fill-icon {
  font-variation-settings: 'FILL' 1;
}
</style>
