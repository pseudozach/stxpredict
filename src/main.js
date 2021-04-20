import Vue from 'vue'
import App from './App.vue'

// import { rtdbPlugin } from 'vuefire'
// Vue.use(rtdbPlugin)



// export const db = firebase.database()
  // .initializeApp({ databaseURL: 'https://deed-8f818.firebaseio.com' })
  // .database()

Vue.config.productionTip = false

new Vue({
	// data: () => ({ todos: [] }),
	// firebase: {
	// 	todos: db.ref('cbtable'),
	// },
	render:h => h(App),
}).$mount('#app')
