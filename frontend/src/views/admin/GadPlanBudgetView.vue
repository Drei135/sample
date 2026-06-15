<template>
      <main class="flex-grow flex flex-col w-full box-border">
        
        <div class="controls-panel mb-3 flex justify-between items-center">
          <div class="panel-left">
            <h2 class="panel-title">Gender and Development Matrix</h2>
            <p class="panel-subtitle">Annual compliance and budget allocations</p>
          </div>
          <div class="panel-right flex items-center gap-3">
            <div class="year-selector-wrapper relative">
              <select 
                v-model="selectedYear" 
                @change="handleYearChange"
                class="year-selector"
              >
                <option value="2026">Year 2026</option>
                <option value="2025">Year 2025</option>
                <option value="2024">Year 2024</option>
              </select>
              <span class="material-symbols-outlined selector-icon">expand_more</span>
            </div>

            <button 
              @click="exportToExcel" 
              class="export-btn"
            >
              <span class="material-symbols-outlined">border_outer</span>
              Export Excel
            </button>
          </div>
        </div>

        <div class="view-toggle mb-3 flex gap-2 p-1 w-fit rounded-xl border border-[#b979cc]/10">
          <button 
            @click="activeView = 'table'" 
            :class="['view-btn', activeView === 'table' && 'view-btn-active']"
          >
            <span class="material-symbols-outlined">table_chart</span>
            Table View
          </button>
          <button 
            @click="activeView = 'pdf'" 
            :class="['view-btn', activeView === 'pdf' && 'view-btn-active']"
          >
            <span class="material-symbols-outlined">picture_as_pdf</span>
            PDF Document
          </button>
        </div>

        <div v-if="activeView === 'table'" class="table-container">
          <table class="gpb-table w-full table-fixed border-collapse">
            <thead>
              <tr class="table-header">
                <th class="th-col th-col-center th-col-num">#</th>
                <th class="th-col th-col-center th-col-mandate">Gender Issue / GAD Mandate</th>
                <th class="th-col th-col-center th-col-cause">Cause of Issue</th>
                <th class="th-col th-col-center th-col-result">GAD Result / Objective</th>
                <th class="th-col th-col-center th-col-mfo">Relevant MFO</th>
                <th class="th-col th-col-center th-col-activity">GAD Activity</th>
                <th class="th-col th-col-center th-col-indicators">Indicators / Targets</th>
                <th class="th-col th-col-center th-col-budget">Budget</th>
                <th class="th-col th-col-center th-col-source">Src</th>
              </tr>
            </thead>
            
            <tbody class="table-body">
              <tr class="section-header-row">
                <td colspan="9" class="section-header-cell client-header">
                  <span class="section-indicator client-indicator"></span>
                  CLIENT-FOCUSED ACTIVITIES
                 </td>
               </tr>
              <tr 
                v-for="(item, idx) in clientFocused" 
                :key="'client-' + item.id" 
                class="data-row"
              >
                <td class="data-cell data-cell-center data-cell-number">{{ idx + 1 }}</td>
                <td class="data-cell data-cell-mandate">{{ item.mandate }}</td>
                <td class="data-cell data-cell-cause">{{ item.cause }}</td>
                <td class="data-cell data-cell-result">{{ item.result }}</td>
                <td class="data-cell data-cell-mfo"><span class="mfo-badge">{{ item.mfo }}</span></td>
                <td class="data-cell data-cell-activity">{{ item.activity }}</td>
                <td class="data-cell data-cell-indicators">{{ item.indicators }}</td>
                <td class="data-cell data-cell-right data-cell-budget">{{ item.budget }}</td>
                <td class="data-cell data-cell-center data-cell-source">{{ item.source }}</td>
               </tr>

              <tr class="section-header-row">
                <td colspan="9" class="section-header-cell org-header">
                  <span class="section-indicator org-indicator"></span>
                  ORGANIZATION-FOCUSED ACTIVITIES
                 </td>
               </tr>
              <tr 
                v-for="(item, idx) in orgFocused" 
                :key="'org-' + item.id" 
                class="data-row"
              >
                <td class="data-cell data-cell-center data-cell-number">{{ clientFocused.length + idx + 1 }}</td>
                <td class="data-cell data-cell-mandate">{{ item.mandate }}</td>
                <td class="data-cell data-cell-cause">{{ item.cause }}</td>
                <td class="data-cell data-cell-result">{{ item.result }}</td>
                <td class="data-cell data-cell-mfo"><span class="mfo-badge">{{ item.mfo }}</span></td>
                <td class="data-cell data-cell-activity">{{ item.activity }}</td>
                <td class="data-cell data-cell-indicators">{{ item.indicators }}</td>
                <td class="data-cell data-cell-right data-cell-budget">{{ item.budget }}</td>
                <td class="data-cell data-cell-center data-cell-source">{{ item.source }}</td>
               </tr>
            </tbody>

            <tfoot>
              <tr class="total-row">
                <td colspan="7" class="total-label-cell">Total GAD Budget:</td>
                <td class="total-amount-cell">₱243,541,951</td>
                <td class="total-empty-cell"></td>
               </tr>
            </tfoot>
           </table>
        </div>

        <div v-else class="pdf-viewer-container">
          <div class="pdf-header">
            <div class="pdf-header-left">
              <span class="material-symbols-outlined pdf-icon">description</span>
              <h3 class="pdf-title">{{ selectedYear }} GAD Plan and Budget (GPB) Document</h3>
            </div>
            <div class="pdf-header-right flex gap-2">
              <a 
                :href="`/uploads/${selectedYear}-GPB.pdf`" 
                target="_self" 
                class="pdf-btn"
              >
                <span class="material-symbols-outlined">open_in_new</span>
                Open Full PDF
              </a>
              <a 
                :href="`/uploads/${selectedYear}-GPB.pdf`" 
                :download="`${selectedYear}-GPB.pdf`" 
                class="pdf-btn"
              >
                <span class="material-symbols-outlined">download</span>
                Download
              </a>
            </div>
          </div>
          <div class="pdf-frame-wrapper">
            <iframe 
              :src="`/uploads/${selectedYear}-GPB.pdf`" 
              class="pdf-frame"
            ></iframe>
          </div>
        </div>

      </main>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const mandates = ref([]);
