<template>
  <div class="min-h-screen bg-[#f8f9fb] antialiased">
    <main class="pl-64 pt-16">
      <div class="p-10 flex gap-8">
        <section class="flex-[0.6] bg-white rounded-xl flex flex-col overflow-hidden shadow-sm border">
          <div class="p-8 pb-4 border-b bg-emerald-50/30">
            <div class="flex items-center gap-2 mb-4">
              <div class="flex items-center gap-2 bg-[#3f6516]/20 text-[#3f6516] px-3 py-1 rounded-full">
                <div class="w-2 h-2 rounded-full bg-[#3f6516]"></div>
                <span class="text-[9px] font-black uppercase tracking-widest">Approved</span>
              </div>
              <span class="text-[9px] font-bold text-[#3b3b3b] uppercase tracking-widest">{{ activity.controlNumber }}</span>
            </div>
            <h2 class="font-serif text-[28px] text-[#000] leading-tight mb-4">{{ activity.title }}</h2>
            
            <div class="flex flex-wrap gap-6 pt-4 border-t border-slate-100">
              <div class="flex flex-col"><span class="text-[9px] uppercase tracking-widest text-[#3b3b3b] font-bold mb-1">Submitted By</span><span class="text-[11px] font-semibold text-[#3f6516]">{{ activity.submittedBy }}</span></div>
              <div class="flex flex-col"><span class="text-[9px] uppercase tracking-widest text-[#3b3b3b] font-bold mb-1">Office</span><span class="text-[11px] font-medium text-[#3b3b3b]">{{ activity.office }}</span></div>
              <div class="flex flex-col"><span class="text-[9px] uppercase tracking-widest text-[#3b3b3b] font-bold mb-1">Date Submitted</span><span class="text-[11px] font-medium text-[#3b3b3b]">{{ activity.dateSubmitted }}</span></div>
            </div>
          </div>

          <div class="flex-1 overflow-y-auto custom-scrollbar p-8 space-y-6">
            <div class="bg-slate-50 rounded-xl p-5">
              <h3 class="font-bold text-[11px] uppercase tracking-widest text-[#3b3b3b] mb-4">Activity Description</h3>
              <p class="text-[11px] text-[#3b3b3b] leading-relaxed">{{ activity.description }}</p>
            </div>
            
            </div>
        </section>

        <section class="flex-[0.4] flex flex-col gap-5 sticky top-20 self-start">
          <div class="bg-white rounded-xl p-6 shadow-sm border">
            <h3 class="font-bold text-[11px] uppercase tracking-widest text-[#3b3b3b] mb-4">Assessment Status</h3>
            <div class="flex items-center gap-3 mb-4">
              <div class="w-10 h-10 rounded-full bg-[#3f6516]/20 flex items-center justify-center"><span class="material-symbols-outlined text-[#3f6516]">verified</span></div>
              <div><p class="text-[11px] font-bold text-[#3f6516]">Approved</p></div>
            </div>
            </div>
        </section>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const activity = ref({
  controlNumber: 'BSU-GAD-2026-003',
  title: 'Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit',
  submittedBy: 'Dr. Lorem Ipsum',
  office: 'Lorem Ipsum Office',
  dateSubmitted: 'Jan 15, 2026',
  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
});
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: #cfc2d544; border-radius: 10px; }
</style>