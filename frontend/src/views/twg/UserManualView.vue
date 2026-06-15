<template>

      <main class="content-main">
        <div class="content-wrapper">
          
          <div class="sidebar-container">
            <div class="sticky-toc">
              <h3 class="toc-title">
                Table of Contents
              </h3>
              <ul class="toc-list">
                <li v-for="section in tocSections" :key="section.id">
                  <button 
                    @click="scrollToSection(section.id)"
                    class="sidebar-nav-item"
                    :class="{ 'active-nav-item': activeSection === section.id }"
                  >
                    {{ section.label }}
                  </button>
                </li>
              </ul>
            </div>
          </div>

          <div class="content-area">
            <div class="manual-container">
              
              <div id="intro" class="manual-section">
                <h1 class="page-title">User Manual</h1>
                <p class="intro-text">
                  Welcome to the Benguet State University Gender and Development Activities Management System (GAD-AMS) User Manual. This guide will help you navigate and use the system effectively as a GAD Staff user.
                </p>
              </div>

              <div id="getting-started" class="manual-section">
                <h2 class="section-title">2. Getting Started</h2>
                <div class="subsection">
                  <div>
                    <h3 class="subsection-title">2.1 Logging In</h3>
                    <p class="subsection-text">
                      Access the system via your web browser using the provided URL. Enter your username and password credentials provided by the system administrator.
                    </p>
                  </div>
                  <div>
                    <h3 class="subsection-title">2.2 Navigating the Dashboard</h3>
                    <p class="subsection-text">
                      After logging in, you will be directed to the Staff Dashboard. The left sidebar contains all main navigation menus including Dashboard, GAD Programs, Mandates Management, Budget Monitoring, and Reports.
                    </p>
                  </div>
                </div>
              </div>

              <div id="dashboard" class="manual-section">
                <h2 class="section-title">3. Dashboard Overview</h2>
                <p class="subsection-text">
                  The dashboard provides a quick overview of key metrics and pending activities:
                </p>
                <ul class="styled-list">
                  <li><strong>Pending Activities</strong> - Shows number of activity designs awaiting review</li>
                  <li><strong>Activity Designs</strong> - Count of submitted activity designs</li>
                  <li><strong>Accomplishment Reports</strong> - Count of submitted accomplishment reports</li>
                  <li><strong>GAD Budget</strong> - Displays current budget allocation and utilization</li>
                  <li><strong>Calendar Widget</strong> - Shows upcoming deadlines and scheduled activities</li>
                  <li><strong>Recent Activity Logs</strong> - Tracks recent system activities</li>
                </ul>
              </div>

              <div id="submissions" class="manual-section">
                <h2 class="section-title">4. Submitting Forms</h2>
                
                <div class="subsection">
                  <h3 class="subsection-title">4.1 Activity Design Submission</h3>
                  <ol class="styled-list numeric">
                    <li>Click the "New Submission" button on the sidebar or the floating action button</li>
                    <li>Select "Activity Design" from the options</li>
                    <li>Fill out the form with:
                      <ul class="nested-list">
                        <li>Nature of Transaction (Employee, INSET, Extension, or Student Activity)</li>
                        <li>Activity Title</li>
                        <li>Start and End Dates</li>
                        <li>Start and End Times</li>
                        <li>Venue</li>
                        <li>Target Participants (max 6 digits)</li>
                        <li>Proposed Budget</li>
                        <li>Upload Activity Design file (PDF/DOCX)</li>
                        <li>Proponent Information</li>
                      </ul>
                    </li>
                    <li>Click "Submit Activity Design" to complete the submission</li>
                  </ol>
                </div>

                <div class="subsection">
                  <h3 class="subsection-title">4.2 Accomplishment Report Submission</h3>
                  <ol class="styled-list numeric">
                    <li>Click the "New Submission" button on the sidebar or the floating action button</li>
                    <li>Select "Accomplishment Report" from the options</li>
                    <li>Fill out the form with:
                      <ul class="nested-list">
                        <li>Activity Title</li>
                        <li>Control Number (select from approved activity designs dropdown)</li>
                        <li>Start and End Dates</li>
                        <li>Start and End Times</li>
                        <li>Venue</li>
                        <li>Number of Attendees (max 6 digits)</li>
                        <li>Male/Female Participant Breakdown</li>
                        <li>Activity Rating (0-100% with criteria table)</li>
                        <li>Upload Report & Attachments (multiple files accepted)</li>
                        <li>Proponent Information</li>
                      </ul>
                    </li>
                    <li>Click "Submit Accomplishment Report" to complete the submission</li>
                  </ol>
                </div>
              </div>

              <div id="viewing" class="manual-section">
                <h2 class="section-title">5. Viewing Submissions</h2>
                <p class="subsection-text">
                  As a GAD Staff user, you have monitoring access to view all submissions:
                </p>
                <ul class="styled-list">
                  <li><span class="bold-text">Activity Designs:</span> Navigate to "Submitted Activity Designs" from the sidebar to view all submitted designs. Click "View" on any row to see the complete details.</li>
                  <li><span class="bold-text">Accomplishment Reports:</span> Navigate to "Submitted Accomplishment Reports" to view all reports. Click "View" to see the complete report with ratings and attachments.</li>
                  <li><span class="bold-text">Filters:</span> Use the filter bar to sort by status, form type, office, or search by title/control number.</li>
                </ul>
                <div class="note-box">
                  Note: Staff users can only view documents (preview only). No download buttons are available for uploaded files.
                </div>
              </div>

              <div id="mandates" class="manual-section">
                <h2 class="section-title">6. GAD Mandates Management</h2>
                <p class="subsection-text">This section displays all GAD mandates where the GAD Office is the responsible unit:</p>
                <ul class="styled-list">
                  <li>View the complete list of 22 GAD Office mandates</li>
                  <li>Filter mandates by status (In Progress, Completed, Upcoming)</li>
                  <li>Search for specific mandates by title</li>
                  <li>Access the GAD Plan & Budget document (PDF viewer)</li>
                  <li>Assign mandates to accomplishment reports</li>
                </ul>
              </div>

              <div id="budget" class="manual-section">
                <h2 class="section-title">7. Budget Monitoring</h2>
                <p class="subsection-text">The budget monitoring page provides:</p>
                <ul class="styled-list">
                  <li>Total GAD Budget overview</li>
                  <li>GAD Office Budget breakdown by category</li>
                  <li>Balance available for implementation</li>
                  <li>Mandate-based budget utilization tracking with progress bars</li>
                  <li>Recent budget utilization logs</li>
                  <li>Expense category split summary</li>
                </ul>
              </div>

              <div id="reports" class="manual-section">
                <h2 class="section-title">8. Reports</h2>
                <p class="subsection-text">Generate and view annual reports:</p>
                <ul class="styled-list">
                  <li><span class="bold-text">Annual Report:</span> Comprehensive report of GAD accomplishments with sex-disaggregated data</li>
                  <li><span class="bold-text">GAD Plan & Budget:</span> View the GPB document in table or PDF format</li>
                  <li><span class="bold-text">Export to Excel:</span> Download report data for offline analysis</li>
                  <li><span class="bold-text">Year Selection:</span> Switch between different fiscal years (2024-2026)</li>
                </ul>
              </div>

              <div id="faq" class="manual-section">
                <h2 class="section-title">9. Frequently Asked Questions</h2>
                <div class="faq-list">
                  <div class="faq-item" v-for="(faq, idx) in faqs" :key="idx">
                    <h3 class="faq-question">Q: {{ faq.q }}</h3>
                    <p class="faq-answer">A: {{ faq.a }}</p>
                  </div>
                </div>
              </div>

              <div id="support" class="manual-section">
                <h2 class="section-title">10. Technical Support</h2>
                <p class="subsection-text">For technical assistance, bug reports, or system inquiries, please contact:</p>
                <div class="support-box">
                  <p class="support-title">GAD-AMS System Administrator</p>
                  <p class="support-text">Gender and Development Office</p>
                  <p class="support-text">Benguet State University</p>
                  <p class="support-email">Email: gad.ims@bsu.edu.ph</p>
                  <p class="support-text">Tel: (074) 422-2401 loc 123</p>
                </div>
                <p class="version-info">System Version: 1.0 | Last Updated: January 2026</p>
              </div>

            </div>
          </div>
        </div>
      </main>

      <footer class="footer-watermark">
        <p class="watermark-text">
          Benguet State University - Gender and Development Activities Management System | GAD-AMS v1.0
        </p>
      </footer>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));