const loading = ref(false);
const activeView = ref('table');
const selectedYear = ref('2026');

const handleYearChange = () => {
  activeView.value = 'pdf';
};

const clientFocused = ref([
  { id: 1, mandate: "RA 10931 - Affirmative Action Program", cause: "Extraordinary life situations due to disasters, calamities, and socio-cultural discrimination", result: "To promote equitable access and participation of both women and men from GIDAs in tertiary education", mfo: "Higher Education Program", activity: "Implementation of Affirmative Action Agenda", indicators: "Number of served disadvantaged students - 100% disadvantaged students", budget: "₱700,000", source: "GAA" },
  { id: 2, mandate: "RA 10931 - Free Tuition Provision", cause: "High tuition and miscellaneous fees, compounded by socio-cultural expectations for women", result: "To promote gender equality in access to tertiary education", mfo: "Higher Education Program", activity: "Provision of free tuition fee under RA 10931", indicators: "100% of qualified students granted free tuition", budget: "₱131,100,000", source: "GAA" },
  { id: 3, mandate: "CHED Memo 01 s.2015 - GAD Orientation", cause: "Limited activities to increase awareness of men and women students", result: "To increase the students level of awareness and appreciation on GAD", mfo: "Higher Education Program", activity: "Conduct GAD orientation/forum/seminar to students", indicators: "4,000 students oriented on GAD (F-2750 M-1250)", budget: "₱453,363", source: "GAA" },
  { id: 4, mandate: "CHED Memo 01 s.2015 - Student Leadership Training", cause: "Student leaders have limited understanding on GAD", result: "To empower student leaders regarding GAD responsive leadership", mfo: "Higher Education Program", activity: "Continuous conduct of GAD responsive leadership training", indicators: "2 training conducted (F:200 M:100)", budget: "₱150,000", source: "GAA" },
  { id: 5, mandate: "GREP Extension Program", cause: "Presence of gender inequality, poverty and GAD-related concerns", result: "To sustain GAD-related extension activities", mfo: "Extension Services", activity: "Conduct of Extension project/activities", indicators: "24 extension activities conducted (F:560 M:500)", budget: "₱3,500,000", source: "GAA" },
  { id: 6, mandate: "PWD Programs", cause: "Limited access of PWDs to gender-responsive programs", result: "Improved access of PWDs to gender-responsive programs", mfo: "Research Services", activity: "Gender-responsive programs for PWDs", indicators: "Number of PWDs who benefited", budget: "₱350,000", source: "GAA" },
  { id: 7, mandate: "Senior Citizens Program", cause: "Absence of senior citizens access to sustainable programs", result: "Improved access of senior citizens to gender-responsive programs", mfo: "Extension Services", activity: "BSU Kalinga for women Senior Citizens", indicators: "Programs provided for Senior Citizens", budget: "₱250,000", source: "GAA" }
]);

