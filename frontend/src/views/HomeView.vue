<template>
  <div class="page">

    <!-- HERO -->
    <section class="hero">
      <div class="hero-overlay"></div>
      <div class="hero-content">
        <span class="hero-badge">Benguet State University</span>
        <h1 class="hero-title">Gender and Development —<br><em>Information Management System</em></h1>
        <p class="hero-subtitle">A centralized digital platform for managing GAD activities, tracking compliance, and streamlining reporting across all university units.</p>
        <!-- <div class="hero-btns">
          <button class="btn-hero-primary">Access System</button>
          <button class="btn-hero-outline">User Guidelines</button>
        </div> -->
      </div>
    </section>

    <!-- VISION & MISSION -->
    <section class="section vm-section">
      <div class="section-inner">
        <p class="section-tag">University Identity</p>
        <h2 class="section-title">Vision &amp; Mission</h2>
        <div class="vm-grid">
          <div class="vm-card vision">
            <div class="vm-card-label">
              <span class="material-symbols-outlined">visibility</span> Vision
            </div>
            <p class="vm-quote">"A premier university in transformative education, innovative research, inclusive extension services, sustainable development, and stewardship of culture and the environment"</p>
          </div>
          <div class="vm-card mission">
            <div class="vm-card-label">
              <span class="material-symbols-outlined">target</span> Mission
            </div>
            <p class="vm-body">Cultivate resilient and future-ready human capital through excellent teaching, responsive research, proactive and sustainable community engagements, strategic partnerships, and progressive leadership.</p>
          </div>
        </div>

        <!-- GOALS -->
        <div class="goals-label">
          <span>Goals and Objectives</span>
          <div class="goals-divider"></div>
        </div>
        <div class="goals-grid">
          <div
            v-for="(goal, index) in goals"
            :key="index"
            class="goal-card"
            :class="{ active: activeGoal === index }"
          >
            <div class="goal-icon-wrap">
              <span class="material-symbols-outlined">{{ goal.icon }}</span>
            </div>
            <div class="goal-title-text">{{ goal.title }}</div>
            <div class="goal-desc">{{ goal.description }}</div>

            <div v-if="activeGoal === index" class="objective-list">
              <div v-for="(obj, i) in goal.objectives" :key="i" class="obj-item">
                <div class="obj-dot"></div>
                <div class="obj-text">{{ obj }}</div>
              </div>
            </div>

            <button class="toggle-btn" @click="toggleGoal(index)">
              <span class="material-symbols-outlined toggle-icon">
                {{ activeGoal === index ? 'keyboard_arrow_up' : 'keyboard_arrow_down' }}
              </span>
              {{ activeGoal === index ? 'Hide Objectives' : 'See Objectives' }}
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- ABOUT -->
    <section class="section about-section">
      <div class="section-inner">
        <div class="about-grid">
          <div class="about-text">
            <p class="about-label">Platform Background</p>
            <h2 class="about-title">GAD Activity Management System</h2>
            <p class="about-body-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </p>
            <p class="about-body">Aliquip do do consectetur ut ut ut consequat ad ea sed commodo sed adipiscing nisi. Ut eiusmod labore elit ullamco ipsum elit eiusmod aliqua ut ipsum.</p>
            <div class="about-btns">
              <button class="btn-primary">Access System</button>
              <button class="btn-outline">User Guidelines</button>
            </div>
          </div>
          <div class="about-img-wrap">
            <div class="about-img-decor"></div>
            <img
              class="about-img"
              alt="GAD AMS Interface"
              src="https://lh3.googleusercontent.com/aida-public/AB6AXuAWfT6cC60lgVDULdoogzB-MqXy2W26P0mWQRwWZlGkE923q72CL7VsdlXrQ3ONVRtPpIAdz0loaZqNv752I6T4tWMpiGjfjFZ5fW24Sfoci_ohBW1qEVV9NE620yhOZ-daOtQ5_Ke3-ynCEfXJtIFHBYzVbaaW-eQSwnmTd5KrJTtgawPgSP7WFqL0f1fSXoc59OanXgqSLeqWF3vqqVO6Hx8TiUmjgINFqNzFOmzF5FN5tO8vU23t87uu5FIfJZCCqJ0rgoBGvnpJ"
            />
          </div>
        </div>
      </div>
    </section>

    <!-- FOOTER STRIP -->
    <div class="footer-strip">
      <p>© 2025 <strong>GAD-IMS · BSU · TWG Portal</strong> — Benguet State University</p>
    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue';