const activeSection = ref('intro');

const tocSections = [
  { id: 'intro', label: '1. Introduction' },
  { id: 'getting-started', label: '2. Getting Started' },
  { id: 'dashboard', label: '3. Dashboard Overview' },
  { id: 'submissions', label: '4. Submitting Forms' },
  { id: 'viewing', label: '5. Viewing Submissions' },
  { id: 'mandates', label: '6. GAD Mandates Management' },
  { id: 'budget', label: '7. Budget Monitoring' },
  { id: 'reports', label: '8. Reports' },
  { id: 'faq', label: '9. Frequently Asked Questions' },
  { id: 'support', label: '10. Technical Support' }
];

const faqs = [
  { 
    q: 'What should I do if I encounter an error while submitting a form?', 
    a: 'Check that all required fields are filled out correctly. Ensure file sizes are within limits (10MB for activity designs, 15MB per file for reports). If the issue persists, contact technical support.' 
  },
  { 
    q: 'Can I edit a submission after it has been submitted?', 
    a: 'As a monitoring user, you cannot edit submissions. If changes are needed, please contact the GAD Office administrator.' 
  },
  { 
    q: 'How do I view the full content of uploaded files?', 
    a: 'Click the "Preview" button on any document to view it in the browser. Download buttons are not available for staff users.' 
  },
  { 
    q: 'What does the "Archive" section contain?', 
    a: 'The archive contains cancelled activity designs and completed activities (both designs and accomplishment reports). You can filter by status and type.' 
  },
  { 
    q: 'How do I interpret the Activity Rating?', 
    a: 'The activity rating uses a 0-100% scale with corresponding descriptors (Excellent, Very Satisfactory, Satisfactory, Needs Improvement, Unsatisfactory, Canceled). Refer to the rating table in the accomplishment report form.' 
  }
];

