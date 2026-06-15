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
            <div class="policy-card">
              
              <div id="introduction" class="policy-section">
                <div class="policy-header">
                  <div>
                    <h1 class="policy-title">Data Privacy Statement</h1>
                    <p class="policy-subtitle">
                      Benguet State University - Gender and Development Activities Management System (GAD-AMS)
                    </p>
                  </div>
                </div>
              </div>

              <div id="intro" class="policy-section">
                <h2 class="section-heading">1. Introduction</h2>
                <p class="section-text">
                  Benguet State University (BSU) is committed to protecting the privacy and confidentiality of personal information collected, stored, and processed through the Gender and Development Activities Management System (GAD-AMS). This Data Privacy Statement outlines our practices regarding the collection, use, and protection of your personal data in compliance with the Data Privacy Act of 2012 (Republic Act No. 10173).
                </p>
              </div>

              <div id="information-collect" class="policy-section">
                <h2 class="section-heading">2. Information We Collect</h2>
                <p class="section-text">
                  The GAD-AMS collects the following types of personal information:
                </p>
                <ul class="styled-list">
                  <li>Full name and contact information (<span class="highlight-text">email address, office/department</span>)</li>
                  <li>Activity design and accomplishment report submissions</li>
                  <li>Budget utilization data and financial information</li>
                  <li>Attendance records and participant demographics (<span class="highlight-text">sex-disaggregated data</span>)</li>
                  <li>User activity logs and system access records</li>
                </ul>
              </div>

              <div id="purpose" class="policy-section">
                <h2 class="section-heading">3. Purpose of Collection</h2>
                <p class="section-text">
                  Your personal information is collected and processed for the following purposes:
                </p>
                <ul class="styled-list">
                  <li>Processing and evaluation of GAD activity designs and accomplishment reports</li>
                  <li>Generation of GAD Plan and Budget (GPB) reports</li>
                  <li>Monitoring and evaluation of GAD program implementation</li>
                  <li>Compliance with government reporting requirements (<span class="highlight-text">PCW, CHED, DBM</span>)</li>
                  <li>Research and statistical analysis for GAD program improvement</li>
                </ul>
              </div>

              <div id="data-sharing" class="policy-section">
                <h2 class="section-heading">4. Data Sharing and Disclosure</h2>
                <p class="section-text">
                  BSU may share aggregated, anonymized data with government agencies such as the Philippine Commission on Women (PCW), Commission on Higher Education (CHED), and Department of Budget and Management (DBM) for reporting purposes. Personal information is not shared with third parties without your explicit consent, unless required by law.
                </p>
              </div>

              <div id="data-security" class="policy-section">
                <h2 class="section-heading">5. Data Security</h2>
                <p class="section-text">
                  BSU implements appropriate organizational, physical, and technical security measures to protect personal information from unauthorized access, alteration, disclosure, or destruction. These measures include access controls, encryption, regular security audits, and staff training on data protection.
                </p>
              </div>

              <div id="data-retention" class="policy-section">
                <h2 class="section-heading">6. Data Retention</h2>
                <p class="section-text">
                  Personal information is retained only for as long as necessary to fulfill the purposes for which it was collected, or as required by applicable laws and regulations. GAD records are typically retained for a period of ten (10) years in accordance with government archival requirements.
                </p>
              </div>

              <div id="your-rights" class="policy-section">
                <h2 class="section-heading">7. Your Rights</h2>
                <p class="section-text">
                  Under the Data Privacy Act, you have the right to:
                </p>
                <ul class="styled-list">
                  <li>Access your personal information</li>
                  <li>Rectify inaccurate or incomplete data</li>
                  <li>Request deletion or blocking of your data</li>
                  <li>Object to the processing of your data</li>
                  <li>Data portability</li>
                </ul>
              </div>

              <div id="contact" class="policy-section">
                <h2 class="section-heading">8. Contact Information</h2>
                <p class="section-text">For questions, concerns, or requests regarding your personal data, please contact:</p>
                
                <div class="contact-box">
                  <p class="contact-title">Data Protection Officer</p>
                  <p class="contact-text">Benguet State University</p>
                  <p class="contact-text">La Trinidad, Benguet 2601</p>
                  <p class="contact-email">Email: dpo@bsu.edu.ph</p>
                  <p class="contact-text">Tel: (074) 422-2401</p>
                </div>
              </div>

              <div id="updates" class="policy-section">
                <h2 class="section-heading">9. Updates to this Statement</h2>
                <p class="section-text">
                  This Data Privacy Statement may be updated periodically. Users will be notified of significant changes through the system or via email. The effective date of the current version is displayed below.
                </p>
                <p class="effective-date">Effective Date: January 1, 2026</p>
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
  { id: 'information-collect', label: '2. Information We Collect' },
  { id: 'purpose', label: '3. Purpose of Collection' },
  { id: 'data-sharing', label: '4. Data Sharing and Disclosure' },
  { id: 'data-security', label: '5. Data Security' },
  { id: 'data-retention', label: '6. Data Retention' },
  { id: 'your-rights', label: '7. Your Rights' },
  { id: 'contact', label: '8. Contact Information' },
  { id: 'updates', label: '9. Updates to this Statement' }
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
  if (!user.value.id || user.value.role !== 'admin') {
    router.push('/login');
  }
});
</script>