const orgFocused = ref([
  { id: 8, mandate: "GAD Mainstreaming Capability Building", cause: "Low awareness among personnel about GAD mainstreaming", result: "To enhance GAD mainstreaming in Administration, Academic, Research and Extension", mfo: "Research Services", activity: "Conduct GAD related Gender Mainstreaming capability building", indicators: "25 training/workshop/seminars conducted (F:1500 M:1000)", budget: "₱4,000,000", source: "GAA" },
  { id: 9, mandate: "GFPS Capacity Building", cause: "Low level of capacity of GFPS members", result: "Capacitated GFPS members to implement GAD PAPs", mfo: "Research Services", activity: "GMFE/HGDG/GPB/GAD Deepening Session", indicators: "At least 1 training per GFPS member (F:31 M:15)", budget: "₱396,000", source: "GAA" },
  { id: 10, mandate: "Gender Sensitivity Training", cause: "Lack of regular orientation on gender sensitivity", result: "To enhance awareness of gender concepts among personnel", mfo: "Higher Education Program", activity: "Conduct Gender Sensitivity Training", indicators: "1 training for newly hired, 3 refresher trainings (F:50 M:20)", budget: "₱421,728", source: "GAA" },
  { id: 11, mandate: "Child Minding Center", cause: "Problems of parents and students related to child care", result: "Ensure access to agency care services for children", mfo: "Research Services", activity: "Maintenance of Child Minding Center", indicators: "Fully maintained child minding centers", budget: "₱230,000", source: "GAA" },
  { id: 12, mandate: "Breastfeeding Station", cause: "Inadequate support for breastfeeding mothers", result: "Adequate support services for personnel with children", mfo: "Research Services", activity: "Establishment/maintenance of breastfeeding stations", indicators: "100% fully maintained lactation rooms", budget: "₱220,000", source: "GAA" },
  { id: 13, mandate: "GAD Database System", cause: "No centralized GAD database", result: "Institutionalized GAD database system", mfo: "Higher Education Program", activity: "Institutionalize GAD database and Sex-Disaggregated Database", indicators: "Fully functional GAD database", budget: "₱500,000", source: "GAA" },
  { id: 14, mandate: "VAW Campaigns", cause: "Need to highlight women's rights and provide platform to invoke protection", result: "To strengthen awareness on women's rights", mfo: "Research Services", activity: "Participation to 18-Day Campaign to end VAW and Women's Month", indicators: "At least one activity conducted per campus", budget: "₱450,000", source: "GAA" },
  { id: 15, mandate: "IEC Materials Development", cause: "Presence of Gender Based Violence issues", result: "Institutionalize GAD mechanisms and sustain awareness campaigns", mfo: "Research Services", activity: "Development and Dissemination of GAD IEC Materials", indicators: "Official Publication of BSU with GAD articles", budget: "₱296,000", source: "GAA" }
]);