const scrollToSection = (id) => {
  activeSection.value = id;
  const element = document.getElementById(id);
  if (element) {
    const yOffset = -96; 
    const y = element.getBoundingClientRect().top + window.scrollY + yOffset;
    window.scrollTo({ top: y, behavior: 'smooth' });
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
  if (!user.value.id || user.value.role !== 'college') {
    router.push('/login');
  }
});
</script>

<style scoped>
.user-manual {
  background: #fff;
  min-height: 100vh;
  display: flex;
}

.main-content {
  flex-grow: 1;
  margin-left: 256px;
  display: flex;
  flex-direction: column;
}

.content-main {
  min-height: 100vh;
  background: transparent;
}

.content-wrapper {
  display: flex;
  gap: 2rem;
}

.sidebar-container {
  width: 256px;
  flex-shrink: 0;
}

.sticky-toc {
  position: sticky;
  top: 6rem;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  backdrop-filter: blur(10px);
  border-radius: 0.5rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  padding: 1rem;
}

.toc-title {
  font-weight: 600;
  color: #cbd5e1;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid rgba(185, 121, 204, 0.15);
  font-size: 1.1rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.toc-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.toc-list li {
  margin-bottom: 0.25rem;
}

.sidebar-nav-item {
  width: 100%;
  text-align: left;
  padding: 0.5rem 0.75rem;
  border-radius: 0.375rem;
  font-weight: 500;
  color: #cbd5e1;
  background: transparent;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.813rem;
}

.sidebar-nav-item:hover {
  background: rgba(0, 0, 0, 0.3);
  color: #b979cc;
}

.active-nav-item {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  font-weight: 600;
}

/* Content Area */
.content-area {
  flex: 1;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.manual-container {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  backdrop-filter: blur(10px);
  border-radius: 0.5rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  padding: 2rem;
}

.manual-section {
  scroll-margin-top: 96px;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(185, 121, 204, 0.1);
}

.manual-section:first-of-type {
  border-top: none;
  padding-top: 0;
}

/* Typography */
.page-title {
  font-size: 1.875rem;
  font-weight: 700;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin-bottom: 1rem;
  letter-spacing: -0.025em;
}

.intro-text {
  font-size: 1.1rem;
  color: #cbd5e1;
  line-height: 1.625;
}

.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin-bottom: 1rem;
}

.subsection {
  margin-bottom: 1.5rem;
}

.subsection-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #b979cc;
  margin-bottom: 0.5rem;
}

