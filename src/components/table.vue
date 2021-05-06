<!-- <template>
  <div style="width: 600px">
    <vue-table-dynamic 
      :params="params" 
      ref="table"
    >
    </vue-table-dynamic>
  </div>
</template> -->

<!-- compactMode -->
<!-- :fixed-header="true" -->
<template>
  <div style="margin: 20px;">
    <vue-good-table
      :columns="columns"
      :rows="rows"
      :search-options="{
        enabled: false,
        placeholder: 'Search Cashback Rates',
      }"
      :pagination-options="{
        enabled: true,
        perPage: 20}"
      @on-cell-click="onCellClick"
      :sort-options="{
        enabled: false,
      }"
      >
      <template slot="table-row" slot-scope="props">
        <span v-if="props.column.field == 'txid'">
          <!-- style="font-weight: bold; color: blue;" -->
          <a :href="props.row.txid" target="_blank">txid link</a> 
        </span>
        <span v-else-if="props.column.field == 'join'">
          <!-- style="font-weight: bold; color: blue;" -->
          <VueLoadingButton
            aria-label="Join Market"
            style="background-color: green;"
            class="button"
            label="up"
            @click.native="setThumbsUp"
            data-id="up"
            :styled="true"
            :loading="isLoadingJoin"
          ><font-awesome-icon icon="thumbs-up" /></VueLoadingButton>
          <VueLoadingButton
            aria-label="Join Market"
            style="margin-left: 10px; background-color: red;"
            class="button"
            @click.native="setThumbsDown"
            data-id="down"
            :styled="true"
            :loading="isLoadingJoin"
          ><font-awesome-icon icon="thumbs-down" /></VueLoadingButton>
        </span>
        <span v-else-if="props.column.field == 'resolve'">
          <!-- style="font-weight: bold; color: blue;" -->
          <VueLoadingButton
            aria-label="Resolve Market"
            style="background-color: green;"
            class="button"
            @click.native="setThumbsUp"
            :styled="true"
            :loading="isLoadingResolve"
          ><font-awesome-icon icon="thumbs-up" /></VueLoadingButton>
          <VueLoadingButton
            aria-label="Resolve Market"
            style="margin-left: 10px; background-color: red;"
            class="button"
            @click.native="setThumbsDown"
            :styled="true"
            :loading="isLoadingResolve"
          ><font-awesome-icon icon="thumbs-down" /></VueLoadingButton>
          <VueLoadingButton
            aria-label="Resolve Market"
            style="margin-left: 10px; background-color: gray;"
            class="button"
            @click.native="setQuestion"
            :styled="true"
            :loading="isLoadingResolve"
          ><font-awesome-icon icon="question" /></VueLoadingButton>
        </span>
        <span v-else-if="props.column.field == 'exit'">
          <!-- style="font-weight: bold; color: blue;" -->
          <VueLoadingButton
            aria-label="Exit Market"
            class="button"
            :styled="true"
            :loading="isLoadingExit"
          ><font-awesome-icon icon="times" /></VueLoadingButton>
        </span>
        <span v-else>
          {{props.formattedRow[props.column.field]}}
        </span>
      </template>
    </vue-good-table>
  </div>
</template>





<script>
// import VueTableDynamic from 'vue-table-dynamic'

// import VueGoodTablePlugin from 'vue-good-table';
// // import the styles
// import 'vue-good-table/dist/vue-good-table.css'
// Vue.use(VueGoodTablePlugin);


import 'vue-good-table/dist/vue-good-table.css'
import { VueGoodTable } from 'vue-good-table';
import VueLoadingButton from 'vue-loading-button'

import { library } from '@fortawesome/fontawesome-svg-core'
import { faPlus } from '@fortawesome/free-solid-svg-icons'
import { faCheck } from '@fortawesome/free-solid-svg-icons'
import { faTimes } from '@fortawesome/free-solid-svg-icons'
import { faThumbsUp } from '@fortawesome/free-solid-svg-icons'
import { faThumbsDown } from '@fortawesome/free-solid-svg-icons'
import { faQuestion } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
library.add(faPlus)
library.add(faCheck)
library.add(faTimes)
library.add(faThumbsUp)
library.add(faThumbsDown)
library.add(faQuestion)

import Vue from 'vue'
import VueMeta from 'vue-meta'
Vue.use(VueMeta)
// import { db } from '../main'


  // stacks stuff
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
  falseCV,
  FungibleConditionCode,
  makeStandardSTXPostCondition,
} from '@stacks/transactions';
const BigNum = require('bn.js');


// Get a RTDB instance
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

