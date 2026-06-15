<template>
  <main class="main-viewport">
    <div v-if="loading" class="loading-wrapper">
      <div class="loading-spinner"></div>
    </div>

    <div v-else-if="error" class="error-view-wrapper">
      <div class="error-card">
        <div class="error-glow"></div>
        <div class="error-icon-container">
          <span class="material-symbols-outlined error-icon">error</span>
        </div>
        <h2 class="error-heading">Error Loading Data</h2>
        <p class="error-text">{{ error }}</p>
        <button @click="router.back()" class="error-btn">
          <span class="material-symbols-outlined btn-icon">arrow_back</span>
          Go Back
        </button>
      </div>
    </div>

    <div v-else class="page-container">
      <div class="layout-grid">

        <section class="flex-06 glass-card">
          <div class="report-header">
            <div class="meta-header">
              <div class="status-badge-wrapper">
                <div class="status-badge-view" :class="getStatusClass(report.status)">
                  <span class="status-text">{{ formatStatus(report.status) }}</span>
                </div>
                <span class="control-number">{{ report.control_number || 'N/A' }}</span>
              </div>
              <div class="header-meta-group">
                <div class="meta-tag">
                  <span class="info-label header-label">Category:</span>
                  <span class="info-value-white uppercase">Accomplishment Report</span>
                </div>
                <div class="meta-tag">
                  <span class="info-label header-label">Form Type:</span>
                  <span class="info-value-white uppercase">{{ formatFormType(report.form_type) }}</span>
                </div>
              </div>
            </div>

            <h2 class="report-title">{{ report.activity_title }}</h2>

            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">Submitted By</span>
                <span class="info-value-white">{{ report.username || '---' }} ({{ report.email || '---' }})</span>
              </div>
              <div class="info-item">
                <span class="info-label">Office / Unit</span>
                <span class="info-value-white">{{ report.office || '---' }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">Date Submitted</span>
                <span class="info-value-white">{{ formatDate(report.created_at) }}</span>
              </div>
            </div>
          </div>

          <div class="report-body">
            <!-- Implementation Details -->
            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">event_available</span>
                <h3 class="section-title">Implementation Details</h3>
              </div>
              <div class="grid-2">
                <div>
                  <label class="info-label">Date</label>
                  <p class="info-value-white">{{ formatDate(report.start_date) }} — {{ formatDate(report.end_date) }}</p>
                </div>
                <div>
                  <label class="info-label">Time</label>
                  <p class="info-value-white">{{ formatTime(report.start_time) }} to {{ formatTime(report.end_time) }}</p>
                </div>
                <div class="full-width-info">
                  <label class="info-label">Venue</label>
                  <p class="info-value-white">{{ report.venue }}</p>
                </div>
              </div>
              
              <div class="participants-summary mt-4 pt-4 border-t border-white/10">
                <label class="info-label mb-3 block">Participation Breakdown</label>
                <div class="grid-3">
                  <div class="metric-box">
                    <span class="metric-value">{{ report.male || 0 }}</span>
                    <span class="metric-label">Male</span>
                  </div>
                  <div class="metric-box">
                    <span class="metric-value">{{ report.female || 0 }}</span>
                    <span class="metric-label">Female</span>
                  </div>
                  <div class="metric-box total-highlight">
                    <span class="metric-value">{{ report.attendees || 0 }}</span>
                    <span class="metric-label">Total Attendees</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Budget Section -->
            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">payments</span>
                <h3 class="section-title">Actual Budgetary Requirements</h3>
              </div>
              <div v-if="parsedBudget.length" class="budget-content">
                <div class="budget-table-wrapper">
                  <table class="budget-table">
                    <thead class="budget-table-header">
                      <tr>
                        <th class="table-header-cell">Budget Item</th>
                        <th class="table-header-cell budget-total-header">Total</th>
                      </tr>
                    </thead>
                    <tbody class="budget-table-body">
                      <tr v-for="(item, idx) in parsedBudget" :key="idx" class="budget-table-row">
                        <td class="budget-item-name" v-html="formatBudgetName(item.name)"></td>
                        <td class="budget-item-value-cell budget-value-right">
                          <span class="budget-item-value">₱{{ formatCurrency(item.total) }}</span>
                        </td>
                      </tr>
                    </tbody>
                    <tfoot class="budget-table-footer">
                      <tr>
                        <td class="grand-total-label">Actual Total Expenditures</td>
                        <td class="grand-total-value-white budget-value-right">₱{{ formatCurrency(actualTotal) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
              <div v-else class="empty-budget-notice">
                No budgetary records found for this report.
              </div>
            </div>


            <!-- Evaluation Results -->
            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">analytics</span>
                <h3 class="section-title">Evaluation Results</h3>
              </div>
              <div class="evaluation-content">
                <div class="budget-table-wrapper">
                  <table class="budget-table">
                    <thead class="budget-table-header">
                      <tr>
                        <th class="table-header-cell">Area of Evaluation</th>
                        <th class="table-header-cell text-center">Rating</th>
                        <th class="table-header-cell text-right">Interpretation</th>
                      </tr>
                    </thead>
                    <tbody class="budget-table-body">
                      <tr v-for="(item, idx) in parsedEvaluation" :key="idx" class="budget-table-row">
                        <td class="budget-item-name">{{ item.area }}</td>
                        <td class="budget-item-value-cell text-center">
                          <span class="font-bold text-white">{{ item.rating }}</span>
                        </td>
                        <td class="budget-item-value-cell text-right">
                          <span :class="getInterpretationClass(item.rating)">{{ getInterpretation(item.rating) }}</span>
                        </td>
                      </tr>
                    </tbody>
                    <tfoot class="budget-table-footer">
                      <tr>
                        <td class="grand-total-label">Total Average Rating</td>
                        <td class="text-center font-black text-white text-lg">{{ report.rating }}</td>
                        <td class="text-right">
                          <span class="font-bold" :class="getInterpretationClass(report.rating)">
                            {{ getInterpretation(report.rating) }}
                          </span>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>

            <!-- Supporting Documents -->
            <div v-if="parsedAttachments.length" class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">description</span>
                <h3 class="section-title">Submitted Documents</h3>
              </div>
              <div class="doc-list">
                <div v-for="(file, index) in parsedAttachments" :key="index" class="doc-item">
                  <div class="doc-info">
                    <span class="material-symbols-outlined doc-pdf-icon">picture_as_pdf</span>
                    <div>
                      <p class="doc-title">Attachment {{ index + 1 }}</p>
                      <p class="doc-meta">Reference: {{ file }}</p>
                    </div>
                  </div>
                  <button @click="previewFile(file)" class="preview-btn">👁️ Preview</button>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Assessment Sidebar -->
        <section class="flex-04-sidebar">
          <div class="assessment-card-custom">
            <div class="assessment-header">
              <div class="assessment-icon">📋</div>
              <div class="assessment-title">Report Assessment</div>
            </div>

            <div class="assessment-form">
              <div class="info-item assessment-field">
                <span class="info-label">Date of Assessment</span>
                <span class="info-value-white">{{ formatDate(report.assessment_date) || '---' }}</span>
              </div>

              <div class="info-item">
                <span class="info-label">Reviewer Remarks</span>
                <div class="read-only-remarks">
                  {{ report.remarks || 'No remarks provided for this report.' }}
                </div>
              </div>

              <div class="action-buttons">
                <button @click="router.back()" class="btn-back">
                  ← Back to Tracker
                </button>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>

    <PdfPreviewModal :isOpen="isPdfModalOpen" :fileUrl="pdfFileUrl" @close="closePdfModal" />
  </main>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../../api';
import PdfPreviewModal from '../../components/PdfPreviewModal.vue';

const route = useRoute();
const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));
const report = ref({});
const loading = ref(true);
const error = ref(null);

const fetchReportDetails = async () => {
  loading.value = true;
  try {
    const id = route.params.id;
    const response = await api.get(`activity-report/${id}`);
    if (response.data.success) report.value = response.data.data;
    else error.value = "Accomplishment report not found.";
  } catch (err) {
    error.value = "Failed to load report details.";
  } finally {
    loading.value = false;
  }
};

const formatDate = (date) => date ? new Date(date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' }) : '---';
const formatTime = (time) => {
  if (!time) return '---';
  const [h, m] = time.split(':');
  return `${h % 12 || 12}:${m} ${h >= 12 ? 'PM' : 'AM'}`;
};

const formatStatus = (status) => {
  if (!status) return 'Unknown';
  return status.charAt(0).toUpperCase() + status.slice(1);
};

const formatFormType = (type) => {
  const map = { 'employee': 'Employee Training', 'inset': 'INSET', 'extension': 'Extension Program' };
  return map[type] || type;
};

const getStatusClass = (status) => {
  const s = (status || '').toLowerCase();
  if (s === 'pending') return 'pending';
  if (s === 'approved' || s === 'verified') return 'approved';
  if (s.includes('revision')) return 'revision';
  return 'completed';
};

const formatCurrency = (amt) => amt ? parseFloat(amt).toLocaleString(undefined, { minimumFractionDigits: 2 }) : '0.00';

const parsedBudget = computed(() => {
  const r = report.value;
  if (!r) return [];

  // Mapping for individual columns if joined from a 'report_budget_items' style table
  const items = [
    { name: 'Meals and Snacks (AM/PM)', total: r.meals_and_snacks },
    { name: 'Function Room/Venue', total: r.function_room_venue },
    { name: 'Accommodation', total: r.accommodation },
    { name: 'Equipment Rental', total: r.equipment_rental },
    { name: 'Professional Fee/Honoria', total: r.professional_fee_honoria },
    { name: 'Token/s', total: r.tokens },
    { name: 'Materials and Supplies', total: r.materials_and_supplies },
    { name: 'Transportation', total: r.transportation }
  ];

  const filteredItems = items.filter(item => item.total !== undefined && item.total !== null && Number(item.total) > 0);
  if (filteredItems.length > 0) return filteredItems;

  // Fallback: If stored as a JSON string in the 'budget_items' column
  if (r.budget_items) {
    try {
      const jsonItems = typeof r.budget_items === 'string' ? JSON.parse(r.budget_items) : r.budget_items;
      return Array.isArray(jsonItems) ? jsonItems.filter(item => Number(item.total) > 0) : [];
    } catch (e) { return []; }
  }

  return [];
});

const parsedEvaluation = computed(() => {
  const r = report.value;
  if (!r) return [];

  // Mapping for individual columns if joined from an 'accomplishment_evaluation_results' table
  const items = [
    { area: 'Time Management', rating: r.time_management },
    { area: 'Orderliness and Program Flow', rating: r.orderliness_and_program_flow },
    { area: 'Appropriateness of the Venue', rating: r.appropriateness_of_venue },
    { area: 'Sound System and Hall Preparation', rating: r.sound_system_and_hall_preparation },
    { area: 'Restroom/s', rating: r.restrooms },
    { area: 'Food and Drinks', rating: r.food_drinks }
  ];

  const filteredItems = items.filter(item => item.rating !== undefined && item.rating !== null && Number(item.rating) > 0);
  if (filteredItems.length > 0) return filteredItems;

  // Fallback: If stored as a JSON string in the 'evaluation_items' column
  if (r.evaluation_items) {
    try {
      const jsonItems = typeof r.evaluation_items === 'string' ? JSON.parse(r.evaluation_items) : r.evaluation_items;
      return Array.isArray(jsonItems) ? jsonItems : [];
    } catch (e) { return []; }
  }

  return [];
});

const getInterpretation = (rating) => {
  const val = parseFloat(rating);
  if (isNaN(val) || val === 0) return '-';
  if (val >= 4.51) return 'Outstanding';
  if (val >= 4.01) return 'Very Good';
  if (val >= 3.51) return 'Good';
  if (val >= 3.01) return 'Average';
  if (val >= 2.51) return 'Fair';
  if (val >= 2.01) return 'Poor';
  return 'Very Poor';
};

const getInterpretationClass = (rating) => {
  const val = parseFloat(rating);
  if (isNaN(val) || val === 0) return '';
  if (val >= 4.51) return 'text-emerald-400';
  if (val >= 4.01) return 'text-teal-400';
  if (val >= 3.51) return 'text-cyan-400';
  if (val >= 3.01) return 'text-amber-400';
  return 'text-rose-400';
};

const formatBudgetName = (name) => name ? name.replace(/(\(.*\))/g, '<span class="budget-item-subtext">$1</span>') : '';

const actualTotal = computed(() => {
  return parsedBudget.value.reduce((sum, item) => sum + (Number(item.total) || 0), 0);
});

const parsedAttachments = computed(() => {
  const att = report.value.attachment;
  if (!att) return [];
  try {
    // If it's already an array, return it; otherwise parse the JSON string
    const parsed = typeof att === 'string' ? JSON.parse(att) : att;
    return Array.isArray(parsed) ? parsed : [att];
  } catch (e) {
    // Fallback for legacy data stored as plain strings
    return [att];
  }
});

const isPdfModalOpen = ref(false);
const pdfFileUrl = ref('');

const previewFile = (fileName) => {
  if (!fileName) return;
  const base = (import.meta.env.VITE_API_BASE_URL ? import.meta.env.VITE_API_BASE_URL.replace('/api/', '') : 'http://localhost:8080');
  pdfFileUrl.value = `${base}/api/files/drafts/${fileName}`;
  isPdfModalOpen.value = true;
};

const closePdfModal = () => { isPdfModalOpen.value = false; pdfFileUrl.value = ''; };

onMounted(() => {
  if (!user.value.id) router.push('/login');
  else fetchReportDetails();
});
</script>

<style scoped>
.main-viewport { flex: 1; height: 100vh; background: transparent; }
.loading-wrapper { display: flex; justify-content: center; align-items: center; min-height: 400px; }
.page-container { max-width: 1280px; margin: 0 auto; }
.glass-card { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); backdrop-filter: blur(24px); border-radius: 24px; border: 1px solid rgba(185, 121, 204, 0.2); }
.layout-grid { display: flex; gap: 20px; }
.flex-06 { flex: 0.65; }
.flex-04-sidebar { flex: 0.35; position: sticky; top: 20px; align-self: flex-start; }
.report-header { padding: 32px; border-bottom: 1px solid rgba(185, 121, 204, 0.15); background: rgba(0, 0, 0, 0.2); }
.meta-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
.header-meta-group { display: flex; gap: 20px; align-items: center; }
.meta-tag { display: flex; flex-direction: column; align-items: flex-end; text-align: right; }
.header-label { color: #64748b !important; margin-bottom: 2px; }
.report-title { font-family: 'Times New Roman', serif; font-size: 26px; color: white; line-height: 1.25; margin: 16px 0; }
.status-badge-view { padding: 4px 12px; border-radius: 9999px; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; }
.status-badge-view.completed { background: rgba(34, 197, 94, 0.15); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.3); }
.status-badge-view.cancelled { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
.status-badge-view.pending { background: rgba(245, 158, 11, 0.15); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.3); }
.status-badge-view.approved { background: rgba(59, 130, 246, 0.15); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.3); }
.status-badge-view.revision { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
.status-badge-wrapper { display: flex; align-items: center; gap: 8px; }
.control-number { font-size: 13px; font-weight: 700; color: #b979cc; text-transform: uppercase; margin-left: 12px; font-family: monospace; }
.info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 16px; }
.info-label { font-size: 13px; text-transform: uppercase; color: #b979cc; font-weight: 800; letter-spacing: 0.05em; }
.info-value-white { color: white; font-weight: 600; font-size: 13px; display: block; }
.report-body { padding: 32px; display: flex; flex-direction: column; gap: 24px; }
.section-card { background: rgba(0, 0, 0, 0.25); border-radius: 16px; padding: 20px; border: 1px solid rgba(185, 121, 204, 0.12); }
.section-header-row { display: flex; align-items: center; gap: 8px; margin-bottom: 1rem; }
.section-title { font-size: 13px; font-weight: 800; text-transform: uppercase; color: #b979cc; letter-spacing: 0.1em; }
.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.metric-box { background: rgba(0, 0, 0, 0.2); border: 1px solid rgba(255, 255, 255, 0.05); padding: 12px; border-radius: 12px; text-align: center; }
.metric-value { display: block; font-size: 20px; font-weight: 800; color: white; }
.metric-label { font-size: 13px; color: #94a3b8; text-transform: uppercase; }
.total-highlight { border-color: rgba(185, 121, 204, 0.4); background: rgba(185, 121, 204, 0.05); }
.budget-table-wrapper { border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.1); overflow: hidden; }
.budget-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.budget-table-header { background: rgba(255, 255, 255, 0.05); color: #b979cc; text-transform: uppercase; font-size: 13px; letter-spacing: 0.05em; }
.table-header-cell { padding: 10px 16px; text-align: left; font-weight: 700; }
.budget-table-row { border-top: 1px solid rgba(255, 255, 255, 0.05); }
.budget-item-name { padding: 12px 16px; color: #cbd5e1; line-height: 1.25; font-size: 13px; }
.budget-item-value-cell { padding: 8px 16px; color: white; font-size: 13px; }
.budget-table-footer { background: rgba(255, 255, 255, 0.05); font-weight: 800; }
.grand-total-label { padding: 12px 16px; text-align: right; color: #b979cc; text-transform: uppercase; font-size: 13px; font-weight: 700; letter-spacing: 0.05em;}
.grand-total-value-white { padding: 12px 16px; color: white; font-weight: 700; font-size: 14px; }
.doc-item { display: flex; justify-content: space-between; align-items: center; background: rgba(0, 0, 0, 0.3); padding: 12px 16px; border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.1); }
.doc-list { display: flex; flex-direction: column; gap: 12px; }
.doc-info { display: flex; align-items: center; gap: 12px; }
.doc-pdf-icon { color: #f87171; font-size: 32px; }
.doc-title { color: white; font-weight: 700; font-size: 13px; }
.doc-meta { color: #94a3b8; font-size: 13px; }
.preview-btn { background: rgba(185, 121, 204, 0.1); border: 1px solid rgba(185, 121, 204, 0.3); color: #b979cc; padding: 6px 16px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.preview-btn:hover { background: #b979cc; color: white; }
.assessment-card-custom { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 24px; padding: 32px; border: 1px solid rgba(185, 121, 204, 0.2); }
.assessment-header { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
.assessment-icon { background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
.assessment-title { color: #b979cc; font-weight: 800; text-transform: uppercase; font-size: 13px; }
.read-only-remarks { background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(185, 121, 204, 0.2); border-radius: 12px; padding: 15px; color: #cbd5e1; font-size: 13px; min-height: 100px; margin-top: 10px; line-height: 1.5; }
.btn-back { width: 100%; margin-top: 20px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(255, 255, 255, 0.1); color: #94a3b8; padding: 12px; border-radius: 10px; font-size: 13px; font-weight: 800; text-transform: uppercase; cursor: pointer; }
.btn-back:hover { color: white; border-color: #b979cc; }
.icon-pink { color: #b979cc; }
.text-emerald-400 { color: #34d399; }
.text-teal-400 { color: #2dd4bf; }
.text-cyan-400 { color: #22d3ee; }
.text-amber-400 { color: #fbbf24; }
.text-rose-400 { color: #f87171; }
.text-right { padding-right: 20px; font-size: 13px; }
</style>