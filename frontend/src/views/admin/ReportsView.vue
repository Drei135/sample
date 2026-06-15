<template>

      <main class="main-content">
        <div class="content-wrapper">
          
          <section class="filter-panel">
            <div>
              <h1 class="filter-title">Consolidated Report</h1>
              <p class="filter-subtitle">Yearly overview tracking total corporate mandates and combined beneficiary participant metrics.</p>
            </div>
            
            <div class="year-selector-wrapper">
              <span class="year-label">Select Fiscal Year:</span>
              <div class="year-selector-container">
                <select v-model="selectedYear" @change="handleYearChange" class="year-select">
                  <option v-for="y in availableYears" :key="y" :value="y">{{ y }}</option>
                </select>
                <span class="year-select-arrow">▼</span>
              </div>
            </div>
          </section>

          <section class="stats-section">
            <div v-for="stat in metricsSummary" :key="stat.label" class="stat-card">
              <div class="stat-card-inner">
                <div :class="['stat-icon', stat.bgClass]">
                  <span class="material-symbols-outlined stat-icon-symbol" :class="stat.iconColor">{{ stat.icon }}</span>
                </div>
                <div class="stat-info">
                  <h3 class="stat-value">{{ stat.value }}</h3>
                  <p class="stat-label">{{ stat.label }}</p>
                </div>
              </div>
            </div>
          </section>

          <div class="table-container">
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr class="table-header-main">
                    <th rowspan="2" class="table-header-cell col-number">#</th>
                    <th rowspan="2" class="table-header-cell col-mandate">GENDER ISSUE / GAD MANDATE</th>
                    <th rowspan="2" class="table-header-cell col-cause">CAUSE OF GENDER ISSUE</th>
                    <th rowspan="2" class="table-header-cell col-objective">GAD RESULT STATEMENT / OBJECTIVE</th>
                    <th rowspan="2" class="table-header-cell col-activity">GAD ACTIVITY</th>
                    <th rowspan="2" class="table-header-cell col-indicators">PERFORMANCE INDICATORS / TARGETS</th>
                    <th rowspan="2" class="table-header-cell col-result">TARGET RESULT</th>
                    <th colspan="2" class="table-header-cell col-attendance">ATTENDANCE</th>
                    <th rowspan="2" class="table-header-cell col-actions">ACTIONS</th>
                  </tr>
                  <tr class="table-header-sub">
                    <th class="sub-header-cell male-attendance">MALE</th>
                    <th class="sub-header-cell female-attendance">FEMALE</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="reportItems.length === 0">
                    <td colspan="11" class="empty-state">
                      No matching historical mandate aggregates discovered for fiscal year {{ selectedYear }}.
                    </td>
                  </tr>
                  <tr v-else v-for="(item, index) in reportItems" :key="item.id" class="table-row">
                    <td class="table-cell cell-number">{{ index + 1 }}</td>
                    <td class="table-cell cell-mandate">
                      <div class="cell-content">{{ item.mandate_title }}</div>
                    </td>
                    <td class="table-cell cell-cause">
                      <div class="cell-content">{{ item.cause_of_issue || '—' }}</div>
                    </td>
                    <td class="table-cell cell-objective">
                      <div class="cell-content">{{ item.gad_objective || '—' }}</div>
                    </td>
                    <td class="table-cell cell-activity">
                      <div class="cell-content">{{ item.gad_activity || '—' }}</div>
                    </td>
                    <td class="table-cell cell-indicators">
                      <div class="cell-content">{{ item.performance_indicators || '—' }}</div>
                    </td>
                    <td class="table-cell cell-result">
                      <div class="cell-content">{{ item.target_result || '—' }}</div>
                    </td>
                    <td class="table-cell cell-attendance-male">{{ formatNum(item.attendance_male || 0) }}</td>
                    <td class="table-cell cell-attendance-female">{{ formatNum(item.attendance_female || 0) }}</td>
                    <td class="table-cell cell-actions">
                      <button @click="viewDetails(item.id)" class="view-btn">View →</button>
                    </td>
                  </tr>
                </tbody>
                <tfoot v-if="reportItems.length > 0" class="table-footer">
                  <tr>
                    <td colspan="7" class="footer-label text-right">Total Attendance:</td>
                    <td class="footer-number combined-total">{{ formatNum(totals.attendanceMale) }}</td>
                    <td class="footer-number combined-total">{{ formatNum(totals.attendanceFemale) }}</td>
                    <td class="footer-empty"></td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </div>

        </div>
      </main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const selectedYear = ref(new Date().getFullYear());
const availableYears = ref([2026, 2025, 2024]);
const reportItems = ref([]);

const totals = computed(() => {
  let attendanceMale = 0, attendanceFemale = 0;
  reportItems.value.forEach(i => {
    attendanceMale += (i.attendance_male || 0);
    attendanceFemale += (i.attendance_female || 0);
  });
  return {
    attendanceMale,
    attendanceFemale
  };
});