// console.log("todos: ", db.ref('cbtable'));
// // retrieve a collection
// db.ref('cbtable').once('value', snapshot => {
//   const documents = snapshot.val()
//   console.log("got cbtable: ", documents)
//   // do something with documents
// })

// export default {
//   name: 'Demo',
//   // firebase: function () {
//   //    return {
//   //        fbObj: db.ref('cbtable')
//   //    }
//   // },
//   firebase: {
//     fbObj: db.ref('cbtable')
//   },
//   computed: {
//     data() {
//         return this.fbObj;
//     }
//   },
//   data() {
//     return {
//       params: {
//         data: this.fbObj,
//         // [
//         //   ['Index', 'Data1', 'Data2', 'Data3'],
//         //   [1, 'b3ba90', '7c95f7', '9a3853'],
//         //   [2, 'ec0b78', 'ba045d', 'ecf03c'],
//         //   [3, '63788d', 'a8c325', 'aab418']
//         // ],
//         header: 'row',
//         enableSearch: true,
//         sort: [0, 1]
//       }
//     }
//   },
//   methods: {
//   },
//   components: { VueTableDynamic }
// }


export default {
  name: 'my-component',
  // firebase: function () {
  //   return {
  //     fbObj: db.ref('cbtable'),
  //     tableitems: []
  //   }
  // },
  // watch: {
  //   '$route': 'fetchData'
  // },
  mounted: function () {
    // YYYY-MM-DD hh:mm a
    // var mindate = moment().format('YYYY-MM-DD hh:mm a');
    // // console.log("mindate: ", mindate);
    // this.mindatetime = mindate;
    if (userSession.isUserSignedIn()){
        // console.log("isUserSignedIn: ", userSession.loadUserData());
        this.userData = userSession.loadUserData();       
    } else {
      console.log("not signed in? ", userSession)
    }
  },
  methods: {
    setThumbsUp(){
      // console.log("setThumbsUp");
      this.fatype = "up";
    },
    setThumbsDown(){
      // console.log("setThumbsUp");
      this.fatype = "down";
    },
    setQuestion(){
      // console.log("setThumbsUp");
      this.fatype = "question";
    },
    onCellClick(params) {
      // console.log("row clicked: ", params.row)
      // console.log("column clicked: ", params.column)
      // console.log("event: ", params.event, event.target.getAttribute('data-id'), event.currentTarget.getAttribute('data-id'), event.target.dataset.id)
      // console.log("fatype: ", this.fatype)
      if(params.column.field == "join"){
        this.joinMarket(params.row);
      }
      if(params.column.field == "resolve"){
        if(this.fatype == "question") {
          console.log("auto resolve");
          this.requestResolveMarket(params.row);
        } else {
          console.log("manual resolve");
          this.resolveMarket(params.row);
        }
        
      }
      if(params.column.field == "exit"){
        this.exitMarket(params.row);
      }
      // params.row - row object 
      // params.column - column object
      // params.rowIndex - index of this row on the current page.
      // params.event - click event
    },
    // {
    //     "merchant": "-MYgY5u5gralxGXbxwkH",
    //     "account": "ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ",
    //     "createdAt": 1618876329677,
    //     "marketId": 2,
    //     "nocount": 0,
    //     "oracle": "ST2507VNQZC9VBXM7X7KB4SF4QJDJRSWHG6ERHWB7",
    //     "paypervote": "1",
    //     "question": "test2",
    //     "resolveTime": "2021-04-24 04:52 pm",
    //     "resolveType": "manual",
    //     "txid": "https://explorer.stacks.co/txid/${data.txId}?chain=testnet",
    //     "unixtime": 1619308320,
    //     "yescount": 0,
    //     "vgt_id": 0,
    //     "originalIndex": 0
    // }
    async joinMarket(marketobj){
      let thisthing = this
      // console.log("joinMarket: ", JSON.stringify(marketobj), "useraddress ", this.userData.profile.stxAddress.testnet);
      // let unixtime = new Date(this.datetime).getTime()/1000;
      // console.log("unixtime ", unixtime);
      // validate
      if(marketobj.question == "" || marketobj.paypervote == "" || marketobj.oracle.trim() == "" || this.fatype == "nothing"){
        // using options
      this.$notify({
        title: 'Empty Fields',
        text: 'Failed to fetch market data, refresh and try again.',
        type: 'error',
        duration: 10000,
      });
      return;
      }
      // thisthing.statustext = "Creating Market...";
      thisthing.isLoadingJoin = true;
        
      // (joinMarket (marketId int) (side bool) (amount uint))
      let sideobj = trueCV();
      let newyescount = marketobj.yescount;
      let newnocount = marketobj.nocount;
      if(thisthing.fatype == "down"){
        sideobj = falseCV();
        newnocount++;
      } else {
        newyescount++;
      }
      const functionArgs = [
        intCV(parseInt(marketobj.marketId)),
        sideobj,
        // stringAsciiCV(thisthing.form.question),
        uintCV(parseInt(marketobj.paypervote)),
        // standardPrincipalCV(thisthing.form.oracle.trim()),
        // uintCV(parseInt(unixtime)),
        // stringAsciiCV("manual"),
        // uintCV(1234),
        // intCV(-234),
        // bufferCV(Buffer.from('hello, world')),
        // stringUtf8CV('hey-utf8'),
        // trueCV(),
      ];
      // Add an optional post condition
      // See below for details on constructing post conditions
      const postConditionAddress = 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ';
      const postConditionCode = FungibleConditionCode.LessEqual;
      const postConditionAmount = new BigNum(parseInt(marketobj.paypervote)*2);
      const postConditions = [
        makeStandardSTXPostCondition(postConditionAddress, postConditionCode, postConditionAmount),
      ];
      console.log("join functionArgs: ", JSON.stringify(functionArgs));
      const options = {
        network: testnet,
        contractAddress: 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ',
        contractName: thisthing.contractname,
        functionName: 'joinMarket',
        functionArgs,
        appDetails: {
          name: 'stxpredict',
          icon: window.location.origin + './assets/icon.png',
        },
        postConditions,
        onFinish: data => {
          console.log('Stacks Transaction:', data.stacksTransaction);
          console.log('Transaction ID:', data.txId);
          // console.log('Raw transaction:', data.txRaw);
          const explorerTransactionUrl = 'https://explorer.stacks.co/txid/'+data.txId+'?chain=testnet';
          console.log('View transaction in explorer:', explorerTransactionUrl);
        thisthing.isLoadingJoin = false;
        var updateobj = {yescount: newyescount, nocount: newnocount, balance: parseInt(marketobj.balance+marketobj.paypervote)};
        console.log("market, updateobj: ",marketobj.merchant, updateobj);
          db.ref(thisthing.contractname+"/"+marketobj.merchant).update(updateobj);
        this.$notify({
          title: 'Joining Market',
          text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
          type: 'success',
          duration: 10000,
        });
        // this.$emit('exit', true);
        },
      };
      await openContractCall(options);
      },
    async resolveMarket(marketobj){
      let thisthing = this
      console.log("resolveMarket: ", JSON.stringify(marketobj), "useraddress ", this.userData.profile.stxAddress.testnet);
      // let unixtime = new Date(this.datetime).getTime()/1000;
      // console.log("unixtime ", unixtime);
      // validate
      if(marketobj.question == "" || marketobj.paypervote == "" || marketobj.oracle.trim() == "" || this.fatype == "nothing"){
        // using options
      this.$notify({
        title: 'Empty Fields',
        text: 'Failed to fetch market data, refresh and try again.',
        type: 'error',
        duration: 10000,
      });
      return;
      }
      // thisthing.statustext = "Creating Market...";
      thisthing.isLoadingResolve = true;
        
      // (resolveMarket (marketId int) (result bool))
      let sideobj = trueCV();
      let newresult = false;
      if(thisthing.fatype == "down"){
        sideobj = falseCV();
        newresult = false;
      } else {
        newresult = true;
      }
      const functionArgs = [
        intCV(parseInt(marketobj.marketId)),
        sideobj,
        // stringAsciiCV(thisthing.form.question),
        // uintCV(parseInt(marketobj.paypervote)),
        // standardPrincipalCV(thisthing.form.oracle.trim()),
        // uintCV(parseInt(unixtime)),
        // stringAsciiCV("manual"),
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
        functionName: 'resolveMarket',
        functionArgs,
        appDetails: {
          name: 'stxpredict',
          icon: window.location.origin + './assets/icon.png',
        },
        onFinish: data => {
          console.log('Stacks Transaction:', data.stacksTransaction);
          console.log('Transaction ID:', data.txId);
          // console.log('Raw transaction:', data.txRaw);
          // const explorerTransactionUrl = 'https://explorer.stacks.co/txid/'+data.txId+'?chain=testnet';
          console.log('View transaction in explorer:', explorerTransactionUrl);
        thisthing.isLoadingResolve = false;
        var updateobj = {result: newresult, resolved: true};
        console.log("market, updateobj: ",marketobj.merchant, updateobj);
          db.ref(thisthing.contractname+"/"+marketobj.merchant).update(updateobj);
        this.$notify({
          title: 'Resolving Market',
          text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
          type: 'success',
          duration: 10000,
        });
        // this.$emit('exit', true);
        },
      };
      await openContractCall(options);
      },
    async requestResolveMarket(marketobj){
      let thisthing = this
      console.log("resolveMarket: ", JSON.stringify(marketobj), "useraddress ", this.userData.profile.stxAddress.testnet);
      // let unixtime = new Date(this.datetime).getTime()/1000;
      // console.log("unixtime ", unixtime);
      // validate
      if(marketobj.question == "" || marketobj.paypervote == "" || marketobj.oracle.trim() == "" || this.fatype == "nothing"){
        // using options
      this.$notify({
        title: 'Empty Fields',
        text: 'Failed to fetch market data, refresh and try again.',
        type: 'error',
        duration: 10000,
      });
      return;
      }
      // thisthing.statustext = "Creating Market...";
      thisthing.isLoadingResolve = true;
        
      // (resolveMarket (marketId int) (result bool))
      let sideobj = trueCV();
      let newresult = false;
      if(thisthing.fatype == "down"){
        sideobj = falseCV();
        newresult = false;
      } else {
        newresult = true;
      }
      const functionArgs = [
        intCV(parseInt(marketobj.marketId)),
        // sideobj,
        // stringAsciiCV(thisthing.form.question),
        // uintCV(parseInt(marketobj.paypervote)),
        // standardPrincipalCV(thisthing.form.oracle.trim()),
        // uintCV(parseInt(unixtime)),
        // stringAsciiCV("manual"),
        // uintCV(1234),
        // intCV(-234),
        // bufferCV(Buffer.from('hello, world')),
        // stringUtf8CV('hey-utf8'),
        // trueCV(),
      ];
      console.log("requestResolution functionArgs: ", JSON.stringify(functionArgs));
      var caddress = marketobj.oracle;
      var cname = thisthing.contractname;
      if(marketobj.oracle.includes(".")){
        caddress = marketobj.oracle.split(".")[0];
        cname = marketobj.oracle.split(".")[1];
      }
      console.log("caddress, cname: ", caddress, cname);
      const options = {
        network: testnet,
        contractAddress: caddress,
        contractName: cname,
        functionName: 'requestResolution',
        functionArgs,
        appDetails: {
          name: 'stxpredict',
          icon: window.location.origin + './assets/icon.png',
        },
        onFinish: data => {
          console.log('Stacks Transaction:', data.stacksTransaction);
          console.log('Transaction ID:', data.txId);
          // console.log('Raw transaction:', data.txRaw);
          // const explorerTransactionUrl = 'https://explorer.stacks.co/txid/'+data.txId+'?chain=testnet';
          console.log('View transaction in explorer:', explorerTransactionUrl);
        thisthing.isLoadingResolve = false;
        var updateobj = {result: newresult, resolved: true};
        console.log("market, updateobj: ",marketobj.merchant, updateobj);
          db.ref(thisthing.contractname+"/"+marketobj.merchant).update(updateobj);
        this.$notify({
          title: 'Resolving Market',
          text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
          type: 'success',
          duration: 10000,
        });
        // this.$emit('exit', true);
        },
      };
      await openContractCall(options);
      },
    async exitMarket(marketobj){
      let thisthing = this
      console.log("exitMarket: ", JSON.stringify(marketobj), "useraddress ", this.userData.profile.stxAddress.testnet);
      // let unixtime = new Date(this.datetime).getTime()/1000;
      // console.log("unixtime ", unixtime);
      // validate
      if(marketobj.question == "" || marketobj.paypervote == "" || marketobj.oracle.trim() == "" || this.fatype == "nothing"){
        // using options
      this.$notify({
        title: 'Empty Fields',
        text: 'Failed to fetch market data, refresh and try again.',
        type: 'error',
        duration: 10000,
      });
      return;
      }
      // thisthing.statustext = "Creating Market...";
      thisthing.isLoadingResolve = true;
        
      // (exitMarket (marketId int)
      // let sideobj = trueCV();
      // let newresult = false;
      // if(thisthing.fatype == "down"){
      //   sideobj = falseCV();
      //   newresult = false;
      // } else {
      //   newresult = true;
      // }
      const functionArgs = [
        intCV(parseInt(marketobj.marketId)),
        // sideobj,
        // stringAsciiCV(thisthing.form.question),
        // uintCV(parseInt(marketobj.paypervote)),
        // standardPrincipalCV(thisthing.form.oracle.trim()),
        // uintCV(parseInt(unixtime)),
        // stringAsciiCV("manual"),
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
        functionName: 'exitMarket',
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
        thisthing.isLoadingResolve = false;
        // var updateobj = {balance: marketobj.balance, resolved: true};
        // console.log("market, updateobj: ",marketobj.merchant, updateobj);
        //   db.ref("stxpredict/"+marketobj.merchant).update(updateobj);
        this.$notify({
          title: 'Exiting Market',
          text: 'Tx broadcasted. Please wait for it to be confirmed: ' + explorerTransactionUrl,
          type: 'success',
          duration: 10000,
        });
        // this.$emit('exit', true);
        },
      };
      await openContractCall(options);
      },
    fetchData() {
      db.ref(this.contractname).on("value", snapshot => {
        if(snapshot.exists()){
          let data = snapshot.val();
          let messages = [];
          Object.keys(data).forEach(key => {
            // console.log("each data[key]: ", data[key]);
            var msgtopush = {merchant: key, ...data[key]};
            // console.log("msgtopush: ", msgtopush);
            messages.push(msgtopush);
            // messages.push({
            //   merchant: key,
            //   lolli: data[key].lolli,
            //   fold: data[key].fold,
            //   strike: data[key].strike,
            //   updatedAt: ''
            // });
          });
          this.rows = messages;          
        }

        // this.tableitems = messages;
        // this.tableitems = [{ merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''}];
        // this.mytableitems = [{ merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''}];
        // this.rows = [{ merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''}];
        // console.log("fetchData this.rows: ", this.rows);
        // viewMessage.messages = messages;
      });    
    },
  },
  created() {
    // let viewMessage = this;
    // const itemsRef = fire.database().ref("cbtable");
    this.fetchData()
  },
  data(){
    // console.log("data return this.rows: ", this.rows);
    // {account: thisthing.userData.profile.stxAddress.testnet, question: thisthing.form.question, paypervote: thisthing.form.paypervote, oracle: thisthing.form.oracle.trim(), txid: "https://explorer.stacks.co/txid/${data.txId}?chain=testnet", resolveTime: unixtime, resolveType:"manual",  createdAt: firebase.database.ServerValue.TIMESTAMP}
    return {
      isLoadingJoin: false,
      isLoadingResolve: false,
      isLoadingExit: false,
      fatype: 'nothing',
      userData: null,
      contractname: 'stxpredict_v3',
      columns: [
        // {
        //   label: 'Market Creator',
        //   field: 'account',
        // },
        {
          label: 'Question',
          field: 'question',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Pay per Vote',
          field: 'paypervote',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Yes #',
          field: 'yescount',
          type: 'number',
          // type: 'percentage',
        },
        {
          label: 'No #',
          field: 'nocount',
          type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Oracle',
          field: 'oracle',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Tx Id',
          field: 'txid',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Resolve Time (PST)',
          field: 'resolveTime',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Join',
          field: 'join',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Resolve',
          field: 'resolve',
          // type: 'number',
          // type: 'percentage',
        },
        {
          label: 'Exit',
          field: 'exit',
          // type: 'number',
          // type: 'percentage',
        },
        // {
        //   label: 'Type',
        //   field: 'resolveType',
        //   // type: 'number',
        //   // type: 'percentage',
        // },
        // {
        //   label: 'Liquigate',
        //   field: 'liquigate',
        //   // type: 'number',
        //   // type: 'percentage',
        // },
        // {
        //   // 📅
        //   label: 'Created At',
        //   field: 'createdAt',
        //   type: 'date',
        //   dateInputFormat: 'T',
        //   dateOutputFormat: 'MMM do yyyy HH:mm:ss',
        // },
        // {
        //   label: 'Percent',
        //   field: 'cashback',
        //   type: 'percentage',
        // },
      ],
      rows: [],
      // mytableitems: []
      // rows: [
      //      { merchant:"Amazon", lolli:0.01, fold: 0.01, createdAt: ''},
      //   // { id:1, name:"John", age: 20, createdAt: '',score: 0.03343 },
      //   // { id:2, name:"Jane", age: 24, createdAt: '2011-10-31', score: 0.03343 },
      //   // { id:3, name:"Susan", age: 16, createdAt: '2011-10-30', score: 0.03343 },
      //   // { id:4, name:"Chris", age: 55, createdAt: '2011-10-11', score: 0.03343 },
      //   // { id:5, name:"Dan", age: 40, createdAt: '2011-10-21', score: 0.03343 },
      //   // { id:6, name:"John", age: 20, createdAt: '2011-10-31', score: 0.03343 },
      // ],
    };
  },
  components: {
    VueGoodTable,
    VueLoadingButton,
    FontAwesomeIcon,
  }
};
</script>





