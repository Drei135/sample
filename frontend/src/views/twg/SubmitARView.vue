<template>
      <main class="twg-view-wrapper">
        <div class="main-content-container-ar">
          <div class="form-header-ar">
            <h1 class="form-main-title">Submit Accomplishment Report</h1>
            <p class="form-description-ar">Fill out the accomplishment report form below. All fields marked with * are required.</p>
          </div>

          <div class="form-container-box">
            <form @submit.prevent="submitReport" class="form-main-layout-ar">
              <div class="form-grid-main-ar">
                <div class="form-column-left-ar">
                  <div class="input-group-ar">
                    <label class="form-label-ar">Activity Title *</label>
                    <textarea 
                      v-model="form.activity_title" 
                      required 
                      rows="2" 
                      class="custom-input-field textarea-no-resize"
                      placeholder="Enter the complete title of the activity"
                    ></textarea>
                  </div>

                  <div class="input-group-ar">
                    <label class="form-label-ar">Activity Design Control Number *</label>
                    <select 
                      v-model="form.control_number" 
                      required 
                      class="custom-input-field select-arrow-fix"
                    >
                      <option value="" class="dark-option">Select approved activity design...</option>
                      <option v-if="loadingControls" value="" disabled class="dark-option">Loading...</option>
                      <option v-for="control in approvedControls" :key="control.control_number" :value="control.control_number" class="dark-option">
                        {{ control.control_number }} - {{ control.activity_title }}
                      </option>
                      <option v-if="!loadingControls && approvedControls.length === 0" value="" disabled class="dark-option">No approved control numbers found</option>
                    </select>
                  </div>

                  <div class="form-sub-grid-ar">
                    <div class="input-group-ar">
                      <label class="form-label-ar">Start Date of Implementation *</label>
                      <input 
                        type="date" 
                        v-model="form.start_date" 
                        required 
                        class="custom-input-field code-icon-calendar"
                      >
                    </div>
                    <div class="input-group-ar">
                      <label class="form-label-ar">End Date of Implementation *</label>
                      <input 
                        type="date" 
                        v-model="form.end_date" 
                        required 
                        class="custom-input-field code-icon-calendar"
                      >
                    </div>
                  </div>

                  <div class="form-sub-grid-ar">
                    <div class="input-group-ar">
                      <label class="form-label-ar">Start Time *</label>
                      <input 
                        type="time" 
                        v-model="form.start_time" 
                        required 
                        class="custom-input-field code-icon-clock"
                      >
                    </div>
                    <div class="input-group-ar">
                      <label class="form-label-ar">End Time *</label>
                      <input 
                        type="time" 
                        v-model="form.end_time" 
                        required 
                        class="custom-input-field code-icon-clock"
                      >
                    </div>
                  </div>

                  <div class="input-group-ar">
                    <label class="form-label-ar">Venue *</label>
                    <input 
                      type="text" 
                      v-model="form.venue" 
                      required 
                      class="custom-input-field"
                      placeholder="e.g., Convention Center, Main Hall"
                    >
                  </div>

                  <div class="input-group-ar">
                    <label class="form-label-ar">Number of Attendees *</label>
                    <input 
                      type="number" 
                      v-model="form.attendees" 
                      required 
                      min="0"
                      class="custom-input-field input-disabled-ar"
                      placeholder="0"
                      readonly
                    >
                  </div>

                  <div class="form-sub-grid-ar">
                    <div class="input-group-ar">
                      <label class="form-label-ar">Male Participants *</label>
                      <input 
                        type="number" 
                        v-model="form.male" 
                        required 
                        min="0"
                        class="custom-input-field"
                        placeholder="0"
                      >
                    </div>
                    <div class="input-group-ar">
                      <label class="form-label-ar">Female Participants *</label>
                      <input 
                        type="number" 
                        v-model="form.female" 
                        required 
                        min="0"
                        class="custom-input-field"
                        placeholder="0"
                      >
                    </div>
                  </div>
                </div>

                <div class="form-column-right-ar">
                  <div class="budget-section">
                    <label class="form-label-ar">Actual Budgetary Requirements *</label>
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

                  <div class="evaluation-section-ar">
                    <label class="form-label-ar">Evaluation Results *</label>
                    <div class="evaluation-table-wrapper-ar">
                      <table class="evaluation-table-ar">
                        <thead class="evaluation-table-header-ar">
                          <tr>
                            <th class="table-header-cell">Area of Evaluation</th>
                            <th class="table-header-cell rating-col-ar">Average Rating</th>
                            <th class="table-header-cell interpretation-col-ar">Interpretation</th>
                          </tr>
                        </thead>
                        <tbody class="evaluation-table-body-ar">
                          <tr v-for="(item, index) in form.evaluation_items" :key="index">
                            <td class="evaluation-item-name-ar">{{ item.area }}</td>
                            <td class="evaluation-item-input-cell-ar">
                              <input 
                                type="number" 
                                v-model="item.rating" 
                                min="1" 
                                max="5" 
                                step="0.01" 
                                required
                                class="evaluation-input-field-ar"
                                placeholder="0.00"
                              />
                            </td>
                            <td class="evaluation-interpretation-cell-ar">
                              <span :class="['interpretation-tag-ar', getInterpretationClass(item.rating)]">
                                {{ getInterpretation(item.rating) }}
                              </span>
                            </td>
                          </tr>
                        </tbody>
                        <tfoot class="evaluation-table-footer-ar">
                          <tr>
                            <td class="total-avg-label-ar">Total Average Rating</td>
                            <td class="total-avg-value-ar">{{ form.rating }}</td>
                            <td class="total-avg-interpretation-ar">
                              <span :class="['interpretation-tag-ar', getInterpretationClass(form.rating)]">
                                {{ getInterpretation(form.rating) }}
                              </span>
                            </td>
                          </tr>
                        </tfoot>
                      </table>
                    </div>
                  </div>
                </div>
              </div>

              <div class="attachment-section-container-ar">
                <label class="form-label-ar">Upload Documents (PDF/ZIP - Multiple files allowed) *</label>
                <div class="attachment-display-grid-ar">
                  <div class="attachment-upload-column-ar">
                    <div class="upload-dropzone-box" @click="$refs.fileInput.click()">
                      <input 
                        ref="fileInput" 
                        type="file" 
                        @change="handleFileUpload" 
                        accept=".pdf" 
                        required 
                        class="file-input-hidden" 
                        multiple 
                      />
                      <span class="upload-icon-ar">📤</span>
                      <p class="upload-text-ar">Upload Accomplishment Report & Attachments</p>
                      <p class="upload-hint-ar">Multiple files allowed (PDF, ZIP)</p>
                    </div>
                  </div>
                  <div class="attachment-preview-column-ar">
                    <div v-if="uploadedFiles.length > 0" class="uploaded-files-container-ar">
                      <div v-for="(file, index) in uploadedFiles" :key="index" class="uploaded-file-tag">
                        <span class="uploaded-file-name">📄 {{ file.name }}</span>
                        <div class="uploaded-file-actions-ar">
                          <span class="uploaded-file-size-ar">({{ (file.size / 1024).toFixed(2) }} KB)</span>
                          <button type="button" @click="removeFile(index)" class="remove-file-btn">Remove</button>
                        </div>
                      </div>
                    </div>
                    <p v-else class="no-file-uploaded-text">No files uploaded yet.</p>
                  </div>
                </div>
              </div>

              <div class="form-actions-ar">
                <button 
                  type="submit" 
                  class="submit-action-btn"
                >
                  Submit Report →
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