const activeGoal = ref(null);

const toggleGoal = (idx) => {
  activeGoal.value = activeGoal.value === idx ? null : idx;
};

const goals = [
  {
    title: 'Instruction (Goal 1)',
    description: 'Ensure equity in accessing quality higher education.',
    icon: 'school',
    objectives: [
      'Formulate and implement affirmative action policies aligned with Free Higher Education',
      'Sustain enrollment of disadvantaged students',
      'Sustain grants and scholarships for undergraduate and graduate students',
      'Develop learning continuity and student affairs services plan',
      'Implement inclusive education strategies for diverse learners',
      'Sustain optimal enrollment in all degree programs'
    ]
  },
  {
    title: 'Instruction (Goal 2)',
    description: 'Advance quality and relevant instruction to boost regional economies.',
    icon: 'trending_up',
    objectives: [
      'Enhance instruction through a supportive and innovative environment',
      'Continuously improve tertiary and advanced education standards'
    ]
  },
  {
    title: 'Research (Goal 3)',
    description: 'Develop pioneering science and gender/culture-sensitive solutions.',
    icon: 'biotech',
    objectives: [
      'Strengthen policies, culture, linkages and support for research and development',
      'Advance scholarly capabilities of faculty and staff through research-driven initiatives',
      'Conduct socially-responsive and impactful research'
    ]
  },
  {
    title: 'Extension (Goal 4)',
    description: 'Develop proactive extension programs for disadvantaged communities.',
    icon: 'diversity_1',
    objectives: [
      'Enhance extension system environment for effective community development',
      'Build capacity among extension service providers',
      'Implement culturally-relevant and gender-sensitive engagement programs',
      'Expand reach and inclusivity of extension initiatives',
      'Evaluate and amplify the impact of extension programs'
    ]
  },
  {
    title: 'Governance (Goal 5)',
    description: 'Promote integrity-based governance and efficient management of resources.',
    icon: 'account_balance',
    objectives: [
      'Develop human resource capabilities',
      'Cultivate a culture of good governance and resource stewardship',
      'Develop smart and green campus solutions',
      'Establish sound financial policies and systems'
    ]
  },
  {
    title: 'Business (Goal 6)',
    description: 'Balance progressive resource development while maintaining biophysical resources.',
    icon: 'payments',
    objectives: [
      'Foster a supportive ecosystem for entrepreneurial ventures',
      'Create strategic and socially-responsible business partnerships',
      'Strengthen capabilities in revenue-generating activities',
      'Optimize existing income sources',
      'Pursue green enterprises and growth opportunities'
    ]
  },
  {
    title: 'Partnerships (Goal 7)',
    description: 'Strengthen and expand strategic partnerships.',
    icon: 'handshake',
    objectives: [
      'Build a dynamic and enabling environment for partnerships',
      'Deepen engagement with alumni, government, and civil society',
      'Strengthen multi-sectoral collaboration among academe, LGUs, and communities'
    ]
  }
];
</script>

