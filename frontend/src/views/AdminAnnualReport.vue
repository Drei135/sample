<template>
  <div class="annual-report-content">
    <div class="page-header mb-6">
      <h1 class="text-2xl font-bold text-slate-900">Annual Report</h1>
      <p class="text-slate-500 text-sm mt-1">Report monitoring and consolidation</p>
    </div>
    <div class="flex justify-between items-center mb-10">
          <div class="flex items-center gap-4">
            <select v-model="selectedYear" class="bg-white border border-outline-variant/30 rounded-xl px-4 py-2 text-sm font-bold shadow-sm focus:ring-2 focus:ring-primary outline-none">
              <option v-for="year in [2026, 2025, 2024]" :key="year" :value="year">{{ year }}</option>
            </select>
            <button @click="exportToExcel" class="bg-[#3f6516] text-white px-6 py-2 rounded-xl font-bold text-xs hover:bg-[#2d4a10] transition-all flex items-center gap-2 shadow-sm active:scale-95">
              <span class="material-symbols-outlined text-sm">download</span>
              Export to Excel
            </button>
          </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-10">
          <div class="bg-gradient-to-br from-primary to-primary-container p-6 rounded-2xl shadow-lg text-white">
            <p class="text-[10px] font-bold uppercase tracking-widest opacity-80 mb-2">Total GAD Budget</p>
            <h3 class="text-2xl font-headline font-extrabold">₱243,541,951</h3>
          </div>
          <div class="bg-white p-6 rounded-2xl shadow-sm border border-outline-variant/15">
            <p class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant mb-2">Total Beneficiaries</p>
            <h3 class="text-2xl font-headline font-extrabold text-primary">{{ totals.beneficiaries.toLocaleString() }}</h3>
            <p class="text-[9px] font-bold mt-2"><span class="text-blue-500">♂ Male</span> | <span class="text-purple-500">♀ Female</span></p>
          </div>
          <div class="bg-white p-6 rounded-2xl shadow-sm border border-outline-variant/15">
            <p class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant mb-2">Client-Focused</p>
            <h3 class="text-2xl font-headline font-extrabold text-on-surface">{{ currentData.clientFocused.length }}</h3>
            <p class="text-[9px] font-bold text-on-surface-variant mt-2 uppercase">Activities</p>
          </div>
          <div class="bg-white p-6 rounded-2xl shadow-sm border border-outline-variant/15">
            <p class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant mb-2">Organization-Focused</p>
            <h3 class="text-2xl font-headline font-extrabold text-on-surface">{{ currentData.orgFocused.length }}</h3>
            <p class="text-[9px] font-bold text-on-surface-variant mt-2 uppercase">Activities</p>
          </div>
        </div>

        <!-- Report Table -->
        <div class="bg-white rounded-2xl shadow-sm border border-outline-variant/15 overflow-hidden">
          <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="bg-gradient-to-r from-primary to-primary-container text-white text-[10px] font-bold uppercase tracking-widest">
                  <th class="p-4 border-r border-white/10 text-center">#</th>
                  <th class="p-4 border-r border-white/10">Gender Issue / Mandate</th>
                  <th class="p-4 border-r border-white/10">Cause of Issue</th>
                  <th class="p-4 border-r border-white/10">GAD Objective</th>
                  <th class="p-4 border-r border-white/10">Activity</th>
                  <th class="p-4 border-r border-white/10">Performance Indicators</th>
                  <th class="p-4 border-r border-white/10">Target Result</th>
                  <th class="p-4 border-r border-white/10 text-center">Male</th>
                  <th class="p-4 text-center">Female</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-outline-variant/10">
                <tr v-for="(item, idx) in currentData.clientFocused" :key="'c'+idx" class="text-xs hover:bg-primary/5 transition-colors cursor-pointer" @click="viewDetails(item)">
                  <td class="p-4 text-center border-r border-outline-variant/10">{{ idx + 1 }}</td>
                  <td class="p-4 border-r border-outline-variant/10 font-bold text-on-surface">{{ item.mandate }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.cause }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.result }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.activity }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.indicators }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.targetResult }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-center font-bold">{{ item.male.toLocaleString() }}</td>
                  <td class="p-4 text-center font-bold">{{ item.female.toLocaleString() }}</td>
                </tr>
                <tr class="bg-primary/5 font-bold text-primary">
                  <td colspan="7" class="p-4 text-[10px] uppercase tracking-widest">Client-Focused Mandates Total</td>
                  <td class="p-4 text-center border-r border-outline-variant/10">{{ totals.clientMale.toLocaleString() }}</td>
                  <td class="p-4 text-center">{{ totals.clientFemale.toLocaleString() }}</td>
                </tr>
                <tr v-for="(item, idx) in currentData.orgFocused" :key="'o'+idx" class="text-xs hover:bg-primary/5 transition-colors cursor-pointer" @click="viewDetails(item)">
                  <td class="p-4 text-center border-r border-outline-variant/10">{{ currentData.clientFocused.length + idx + 1 }}</td>
                  <td class="p-4 border-r border-outline-variant/10 font-bold text-on-surface">{{ item.mandate }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.cause }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.result }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.activity }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.indicators }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-on-surface-variant">{{ item.targetResult }}</td>
                  <td class="p-4 border-r border-outline-variant/10 text-center font-bold">{{ item.male.toLocaleString() }}</td>
                  <td class="p-4 text-center font-bold">{{ item.female.toLocaleString() }}</td>
                </tr>
                <tr class="bg-primary/5 font-bold text-primary">
                  <td colspan="7" class="p-4 text-[10px] uppercase tracking-widest">Organization-Focused Mandates Total</td>
                  <td class="p-4 text-center border-r border-outline-variant/10">{{ totals.orgMale.toLocaleString() }}</td>
                  <td class="p-4 text-center">{{ totals.orgFemale.toLocaleString() }}</td>
                </tr>
              </tbody>
              <tfoot class="bg-surface-container-high font-extrabold text-on-surface">
                <tr>
                  <td colspan="7" class="p-4 text-[11px] uppercase tracking-[0.1em]">Grand Total</td>
                  <td class="p-4 text-center border-r border-outline-variant/10 text-primary">{{ (totals.clientMale + totals.orgMale).toLocaleString() }}</td>
                  <td class="p-4 text-center text-primary">{{ (totals.clientFemale + totals.orgFemale).toLocaleString() }}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));