const menuItems = computed(() => {
  if (route.path.includes('/college')) return collegeMenu;
  return [];
});

const form = ref({
  activity_title: '',
  control_number: '',
  act_design_id: null,
  start_date: '',
  end_date: '',
  start_time: '',
  end_time: '',
  venue: '',
  attendees: '',
  male: '',
  female: '', 
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
  ],
  evaluation_items: [
    { area: 'Time Management', rating: '' },
    { area: 'Orderliness and Program Flow', rating: '' },
    { area: 'Appropriateness of the Venue', rating: '' },
    { area: 'Sound System and Hall Preparation', rating: '' },
    { area: 'Restroom/s', rating: '' },
    { area: 'Food and Drinks', rating: '' }
  ],
  rating: 0
});

const approvedControls = ref([]);
const loadingControls = ref(false);

const fetchApprovedControls = async () => {
  loadingControls.value = true;
  try {
    // Fetch all values from the control_number table
    const res = await api.get(`get-control-numbers/${user.value.id}`);
    if (res.data.success) {
      approvedControls.value = res.data.data;
    }
  } catch (error) {
    console.error('Error fetching approved controls:', error);
  } finally {
    loadingControls.value = false;
  }
};

watch(() => form.value.control_number, (newVal) => {
  const selected = approvedControls.value.find(c => c.control_number === newVal);
  if (selected) {
    form.value.act_design_id = selected.act_design_id;
    form.value.activity_title = selected.activity_title;
    form.value.start_date = selected.start_date;
    form.value.end_date = selected.end_date;
    form.value.start_time = selected.start_time;
    form.value.end_time = selected.end_time;
    form.value.venue = selected.venue;
  }
});

