<template>
	<div>
		<!-- form wrapper -->
		<fvl-form method="post" :data="form" url="/create">
		  <!-- Text input component -->
		  
			<fvl-input 
				:value.sync="form.question" 
				label="Question (Answer must be YES or NO)" 
				name="question" 
				style="margin: 10px;" 
				placeholder="e.g. BTC/USD price will be over $60k"
				required
				type="text"
			/>
		  <!-- Textarea component -->
		  <!-- <fvl-textarea :value.sync="form.bio" label="Bio" name="bio" /> -->

		  <!-- Radio component with options -->
		  <!-- <fvl-radio :checked.sync="form.pet" :options="{'cat': 'Cat', 'dog': 'Dog'}" label="Favorite pet" name="pet" /> -->

			<fvl-select
			  label="Select Oracle"
			  name="oracle"
			  placeholder="--- Available Automatic Oracles ---"
			  :allowEmpty="true"
			  :options="{ 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ': 'BTC / USD', 'ST11NHWNT1GYPAJH3ZN8XH4SJ1EYE7R0A3C6ZKJSX': 'STX / USD'}"
			  :selected.sync="form.oracle"
			  style="margin: 10px;"
			/>
			<fvl-input 
				:value.sync="form.oracle" 
				label="Manual Oracle Account" 
				name="manual oracle address" 
				placeholder="e.g. ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ"
				style="margin: 10px;"
			/>
			<!-- Gujarat / ceylon / hunan / Iowa -->

			<VueCtkDateTimePicker 
				v-model="datetime" 
				style="margin: 15px; width: auto;" 
				label="Market Resolve Date & Time"
				:min-date="mindatetime"
			/>


			<!-- <div id="statusholder" style="margin: 10px;" v-if="statustext != ''">{{statustext}}</div> -->


			<!-- <div id="txholderholder" v-if="txid != ''">Transaction ID: {{txid}}</div> -->
			<!-- <div id="stuffholderholder" v-if="stuff != ''">stuff: {{stuff}}</div> -->
		  <!-- Submit button -->
		  <!-- <fvl-submit>Validate</fvl-submit> -->

 <!--    	<button
            type="button"
            class="btn-primary"
            @click="setstuff"
          >
            set stuff
      	</button> -->

  <!--     	<VueLoadingButton 
            aria-label="Get Precipitation Data from Oracle"
            class="button"
            @click.native="getpop"
            :loading="isLoading"
            :styled="true"
      	>Get Precipitation Data from Oracle
      	</VueLoadingButton> -->

<!--     	<button
            type="button"
            class="btn-primary"
            @click="getpop"
          >
            Get Precipitation Data from Oracle
      	</button> -->
      	
	      	<fvl-input :value.sync="form.paypervote" 
	      		label="Payment per vote (stx)" 
	      		name="paypervote" 
	      		style="margin: 10px;"
	      		type="number"
	      		required
	      	/>

<!--     	<button
            type="button"
            class="btn-primary"
            @click="triggercontract"
          >
            Deposit to Contract
      	</button> -->


		  	<VueLoadingButton 
		        aria-label="Create Market"
		        class="button"
		        @click.native="createMarket"
		        :loading="isLoading"
		        :styled="true"
		  	>Create Market
		  	</VueLoadingButton>

		</fvl-form>
	</div>
</template>

<style>
	@import '~formvuelar/dist/formvuelar.css';
	.pointer-events-none {
		display: none;
	}
</style>

<script>
	import { FvlForm, FvlInput, FvlTextarea, FvlRadio, FvlSubmit, FvlSelect } from 'formvuelar'
	import VueLoadingButton from 'vue-loading-button'
	// import Modal from './modal.vue';

    import { AppConfig, UserSession, showConnect } from '@stacks/connect';
    import { Person } from '@stacks/profile';

    const appConfig = new AppConfig(['store_write', 'publish_data']);
    const userSession = new UserSession({ appConfig });	
    // const { doContractCall } = useConnect();
    import { connectWebSocketClient } from '@stacks/blockchain-api-client';

    import { StacksTestnet, StacksMainnet } from '@stacks/network';
	const testnet = new StacksTestnet();
	const mainnet = new StacksMainnet();

    import { openContractCall } from '@stacks/connect';
    import {
	  uintCV,
	  intCV,
	  bufferCV,
	  stringAsciiCV,
	  stringUtf8CV,
	  standardPrincipalCV,
	  trueCV,
	} from '@stacks/transactions';

	import Vue from 'vue'
	import VueCtkDateTimePicker from 'vue-ctk-date-time-picker';
	import 'vue-ctk-date-time-picker/dist/vue-ctk-date-time-picker.css';
	Vue.component('VueCtkDateTimePicker', VueCtkDateTimePicker);
	import moment from 'moment';

	import firebase from 'firebase/app'
	import 'firebase/database'

	var firebaseConfig = {
	  apiKey: process.env.VUE_APP_fb_apikey,
	  authDomain: process.env.VUE_APP_fb_authdomain,
	  databaseURL: process.env.VUE_APP_fb_dburl,
	  projectId: process.env.VUE_APP_fb_projectid,
	  storageBucket: process.env.VUE_APP_fb_storagebucket,
	  messagingSenderId: process.env.VUE_APP_fb_msgsenderid,
	  appId: process.env.VUE_APP_fb_appid,
	  measurementId: process.env.VUE_APP_fb_measurementid
	};
	if (!firebase.apps.length) {
		// Initialize Firebase
		firebase.initializeApp(firebaseConfig);
	}

	const db = firebase
	  // .initializeApp({ databaseURL: 'https://MY-DATABASE.firebaseio.com' })
	  .database()