const selectedYear = ref(2026);

const annualReportData = {
  2026: {
    clientFocused: [
      { id: 1, mandate: "Universal Access to Tertiary Education", cause: "Socio-cultural discrimination", result: "Promote equitable access", activity: "Affirmative Action Agenda", indicators: "Students served", targetResult: "100% served", male: 1250, female: 2750 },
      { id: 2, mandate: "Free Tuition RA 10931", cause: "Financial barriers", result: "Eliminate barriers", activity: "Free tuition provision", indicators: "Qualified students", targetResult: "100% granted", male: 4800, female: 6200 }
    ],
    orgFocused: [
      { id: 3, mandate: "GAD Mainstreaming", cause: "Low awareness", result: "Enhance mainstreaming", activity: "Capability building", indicators: "Training sessions", targetResult: "25 sessions", male: 1000, female: 1500 }
    ]
  },
  2025: {
    clientFocused: [
      { id: 1, mandate: "Universal Access", cause: "Disasters", result: "Equitable access", activity: "Affirmative Action", indicators: "Students served", targetResult: "95% served", male: 1120, female: 2480 }
    ],
    orgFocused: [
      { id: 2, mandate: "Capability Building", cause: "Low awareness", result: "Enhance GAD", activity: "Training", indicators: "Sessions", targetResult: "20 sessions", male: 850, female: 1350 }
    ]
  }
};

const currentData = computed(() => annualReportData[selectedYear.value] || annualReportData[2026]);

const totals = computed(() => {
  const data = currentData.value;
  const clientMale = data.clientFocused.reduce((sum, item) => sum + item.male, 0);
  const clientFemale = data.clientFocused.reduce((sum, item) => sum + item.female, 0);
  const orgMale = data.orgFocused.reduce((sum, item) => sum + item.male, 0);
  const orgFemale = data.orgFocused.reduce((sum, item) => sum + item.female, 0);
  
  return {
    clientMale, clientFemale,
    orgMale, orgFemale,
    beneficiaries: clientMale + clientFemale + orgMale + orgFemale
  };
});

const exportToExcel = () => alert(`Exporting ${selectedYear.value} report...`);
const viewDetails = (item) => alert(`Details for: ${item.mandate}`);

onMounted(() => {
  if (!user.value.id || user.value.role !== 'admin') {
    router.push('/login');
  }
});
</script>

<style scoped>
</style>
