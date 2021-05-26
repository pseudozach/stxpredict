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
				v-model="key"
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
			  :options="{ 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ.oracle_v4_btcusd': 'BTC / USD',
			  'ST11NHWNT1GYPAJH3ZN8XH4SJ1EYE7R0A3C6ZKJSX.oracle_v4_stxusd': 'STX / USD',
			  'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ.resolver_v1_coinbasebtc': 'BTC / USD (Exchange Signed Oracle)',
			  'enter account.contract-name manually': 'Other pre-deployed glue contract'
			  }"
			  :selected.sync="form.oracle"
			  @change.native="onChange"
			  style="margin: 10px;"
			/>

			<div style="border: 1px solid #4e5d7c; padding: 2px;">
				<span>Deploy your own resolver oracle contract based on signed exchange data (optional)</span>
				<fvl-select
				  label="Select Available Exchange"
				  :selected.sync="ooexchange"
				  name="ooexchange"
				  :options="{ 'coinbase': 'coinbase (BTC, ETH, LINK, COMP, UNI, SNX)',
				  'okcoin': 'okcoin (BTC, ETH)',
				  'artifix-okcoin': 'artifix-okcoin (BTC, ETH, LINK, STX-BTC, STX, COMP, LTC, UNI)',
				  'artifix-binance': 'artifix-binance (ETH-BTC, LINK-BTC, LINK-ETH, STX-BTC, STX-USDT, COMP-BTC, LTC-BTC, UNI-BTC, AAVE-BTC, SUSHI-BTC)'
				  }"
				  style="margin: 10px;"
				/>
				<fvl-select
				  label="Select Available Pairs"
				  name="oopair"
				  :selected.sync="oopair"
				  :options="{
				  'BTC': 'BTC',
				  'ETH': 'ETH',
				  'LINK': 'LINK',
				  'COMP': 'COMP',
				  'UNI': 'UNI',
				  'SNX': 'SNX',
				  'STX': 'STX',
				  'LTC': 'LTC',
				  'ETH-BTC': 'ETH-BTC',
				  'STX-BTC': 'STX-BTC'
				  }"
				  style="margin: 10px;"
				/>
		  		<VueLoadingButton 
			        aria-label="Create Resolver"
			        class="button"
			        @click.native="createResolver"
			        :loading="isLoadingResolver"
			        :styled="true"
			  	>Create Resolver Contract
			  	</VueLoadingButton>
			</div>

			<fvl-input 
				:value.sync="form.oracle" 
				label="Oracle Account" 
				name="manual oracle address" 
				placeholder="e.g. ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ"
				style="margin: 10px;"
			/>

			<fvl-input 
				:value.sync="form.threshold" 
				label="Threshold (* Required for Auto Resolution)" 
				name="threshold" 
				style="margin: 10px;" 
				placeholder="60000"
				v-show="thresholdVisible"
				type="number"
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
	      		label="Payment per vote (mSTX)" 
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

    import { openContractCall, openContractDeploy } from '@stacks/connect';
    import {
	  uintCV,
	  intCV,
	  bufferCV,
	  stringAsciiCV,
	  stringUtf8CV,
	  standardPrincipalCV,
	  trueCV,
	  makeStandardSTXPostCondition,
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
		        threshold: '0',
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
		    isLoadingResolver: false,
		    userData: null,
		    marketcount: 0,
		    contractname: 'stxpredict_v4',
		    thresholdVisible: false,
		    key: '',
		    resolvetype: 'manual',
		    ooexchange: '',
		    oopair: '',
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
		db.ref(this.contractname).on("value", snapshot => {
			if(snapshot.exists()){
				let data = snapshot.val();
				let marketcount = 0;
				Object.keys(data).forEach(key => {
					marketcount++;
				});
				console.log("number of markets: ",  marketcount);
				this.marketcount = marketcount;				
			}
		});
    },
    methods: {
    	onChange: function () {
    		// console.log("testChange");
            console.log("onChange: " ,event.target.value)
            if(event.target.value.includes(".")){
            	this.thresholdVisible = true;
            	this.resolvetype = "auto";
            } else {
            	this.thresholdVisible = false;
            	this.resolvetype = "manual";
            }
        },
    	setstuff(){
    		let thisthing = this
    		console.log("1setting stuff to yes ", this.stuff);
    		thisthing.stuff = "yes";
    		console.log("2setting stuff to yes ", this.stuff);
    		// this.$refs.Modal.close();
    		this.$emit('exit', true);
    	},
    	async createResolver(){
			let thisthing = this
    		console.log("createResolver ", JSON.stringify(this.form), "useraddress ", this.userData.profile.stxAddress.testnet);
    		// let unixtime = new Date(this.datetime).getTime()/1000;
    		// // console.log("unixtime ", unixtime);
    		// var caddress = thisthing.form.oracle.trim();
    		// if(thisthing.form.oracle.trim().includes(".")){
    		// 	// auto resolve oracle - will have contract address + contract name
    		// 	caddress = thisthing.form.oracle.trim().split(".")[0];
    		// }

    		// validate
    		if(thisthing.ooexchange == "" || thisthing.oopair == ""){
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
    		thisthing.isLoadingResolver = true;
    		this.thresholdVisible = true;

    		// replace resolver_v1.clar with user options and deploy contract.
            const response = await fetch(`./resolver_v1.clar`);
            const resolvercode = await response.text();
            var modresolver = resolvercode.replace("coinbase",thisthing.ooexchange);
            modresolver = modresolver.replace("BTC",thisthing.oopair);
            var contractname = 'resolver_v1_'+thisthing.ooexchange.toLowerCase()+"_"+thisthing.oopair.toLowerCase()
            console.log("modresolver: ", modresolver, contractname);
			// const codeBody = '(begin (print "hello, world"))';

			openContractDeploy({
			  codeBody: modresolver,
			  contractName: contractname,
			  network: testnet,
			  appDetails: {
			    name: 'stxpredict',
			    icon: window.location.origin + './assets/icon.png',
			  },
			  onFinish: data => {
			    console.log('Stacks Transaction:', data.stacksTransaction);
			    console.log('Transaction ID:', data.txId);
			    // console.log('Raw transaction:', data.txRaw);
			    thisthing.isLoadingResolver = false;
			    var resolveraddress = this.userData.profile.stxAddress.testnet + "." + contractname;
			    console.log("resolveraddress: ", resolveraddress);
			    thisthing.form.oracle = resolveraddress;
				this.$notify({
				  title: 'Deploy Contract',
				  text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
				  type: 'success',
				  duration: 10000,
				});
			  },
			});
    	},
    	async createMarket(){
			let thisthing = this
    		console.log("createMarket ", JSON.stringify(this.form), "datetime ", this.datetime, "useraddress ", this.userData.profile.stxAddress.testnet);
    		let unixtime = new Date(this.datetime).getTime()/1000;
    		// console.log("unixtime ", unixtime);
    		var caddress = thisthing.form.oracle.trim();
    		if(thisthing.form.oracle.trim().includes(".")){
    			// auto resolve oracle - will have contract address + contract name
    			caddress = thisthing.form.oracle.trim().split(".")[0];
    		}

    		// validate
    		if(thisthing.form.question == "" || thisthing.form.paypervote == "" || thisthing.form.oracle.trim() == "" || thisthing.form.oracle == "enter account.contract-name manually" || this.datetime == null || caddress == ""){
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
    		// console.log(thisthing.form.question, parseInt(thisthing.form.threshold), parseInt(thisthing.form.paypervote), caddress, parseInt(unixtime), thisthing.resolvetype);
    		// (createMarket (question (string-ascii 99)) (threshold int) (paypervote uint) (resolver principal) (resolveTime uint) (resolveType (string-ascii 10)))
    		const functionArgs = [
			  stringAsciiCV(thisthing.form.question),
			  intCV(parseInt(thisthing.form.threshold)),
			  uintCV(parseInt(thisthing.form.paypervote)),
			  standardPrincipalCV(caddress),
			  uintCV(parseInt(unixtime)),
			  stringAsciiCV(thisthing.resolvetype),
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
			  contractName: thisthing.contractname,
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
			  	db.ref(thisthing.contractname).push({marketId: thisthing.marketcount+1, account: thisthing.userData.profile.stxAddress.testnet, question: thisthing.form.question, threshold: thisthing.form.threshold, paypervote: thisthing.form.paypervote, caddress: caddress, oracle: thisthing.form.oracle.trim(), txid: "https://explorer.stacks.co/txid/"+data.txId+"?chain=testnet", resolveTime: thisthing.datetime, unixtime: unixtime, resolveType:thisthing.resolvetype, yescount: 0, nocount: 0, balance:0, resolved: false, result: false,  createdAt: firebase.database.ServerValue.TIMESTAMP});
				this.$notify({
				  title: 'Create Market',
				  text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
				  type: 'success',
				  duration: 10000,
				});
				this.$emit('exit', true);
			  },
			};
			await openContractCall(options)
			// .catch(error => {
			// 	console.log("openContractCall error: ", error);
			// })
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
			  contractName: thisthing.contractname,
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
			  	db.ref(thisthing.contractname).push({account: thisthing.userData.profile.stxAddress.testnet, question: thisthing.form.question, paypervote: thisthing.form.paypervote, oracle: thisthing.form.oracle.trim(), txid: "https://explorer.stacks.co/txid/"+data.txId+"?chain=testnet", resolveTime: thisthing.datetime, unixtime: unixtime, resolveType:"manual", yescount: 0, nocount: 0, balance:0, resolved: false, result: false,  createdAt: firebase.database.ServerValue.TIMESTAMP});
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
	      db.ref(thisthing.contractname).on("value", snapshot => {
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

