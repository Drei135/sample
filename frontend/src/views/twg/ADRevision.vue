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
        <button @click="router.back()" class="error-btn-red">
          <span class="material-symbols-outlined btn-icon">arrow_back</span>
          Go Back
        </button>
      </div>
    </div>

    <div v-else class="page-container">
      <div class="layout-grid">
        <!-- LEFT SECTION - Edit Form -->
        <section class="flex-06 glass-card">
          <div class="report-header">
            <div class="meta-header">
              <div class="status-badge-revision">
                <div class="status-dot-pulse"></div>
                <span class="status-text">Revision Mode</span>
              </div>
              <span class="control-number">{{ design.control || 'PENDING ASSIGNMENT' }}</span>
            </div>

            <div class="form-group-top">
              <label class="form-label">Activity Title</label>
              <input 
                v-model="formData.activity_title" 
                type="text" 
                class="modal-input title-input" 
                placeholder="Enter Activity Title"
              >
            </div>

            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">Office / Unit</span>
                <span class="info-value-white">{{ formData.office }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">Form Type</span>
                <select v-model="formData.form_type" class="modal-input select-input">
                  <option value="employee">Employee Training</option>
                  <option value="inset">INSET</option>
                  <option value="extension">Extension Program</option>
                  <option value="student">Student Activity</option>
                </select>
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
                  <label class="form-label">Start Date</label>
                  <input v-model="formData.start_date" type="date" class="modal-input">
                </div>
                <div>
                  <label class="form-label">End Date</label>
                  <input v-model="formData.end_date" type="date" class="modal-input">
                </div>
                <div>
                  <label class="form-label">Start Time</label>
                  <input v-model="formData.start_time" type="time" class="modal-input">
                </div>
                <div>
                  <label class="form-label">End Time</label>
                  <input v-model="formData.end_time" type="time" class="modal-input">
                </div>
              </div>
              <div class="venue-participants-row">
                <div class="venue-col">
                  <label class="form-label">Venue</label>
                  <select v-model="formData.venue" class="modal-input select-input select-arrow-fix">
                    <option value="" disabled>Select venue...</option>
                    <option v-for="v in venues" :key="v.venue_id" :value="v.venue_id" class="dark-option">
                      {{ v.venue_name }}
                    </option>
                    <option value="Other" class="dark-option">Other</option>
                  </select>
                </div>
                <div class="participants-col">
                  <label class="form-label">Participants</label>
                  <input v-model="formData.target_participants" type="number" class="modal-input modal-input-center">
                </div>
              </div>

              <div v-if="formData.venue === 'Other'" class="custom-venue-wrapper">
                <label class="form-label">Specify Other Venue</label>
                <input v-model="customVenue" type="text" class="modal-input" placeholder="Enter the complete venue name">
              </div>
            </div>

            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">payments</span>
                <h3 class="section-title">Proposed Budgetary Requirements</h3>
              </div>
              <div v-if="formData.budget_items.length" class="budget-content">
                <div class="budget-table-wrapper">
                  <table class="budget-table">
                    <thead class="budget-table-header">
                      <tr>
                        <th class="table-header-cell">Budget Item</th>
                        <th class="table-header-cell budget-col-total">Total</th>
                      </tr>
                    </thead>
                    <tbody class="budget-table-body">
                      <tr v-for="(item, idx) in formData.budget_items" :key="idx" class="budget-table-row">
                        <td class="budget-item-name" v-html="formatBudgetName(item.name)"></td>
                        <td class="budget-item-input-cell">
                          <input
                            type="number"
                            v-model="item.total"
                            class="budget-input-field budget-total-field"
                            placeholder="0.00"
                            min="0"
                            step="0.01"
                          />
                        </td>
                      </tr>
                    </tbody>
                    <tfoot class="budget-table-footer">
                      <tr>
                        <td class="grand-total-label">Grand Total (PHP)</td>
                        <td class="grand-total-value-white budget-value-right">₱{{ formatCurrency(formData.proposed_budget) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
              <div v-else class="empty-budget-notice">
                No budgetary requirements were specified for this design.
                </div>
              </div>
            </div>

            <div class="section-card">
              <div class="section-header-row">
                <span class="material-symbols-outlined icon-pink">description</span>
                <h3 class="section-title">Supporting Documents</h3>
              </div>
              <div class="doc-item">
                <div class="doc-info">
                  <span class="material-symbols-outlined doc-pdf-icon">picture_as_pdf</span>
                  <div>
                    <p class="doc-title" v-if="!newFile">{{ design.attachment || 'No file uploaded' }}</p>
                    <p class="doc-title" v-else>{{ newFile.name }}</p>
                    <p class="doc-meta" v-if="design.attachment && !newFile">Current File</p>
                  </div>
                </div>
                <label class="preview-btn">
                  <span>Change File</span>
                  <input type="file" @change="handleFileChange" class="file-input-hidden" accept=".pdf,.doc,.docx">
                </label>
              </div>
            </div>
        </section>

        <section class="flex-04-sidebar">
          <div class="assessment-card-custom">
            <div class="assessment-header">
              <div class="assessment-icon">📋</div>
              <div class="assessment-title">Reviewer Feedback</div>
            </div>

            <div class="assessment-form">
              <div v-if="design.accomplishment_deadline" class="info-item assessment-date-display">
                <span class="info-label">Accomplishment Deadline</span>
                <span class="info-value-white">{{ formatDate(design.accomplishment_deadline) }}</span>
              </div>

              <div class="info-item assessment-date-display">
                <span class="info-label">Date of Assessment</span>
                <span class="info-value-white">{{ formatDate(design.assessment_date) }}</span>
              </div>

              <div class="info-item feedback-remarks">
                <span class="info-label">Previous Remarks</span>
                <div class="read-only-remarks">
                  {{ design.remarks || 'No remarks provided.' }}
                </div>
              </div>

              <div class="action-buttons">
                <button @click="handleUpdate" class="btn-approve" :disabled="submitting">
                  <span class="material-symbols-outlined">send</span> 
                  {{ submitting ? 'Updating...' : 'Resubmit for Review' }}
                </button>
                <button @click="router.back()" class="btn-back">
                  Cancel Changes
                </button>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </main>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../../api';
import Swal from 'sweetalert2';

const route = useRoute();
const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const design = ref({});
const loading = ref(true);
const submitting = ref(false);
const error = ref(null);
const venues = ref([]);
const customVenue = ref('');
const newFile = ref(null);

const formData = ref({
  activity_title: '',
  office: '',
  form_type: '',
  start_date: '',
  end_date: '',
  start_time: '',
  end_time: '',
  venue: '',
  proposed_budget: 0,
  target_participants: 0,
  budget_items: [ // Added budget_items
    { name: 'Meals and Snacks (AM/PM)', total: 0 },
    { name: 'Function Room/Venue', total: 0 },
    { name: 'Accommodation', total: 0 },
    { name: 'Equipment Rental', total: 0 },
    { name: 'Professional Fee/Honoria', total: 0 },
    { name: 'Token/s', total: 0 },
    { name: 'Materials and Supplies', total: 0 },
    { name: 'Transportation', total: 0 }
  ]
});

// Watch for changes in budget_items to update proposed_budget
watch(() => formData.value.budget_items, (newItems) => {
  const total = newItems.reduce((sum, item) => sum + (Number(item.total) || 0), 0);
  formData.value.proposed_budget = total;
}, { deep: true });

const fetchVenues = async () => {
  try {
    const response = await api.get('get-venues');
    if (response.data && response.data.success) {
      venues.value = response.data.data || [];
    }
  } catch (err) {
    console.error('Error fetching venues:', err);
  }
};

const fetchDesignDetails = async () => {
  loading.value = true;
  try {
    const id = route.params.id;
    const response = await api.get(`activity-design/${id}`);
    if (response.data.success) {
      design.value = response.data.data;
      // Map data to formData
      formData.value = {
        activity_title: design.value.activity_title,
        office: design.value.office,
        form_type: design.value.form_type,
        start_date: design.value.start_date,
        end_date: design.value.end_date,
        start_time: design.value.start_time,
        end_time: design.value.end_time,
        venue: design.value.venue_id || 'Other',
        proposed_budget: design.value.proposed_budget,
        target_participants: design.value.target_participants,
        budget_items: [ // Populate budget_items from individual columns
          { name: 'Meals and Snacks (AM/PM)', total: design.value.meals_and_snacks || 0 },
          { name: 'Function Room/Venue', total: design.value.function_room_venue || 0 },
          { name: 'Accommodation', total: design.value.accommodation || 0 },
          { name: 'Equipment Rental', total: design.value.equipment_rental || 0 },
          { name: 'Professional Fee/Honoria', total: design.value.professional_fee_honoria || 0 },
          { name: 'Token/s', total: design.value.tokens || 0 },
          { name: 'Materials and Supplies', total: design.value.materials_and_supplies || 0 },
          { name: 'Transportation', total: design.value.transportation || 0 }
        ]
      };

      if (!design.value.venue_id) {
        customVenue.value = design.value.venue;
      }
    } else {
      error.value = "Activity design not found.";
    }
  } catch (err) {
    error.value = "Failed to load activity design details.";
  } finally {
    loading.value = false;
  }
};

const handleFileChange = (e) => {
  newFile.value = e.target.files[0];
};

const formatDate = (date) => date ? new Date(date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' }) : '---';

const formatBudgetName = (name) => { // Added formatBudgetName
  if (!name) return '';
  return name.replace(/(\(.*\))/g, '<span class="budget-item-subtext">$1</span>');
};

const formatCurrency = (amt) => amt ? parseFloat(amt).toLocaleString(undefined, { minimumFractionDigits: 2 }) : '0.00'; // Added formatCurrency

const handleUpdate = async () => {
  // Validation removed as requested: user can change 1 or 2 fields freely.

  submitting.value = true;
  try {
    const id = route.params.id;
    const submitData = new FormData();
    
    // Aligning keys with ActivityDesignController expectations
    submitData.append('activity-title', formData.value.activity_title);
    submitData.append('form-type', formData.value.form_type);
    submitData.append('start-date', formData.value.start_date);
    submitData.append('end-date', formData.value.end_date);
    submitData.append('start-time', formData.value.start_time);
    submitData.append('end-time', formData.value.end_time);
    submitData.append('proposed-budget', formData.value.proposed_budget);
    submitData.append('target-participants', formData.value.target_participants);

    // Venue Logic
    if (formData.value.venue && formData.value.venue !== 'Other') {
      submitData.append('venue-id', formData.value.venue);
      // Use the venue name from the venues array or fall back to the existing design name
      const v = venues.value.find(v => v.venue_id == formData.value.venue);
      submitData.append('venue-name', v ? v.venue_name : formData.value.venue);
    } else if (formData.value.venue === 'Other') {
      submitData.append('venue-id', '');
      submitData.append('venue-name', customVenue.value || '');
    }

    submitData.append('budgetary-requirements', JSON.stringify(formData.value.budget_items)); // Add budget_items as JSON string
    submitData.append('status', 'Pending'); // Reset status so admin can review again
    
    if (newFile.value) {
      submitData.append('attachment', newFile.value);
    }

    const response = await api.post(`update-design/${id}`, submitData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });

    if (response.data.success) {
      Swal.fire({ icon: 'success', title: 'Resubmitted!', text: 'Activity Design updated and resubmitted successfully.', confirmButtonColor: '#b979cc' }).then(() => {
        router.push('/college/submitted-list');
      });
    } else {
      Swal.fire({ icon: 'error', title: 'Update Failed', text: response.data.message || 'Failed to update activity design.', confirmButtonColor: '#b979cc' });
    }
  } catch (err) {
    console.error('Error updating design:', err);
    const errorMsg = err.response?.data?.message || 'Failed to update activity design. Please check your network or server logs.';
    Swal.fire({ icon: 'error', title: 'Update Failed', text: errorMsg, confirmButtonColor: '#b979cc' });
  } finally {
    submitting.value = false;
  }
};

onMounted(() => {
  if (!user.value.id || user.value.role !== 'college') {
    router.push('/login');
  } else {
    fetchVenues();
    fetchDesignDetails();
  }
});
</script>

<style scoped>
.main-viewport { flex: 1; height: 100vh; background: transparent; }
.loading-wrapper { display: flex; justify-content: center; align-items: center; min-height: 400px; }

.error-view-wrapper { flex: 1; display: flex; align-items: center; justify-content: center; padding: 24px; min-height: 400px; }
.error-card { position: relative; background: rgba(0, 0, 0, 0.4); backdrop-filter: blur(24px); border-radius: 24px; border: 1px solid rgba(239, 68, 68, 0.2); padding: 40px; width: 100%; max-width: 448px; text-align: center; overflow: hidden; display: flex; flex-direction: column; align-items: center; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); }
.error-glow { position: absolute; top: 0; left: 50%; transform: translateX(-50%); width: 256px; height: 256px; background: rgba(239, 68, 68, 0.1); border-radius: 50%; filter: blur(64px); pointer-events: none; }
.error-icon-container { width: 96px; height: 96px; border-radius: 50%; background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); display: flex; align-items: center; justify-content: center; margin-bottom: 24px; position: relative; z-index: 10; }
.error-icon { font-size: 48px; color: #f87171; }
.error-heading { font-size: 24px; font-weight: 900; color: white; margin-bottom: 12px; position: relative; z-index: 10; letter-spacing: -0.025em; }
.error-text { color: #e2e8f0; font-size: 16px; margin-bottom: 40px; position: relative; z-index: 10; line-height: 1.6; }
.error-btn-red { position: relative; z-index: 10; background: #ef4444; color: white; padding: 12px 32px; border-radius: 9999px; font-size: 14px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; transition: all 0.2s; display: flex; align-items: center; gap: 8px; border: none; cursor: pointer; }
.error-btn-red:hover { background: #dc2626; transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(239, 68, 68, 0.4); }
.btn-icon { font-weight: bold; }

.page-container { min-height: 100vh; }
.layout-grid { display: flex; gap: 15px; max-width: 80rem; margin: 0 auto; }
.flex-06 { flex: 0.65; display: flex; flex-direction: column; overflow: hidden; }
.flex-04-sidebar { flex: 0.35; position: sticky; top: 120px; align-self: flex-start; }

.glass-card { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); backdrop-filter: blur(24px); border-radius: 1.5rem; border: 1px solid rgba(185, 121, 204, 0.2); }
.report-header { padding: 2rem; border-bottom: 1px solid rgba(185, 121, 204, 0.15); background: rgba(0, 0, 0, 0.2); }
.meta-header { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem; }
.report-body { flex: 1; overflow-y: auto; padding: 2rem; }
.report-body > * + * { margin-top: 1.5rem; }

.status-badge-revision { display: inline-flex; align-items: center; gap: 8px; background-color: rgba(239, 68, 68, 0.15); color: #ef4444; padding: 4px 12px; border-radius: 9999px; border: 1px solid rgba(239, 68, 68, 0.3); }
.status-dot-pulse { width: 8px; height: 8px; background-color: #ef4444; border-radius: 9999px; animation: pulse 2s infinite; }
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
.status-text { font-size: 12px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; }

.control-number { font-size: 13px; font-weight: 700; color: #b979cc; text-transform: uppercase; margin-left: 12px; font-family: monospace; }
.form-group-top { margin-bottom: 1.5rem; }
.title-input { font-size: 20px !important; font-family: 'Times New Roman', serif; font-weight: 700; }

.info-grid { display: flex; flex-wrap: wrap; gap: 24px; padding-top: 16px; border-top: 1px solid rgba(185, 121, 204, 0.1); }
.info-item { display: flex; flex-direction: column; }
.info-label { font-size: 12px; text-transform: uppercase; letter-spacing: 0.1em; color: #b979cc; font-weight: 700; margin-bottom: 4px; }
.info-value-white { font-size: 14px; font-weight: 600; color: white; }

.assessment-date-display { margin-bottom: 1.5rem; }
.icon-pink { color: #b979cc; }
.full-width-info { grid-column: span 2; margin-top: 1rem; }

.section-card { background-color: rgba(0, 0, 0, 0.2); border-radius: 16px; padding: 24px; border: 1px solid rgba(185, 121, 204, 0.15); }
.section-header-row { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1rem; }
.section-title { font-weight: 800; font-size: 13px; text-transform: uppercase; letter-spacing: 0.1em; color: #b979cc; }

.grid-2 { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
.venue-participants-row {
  display: grid;
  grid-template-columns: 2.25fr 1fr;
  gap: 16px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid rgba(185, 121, 204, 0.1);
}

.doc-item { display: flex; align-items: center; justify-content: space-between; padding: 16px; background-color: rgba(0, 0, 0, 0.3); border-radius: 12px; border: 1px solid rgba(185, 121, 204, 0.15); }
.doc-info { display: flex; align-items: center; gap: 12px; color: white; font-size: 12px;}
.doc-pdf-icon { font-size: 1.875rem; color: #ef4444; }
.doc-title { font-size: 13px; font-weight: 700; color: b979cc; }
.doc-meta { font-size: 11px; color: #cbd5e1; margin-top: 2px; }
.preview-btn { color: #b979cc; font-size: 11px; padding: 6px 12px; border-radius: 8px; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(185, 121, 204, 0.15); font-weight: 700; text-align: center; cursor: pointer; }
.preview-btn:hover { border-color: #b979cc; color: white; background: rgba(185, 121, 204, 0.1); }

.assessment-card-custom { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 1.5rem; padding: 2rem; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2); border: 1px solid rgba(185, 121, 204, 0.2); }
.assessment-header { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid rgba(185, 121, 204, 0.15); }
.assessment-icon { width: 44px; height: 44px; background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); border-radius: 14px; display: flex; align-items: center; justify-content: center; color: white; font-size: 22px; }
.assessment-title { font-size: 14px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; color: #b979cc; }
.assessment-form { display: flex; flex-direction: column; }

.read-only-remarks { width: 100%; border: 1px solid rgba(185, 121, 204, 0.2); border-radius: 12px; padding: 14px 16px; font-size: 13px; background: rgba(0, 0, 0, 0.3); color: #cbd5e1; min-height: 100px; line-height: 1.5; }
.feedback-remarks { margin-bottom: 1rem; }

.form-label { display: block; font-size: 12px; font-weight: 800; text-transform: uppercase; color: #b979cc; letter-spacing: 1px; margin-bottom: 8px; }
.modal-input { width: 100%; padding: 12px 18px; border: 1px solid rgba(185, 121, 204, 0.2); background: rgba(0, 0, 0, 0.4); color: white; border-radius: 12px; font-size: 13px; }
.modal-input:focus { outline: none; border-color: #b979cc; }
.modal-input-center { text-align: center; }
.select-input { appearance: none; cursor: pointer; }
.select-arrow-fix {
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23b979cc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 16px center;
  background-size: 14px;
}
.dark-option { background-color: #16213e; color: #ffffff; }
.custom-venue-wrapper { margin-top: 1rem; }
.file-input-hidden { display: none; }

.action-buttons { display: flex; flex-direction: column; gap: 12px; margin-top: 24px; padding-top: 20px; border-top: 1px solid rgba(185, 121, 204, 0.15); }
.btn-approve { width: 100%; background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); color: white; border: none; border-radius: 14px; padding: 14px; font-size: 12px; font-weight: 800; text-transform: uppercase; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; }
.btn-approve:disabled { opacity: 0.6; cursor: not-allowed; }
.btn-approve:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(153, 13, 209, 0.25); }

.btn-back { display: block; width: 100%; padding: 12px; font-size: 11px; color: #cbd5e1; text-align: center; border-radius: 12px; background: transparent; border: 1px solid rgba(185, 121, 204, 0.15); margin-top: 8px; cursor: pointer; }
.btn-back:hover { color: white; border-color: #b979cc; background: rgba(185, 121, 204, 0.05); }

.loading-spinner { width: 40px; height: 40px; border: 3px solid #f3f3f3; border-top: 3px solid #990dd1; border-radius: 50%; animation: spin 1s linear infinite; }
@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

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
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
}

.table-header-cell {
  padding: 10px 16px;
  font-weight: 700;
}

.budget-col-total {
  width: 128px; /* Adjust as needed */
}

.budget-table-body {
  border-top: 1px solid rgba(255, 255, 255, 0.05);
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

.budget-item-input-cell {
  padding: 8px 16px;
}

.budget-input-field {
  background-color: transparent;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  outline: none;
  width: 100%;
  color: #ffffff;
  font-size: 14px;
  padding-top: 4px;
  padding-bottom: 4px;
  text-align: right; /* Align budget input to the right */
}
.budget-input-field:focus {
  border-color: #b979cc;
}

.budget-total-field {
  font-weight: 600;
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
  text-align: right; /* Align grand total value to the right */
}

.empty-budget-notice {
  color: #64748b;
  font-size: 13px;
  font-style: italic;
  padding: 16px;
  text-align: center;
}
</style>