<template>
  <main class="main-viewport">
    <div v-if="loading" class="loading-wrapper">
      <div class="loading-spinner"></div>
    </div>

    <div v-else-if="error" class="error-view-wrapper">
      <div class="error-card">
        <div class="error-glow"></div>
        <div class="error-icon-container">
          <span class="material-symbols-outlined error-icon" v-if="error.includes('Access Denied')">gpp_bad</span>
          <span class="material-symbols-outlined error-icon" v-else>error</span>
        </div>
        <h2 class="error-heading">
          {{ error.includes('Access Denied') ? 'Access Restricted' : 'Error Loading Data' }}
        </h2>
        <p class="error-text">
          {{ error }}
        </p>
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
                <div class="status-badge-view" :class="getStatusClass(design.status)">
                  <span class="status-text">{{ formatStatus(design.status) }}</span>
                </div>
                <span class="control-number">{{ design.control || 'PENDING ASSIGNMENT' }}</span>
              </div>
              <div class="meta-group">
                <div class="meta-item">
                  <span class="info-label header-label">Category</span>
                  <span class="info-value-white">Activity Design</span>
                </div>
                <div class="meta-item">
                  <span class="info-label header-label">Form Type</span>
                  <span class="info-value-white">{{ formatFormType(design.form_type) }}</span>
                </div>
              </div>
            </div>

            <h2 class="report-title">{{ design.activity_title }}</h2>

            <div class="info-grid">
              <div class="info-item">
              <span class="info-label">Submitted By</span>
              <span class="info-value-white">{{ design.username || '' }} {{ design.email ? '(' + design.email + ')' : '' }}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Office / Unit</span>
                <span class="info-value-white">{{ design.office }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">Date Submitted</span>
                <span class="info-value-white">{{ design.date || '---' }}</span>
              </div>
            </div>
          </div>

          <div class="report-body">
            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">calendar_month</span>
                <h3 class="section-title">Schedule & Venue</h3>
              </div>
              <div class="grid-2">
                <div>
                  <label class="info-label">Date</label>
                  <p class="info-value-white">{{ formatDate(design.start_date) }} — {{ formatDate(design.end_date) }}</p>
                </div>
                <div>
                  <label class="info-label">Time</label>
                  <p class="info-value-white">{{ formatTime(design.start_time) }} to {{ formatTime(design.end_time) }}</p>
                </div>
                <div class="full-width-info">
                  <label class="info-label">Venue</label>
                  <p class="info-value-white">{{ design.venue }}</p>
                </div>
                <div class="full-width-info participants-info">
                  <label class="info-label">Target Participants</label>
                  <p class="info-value-white">{{ design.target_participants }} individuals</p>
                </div>
              </div>
            </div>

            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">payments</span>
                <h3 class="section-title">Proposed Budgetary Requirements</h3>
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
                        <td class="grand-total-label">Grand Total (PHP)</td>
                        <td class="grand-total-value-white budget-value-right">₱{{ formatCurrency(design.proposed_budget) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
              <div v-else class="empty-budget-notice">
                No budgetary requirements were specified for this design.
              </div>
            </div>

            <div v-if="design.attachment" class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">description</span>
                <h3 class="section-title">Supporting Documents</h3>
              </div>
              <div class="doc-item">
                <div class="doc-info">
                  <span class="material-symbols-outlined doc-pdf-icon">picture_as_pdf</span>
                  <div>
                    <p class="doc-title">Activity_Design_Framework.pdf</p>
                    <p class="doc-meta">Reference: {{ design.attachment }}</p>
                  </div>
                </div>
                <button @click="previewFile(design.attachment)" class="preview-btn">👁️ Preview</button>
              </div>
            </div>
          </div>
        </section>

        <section class="flex-04-sidebar">
          <div class="assessment-card-custom">
            <div class="assessment-header">
              <div class="assessment-icon">
                <span class="material-symbols-outlined">edit_square</span>
              </div>
              <div class="assessment-title">Design Assessment</div>
            </div>

            <div class="assessment-form">
              <div class="info-item assessment-field">
                <label class="info-label">Control Number</label>
                <div class="control-input-wrapper">
                  <span class="control-prefix">{{ currentYear }}-</span>
                  <input 
                    v-model="assessmentForm.controlSuffix" 
                    type="text" 
                    class="modal-input control-suffix-input" 
                    :placeholder="suggestedSuffix || '0000'"
                  >
                </div>
              </div>

              <div class="info-item assessment-field">
                <label class="info-label">Accomplishment Deadline</label>
                <input 
                  v-model="assessmentForm.accomplishment_deadline" 
                  type="date" 
                  class="modal-input"
                >
              </div>

              <div class="info-item assessment-field">
                <label class="info-label">Date of Assessment</label>
                <input 
                  v-model="assessmentForm.assessment_date" 
                  type="date" 
                  class="modal-input"
                >
              </div>

              <div class="info-item">
                <label class="info-label">Reviewer Remarks / Comments</label>
                <textarea 
                  v-model="assessmentForm.remarks" 
                  class="modal-input remarks-textarea" 
                  placeholder="Enter feedback or instructions..."
                ></textarea>
              </div>

              <div class="action-buttons">
                <button @click="submitAssessment('approved')" class="btn-approve" :disabled="submitting">
                  <span class="material-symbols-outlined">check_circle</span>
                  {{ submitting ? 'Processing...' : 'Approve Design' }}
                </button>
                
                <button @click="submitAssessment('revision')" class="btn-revision" :disabled="submitting">
                  <span class="material-symbols-outlined">edit_note</span>
                  Request Revision
                </button>

                <button @click="router.back()" class="btn-back">
                  ← Back to List
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
import Swal from 'sweetalert2';
import PdfPreviewModal from '../../components/PdfPreviewModal.vue';

const route = useRoute();
const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));
const design = ref({});
const loading = ref(true);
const submitting = ref(false);
const error = ref(null);
const currentYear = new Date().getFullYear();
const suggestedSuffix = ref('');

const assessmentForm = ref({
  controlSuffix: '',
  assessment_date: new Date().toISOString().split('T')[0],
  accomplishment_deadline: '',
  remarks: ''
});

const calculateNextControl = async () => {
  try {
    const response = await api.get('activity-designs');
    if (response.data.success) {
      const currentMonth = String(new Date().getMonth() + 1).padStart(2, '0');
      const yearPrefix = `${currentYear}-`;
      let maxVal = 0;

      response.data.data.forEach(item => {
        if (item.control && item.control.startsWith(yearPrefix)) {
          const suffix = item.control.split('-')[1];
          const val = parseInt(suffix);
          if (!isNaN(val) && val > maxVal) maxVal = val;
        }
      });

      if (maxVal === 0) {
        suggestedSuffix.value = `${currentMonth}01`;
      } else {
        const monthInMax = Math.floor(maxVal / 100);
        if (parseInt(currentMonth) > monthInMax) suggestedSuffix.value = `${currentMonth}01`;
        else suggestedSuffix.value = String(maxVal + 1).padStart(4, '0');
      }
    }
  } catch (err) {
    console.error("Error calculating next control:", err);
  }
};

const fetchDesignDetails = async () => {
  loading.value = true;
  try {
    const id = route.params.id;
    const response = await api.get(`activity-design/${id}`);
    if (response.data.success) {
      design.value = response.data.data;
      assessmentForm.value = {
        controlSuffix: design.value.control ? design.value.control.split('-')[1] : '',
        assessment_date: design.value.assessment_date || new Date().toISOString().split('T')[0],
        accomplishment_deadline: design.value.accomplishment_deadline || '',
        remarks: design.value.remarks || ''
      };
    }
    else error.value = "Activity design not found.";
  } catch (err) {
    error.value = "Failed to load activity design.";
  } finally {
    loading.value = false;
  }
};

const submitAssessment = async (action) => {
  const form = assessmentForm.value;
  const fullControl = `${currentYear}-` + form.controlSuffix;

  if (action === 'approved') {
    if (!form.controlSuffix || !form.assessment_date || !form.accomplishment_deadline) {
      Swal.fire({
        icon: 'warning',
        title: 'Incomplete Assessment',
        text: 'Control Number, Assessment Date, and Accomplishment Deadline are required for approval.',
        confirmButtonColor: '#b979cc'
      });
      return;
    }
  } 
  else if (action === 'revision') {
    if (!form.controlSuffix || !form.remarks || !form.remarks.trim()) {
      Swal.fire({
        icon: 'warning',
        title: 'Incomplete Request',
        text: 'Both Control Number and Reviewer Remarks are required to request a revision.',
        confirmButtonColor: '#b979cc'
      });
      return;
    }
  }

  const result = await Swal.fire({
    title: action === 'approved' ? 'Confirm Approval?' : 'Confirm Revision Request?',
    text: action === 'approved' 
      ? 'This will assign the control number and move both the Activity Design and its associated Accomplishment Report to the archives database.' 
      : 'This will return the design to the submitter for revision.',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, Proceed',
    confirmButtonColor: '#b979cc',
    cancelButtonColor: '#64748b'
  });

  if (!result.isConfirmed) return;

  submitting.value = true;
  try {
    const id = route.params.id;
    const endpoint = action === 'approved' ? `approve-design/${id}` : `revision-design/${id}`;
    
    const submitData = new FormData();
    submitData.append('control', fullControl);
    if (form.assessment_date) submitData.append('assessment-date', form.assessment_date);
    if (form.accomplishment_deadline) submitData.append('accomplishment-deadline', form.accomplishment_deadline);
    submitData.append('remarks', form.remarks || '');
    submitData.append('status', action === 'approved' ? 'Approved' : 'Revision');

    // Explicitly signal the move to archives database for both entities
    if (action === 'approved') {
      submitData.append('is_archived', '1');
      submitData.append('archive_associated_entities', 'true');
    }

    const response = await api.post(endpoint, submitData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });

    if (response.data.success) {
      Swal.fire({
        icon: 'success',
        title: action === 'approved' ? 'Design Approved' : 'Revision Requested',
        text: response.data.message || (action === 'approved' 
          ? 'The activity design has been approved and a control number assigned.' 
          : 'The design has been returned to the submitter for revision.'),
        confirmButtonColor: '#b979cc'
      }).then(() => router.push('/admin/ad-list'));
    }
  } catch (err) {
    console.error('Assessment Error:', err);
    Swal.fire('Action Failed', err.response?.data?.message || 'A server error occurred.', 'error');
  } finally {
    submitting.value = false;
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
  const s = status.toLowerCase();
  if (s === 'revision') return 'For Revision';
  return status.charAt(0).toUpperCase() + status.slice(1);
};


const formatFormType = (type) => {
  if (!type) return '---';
  const map = {
    'employee': 'Employee Training',
    'inset': 'INSET Training',
    'extension': 'Extension Program',
    'student': 'Student Activity'
  };
  return map[type] || type;
};

const getStatusClass = (status) => {
  const s = (status || '').toLowerCase();
  if (s === 'pending') return 'pending';
  if (s === 'approved') return 'approved';
  if (s === 'completed' || s === 'archived') return 'completed';
  if (s === 'cancelled') return 'cancelled';
  if (s === 'Revision' || s === 'revision') return 'revision';
  return 'completed';
};

const formatCurrency = (amt) => amt ? parseFloat(amt).toLocaleString(undefined, { minimumFractionDigits: 2 }) : '0.00';

const parsedBudget = computed(() => {
  const d = design.value;
  if (!d || !d.act_design_id) return [];

  const items = [
    { name: 'Meals and Snacks (AM/PM)', total: d.meals_and_snacks },
    { name: 'Function Room/Venue', total: d.function_room_venue },
    { name: 'Accommodation', total: d.accommodation },
    { name: 'Equipment Rental', total: d.equipment_rental },
    { name: 'Professional Fee/Honoria', total: d.professional_fee_honoria },
    { name: 'Token/s', total: d.tokens },
    { name: 'Materials and Supplies', total: d.materials_and_supplies },
    { name: 'Transportation', total: d.transportation }
  ];

  return items.filter(item => Number(item.total) > 0);
});

const formatBudgetName = (name) => {
  if (!name) return '';
  return name.replace(/(\(.*\))/g, '<span class="budget-item-subtext">$1</span>');
};

const isPdfModalOpen = ref(false);
const pdfFileUrl = ref('');

const previewFile = (fileName) => {
  if (!fileName) return;
  const base = (import.meta.env.VITE_API_BASE_URL ? import.meta.env.VITE_API_BASE_URL.replace('/api/', '') : 'https://gad-ams-2-1.onrender.com');
  const folder = design.value.is_archived ? 'archived' : 'drafts';
  pdfFileUrl.value = `${base}/api/files/${folder}/${fileName}`;
  isPdfModalOpen.value = true;
};

const closePdfModal = () => {
  isPdfModalOpen.value = false;
  pdfFileUrl.value = '';
};

onMounted(() => {
  if (!user.value.id || user.value.role !== 'admin') router.push('/login');
  else {
    fetchDesignDetails();
    calculateNextControl();
  }
});
</script>

<style scoped>
.main-viewport { flex: 1;  height: 100vh; background: transparent; }

.loading-wrapper { display: flex; justify-content: center; align-items: center; min-height: 400px; }

.error-container { max-width: 48rem; margin: 0 auto; padding: 2.5rem; }

.error-box { background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; padding: 1rem; border-radius: 0.75rem; }

.error-title { color: #ef4444; font-weight: 700; }

.error-message { color: #cbd5e1; font-size: 1.1rem; }
.error-back-btn { margin-top: 1rem; font-size: 1.1rem; font-weight: 700; color: #ef4444; background: transparent; border: none; cursor: pointer; }
.page-container { min-height: 100vh;  }
.glass-card { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); backdrop-filter: blur(24px); border-radius: 1.5rem; border: 1px solid rgba(185, 121, 204, 0.2); }

.layout-grid { display: flex; gap: 10px; max-width: 80rem; margin: 0 auto; align-items: flex-start; }
.flex-06 { flex: 0.65; display: flex; flex-direction: column; overflow: hidden; }
.flex-04-sidebar { flex: 0.35; top: 0px; align-self: flex-start; }

.report-header { padding: 2rem; border-bottom: 1px solid rgba(185, 121, 204, 0.15); background: rgba(0, 0, 0, 0.2); }
.meta-header { display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem; }
.status-badge-wrapper { display: flex; align-items: center; }
.meta-group { display: flex; gap: 20px; align-items: center; }
.meta-item { display: flex; flex-direction: column; align-items: flex-end; text-align: right; }
.header-label { color: #64748b !important; margin-bottom: 2px; }

.report-title { font-family: 'Times New Roman', serif; font-size: 26px; color: white; line-height: 1.25; margin: 1rem 0; }
.status-badge-view { padding: 4px 12px; border-radius: 9999px; font-size: 12px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; }
.status-badge-view.completed { background: rgba(34, 197, 94, 0.15); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.3); }
.status-badge-view.cancelled { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
.status-badge-view.pending { background: rgba(245, 158, 11, 0.15); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.3); }
.status-badge-view.approved { background: rgba(59, 130, 246, 0.15); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.3); }
.status-badge-view.revision { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
.control-number { font-size: 13px; font-weight: 700; color: #b979cc; text-transform: uppercase; margin-left: 12px; font-family: monospace; }

.info-grid { display: flex; flex-wrap: wrap; gap: 24px; padding-top: 16px; border-top: 1px solid rgba(185, 121, 204, 0.1); }
.info-item { display: flex; flex-direction: column; }
.info-label { font-size: 12px; text-transform: uppercase; color: #b979cc; font-weight: 700; margin-bottom: 4px; }
.info-value-white { font-size: 14px; font-weight: 600; color: white; text-transform: uppercase; }
.info-value-purple { font-size: 14px; font-weight: 600; color: white; }

.report-body { padding: 2rem; }
.report-body > * + * { margin-top: 1.5rem; }
.section-card { background: rgba(0, 0, 0, 0.2); border-radius: 16px; padding: 24px; border: 1px solid rgba(185, 121, 204, 0.15); }
.section-header-row { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1rem; }
.section-title { font-weight: 800; font-size: 13px; text-transform: uppercase; color: #b979cc; }
.icon-pink { color: #b979cc; }
.grid-2 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
.metric-box { background: rgba(0, 0, 0, 0.3); border-radius: 12px; padding: 16px; text-align: center; border: 1px solid rgba(185, 121, 204, 0.1); }
.metric-value { font-size: 24px; font-weight: 700; color: white; }
.metric-label { font-size: 12px; color: #cbd5e1; text-transform: uppercase; margin-top: 4px; }
.doc-item { display: flex; align-items: center; justify-content: space-between; padding: 16px; background: rgba(0, 0, 0, 0.3); border-radius: 12px; border: 1px solid rgba(185, 121, 204, 0.15); }
.doc-info { display: flex; align-items: center; gap: 12px; }
.doc-pdf-icon { font-size: 1.8rem; color: #ef4444; }
.doc-title { font-size: 13px; font-weight: 700; color: white; }
.doc-meta { font-size: 11px; color: #cbd5e1; margin-top: 2px; }
.preview-btn { color: #b979cc; font-size: 11px; padding: 6px 16px; border-radius: 8px; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(185, 121, 204, 0.15); font-weight: 700; cursor: pointer; transition: all 0.2s; }
.preview-btn:hover { border-color: #b979cc; color: white; background: rgba(185, 121, 204, 0.1); }

.assessment-card-custom {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-radius: 1.5rem;
  padding: 2rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(185, 121, 204, 0.2);
}
.assessment-header { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid rgba(185, 121, 204, 0.15); }
.assessment-icon { border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #b979cc; font-size: 22px; }
.assessment-title { font-size: 14px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; color: #b979cc; }
.assessment-form { display: flex; flex-direction: column; }

.control-input-wrapper { margin-bottom: 8px; display: flex; align-items: center; border: 1px solid rgba(185, 121, 204, 0.2); border-radius: 12px; background: rgba(0, 0, 0, 0.4); overflow: hidden; margin-top: 4px; }
.control-prefix { padding: 11px 12px; font-size: 13px; font-weight: 700; color: #fff; border-right: 1px solid rgba(185, 121, 204, 0.2); white-space: nowrap; }
.control-suffix-input { border: none !important; border-radius: 0 !important; background: transparent !important; margin: 0 !important; flex: 1; }
.control-suffix-input:focus { outline: none; box-shadow: none; }

.modal-input { width: 100%; padding: 11px 18px; margin: 0 0 10px 0; border: 1px solid rgba(185, 121, 204, 0.2); background: rgba(0, 0, 0, 0.4); color: white; border-radius: 12px; font-size: 13px; margin-top: 4px; }
.modal-input:focus { outline: none; border-color: #b979cc; background: rgba(0, 0, 0, 0.5); }
.remarks-textarea { min-height: 120px; resize: vertical; line-height: 1.5; }

.modal-input::-webkit-calendar-picker-indicator {
  filter: invert(1);
  cursor: pointer;
  opacity: 0.8;
  transition: opacity 0.2s;
}
.modal-input::-webkit-calendar-picker-indicator:hover { opacity: 1; }

.action-buttons { display: flex; flex-direction: column; gap: 10px; margin-top: 24px; padding-top: 20px; border-top: 1px solid rgba(185, 121, 204, 0.15); }
.btn-approve { background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); color: white; border: none; border-radius: 12px; padding: 12px; font-size: 12px; font-weight: 800; text-transform: uppercase; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s; }
.btn-approve:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(153, 13, 209, 0.3); }
.btn-revision { background: rgba(239, 68, 68, 0.1); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 12px; padding: 12px; font-size: 12px; font-weight: 800; text-transform: uppercase; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s; }
.btn-revision:hover:not(:disabled) { background: rgba(239, 68, 68, 0.2); border-color: #f87171; }
.btn-back { width: 100%; padding: 12px; font-size: 11px; font-weight: 800; text-transform: uppercase; color: #cbd5e1; border-radius: 12px; background: transparent; border: 1px solid rgba(185, 121, 204, 0.15); cursor: pointer; transition: all 0.2s; }
.btn-back:hover { color: white; border-color: #b979cc; background: rgba(185, 121, 204, 0.05); }

.empty-budget-notice {
  color: #64748b;
  font-size: 13px;
  font-style: italic;
}

.budget-table-wrapper {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(0, 0, 0, 0.2);
}

.budget-table {
  width: 100%;
  text-align: left;
  border-collapse: collapse;
}

.budget-table-header {
  background-color: rgba(255, 255, 255, 0.05);
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
}

.table-header-cell {
  padding: 10px 16px;
  font-weight: 700;
}

.budget-table-row {
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.budget-item-name {
  padding: 12px 16px;
  color: #b979cc;
  line-height: 1.25;
  font-size: 13px;
}

.budget-item-subtext {
  display: block;
  font-size: 12px;
  color: #64748b;
  font-weight: 400;
  margin-top: 2px;
}

.budget-item-value-cell {
  color: white;
  padding: 8px 16px;
  font-size: 12px;
}

.budget-table-footer {
  background-color: rgba(255, 255, 255, 0.05);
}

.grand-total-label {
  padding: 12px 16px;
  font-size: 12px;
  font-weight: 700;
  color: #b979cc;
  text-align: right;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.grand-total-value-white {
  padding: 12px 16px;
  font-size: 14px;
  font-weight: 700;
  color: white;
}
</style>