<style scoped>
.privacy-policy {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
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
  background: #fff;
}

.content-wrapper {
  display: flex;
  gap: 2rem;
}

/* Sidebar Table of Contents */
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
}

/* Policy Card */
.policy-card {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);

  backdrop-filter: blur(10px);
  border-radius: 0.5rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  padding: 2rem;
  animation: fadeIn 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@media (min-width: 768px) {
  .policy-card {
    padding: 2.5rem;
  }
}

/* Policy Sections */
.policy-section {
  scroll-margin-top: 96px;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(185, 121, 204, 0.1);
}

.policy-section:first-of-type {
  border-top: none;
  padding-top: 0;
}

/* Policy Header */
.policy-header {
  border-bottom: 1px solid rgba(185, 121, 204, 0.15);
  padding-bottom: 1.5rem;
  margin-bottom: 0;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.header-icon {
  padding: 0.625rem;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 0.75rem;
  font-size: 1.5rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
}

.policy-title {
  font-size: 1.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  letter-spacing: -0.025em;
  margin-bottom: 0.25rem;
}

@media (min-width: 768px) {
  .policy-title {
    font-size: 1.875rem;
  }
}

.policy-subtitle {
  font-size: 1rem;
  color: #cbd5e1;
  opacity: 0.7;
  font-weight: 500;
}

/* Typography */
.section-heading {
  font-size: 1rem;
  font-weight: 600;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  margin-bottom: 0.5rem;
}

.section-text {
  font-size: 1.1rem;
  color: #cbd5e1;
  opacity: 0.8;
  line-height: 1.625;
}

/* Lists */
.styled-list {
  list-style: disc;
  padding-left: 1rem;
  margin-left: 0.5rem;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.styled-list li {
  font-size: 1.1rem;
  color: #cbd5e1;
  opacity: 0.8;
  margin-bottom: 0.625rem;
  line-height: 1.5;
}

.styled-list li::marker {
  color: #b979cc;
}

.highlight-text {
  color: #cbd5e1;
  font-weight: 500;
  opacity: 1;
}

/* Contact Box */
.contact-box {
  margin-top: 0.75rem;
  padding: 1.25rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(5px);
  max-width: 28rem;
}

.contact-title {
  font-size: 1.1rem;
  font-weight: bold;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin-bottom: 0.25rem;
}

.contact-text {
  font-size: 1.1rem;
  color: #cbd5e1;
  opacity: 0.8;
  margin-bottom: 0.25rem;
}

.contact-email {
  font-size: 1.1rem;
  color: #b979cc;
  font-weight: 600;
  margin-top: 0.5rem;
  margin-bottom: 0.25rem;
}

/* Effective Date */
.effective-date {
  font-size: 1rem;
  color: #b979cc;
  opacity: 0.6;
  font-style: italic;
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

/* Animation */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(6px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Button styles */
button {
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(185, 121, 204, 0.15);
  transition: all 0.2s ease;
}

button:hover {
  background: rgba(0, 0, 0, 0.5);
  border-color: rgba(185, 121, 204, 0.3);
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
  
  .policy-card {
    padding: 1rem;
  }
  
  .policy-header {
    flex-direction: column;
    text-align: center;
  }
  
  .policy-title {
    font-size: 1.25rem;
  }
}
</style>