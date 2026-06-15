<template>
  <div v-if="isOpen" class="pdf-modal-overlay" @click.self="close">
    <div class="pdf-modal-content">
      <div class="pdf-modal-header">
        <h3 class="pdf-modal-title">Document Preview</h3>
        <div class="pdf-modal-actions">
          <button class="pdf-btn-expand" @click="expandToNewTab" title="Open in new tab">
            <span class="material-symbols-outlined">open_in_new</span>
          </button>
          <button class="pdf-btn-close" @click="close" title="Close">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
      </div>
      <div class="pdf-modal-body">
        <iframe :src="fileUrl" class="pdf-iframe" title="PDF Preview"></iframe>
      </div>
    </div>
  </div>
</template>

<script setup>


const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  },
  fileUrl: {
    type: String,
    default: ''
  }
});

const emit = defineEmits(['close']);

const close = () => {
  emit('close');
};

const expandToNewTab = () => {
  if (props.fileUrl) {
    window.open(props.fileUrl, '_blank');
  }
};
</script>

<style scoped>
.pdf-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.pdf-modal-content {
  background: #1a1a2e;
  border: 1px solid rgba(185, 121, 204, 0.3);
  border-radius: 16px;
  width: 90%;
  max-width: 900px;
  height: 80vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
  overflow: hidden;
  animation: modal-pop 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

@keyframes modal-pop {
  0% { opacity: 0; transform: scale(0.95); }
  100% { opacity: 1; transform: scale(1); }
}

.pdf-modal-header {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  padding: 16px 24px;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pdf-modal-title {
  font-size: 16px;
  font-weight: 700;
  margin: 0;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.pdf-modal-actions {
  display: flex;
  gap: 12px;
}

.pdf-btn-expand, .pdf-btn-close {
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  border-radius: 8px;
  padding: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.pdf-btn-expand:hover, .pdf-btn-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

.pdf-modal-body {
  flex: 1;
  background: #f1f5f9;
  overflow: hidden;
  position: relative;
}

.pdf-iframe {
  width: 100%;
  height: 100%;
  border: none;
}
</style>
