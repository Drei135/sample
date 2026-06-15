<template>
  <div class="min-h-screen bg-slate-50 p-8">
    <div class="mb-8">
      <div class="flex items-center gap-3 mb-2">
        <span class="text-4xl text-purple-600">👤</span>
        <h1 class="text-2xl font-bold text-black">Assign Mandates</h1>
      </div>
      <p class="text-slate-600 text-xs">Assign GAD mandates to accomplishment reports</p>
    </div>

    <div class="grid grid-cols-2 gap-8">
      
      <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div class="p-5 border-b border-slate-200 bg-slate-50 flex justify-between items-center">
          <h2 class="font-bold text-slate-800 flex items-center gap-2 text-xs">
            <span class="text-xl text-purple-600">📊</span> Accomplishment Reports
          </h2>
          <select v-model="currentFilter" class="text-xs border rounded-lg p-1.5">
            <option value="all">All Reports</option>
            <option value="unassigned">Unassigned Only</option>
            <option value="assigned">Assigned Only</option>
          </select>
        </div>

        <div class="max-h-[500px] overflow-y-auto">
          <div v-for="report in paginatedReports" :key="report.id" 
               @click="selectReport(report)"
               class="p-4 cursor-pointer border-b hover:bg-purple-50 transition"
               :class="{ 'bg-purple-100 border-l-4 border-l-purple-600': selectedReportId === report.id }">
            <div class="flex justify-between items-start">
              <div>
                <div class="flex items-center gap-2 mb-1">
                  <span class="font-mono text-[10px] font-bold text-purple-700">{{ report.control }}</span>
                  <span :class="report.assignedMandates.length > 0 ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'" 
                        class="text-[9px] px-2 py-0.5 rounded-full uppercase">{{ report.assignedMandates.length > 0 ? 'Assigned' : 'Unassigned' }}</span>
                </div>
                <p class="font-semibold text-xs text-black">{{ report.title }}</p>
                <div class="text-[10px] text-slate-500 mt-1">{{ report.office }} • {{ report.date }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden flex flex-col">
        <div class="p-5 border-b bg-slate-50">
          <h2 class="font-bold text-slate-800 flex items-center gap-2 text-xs">
            <span class="text-xl text-purple-600">🏛️</span> GAD Mandates
          </h2>
          <p class="text-[10px] text-slate-500 mt-1">{{ selectedReport ? 'Selected: ' + selectedReport.control : 'Select a report to view mandates' }}</p>
        </div>

        <div class="p-5 max-h-[500px] overflow-y-auto flex-1">
          <div v-if="!selectedReport" class="text-center py-10 text-slate-400 text-xs">
            Select a report to view available mandates
          </div>
          <div v-else class="space-y-2">
            <label v-for="mandate in gadMandates" :key="mandate.id" class="flex items-start gap-3 p-2 hover:bg-slate-50 rounded cursor-pointer">
              <input type="checkbox" :value="mandate.id" v-model="selectedMandates" class="mt-0.5">
              <span class="text-xs text-slate-700">{{ mandate.title }}</span>
            </label>
            
            <div class="border-t pt-4 mt-4">
              <label class="flex items-center gap-3 font-bold text-xs">
                <input type="checkbox" v-model="otherOptionEnabled"> Other (Specify)
              </label>
              <textarea v-if="otherOptionEnabled" v-model="otherMandateText" class="w-full mt-2 p-2 border rounded text-xs" placeholder="Enter other mandate..."></textarea>
            </div>
          </div>
        </div>

        <div class="p-5 border-t bg-slate-50">
          <button @click="confirmModal = true" :disabled="!selectedReport" class="w-full bg-purple-600 text-white p-3 rounded-lg font-bold text-xs">
            ✅ Set Mandates
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

// --- State ---
const selectedReportId = ref(null);
const selectedMandates = ref([]);
const otherOptionEnabled = ref(false);
const otherMandateText = ref('');
const currentFilter = ref('all');
const confirmModal = ref(false);

const accomplishmentReports = ref([ /* ... same data as original ... */ ]);
const gadMandates = ref([ /* ... same data as original ... */ ]);

// --- Computed ---
const selectedReport = computed(() => accomplishmentReports.value.find(r => r.id === selectedReportId.value));

const filteredReports = computed(() => {
  if (currentFilter.value === 'unassigned') return accomplishmentReports.value.filter(r => r.assignedMandates.length === 0);
  if (currentFilter.value === 'assigned') return accomplishmentReports.value.filter(r => r.assignedMandates.length > 0);
  return accomplishmentReports.value;
});

const paginatedReports = computed(() => filteredReports.value.slice(0, 5));

// --- Methods ---
const selectReport = (report) => {
  selectedReportId.value = report.id;
  selectedMandates.value = [...report.assignedMandates];
  otherOptionEnabled.value = !!report.otherMandate;
  otherMandateText.value = report.otherMandate || '';
};
</script>