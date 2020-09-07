<template>
  <q-layout view="lHh Lpr lFf">
    <TopToolbar></TopToolbar>
    <q-page-container>
      <router-view />
    </q-page-container>
    <q-ajax-bar
      ref="bar"
      position="bottom"
      color="accent"
      size="10px"
      skip-hijack
    />
  </q-layout>
</template>
<script>
import TopToolbar from 'components/TopToolbar.vue'

export default {
  name: 'MainLayout',
  components: { TopToolbar },
  data () {
    return {}
  }
}
</script>