export default {
	name: 'my-component',
	data() {
	return {
	    form: {
	    	question: '',
	        paypervote: '',
	        // cropregion: '',
	        // autooracle: '',
	        // manualoracle: '',
	        oracle: '',
	        // resolveTime: '',
	        // datetime: '',
	    	},
	    datetime: null,
	    mindatetime: null,
	    txid: '',
	    pop: '',
	    statustext: '',
	    stuff: '',
	    isLoading: false,
	    isLoadingContract: false,
	    userData: null,
	    marketcount: 0,
		}
	},
    components: {
        FvlForm,
        FvlInput,
        FvlTextarea,
        FvlRadio,
        FvlSubmit,
        FvlSelect,
        VueLoadingButton,
        // Modal,
    },
    mounted: function () {
    	// YYYY-MM-DD hh:mm a
    	var mindate = moment().format('YYYY-MM-DD hh:mm a');
    	// console.log("mindate: ", mindate);
    	this.mindatetime = mindate;
    	if (userSession.isUserSignedIn()){
	        // console.log("isUserSignedIn: ", userSession.loadUserData());
	        this.userData = userSession.loadUserData();    		
    	}
		db.ref("stxpredict").on("value", snapshot => {
			let data = snapshot.val();
			let marketcount = 0;
			Object.keys(data).forEach(key => {
				marketcount++;
			});
			console.log("number of markets: ",  marketcount);
			this.marketcount = marketcount;
		});
    },
    methods: {
    	setstuff(){
    		let thisthing = this
    		console.log("1setting stuff to yes ", this.stuff);
    		thisthing.stuff = "yes";
    		console.log("2setting stuff to yes ", this.stuff);
    		// this.$refs.Modal.close();
    		this.$emit('exit', true);
    	},
    	async createMarket(){
			let thisthing = this
    		console.log("createMarket ", JSON.stringify(this.form), "datetime ", this.datetime, "useraddress ", this.userData.profile.stxAddress.testnet);
    		let unixtime = new Date(this.datetime).getTime()/1000;
    		// console.log("unixtime ", unixtime);
    		// validate
    		if(thisthing.form.question == "" || thisthing.form.paypervote == "" || thisthing.form.oracle.trim() == "" || this.datetime == null){
    			// using options
				this.$notify({
				  title: 'Empty Fields',
				  text: 'Please fill out all required information.',
				  type: 'error',
				  duration: 10000,
				});
				return;
    		}
    		// thisthing.statustext = "Creating Market...";
    		thisthing.isLoading = true;
    		
    		// (createMarket (question (string-ascii 99)) (paypervote int) (resolver principal) (resolveTime int) (resolveType (string-ascii 10)))
    		// (question (string-ascii 99)) (paypervote uint) (resolver principal) (resolveTime uint) (resolveType (string-ascii 10)
    		const functionArgs = [
			  stringAsciiCV(thisthing.form.question),
			  uintCV(parseInt(thisthing.form.paypervote)),
			  standardPrincipalCV(thisthing.form.oracle.trim()),
			  uintCV(parseInt(unixtime)),
			  stringAsciiCV("manual"),
			  // uintCV(1234),
			  // intCV(-234),
			  // bufferCV(Buffer.from('hello, world')),
			  // stringUtf8CV('hey-utf8'),
			  // trueCV(),
			];
			console.log("functionArgs: ", JSON.stringify(functionArgs));
			const options = {
			  network: testnet,
			  contractAddress: 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ',
			  contractName: 'stxpredict_v1',
			  functionName: 'createMarket',
			  functionArgs,
			  appDetails: {
			    name: 'stxpredict',
			    icon: window.location.origin + './assets/icon.png',
			  },
			  onFinish: data => {
			    console.log('Stacks Transaction:', data.stacksTransaction);
			    console.log('Transaction ID:', data.txId);
			    console.log('Raw transaction:', data.txRaw);
			    const explorerTransactionUrl = 'https://explorer.stacks.co/txid/'+data.txId+'?chain=testnet';
  				console.log('View transaction in explorer:', explorerTransactionUrl);
				thisthing.isLoading = false;
			  	db.ref("stxpredict").push({marketId: thisthing.marketcount+1, account: thisthing.userData.profile.stxAddress.testnet, question: thisthing.form.question, paypervote: thisthing.form.paypervote, oracle: thisthing.form.oracle.trim(), txid: "https://explorer.stacks.co/txid/"+data.txId+"?chain=testnet", resolveTime: thisthing.datetime, unixtime: unixtime, resolveType:"manual", yescount: 0, nocount: 0, balance:0, resolved: false, result: false,  createdAt: firebase.database.ServerValue.TIMESTAMP});
				this.$notify({
				  title: 'Create Market',
				  text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
				  type: 'success',
				  duration: 10000,
				});
				this.$emit('exit', true);
			  },
			};
			await openContractCall(options);
    	},
    	async joinMarket(){
			let thisthing = this
    		console.log("createMarket ", JSON.stringify(this.form), "datetime ", this.datetime, "useraddress ", this.userData.profile.stxAddress.testnet);
    		let unixtime = new Date(this.datetime).getTime()/1000;
    		// console.log("unixtime ", unixtime);
    		// validate
    		if(thisthing.form.question == "" || thisthing.form.paypervote == "" || thisthing.form.oracle.trim() == "" || this.datetime == null){
    			// using options
				this.$notify({
				  title: 'Empty Fields',
				  text: 'Please fill out all required information.',
				  type: 'error',
				  duration: 10000,
				});
				return;
    		}
    		// thisthing.statustext = "Creating Market...";
    		thisthing.isLoading = true;
    		
    		// (joinMarket (marketId int) (side bool) (amount uint))
    		const functionArgs = [
    			intCV(-234),
			  stringAsciiCV(thisthing.form.question),
			  uintCV(parseInt(thisthing.form.paypervote)),
			  standardPrincipalCV(thisthing.form.oracle.trim()),
			  uintCV(parseInt(unixtime)),
			  stringAsciiCV("manual"),
			  // uintCV(1234),
			  // intCV(-234),
			  // bufferCV(Buffer.from('hello, world')),
			  // stringUtf8CV('hey-utf8'),
			  // trueCV(),
			];
			console.log("functionArgs: ", JSON.stringify(functionArgs));
			const options = {
			  network: testnet,
			  contractAddress: 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ',
			  contractName: 'stxpredict_v1',
			  functionName: 'createMarket',
			  functionArgs,
			  appDetails: {
			    name: 'stxpredict',
			    icon: window.location.origin + './assets/icon.png',
			  },
			  onFinish: data => {
			    console.log('Stacks Transaction:', data.stacksTransaction);
			    console.log('Transaction ID:', data.txId);
			    console.log('Raw transaction:', data.txRaw);
			    const explorerTransactionUrl = 'https://explorer.stacks.co/txid/'+data.txId+'?chain=testnet';
  				console.log('View transaction in explorer:', explorerTransactionUrl);
				thisthing.isLoading = false;
			  	db.ref("stxpredict").push({account: thisthing.userData.profile.stxAddress.testnet, question: thisthing.form.question, paypervote: thisthing.form.paypervote, oracle: thisthing.form.oracle.trim(), txid: "https://explorer.stacks.co/txid/"+data.txId+"?chain=testnet", resolveTime: thisthing.datetime, unixtime: unixtime, resolveType:"manual", yescount: 0, nocount: 0, balance:0, resolved: false, result: false,  createdAt: firebase.database.ServerValue.TIMESTAMP});
				this.$notify({
				  title: 'Create Market',
				  text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
				  type: 'success',
				  duration: 10000,
				});
				this.$emit('exit', true);
			  },
			};
			await openContractCall(options);
    	},
      	fetchData() {
	      db.ref("stxpredict").on("value", snapshot => {
	        let data = snapshot.val();
	        console.log("number of markets: ", data.length);
	        // let messages = [];
	        // Object.keys(data).forEach(key => {
	        //   // console.log("each data[key]: ", data[key]);
	        //   var msgtopush = {merchant: key, ...data[key]};
	        //   // console.log("msgtopush: ", msgtopush);
	        //   messages.push(msgtopush);
	        //   // messages.push({
	        //   //   merchant: key,
	        //   //   lolli: data[key].lolli,
	        //   //   fold: data[key].fold,
	        //   //   strike: data[key].strike,
	        //   //   updatedAt: ''
	        //   // });
	        // });
	        // this.rows = messages;
	        // this.tableitems = messages;
	        // this.tableitems = [{ merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''}];
	        // this.mytableitems = [{ merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''}];
	        // this.rows = [{ merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''}];
	        // console.log("fetchData this.rows: ", this.rows);
	        // viewMessage.messages = messages;
	      });   
	    },
	}
}

</script>