const exportToExcel = () => {
  alert(`Exporting ${selectedYear.value} GAD Plan & Budget table content to Excel...`);
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

const fetchMandates = () => {
  console.log('Fetching mandates...');
};

onMounted(() => {
  if (!user.value.id || user.value.role !== 'admin') {
    router.push('/login');
  }
  fetchMandates();
});
</script>

<style scoped>
.controls-panel {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border: 1px solid rgba(185, 121, 204, 0.1);
  padding: 1rem;
  border-radius: 1rem;
  backdrop-filter: blur(4px);
}

.panel-title {
  font-size: 1.125rem;
  font-weight: bold;
  color: white;
  letter-spacing: -0.025em;
}

.view-toggle {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border: 1px solid rgba(185, 121, 204, 0.1);
}

.panel-subtitle {
  font-size: 0.9rem;
  color: rgba(203, 213, 225, 0.7);
  margin-top: 0.125rem;
}

.year-selector-wrapper {
  position: relative;
}

.year-selector {
  appearance: none;
  border: 1px solid rgba(185, 121, 204, 0.2);
  border-radius: 0.75rem;
  padding: 0.5rem 2rem 0.5rem 0.75rem;
  font-size: 1rem;
  background-color: #1a1a2e;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.year-selector:focus {
  outline: none;
  ring: 2px solid #990dd1;
}

.selector-icon {
  position: absolute;
  right: 0.625rem;
  top: 50%;
  transform: translateY(-50%);
  color: #b979cc;
  font-size: 1rem;
  pointer-events: none;
}

/* Export Button */
.export-btn {
  background: rgba(0, 0, 0, 0.3);
  color: white;
  border: 1px solid rgba(185, 121, 204, 0.15);
  padding: 0.5rem 1rem;
  border-radius: 0.75rem;
  font-size: 1rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  backdrop-filter: blur(4px);
  transition: all 0.2s;
}

.export-btn:hover {
  border-color: rgba(185, 121, 204, 0.4);
  background: rgba(0, 0, 0, 0.5);
}

.export-btn .material-symbols-outlined {
  color: #b979cc;
  font-size: 1rem;
}

.view-btn {
  padding: 0.375rem 1rem;
  border-radius: 0.5rem;
  font-size: 1rem;
  font-weight: bold;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.375rem;
  cursor: pointer;
  color: #cbd5e1;
  background: transparent;
  border: none;
}

.view-btn:hover {
  color: white;
  background: rgba(255, 255, 255, 0.05);
}

.view-btn-active {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.view-btn .material-symbols-outlined {
  font-size: 1.1rem;
}

.table-container {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background: rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(4px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  width: 100%;
}

.gpb-table {
  width: 100%;
  border-collapse: collapse;
}

.table-header {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  color: #b979cc;
  text-transform: uppercase;
  font-size: 0.85rem;
  font-weight: 800;
  letter-spacing: 0.05em;
  border-bottom: 1px solid rgba(185, 121, 204, 0.2);
}

.th-col {
  padding: 0.625rem;
  border-right: 1px solid rgba(185, 121, 204, 0.15);
}

.th-col-left {
  text-align: left;
}

.th-col-right {
  text-align: right;
}

.th-col-center {
  text-align: center;
}

.th-col-num { width: 3%; }
.th-col-mandate { width: 15%; }
.th-col-cause { width: 14%; }
.th-col-result { width: 15%; }
.th-col-mfo { width: 11%; }
.th-col-activity { width: 14%; }
.th-col-indicators { width: 14%; }
.th-col-budget { width: 9%; }
.th-col-source { width: 5%; }

/* Table Body */
.table-body {
  font-size: 0.9rem;
  color: #cbd5e1;
}

.section-header-row {
  background: rgba(26, 26, 46, 0.9);
  border-bottom: 1px solid rgba(185, 121, 204, 0.15);
  font-weight: bold;
  color: white;
  font-size: 0.85rem;
  letter-spacing: 0.025em;
}

.section-header-cell {
  padding: 0.625rem 0.75rem;
}

.client-header {
  background: linear-gradient(90deg, rgba(153, 13, 209, 0.15) 0%, transparent 100%);
}

.org-header {
  background: linear-gradient(90deg, rgba(185, 121, 204, 0.15) 0%, transparent 100%);
}

.section-indicator {
  display: inline-block;
  width: 0.375rem;
  height: 0.375rem;
  border-radius: 9999px;
  margin-right: 0.375rem;
}

.client-indicator {
  background-color: #990dd1;
}

.org-indicator {
  background-color: #b979cc;
}

.data-row {
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
  transition: background-color 0.15s;
}

.data-row:hover {
  background-color: rgba(153, 13, 209, 0.05);
}

.data-cell {
  background: #cbd5e1;
  padding: 0.625rem;
  border-right: 1px solid rgba(185, 121, 204, 0.1);
  vertical-align: top;
  font-size: 0.70rem;
}

.data-cell-center {
  text-align: center;
}

.data-cell-right {
  text-align: right;
}

.data-cell-number {
  font-weight: bold;
  color: #990dd1;
}

.data-cell-mandate {
  font-weight: 500;
  color: #16213e;
  word-break: break-word;
  white-space: normal;
}

.data-cell-cause,
.data-cell-indicators {
  color: #16213e;
  line-height: 1.5;
  word-break: break-word;
  white-space: normal;
}

.data-cell-result {
  color: #16213e;
  line-height: 1.5;
  font-weight: 500;
  word-break: break-word;
  white-space: normal;
}

.data-cell-activity {
  color: #16213e;
  font-weight: 500;
  word-break: break-word;
  white-space: normal;
}

.data-cell-budget {
  font-weight: bold;
  color: #16213e;
  letter-spacing: -0.025em;
  white-space: nowrap;
}

.data-cell-source {
  font-weight: bold;
  color: #16213e;
}

.mfo-badge {
  display: block;
  background: rgba(0, 0, 0, 0.4);
  padding: 0.125rem 0.375rem;
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 0.25rem;
  font-size: 0.85rem;
  color: rgba(255, 255, 255, 0.8);
  text-align: center;
  font-weight: 500;
}

/* Total Row */
.total-row {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  font-weight: bold;
  color: white;
  font-size: 1rem;
  border-top: 2px solid rgba(185, 121, 204, 0.3);
}

.total-label-cell {
  padding: 0.75rem;
  border-right: 1px solid rgba(185, 121, 204, 0.15);
  text-align: right;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 800;
  color: #b979cc;
}

.total-amount-cell {
  padding: 0.75rem;
  border-right: 1px solid rgba(185, 121, 204, 0.15);
  text-align: right;
  font-size: 1.1rem;
  font-weight: 900;
  background: rgba(153, 13, 209, 0.1);
  letter-spacing: 0.025em;
  white-space: nowrap;
}

.total-empty-cell {
  padding: 0.75rem;
}

/* PDF Viewer */
.pdf-viewer-container {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background: rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(4px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  transition: all 0.2s;
  width: 100%;
}

.pdf-header {
  padding: 1rem;
  border-bottom: 1px solid rgba(185, 121, 204, 0.15);
  background: rgba(26, 26, 46, 0.6);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pdf-header-left {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.pdf-icon {
  color: #b979cc;
  font-size: 1.25rem;
}

.pdf-title {
  font-weight: bold;
  color: white;
  font-size: 1rem;
}

.pdf-btn {
  background: rgba(0, 0, 0, 0.3);
  color: white;
  border: 1px solid rgba(185, 121, 204, 0.15);
  padding: 0.375rem 0.75rem;
  border-radius: 0.75rem;
  font-size: 1rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.375rem;
  cursor: pointer;
  transition: all 0.2s;
  text-decoration: none;
}

.pdf-btn:hover {
  border-color: rgba(185, 121, 204, 0.4);
  background: rgba(0, 0, 0, 0.5);
}

.pdf-btn .material-symbols-outlined {
  font-size: 1.1rem;
}

.pdf-frame-wrapper {
  padding: 0;
  background: rgba(255, 255, 255, 0.05);
}

.pdf-frame {
  width: 100%;
  border: none;
  min-height: 550px;
  height: 720px;
}

/* Footer */
.app-footer {
  width: 100%;
  text-align: center;
  padding-bottom: 1rem;
  pointer-events: none;
  font-size: 0.85rem;
  color: rgba(255, 255, 255, 0.3);
  font-weight: 500;
  letter-spacing: 0.025em;
}

/* Text Rendering */
.gpb-table th {
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
  word-wrap: break-word;
  hyphens: auto;
}

.gpb-table td {
  word-wrap: break-word;
}

/* Scrollbar */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: #1a1a2e;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: rgba(185, 121, 204, 0.25);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #990dd1;
}
</style>