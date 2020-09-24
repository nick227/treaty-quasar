<template>
  <q-layout view="lHh Lpr lFf">
    <TopToolbar></TopToolbar>
    <!--
    <q-footer reveal elevated class="bg-grey">
        <q-toolbar>
          <q-toolbar-title class="text-h6 text-center">GIVE PEACE A CHANCE</q-toolbar-title>
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
import TopToolbar from 'components/elements/TopToolbar.vue'

export default {
  name: 'MainLayout',
  components: { TopToolbar },
  data () {
    return {
      prevHeight: 0
    }
  },
  methods: {
    beforeLeave (element) {
      this.prevHeight = getComputedStyle(element).height
    },
    enter (element) {
      const { height } = getComputedStyle(element)
      element.style.height = this.prevHeight
      setTimeout(() => { element.style.height = height })
    },
    afterEnter (element) {
      element.style.height = 'auto'
    }
  }
}
</script>
