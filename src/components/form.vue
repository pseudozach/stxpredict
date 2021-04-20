<template>
  <div>asd
    <dynamic-form :id="testForm.id" :fields="testForm.fields" />
  </div>
  
  <!-- <button type="submit" :form="testForm.id">Submit</button> -->
</template>

<script>
// import Vue from 'vue';
// import { DynamicForm, FormField } from '@asigloo/vue-dynamic-forms';

import Vue from 'vue';
import {VueDynamicForms} from '@asigloo/vue-dynamic-forms';
Vue.use(VueDynamicForms);

import {
  FormField,
  FormValidation,
  required,
  email,
  pattern
} from "@asigloo/vue-dynamic-forms";

export default {
  name: 'your-awesome',
  data() {
    return {
      testForm: {
        id: 'test-form',
        fields: [
          new FormField({
            type: 'text',
            label: 'Name',
            name: 'name',
          }),
          new FormField({
            type: 'email',
            label: 'Email',
            name: 'email',
          }),
        ],
      },
    };
  },
  components: {
    VueDynamicForms,
  },
};

</script>