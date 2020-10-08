<template>
  <q-layout view="Lhh lpR fff" container class="q-pa-none bg-white">
    <q-header class="bg-grey">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg text-center">CONCORDANT.IO TREATY</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <TreatyPage class="" :treatyId="treatyId" />
  </q-layout>
</template>
<script>
import TreatyPage from 'pages/treaty/TreatyPage.vue'
export default {
  name: 'TreatyDialogComponent',
  meta () {
    return {
      title: this.treatyName
    }
  },
  props: ['treatyId'],
  components: { TreatyPage },
  created () {}
}
</script>