const metricsSummary = computed(() => [
  { label: 'Total Attendance (Male)', value: formatNum(totals.value.attendanceMale), icon: 'person', iconColor: 'text-purple-400', bgClass: 'bg-purple-500/10' },
  { label: 'Total Attendance (Female)', value: formatNum(totals.value.attendanceFemale), icon: 'co_present', iconColor: 'text-pink-400', bgClass: 'bg-pink-500/10' },
  { label: 'Total Activities', value: formatNum(reportItems.value.length), icon: 'event_note', iconColor: 'text-blue-400', bgClass: 'bg-blue-500/10' },
  { label: 'Completion Rate', value: '0%', icon: 'trending_up', iconColor: 'text-cyan-400', bgClass: 'bg-cyan-500/10' }
]);

const formatNum = (val) => Number(val).toLocaleString();
const handleYearChange = () => { fetchAnnualReportData(); };
const viewDetails = (id) => { router.push(`/admin/mandate-details/${id}`); };
const exportToExcel = () => { console.log(`Exporting baseline data models...`); };

const fetchAnnualReportData = async () => {
  try {
    // API Bind Pipeline Staging
    // const res = await api.get(`admin/annual-report?year=${selectedYear.value}`);
    // reportItems.value = res.data;
  } catch (err) { console.error(err); }
};

const handleLogout = async () => {
  try {
    await api.get('logout');
    localStorage.removeItem('user');
    router.push('/login');
  } catch (err) {
    localStorage.removeItem('user');
    router.push('/login');
  }
};

onMounted(() => {
  if (!user.value.id || user.value.role !== 'admin') { 
    router.push('/login'); 
  } else { 
    fetchAnnualReportData(); 
  }
});
</script>

<style scoped>
.annual-report {
  min-height: 100vh;
  display: flex;
  color: #cbd5e1;
  font-family: system-ui, -apple-system, sans-serif;
}

.annual-report ::selection {
  background: rgba(153, 13, 209, 0.3);
  color: white;
}

.main-container {
  flex-grow: 1;
  margin-left: 256px;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  width: calc(100% - 256px);
  overflow-x: hidden;
}

