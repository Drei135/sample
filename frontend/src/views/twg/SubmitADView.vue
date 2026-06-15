<template>
      <main class="twg-view-wrapper">
        <div class="main-content-container">
          <div class="form-header">
            <h1 class="form-main-title">Submit Activity Design</h1>
            <p class="form-description">Fill out the activity design form below. All fields marked with * are required.</p>
          </div>

          <div class="form-container-box">
            <form @submit.prevent="submitActivityDesign" class="form-main-layout">
              <div class="form-grid-main">
                <div class="form-column-left">
                  <div class="form-sub-grid">
                    <div class="input-group">
                      <label class="form-label">Form Type *</label>
                      <select 
                        v-model="form.nature" 
                        required 
                        class="custom-input-field select-arrow-fix"
                      >
                        <option value="" disabled class="dark-option">Select form type...</option>
                        <option value="inset" class="dark-option">INSET</option>
                        <option value="extension" class="dark-option">Extension Program</option>
                        <option value="employee" class="dark-option">Employee Training</option>
                      </select>
                    </div>

                    <div class="input-group">
                      <label class="form-label">Venue *</label>
                      <select 
                        v-model="form.venue" 
                        required 
                        class="custom-input-field select-arrow-fix"
                      >
                        <option value="" disabled class="dark-option">Select venue...</option>
                        <option 
                          v-for="v in venues" 
                          :key="v.venue_id" 
                          :value="v.venue_id" 
                          class="dark-option"
                        >
                          {{ v.venue_name }}
                        </option>
                        <option value="Other" class="dark-option">Other</option>
                      </select>
                    </div>
                  </div>

                  <div v-if="form.venue === 'Other'" class="input-group">
                    <label class="form-label">Specify Other Venue *</label>
                    <input 
                      type="text" 
                      v-model="customVenue" 
                      required 
                      class="custom-input-field"
                      placeholder="Enter the complete venue name"
                    >
                  </div>

                  <div class="input-group">
                    <label class="form-label">Activity Title *</label>
                    <textarea 
                      v-model="form.activity_title" 
                      required 
                      rows="2" 
                      class="custom-input-field textarea-no-resize"
                      placeholder="Enter the complete title of the activity"
                    ></textarea>
                  </div>

                  <div class="form-sub-grid">
                    <div class="input-group">
                      <label class="form-label">Start Date *</label>
                      <input 
                        type="date" 
                        v-model="form.start_date" 
                        required 
                        :min="today"
                        class="custom-input-field code-icon-calendar"
                      >
                    </div>
                    <div class="input-group">
                      <label class="form-label">End Date *</label>
                      <input 
                        type="date" 
                        v-model="form.end_date" 
                        required 
                        :min="form.start_date || today"
                        class="custom-input-field code-icon-calendar"
                      >
                    </div>
                  </div>

                  <div class="form-sub-grid">
                    <div class="input-group">
                      <label class="form-label">Start Time *</label>
                      <input 
                        type="time" 
                        v-model="form.start_time" 
                        required 
                        class="custom-input-field code-icon-clock"
                      >
                    </div>
                    <div class="input-group">
                      <label class="form-label">End Time *</label>
                      <input 
                        type="time" 
                        v-model="form.end_time" 
                        required 
                        class="custom-input-field code-icon-clock"
                      >
                    </div>
                  </div>

                  <div class="input-group">
                    <label class="form-label">Target Participants *</label>
                    <input 
                      type="number" 
                      v-model="form.target_participants" 
                      required 
                      class="custom-input-field"
                      placeholder="Enter total participants"
                      min="0"
                    >
                  </div>
                </div>

                <div class="form-column-right">
                  <div class="budget-section">
                    <label class="form-label">Proposed Budgetary Requirements *</label>
                    <div class="budget-table-wrapper">
                      <table class="budget-table">
                        <thead class="budget-table-header">
                          <tr>
                            <th class="table-header-cell">Budget Item</th>
                            <th class="table-header-cell budget-col-total">Total</th>
                          </tr>
                        </thead>
                        <tbody class="budget-table-body">
                          <tr v-for="(item, index) in form.budget_items" :key="index" class="budget-table-row">
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
                            <td colspan="1" class="grand-total-label">Grand Total (PHP)</td>
                            <td class="grand-total-value">
                              {{ Number(form.proposed_budget || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}
                            </td>
                          </tr>
                        </tfoot>
                      </table>
                    </div>
                  </div>
                </div>
              </div>

              <div class="attachment-section-container">
                <label class="form-label">Upload Activity Design (PDF) *</label>
                <div class="attachment-display-grid">
                  <div class="attachment-upload-column">
                    <div class="upload-dropzone" @click="$refs.fileInput.click()">
                      <input ref="fileInput" type="file" @change="handleFileUpload" accept=".pdf" required class="file-input-hidden" />
                      <span class="upload-icon">📤</span>
                      <p class="upload-text">Upload Activity Design Document</p>
                      <p class="upload-hint">PDF format (Max 10MB)</p>
                    </div>
                  </div>
                  <div class="attachment-preview-column">
                    <div v-if="designFile" class="uploaded-file-display">
                      <div class="uploaded-file-tag">
                        <span class="uploaded-file-name">📄 {{ designFile.name }}</span>
                        <button type="button" @click="removeFile" class="remove-file-btn">Remove</button>
                      </div>
                    </div>
                    <p v-else class="no-file-uploaded-text">No file uploaded yet.</p>
                  </div>
                </div>
              </div>

              <div class="form-actions">
                <button 
                  type="button"
                  @click="goBack" 
                  class="back-button"
                >
                  ← Back
                </button>
                <button 
                  type="submit" 
                  class="submit-action-btn"
                >
                  Submit Design →
                </button>
              </div>
            </form>
          </div>
        </div>
      </main>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import Swal from 'sweetalert2';
import api from '../../api';

const router = useRouter();
const route = useRoute();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const venues = ref([]);
const customVenue = ref('');

const today = new Date().toISOString().split('T')[0];

const validateDate = (field) => {
  if (form.value[field] < today) {
    form.value[field] = '';
    Swal.fire({
      icon: 'warning',
      title: 'Invalid Date',
      text: 'Please select a date that is not in the past.',
      confirmButtonColor: '#b979cc'
    });
  }
};

const form = ref({
  nature: '',
  activity_title: '',
  start_date: '',
  end_date: '',
  start_time: '',
  end_time: '',
  venue: '',
  target_participants: '',
  proposed_budget: 0,
  budget_items: [
    { name: 'Meals and Snacks (AM/PM)', total: '' },
    { name: 'Function Room/Venue', total: '' },
    { name: 'Accommodation', total: '' },
    { name: 'Equipment Rental', total: '' },
    { name: 'Professional Fee/Honoria', total: '' },
    { name: 'Token/s', total: '' },
    { name: 'Materials and Supplies', total: '' },
    { name: 'Transportation', total: '' }
  ]
});

const designFile = ref(null);
const fileInput = ref(null);

const handleFileUpload = (event) => {
  if (event.target.files.length > 0) {
    designFile.value = event.target.files[0];
  }
};

const removeFile = () => {
  designFile.value = null;
  if (fileInput.value) fileInput.value.value = '';
};

const formatBudgetName = (name) => {
  if (!name) return '';
  return name.replace(/(\(.*\))/g, '<span class="budget-item-subtext">$1</span>');
};

const fetchVenues = async () => {
  try {
    const response = await api.get('get-venues');
    if (response.data && response.data.success) {
      venues.value = response.data.data || [];
    }
  } catch (error) {
    console.error('Error fetching venues:', error);
  }
};

watch(() => form.value.budget_items, (newItems) => {
  const total = newItems.reduce((sum, item) => sum + (Number(item.total) || 0), 0);
  form.value.proposed_budget = total;
}, { deep: true });

const submitActivityDesign = async () => {
  try {
    const formData = new FormData();
    
    formData.append('form-type', form.value.nature);
    formData.append('activity-title', form.value.activity_title);
    formData.append('start-date', form.value.start_date);
    formData.append('end-date', form.value.end_date);
    formData.append('start-time', form.value.start_time);
    formData.append('end-time', form.value.end_time);
    formData.append('user_id', user.value.id || user.value.user_id);
    
    if (form.value.venue && form.value.venue !== 'Other') {
      formData.append('venue-id', form.value.venue); 
      const selectedVenue = venues.value.find(v => v.venue_id == form.value.venue);
      formData.append('venue-name', selectedVenue ? selectedVenue.venue_name : '');
    } else if (form.value.venue === 'Other') {
      formData.append('venue-id', '');
      formData.append('venue-name', customVenue.value);
    }
    
    formData.append('target-participants', form.value.target_participants);
    formData.append('proposed-budget', form.value.proposed_budget);
    formData.append('budgetary-requirements', JSON.stringify(form.value.budget_items));

    if (designFile.value) {
      formData.append('attachment', designFile.value);
    }

    const response = await api.post('submit-activity-design', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });

    if (response.data.success) {
      Swal.fire({
        icon: 'success',
        title: 'Submitted Successfully!',
        text: 'Activity Design submitted successfully!',
        confirmButtonColor: '#b979cc'
      }).then(() => {
        router.push('/college/submitted-list');
      });
    }
  } catch (error) {
    console.error('Submission error:', error);
    Swal.fire({
      icon: 'error',
      title: 'Submission Failed',
      text: 'Failed to submit activity design. Please double check all details.',
      confirmButtonColor: '#b979cc'
    });
  }
};

const goBack = () => {
  router.push('/college/submit');
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
  if (!user.value.id || user.value.role !== 'college') {
    router.push('/login');
  }
  fetchVenues();
});
</script>