const formatBudgetName = (name) => {
  if (!name) return '';
  return name.replace(/(\(.*\))/g, '<span class="budget-item-subtext">$1</span>');
};

watch(() => form.value.budget_items, (newItems) => {
  const total = newItems.reduce((sum, item) => sum + (Number(item.total) || 0), 0);
  form.value.proposed_budget = total;
}, { deep: true });

watch([() => form.value.male, () => form.value.female], ([newMale, newFemale]) => {
  const m = parseInt(newMale) || 0;
  const f = parseInt(newFemale) || 0;
  form.value.attendees = m + f;
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
  if (val >= 2.51) return 'text-rose-400';
  if (val >= 2.01) return 'text-rose-500';
  return 'text-rose-600';
};

watch(() => form.value.evaluation_items, (items) => {
  const valid = items.filter(i => i.rating !== '' && !isNaN(parseFloat(i.rating)));
  if (valid.length === 0) {
    form.value.rating = 0;
  } else {
    const sum = valid.reduce((acc, curr) => acc + parseFloat(curr.rating), 0);
    form.value.rating = (sum / items.length).toFixed(2);
  }
}, { deep: true });

const uploadedFiles = ref([]);
const fileInput = ref(null);

const handleFileUpload = (event) => {
  if (event.target.files.length > 0) {
    uploadedFiles.value = [...uploadedFiles.value, ...Array.from(event.target.files)];
  }
};

const removeFile = (index) => {
  uploadedFiles.value.splice(index, 1);
  if (uploadedFiles.value.length === 0 && fileInput.value) {
    fileInput.value.value = '';
  }
};

const submitReport = async () => {
  try {
    const formData = new FormData();
    
    Object.keys(form.value).forEach(key => {
      if (key === 'budget_items') {
        formData.append(key, JSON.stringify(form.value[key]));
      } else if (key === 'evaluation_items') {
        formData.append(key, JSON.stringify(form.value[key]));
      } else {
      formData.append(key, form.value[key]);
      }
    });
    
    uploadedFiles.value.forEach(file => {
      formData.append('attachment[]', file);
    });
    
    formData.append('user_id', user.value.id);
    
    const response = await api.post('submit-activity-report', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
    
    if (response.data.success) {
      Swal.fire({
        icon: 'success',
        title: 'Submitted Successfully!',
        text: 'Accomplishment report submitted successfully!',
        confirmButtonColor: '#b979cc'
      }).then(() => {
        router.push('/college/submitted-list');
      });
      form.value = {
        activity_title: '',
        control_number: '',
        act_design_id: null,
        start_date: '',
        end_date: '',
        start_time: '',
        end_time: '',
        venue: '',
        attendees: '',
        male: '',
        female: '', 
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
        ],
        evaluation_items: [
          { area: 'Time Management', rating: '' },
          { area: 'Orderliness and Program Flow', rating: '' },
          { area: 'Appropriateness of the Venue', rating: '' },
          { area: 'Sound System and Hall Preparation', rating: '' },
          { area: 'Restroom/s', rating: '' },
          { area: 'Food and Drinks', rating: '' }
        ],
        rating: 0
      };
      uploadedFiles.value = [];
      if (fileInput.value) fileInput.value.value = '';
    }
  } catch (error) {
    console.error('Submission error:', error);
    alert('Failed to submit report. Please try again.');
  }
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
  if (!user.value.id) {
    router.push('/login');
  } else {
    fetchApprovedControls();
  }
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

.main-content-container-ar {
  max-width: 1280px;
  margin-left: auto;
  margin-right: auto;
  width: 100%;
}

.form-header-ar {
  margin-bottom: 32px;
}

.form-main-title {
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -0.025em;
  color: #16213e;
  letter-spacing: -0.02em;
}

.form-description-ar {
  font-size: 14px;
  color: #64748b;
  margin-top: 6px;
}

.form-container-box {
  background: linear-gradient(145deg, #1a1a2e 0%, #16213e 100%);
  border: 1px solid rgba(185, 121, 204, 0.2);
  border-radius: 20px;
  padding: 32px;
  box-shadow: 0 20px 40px rgba(10, 10, 20, 0.4);
}

.form-main-layout-ar {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-grid-main-ar {
  display: grid;
  grid-template-columns: repeat(1, minmax(0, 1fr));
  gap: 30px;
}
@media (min-width: 1024px) {
  .form-grid-main-ar {
    grid-template-columns: 1fr 1fr;
  }
}

.form-column-left-ar, .form-column-right-ar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-column-left-ar {
    border-right: 1px solid rgba(185, 121, 204, 0.2);
    padding-right: 20px;  
}

.input-group-ar {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label-ar {
  display: block;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
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

.form-sub-grid-ar {
  display: grid;
  grid-template-columns: repeat(1, minmax(0, 1fr));
  gap: 24px;
}
@media (min-width: 768px) {
  .form-sub-grid-ar {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

.textarea-no-resize {
  resize: none;
}

.input-disabled-ar {
  cursor: not-allowed;
  opacity: 0.7;
}

.evaluation-section-ar {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.evaluation-table-wrapper-ar {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(0, 0, 0, 0.2);
}

.evaluation-table-ar {
  width: 100%;
  text-align: left;
  border-collapse: collapse;
}

.evaluation-table-header-ar {
  background-color: rgba(255, 255, 255, 0.05);
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
}

.evaluation-item-name-ar {
  padding: 12px 16px;
  color: #cbd5e1;
  font-size: 13px;
  line-height: 1.25;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.evaluation-item-input-cell-ar {
  padding: 8px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.evaluation-input-field-ar {
  background-color: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  outline: none;
  width: 80px;
  color: #ffffff;
  font-size: 14px;
  padding: 4px 8px;
  text-align: center;
}

.evaluation-input-field-ar:focus {
  border-color: #b979cc;
  background: rgba(255, 255, 255, 0.07);
}

.evaluation-interpretation-cell-ar {
  padding: 8px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  font-size: 12px;
  font-weight: 600;
}

.evaluation-table-footer-ar {
  background-color: rgba(255, 255, 255, 0.05);
}

.total-avg-label-ar {
  padding: 12px 16px;
  font-size: 11px;
  font-weight: 700;
  color: #ffffff;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.total-avg-value-ar {
  padding: 12px 16px;
  font-size: 16px;
  font-weight: 800;
  color: #b979cc;
  text-align: center;
}

.total-avg-interpretation-ar {
  padding: 12px 16px;
  font-size: 13px;
  font-weight: 700;
}

.interpretation-tag-ar {
  padding: 2px 0;
}

.text-emerald-400 { color: #34d399; }
.text-teal-400 { color: #2dd4bf; }
.text-cyan-400 { color: #22d3ee; }
.text-amber-400 { color: #fbbf24; }
.text-rose-400 { color: #f472b6; }
.text-rose-500 { color: #f43f5e; }
.text-rose-600 { color: #e11d48; }

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
  font-size: 10px;
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

.file-input-hidden {
  display: none;
}

.upload-dropzone-box {
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

.upload-icon-ar {
  font-size: 26px;
  margin-bottom: 8px;
  transition: transform 0.2s ease;
}
.upload-dropzone-box:hover .upload-icon-ar {
  transform: scale(1.1);
}

.upload-text-ar {
  font-size: 14px;
  font-weight: 600;
  color: #ffffff;
  text-align: center;
  transition: color 0.2s ease;
}
.upload-dropzone-box:hover .upload-text-ar {
  color: #b979cc;
}

.upload-hint-ar {
  font-size: 14px;
  color: #64748b;
  margin-top: 4px;
}

.uploaded-files-container-ar {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.upload-dropzone-box:hover {
  border-color: #b979cc;
  background: rgba(185, 121, 204, 0.06);
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

.uploaded-file-size-ar {
  font-size: 14px;
  opacity: 0.6;
  flex-shrink: 0;
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

.form-actions-ar {
  display: flex;
  justify-content: flex-end;
  padding-top: 24px;
}

</style>