.app-header {
  position: fixed;
  top: 0;
  left: 256px;
  right: 0;
  height: 80px;
background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  backdrop-filter: blur(24px);
  z-index: 40;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 40px;
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.header-title {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  background: linear-gradient(135deg, white, #cbd5e1, #b979cc);
  background-clip: text;
  -webkit-background-clip: text;
  color: transparent;
}

.header-subtitle-wrapper {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.125rem;
}

.header-subtitle {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: #b979cc;
  font-weight: 800;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.export-btn {
  padding: 0.5rem 1rem;
  border-radius: 0.75rem;
  font-size: 1rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: white;
  border: 1px solid rgba(185, 121, 204, 0.3);
  background: rgba(0, 0, 0, 0.4);
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.export-btn:hover {
  background: rgba(153, 13, 209, 0.2);
  border-color: rgba(185, 121, 204, 0.6);
}

.main-content {
  padding-left: 0;
  flex-grow: 1;
  width: 100%;
  overflow-x: hidden;
}

.content-wrapper {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  max-width: 100%;
  overflow-x: hidden;
}

.filter-panel {
  padding: 1rem;
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(8px);
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  flex-wrap: wrap;
}

.filter-title {
  font-size: 1.35rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: white;
}

.filter-subtitle {
  font-size: 0.725rem;
  color: #475569;
  margin-top: 0.125rem;
}

.year-selector-wrapper {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.year-label {
  font-size: 1rem;
  color: #94a3b8;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.year-selector-container {
  position: relative;
  width: 144px;
}

.year-select {
  width: 100%;
  padding: 0.5rem 0.75rem;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(185, 121, 204, 0.2);
  font-size: 1rem;
  font-weight: 700;
  color: white;
  appearance: none;
  cursor: pointer;
  transition: all 0.3s;
}

.year-select:focus {
  outline: none;
  border-color: rgba(185, 121, 204, 0.5);
}

.year-select-arrow {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #94a3b8;
  font-size: 0.85rem;
  pointer-events: none;
}

/* Stats Section */
.stats-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
}

.stat-card {
  padding: 0.85rem 1rem;
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(8px);
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.stat-card-inner {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.stat-icon {
  width: 38px;
  height: 38px;
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.stat-icon-symbol {
  font-weight: 500;
  font-size: 1.05rem;
}

/* Icon Colors */
.text-purple-400 { color: #c084fc; }
.text-pink-400 { color: #f472b6; }
.text-blue-400 { color: #60a5fa; }
.text-cyan-400 { color: #22d3ee; }

/* Background Classes */
.bg-purple-500\/10 { background: rgba(168, 85, 247, 0.1); }
.bg-pink-500\/10 { background: rgba(236, 72, 153, 0.1); }
.bg-blue-500\/10 { background: rgba(59, 130, 246, 0.1); }
.bg-cyan-500\/10 { background: rgba(6, 182, 212, 0.1); }

.stat-info {
  min-width: 0;
}

.stat-value {
  font-size: 1.45rem;
  font-weight: 700;
  letter-spacing: -0.025em;
  color: white;
  line-height: 1.25;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.stat-label {
  font-size: 0.6rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: rgba(203, 213, 225, 0.7);
  margin-top: 0.125rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Maximized Table Container */
.table-container {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(8px);
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  width: 100%;
  overflow: hidden; /* Removes any side scrollbars entirely */
}

.table-wrapper {
  width: 100%;
}

.data-table {
  width: 100%;
  text-align: left;
  border-collapse: collapse;
  table-layout: fixed; /* Mandates absolute compliance with fluid percentages below */
}

/* Percentage Width Distributions - Maximizes view while ensuring zero horizontal overflow */
.col-number { width: 3%; text-align: center; }
.col-mandate { width: 16%; }
.col-cause { width: 14%; }
.col-objective { width: 14%; }
.col-activity { width: 13%; }
.col-indicators { width: 15%; }
.col-result { width: 8%; }
.col-attendance { width: 11%; text-align: center; }
.col-actions { width: 6%; text-align: center; }

/* Table Header */
.table-header-main {
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.table-header-cell {
  padding: 0.625rem 0.4rem;
  font-size: 0.85rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #ffffffd3;
  vertical-align: middle;
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
  word-break: break-word;
  text-align: center;
}

/* Sub Header */
.table-header-sub {
  background: rgba(0, 0, 0, 0.2);
}

.sub-header-cell {
  padding: 0.4rem;
  font-size: 0.85rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #b979cc;
  text-align: center;
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
}

/* Table Body */
.table-body {
  display: table-row-group;
  background: #cbd5e1;
}

.empty-state {
  padding: 3rem;
  text-align: center;
  font-size: 1rem;
  color: #94a3b8;
  font-weight: 500;
}

.table-row {
  transition: all 0.3s;
  border-bottom: 1px solid rgba(185, 121, 204, 0.05);
}

.table-row:hover {
  background: rgba(255, 255, 255, 0.04);
}

.table-cell {
  padding: 0.5rem 0.4rem;
  vertical-align: top;
  border-bottom: 1px solid rgba(185, 121, 204, 0.05);
  font-size: 0.9rem; /* Highly balanced size for seamless screen rendering */
}

.cell-content {
  word-break: break-word;
  line-height: 1.4;
  max-height: none; /* Removes awkward inner mini-scrollbars */
  overflow-y: visible;
}

.cell-number {
  text-align: center;
  font-family: monospace;
  color: #b979cc;
  font-weight: 600;
}

.cell-mandate .cell-content,
.cell-cause .cell-content,
.cell-objective .cell-content {
  font-weight: 500;
  color: #e2e8f0;
}

.cell-activity .cell-content,
.cell-indicators .cell-content,
.cell-result .cell-content {
  color: #cbd5e1;
}

.male-attendance {
    color: #1278f6;
}

.female-attendance {
    color: #e948f4;
}

.cell-attendance-male,
.cell-attendance-female {
  text-align: center;
  font-weight: 600;
  color: #b979cc;
  font-family: monospace;
}

.cell-actions {
  text-align: center;
}

.view-btn {
  color: #b979cc;
  font-weight: 700;
  transition: color 0.2s;
  cursor: pointer;
  font-size: 0.9rem;
  background: none;
  border: none;
  padding: 0.125rem 0.25rem;
  white-space: nowrap;
}

.view-btn:hover {
  color: white;
}

/* Table Footer */
.table-footer {
  background: rgba(0, 0, 0, 0.4);
  border-top: 2px solid rgba(185, 121, 204, 0.2);
  font-weight: 900;
}

.footer-label {
  padding: 0.625rem 0.4rem;
  text-align: right;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #cbd5e1;
}

.text-right {
  text-align: right;
}

.footer-number {
  padding: 0.625rem 0.4rem;
  text-align: center;
  font-weight: 700;
}

.combined-total {
  background: rgba(153, 13, 209, 0.15);
  color: #b979cc;
  font-size: 0.95rem;
  font-weight: 800;
}

.footer-empty {
  padding: 0.625rem 0.4rem;
}

/* Scrollbar */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
}

::-webkit-scrollbar-thumb {
  background: rgba(185, 121, 204, 0.3);
  border-radius: 99px;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(153, 13, 209, 0.5);
}

/* Media Query Layout Reflow Protections */
@media (max-width: 1024px) {
  .main-container {
    margin-left: 0;
    width: 100%;
  }
  
  .app-header {
    left: 0;
  }
  
  .stats-section {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .filter-panel {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .year-selector-wrapper {
    width: 100%;
    justify-content: space-between;
  }
  
  .content-wrapper {
    padding: 20px;
  }
}

@media (max-width: 768px) {
  .stats-section {
    grid-template-columns: 1fr;
  }
}
</style>