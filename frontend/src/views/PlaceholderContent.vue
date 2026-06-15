<template>
  <div class="placeholder-content flex flex-col items-center justify-center min-h-[50vh] text-center">
    <div class="w-24 h-24 bg-slate-100 rounded-full flex items-center justify-center text-primary mb-6">
      <span class="material-symbols-outlined text-5xl">construction</span>
    </div>
    <h1 class="text-2xl font-bold text-slate-900 mb-2">{{ title }}</h1>
    <p class="text-slate-500 max-w-md text-sm">
      This feature is currently being migrated to the new decoupled architecture.
      Please check back soon for the updated version of the {{ title }} module.
    </p>
    <button
      @click="$router.back()"
      class="mt-10 bg-primary text-white px-8 py-3 rounded-full font-bold shadow-lg hover:opacity-90 transition-all"
    >
      Go Back
    </button>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();

const title = computed(() => {
  const name = route.name || '';
  return name.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
});
</script>