.subsection-text {
  font-size: 1.1rem;
  color: #cbd5e1;
  margin-bottom: 1rem;
  line-height: 1.5;
}

.bold-text {
  font-weight: 600;
  color: #b979cc;
}

/* Lists */
.styled-list {
  list-style: disc;
  padding-left: 1rem;
  margin: 0 0 1rem 1rem;
}

.styled-list li {
  font-size: 1.1rem;
  color: #cbd5e1;
  margin-bottom: 0.5rem;
  line-height: 1.5;
}

.styled-list li strong {
  color: #b979cc;
}

.styled-list.numeric {
  list-style: decimal;
}

.nested-list {
  list-style: disc;
  padding-left: 1.5rem;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.nested-list li {
  font-size: 1.1rem;
  color: #cbd5e1;
  margin-bottom: 0.25rem;
}

/* FAQ Section */
.faq-list {
  margin-top: 0.5rem;
}

.faq-item {
  padding-top: 1rem;
  border-top: 1px solid rgba(185, 121, 204, 0.1);
}

.faq-item:first-child {
  padding-top: 0;
  border-top: none;
}

.faq-question {
  font-size: 1.1rem;
  font-weight: 600;
  color: #b979cc;
  margin-bottom: 0.5rem;
}

.faq-answer {
  font-size: 1.1rem;
  color: #cbd5e1;
  line-height: 1.5;
}

/* Note Box */
.note-box {
  margin-top: 1rem;
  padding: 0.75rem 1rem;
  border-radius: 0.375rem;
  border-left: 3px solid #b979cc;
  background: rgba(0, 0, 0, 0.3);
  color: #cbd5e1;
  font-size: 0.813rem;
  line-height: 1.5;
}

/* Support Box */
.support-box {
  padding: 1rem;
  border-radius: 0.375rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background: rgba(0, 0, 0, 0.2);
  margin-top: 0.5rem;
}

.support-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #b979cc;
  margin-bottom: 0.25rem;
}

.support-text {
  font-size: 0.813rem;
  color: #cbd5e1;
  margin-bottom: 0.25rem;
}

.support-email {
  font-size: 0.813rem;
  color: #b979cc;
  font-weight: 500;
  margin-top: 0.5rem;
  margin-bottom: 0.25rem;
}

/* Version Info */
.version-info {
  font-size: 0.688rem;
  color: #cbd5e1;
  opacity: 0.6;
  margin-top: 1rem;
}

/* Footer */
.footer-watermark {
  padding: 1rem;
  text-align: center;
  border-top: 1px solid rgba(185, 121, 204, 0.1);
  pointer-events: none;
  background: transparent;
}

.watermark-text {
  font-size: 0.688rem;
  font-weight: 400;
  color: #cbd5e1;
  opacity: 0.4;
}

/* Responsive */
@media (max-width: 768px) {
  .content-wrapper {
    flex-direction: column;
  }
  
  .sidebar-container {
    width: 100%;
  }
  
  .main-content {
    margin-left: 0;
  }
  
  .content-main {
    padding: 1rem;
  }
  
  .manual-container {
    padding: 1rem;
  }
}
</style>