<style scoped>
.twg-view-wrapper {
  flex: 1;
  overflow-y: auto;
  display: flex;
  background: transparent;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

.text-sm { font-size: 14px; }
.text-3xl { font-size: 26px; }

.form-main-layout {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.main-content-container {
  max-width: 1280px;
  margin-left: auto;
  margin-right: auto;
  width: 100%;
}

.form-header {
  margin-bottom: 32px;
}

.form-main-title {
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -0.025em;
  color: #16213e;
  letter-spacing: -0.02em;
}

.form-description {
  font-size: 14px;
  color: #64748b;
  margin-top: 6px;
}

.form-grid-main {
  display: grid;
  grid-template-columns: repeat(1, minmax(0, 1fr));
  gap: 30px;
}
@media (min-width: 1024px) {
  .form-grid-main {
    grid-template-columns: 1fr 1fr;
  }
}

.form-column-left, .form-column-right {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-column-left {
  border-right: 1px solid rgba(185, 121, 204, 0.2);
  padding-right: 20px;
}
  
.form-section-spacing {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-sub-grid {
  display: grid;
  grid-template-columns: repeat(1, minmax(0, 1fr));
  gap: 20px;
}
@media (min-width: 768px) {
  .form-sub-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  display: block;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
}

.form-container-box {
  background: linear-gradient(145deg, #1a1a2e 0%, #16213e 100%);
  border: 1px solid rgba(185, 121, 204, 0.2);
  border-radius: 20px;
  padding: 32px;
  box-shadow: 0 20px 40px rgba(10, 10, 20, 0.4);
}

.custom-input-field {
  width: 100%;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 14px 20px;
  font-size: 14px;
  color: #ffffff;
  transition: all 0.2s ease;
}

.custom-input-field:focus {
  background: rgba(255, 255, 255, 0.05);
  border-color: #b979cc;
  outline: none;
  box-shadow: 0 0 0 2px rgba(153, 13, 209, 0.2);
}

.custom-input-field::placeholder {
  color: #94a3b8;
}

.dark-option {
  background-color: #16213e;
  color: #ffffff;
}

.code-icon-calendar::-webkit-calendar-picker-indicator,
.code-icon-clock::-webkit-calendar-picker-indicator {
  filter: invert(1);
  cursor: pointer;
  opacity: 0.7;
}

.code-icon-calendar::-webkit-calendar-picker-indicator:hover,
.code-icon-clock::-webkit-calendar-picker-indicator:hover {
  opacity: 1;
}

.budget-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
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
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
}

.table-header-cell {
  padding: 10px 16px;
  font-weight: 600;
}

.budget-col-total {
  width: 128px;
}

.budget-table-body {
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.budget-item-name {
  padding: 12px 16px;
  color: #cbd5e1;
  line-height: 1.25;
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
  color: #ffffff;
  text-align: right;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.grand-total-value {
  padding: 12px 16px;
  font-size: 14px;
  font-weight: 700;
  color: #b979cc;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.upload-dropzone {
  border: 2px dashed rgba(185, 121, 204, 0.3);
  background: rgba(185, 121, 204, 0.02);
  border-radius: 14px;
  padding: 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.upload-dropzone:hover {
  border-color: #b979cc;
  background: rgba(185, 121, 204, 0.06);
}

.upload-icon {
  font-size: 26px;
  margin-bottom: 8px;
  transition: transform 0.2s ease;
}
.upload-dropzone:hover .upload-icon {
  transform: scale(1.1);
}

.upload-text {
  font-size: 14px;
  font-weight: 600;
  color: #ffffff;
  text-align: center;
  transition: color 0.2s ease;
}
.upload-dropzone:hover .upload-text {
  color: #b979cc;
}

.upload-hint {
  font-size: 12px;
  color: #64748b;
  margin-top: 4px;
}

.uploaded-file-display {
  margin-top: 16px;
  width: 100%;
}

.attachment-section-container {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 10px;
}

.attachment-display-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 20px;
}

@media (min-width: 768px) {
  .attachment-display-grid {
    grid-template-columns: 1fr 1fr;
  }
}

.attachment-upload-column {
}

.attachment-preview-column {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 150px;
  border: 1px dashed rgba(185, 121, 204, 0.15);
  border-radius: 14px;
  padding: 15px;
  background: rgba(185, 121, 204, 0.01);
}

.no-file-uploaded-text {
  color: #94a3b8;
  font-size: 14px;
  text-align: center;
}

.uploaded-file-tag {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.08);
  padding: 8px 14px;
  border-radius: 8px;
  color: #cbd5e1;
  font-size: 12px;
  width: 100%;
}

.uploaded-file-name {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.remove-file-btn {
  color: #f472b6;
  font-weight: 700;
  font-size: 14px;
  margin-left: 8px;
  flex-shrink: 0;
}
.remove-file-btn:hover {
  color: #f43f5e;
}

.form-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 24px;
}

.back-button {
  padding: 12px 24px;
  font-size: 14px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
  border-radius: 12px;
  transition: all 0.2s ease;
}
.back-button:hover {
  background-color: rgba(255, 255, 255, 0.05);
}

.submit-action-btn {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: #ffffff;
  padding: 14px 40px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 16px;
  cursor: pointer;
  border: none;
  box-shadow: 0 4px 14px rgba(153, 13, 209, 0.3);
  transition: all 0.3s ease;
}

.submit-action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(153, 13, 209, 0.45);
  background: linear-gradient(135deg, #b979cc 0%, #990dd1 100%);
}

.resize-none {
  resize: none;
}

.select-arrow-fix {
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23b979cc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 20px center;
  background-size: 16px;
}
</style>