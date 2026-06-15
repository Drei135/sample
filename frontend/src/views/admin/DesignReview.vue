<template>
  <div class="min-h-screen bg-slate-50">
    <header class="staff-header">
      <div>
        <h2 class="header-title">Lorem ipsum Review</h2>
        <div class="flex items-center gap-2">
          <span class="header-subtitle">Gender and Development - Information Management System (GAD-AMS)</span>
        </div>
      </div>
      <div class="relative">
        <button @click="toggleNotifications" class="notif-btn">
          <span class="text-2xl">🔔</span>
        </button>
        <span class="notif-badge"></span>
        <div v-if="showNotifications" class="notif-panel show">
          <div class="notif-header"><h3>Notifications</h3></div>
          <div class="notif-list">
            <div class="notif-item"><p class="notif-title">New activity design submitted</p></div>
            <div class="notif-item bg-amber"><p class="notif-title">Budget routing requires attention</p></div>
          </div>
          <div class="notif-footer"><button>View all notifications</button></div>
        </div>
      </div>
    </header>

    <main class="pl-64 pt-20">
      <div class="p-10 flex gap-8">
        <section class="flex-06 bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm">
          <div class="p-8 border-b border-slate-100">
            <div class="flex items-center gap-2 mb-4 bg-yellow-100/50 text-yellow-600 px-3 py-1 rounded-full w-max">
              <div class="w-2 h-2 rounded-full bg-yellow-500 animate-pulse"></div>
              <span class="text-[9px] font-black uppercase tracking-widest">Under Review</span>
            </div>
            <h2 class="font-serif text-3xl font-bold leading-tight mb-4">Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit</h2>
          </div>
          
          <div class="p-8 space-y-6">
            <div class="bg-slate-50 p-5 rounded-xl">
              <h3 class="font-bold text-xs uppercase tracking-widest mb-4">📅 Proposed Schedule & Venue</h3>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="text-[9px] font-bold uppercase text-slate-500">Proposed Dates</label><p class="text-xs">Feb 20 – Feb 22, 2026</p></div>
                <div><label class="text-[9px] font-bold uppercase text-slate-500">Venue</label><p class="text-xs">Lorem Ipsum Convention Center</p></div>
              </div>
            </div>
          </div>
        </section>

        <section class="flex-04 space-y-6 sticky top-20 self-start">
          <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
            <h3 class="text-xs font-bold uppercase text-purple-700 mb-4">📋 Assessment & Approval</h3>
            <form @submit.prevent="approveRequest" class="space-y-4">
              <button type="submit" class="w-full bg-green-800 text-white p-3 rounded-lg text-xs font-bold">✅ Approve Request</button>
              <button type="button" @click="showRevisionModal = true" class="w-full border-2 border-yellow-400 text-yellow-600 p-3 rounded-lg text-xs font-bold">✏️ Request Revision</button>
            </form>
          </div>
        </section>
      </div>
    </main>

    <div v-if="showRevisionModal" class="modal-overlay">
      <div class="modal-content">
        <div class="modal-header"><h3>✏️ Request Revision</h3></div>
        <div class="p-6 space-y-4">
          <textarea v-model="revisionRemarks" class="w-full border p-3 rounded-lg" placeholder="Revision remarks..."></textarea>
          <input type="date" v-model="revisionDeadline" class="w-full border p-3 rounded-lg">
        </div>
        <div class="p-4 flex justify-end gap-2">
          <button @click="showRevisionModal = false" class="px-4 py-2 bg-gray-200 rounded-lg">Cancel</button>
          <button @click="sendRevision" class="px-4 py-2 bg-yellow-500 text-white rounded-lg">Send</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const showNotifications = ref(false);
const showRevisionModal = ref(false);
const revisionRemarks = ref('');
const revisionDeadline = ref('');

const toggleNotifications = () => showNotifications.value = !showNotifications.value;

const sendRevision = () => {
  if (!revisionRemarks.value || !revisionDeadline.value) return alert('Please fill in all fields');
  alert(`Revision requested for ${revisionDeadline.value}`);
  showRevisionModal.value = false;
};

const approveRequest = () => alert('Request Approved');
</script>

<style scoped>
.staff-header { position: fixed; top: 0; left: 256px; right: 0; height: 80px; background: white; border-bottom: 1px solid #eee; display: flex; align-items: center; justify-content: space-between; padding: 0 40px; z-index: 40; }
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-content { background: white; width: 500px; border-radius: 16px; overflow: hidden; }
.modal-header { background: #dc2626; padding: 16px; color: white; }
</style>