<style scoped>
* { box-sizing: border-box; margin: 0; padding: 0; }
.page { background: #f8f6ff; padding-top: 75px; }
.hero {
  position: relative;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  padding: 160px 48px 120px;
  text-align: center;
  overflow: hidden;
}
.hero-overlay {
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at 65% 35%, rgba(153, 13, 209, 0.25) 0%, transparent 60%);
  pointer-events: none;
}
.hero-content { position: relative; z-index: 1; max-width: 800px; margin: 0 auto; }
.hero-badge {
  display: inline-block;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.3em;
  text-transform: uppercase;
  color: #cbd5e1;
  border: 1px solid rgba(203, 213, 225, 0.3);
  padding: 6px 20px;
  border-radius: 9999px;
  margin-bottom: 24px;
}
.hero-title {
  font-size: 42px;
  font-weight: 800;
  color: #fff;
  line-height: 1.15;
  letter-spacing: -0.025em;
  margin-bottom: 18px;
}
.hero-title em {
  font-style: normal;
  background: linear-gradient(135deg, #b979cc, #990dd1);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.hero-subtitle {
  font-size: 15px;
  color: #cbd5e1;
  max-width: 540px;
  margin: 0 auto 32px;
  line-height: 1.8;
}
.hero-btns { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
.btn-hero-primary {
  padding: 12px 28px;
  background: linear-gradient(135deg, #990dd1, #b979cc);
  color: #fff;
  border: none;
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  cursor: pointer;
  transition: transform 0.2s;
}
.btn-hero-primary:hover { transform: translateY(-2px); }
.btn-hero-outline {
  padding: 12px 28px;
  background: transparent;
  color: #cbd5e1;
  border: 1px solid rgba(203, 213, 225, 0.35);
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  cursor: pointer;
  transition: background 0.2s;
}
.btn-hero-outline:hover { background: rgba(203, 213, 225, 0.1); }

.section { padding: 80px 48px; }
.section-inner { max-width: 1160px; margin: 0 auto; }
.section-tag {
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.35em;
  color: #990dd1;
  margin-bottom: 10px;
}
.section-title {
  font-size: 32px;
  font-weight: 800;
  color: #1a1a2e;
  letter-spacing: -0.02em;
  line-height: 1.2;
  margin-bottom: 40px;
}

.vm-section { background: #fff; }
.vm-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 64px; }
.vm-card {
  border-radius: 16px;
  padding: 32px;
}
.vm-card.vision {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border: 1px solid rgba(153, 13, 209, 0.3);
}
.vm-card.mission {
  background: #faf8ff;
  border: 1px solid #ede9f7;
}
.vm-card-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.3em;
  text-transform: uppercase;
  margin-bottom: 18px;
}
.vm-card.vision .vm-card-label { color: #b979cc; }
.vm-card.mission .vm-card-label { color: #990dd1; }
.vm-card.vision .vm-card-label .material-symbols-outlined { color: #b979cc; font-size: 18px; }
.vm-card.mission .vm-card-label .material-symbols-outlined { color: #990dd1; font-size: 18px; }
.vm-quote {
  font-size: 17px;
  font-weight: 600;
  color: #fff;
  line-height: 1.6;
  font-style: italic;
  border-left: 3px solid #990dd1;
  padding-left: 18px;
}
.vm-body { font-size: 15px; color: #1a1a2e; line-height: 1.85; }

.goals-label {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
}
.goals-label span {
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.4em;
  color: #990dd1;
  white-space: nowrap;
}
.goals-divider { flex: 1; height: 1px; background: #ede9f7; }
.goals-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.goal-card {
  background: #fff;
  border: 1px solid #ede9f7;
  border-radius: 14px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s, border-color 0.2s;
}
.goal-card:hover { border-color: rgba(153, 13, 209, 0.3); transform: translateY(-3px); }
.goal-card.active { border-color: rgba(153, 13, 209, 0.4); }
.goal-icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 14px;
}
.goal-icon-wrap .material-symbols-outlined { font-size: 20px; color: #b979cc; }
.goal-title-text {
  font-size: 15px;
  font-weight: 1000;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #1a1a2e;
}
.goal-desc { font-size: 13px; color: #16213e; line-height: 1.7; flex-grow: 1; margin-bottom: 14px; }
.objective-list {
  border-top: 1px solid #ede9f7;
  padding-top: 14px;
  margin-top: 4px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 14px;
}
.obj-item { display: flex; gap: 8px; align-items: flex-start; }
.obj-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #990dd1;
  margin-top: 6px;
  flex-shrink: 0;
}
.obj-text { font-size: 11px; color: #475569; line-height: 1.6; }
.toggle-btn {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: #990dd1;
  background: #faf8ff;
  border: 1px solid rgba(153, 13, 209, 0.2);
  border-radius: 8px;
  padding: 7px 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
  width: fit-content;
  transition: background 0.2s, color 0.2s;
  margin-top: auto;
}
.toggle-btn:hover { background: linear-gradient(135deg, #990dd1, #b979cc); color: #fff; }
.toggle-icon { font-size: 16px; }

.about-section {
  background: linear-gradient(180deg, #faf8ff 0%, #fff 100%);
  border-top: 1px solid #ede9f7;
}
.about-grid { display: grid; grid-template-columns: 6fr 5fr; gap: 72px; align-items: center; }
.about-text { display: flex; flex-direction: column; gap: 0; }
.about-label {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.35em;
  color: #990dd1;
  margin-bottom: 12px;
}
.about-title {
  font-size: 34px;
  font-weight: 800;
  color: #1a1a2e;
  line-height: 1.2;
  letter-spacing: -0.02em;
  margin-bottom: 20px;
}
.about-body-lg { font-size: 15px; color: #1a1a2e; line-height: 1.85; margin-bottom: 16px; }
.about-body { font-size: 14px; color: #16213e; line-height: 1.85; margin-bottom: 28px; }
.about-btns { display: flex; gap: 12px; flex-wrap: wrap; }
.btn-primary {
  padding: 12px 28px;
  background: linear-gradient(135deg, #990dd1, #b979cc);
  color: #fff;
  border: none;
  border-radius: 9999px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  cursor: pointer;
  transition: transform 0.2s;
}
.btn-primary:hover { transform: translateY(-2px); }
.btn-outline {
  padding: 12px 28px;
  background: transparent;
  color: #475569;
  border: 1.5px solid #e2e8f0;
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  cursor: pointer;
  transition: border-color 0.2s, color 0.2s;
}
.btn-outline:hover { border-color: #b979cc; color: #990dd1; }
.about-img-wrap { position: relative; }
.about-img-decor {
  position: absolute;
  inset: -10px;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-radius: 20px;
  opacity: 0.08;
  z-index: 0;
}
.about-img {
  width: 100%;
  border-radius: 16px;
  border: 1px solid #ede9f7;
  position: relative;
  z-index: 1;
  display: block;
}

.footer-strip {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  padding: 40px 48px;
  text-align: center;
}
.footer-strip p { font-size: 13px; color: rgba(203, 213, 225, 0.6); letter-spacing: 0.05em; }
.footer-strip strong { color: #b979cc; font-weight: 600; }

@media (max-width: 1024px) {
  .vm-grid { grid-template-columns: 1fr; }
  .goals-grid { grid-template-columns: repeat(2, 1fr); }
  .about-grid { grid-template-columns: 1fr; gap: 40px; }
  .section { padding: 64px 32px; }
  .hero { padding: 60px 32px 72px; }
}
@media (max-width: 768px) {
  .hero-title { font-size: 28px; }
  .goals-grid { grid-template-columns: 1fr; }
  .stats-bar { grid-template-columns: repeat(2, 1fr); }
  .stats-bar .stat-item:nth-child(2) { border-right: none; }
  .hero-btns, .about-btns { flex-direction: column; align-items: center; }
  .section { padding: 48px 20px; }
  .hero { padding: 48px 20px 60px; }
}
</style>