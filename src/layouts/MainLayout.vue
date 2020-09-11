<template>
  <q-layout view="lHh Lpr lFf">
    <TopToolbar></TopToolbar>
    <!--
    <q-footer reveal elevated class="bg-cyan">
        <q-toolbar>
          <q-toolbar-title></q-toolbar-title>
        </q-toolbar>
      </q-footer>
    -->
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
