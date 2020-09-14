<template>
  <q-page class="flex flex-center">
    <HomePageAnimations />
  </q-page>
</template>

<script>
import HomePageAnimations from 'components/animations/HomePageAnimation3.vue'
export default {
  meta () {
    return {
      title: 'concordant.io',
      keywords: { name: 'keywords', content: 'Quasar website' },
      equiv: { 'http-equiv': 'Content-Type', content: 'text/html; charset=UTF-8' }
    }
  },
  name: 'PageIndex',
  components: { HomePageAnimations }
}
</script>
