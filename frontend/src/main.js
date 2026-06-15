import { createApp } from 'vue'
import '@fontsource/manrope/400.css'
import '@fontsource/manrope/500.css'
import '@fontsource/manrope/700.css'
import '@fontsource/manrope/800.css'
import 'material-symbols/outlined.css'
import './style.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(router)
app.mount('#app')
