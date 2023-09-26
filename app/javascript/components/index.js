import { createApp } from "vue/dist/vue.esm-bundler.js"
import Course from "./course.vue"

const app = createApp({
  data() {  
    return {  
      sayHi: 'Intro to Vue 3 and Rails'  
    }  
  } 
});

app.component('Course', Course)  

app.mount("#app")
