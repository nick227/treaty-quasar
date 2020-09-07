<template>
  <div>
  <q-header elevated reveal class="bg-black">
    <q-toolbar>
      <q-btn
        flat
        dense
        round
        icon="menu"
        aria-label="Menu"
        @click="leftDrawerOpen = !leftDrawerOpen"
      />

      <q-toolbar-title>
        <span class="">CONCORDANT.IO</span>
        <q-avatar class="q-ml-lg" v-if="profile.id">
          <img :src="profile.picture">
        </q-avatar>
      </q-toolbar-title>

    </q-toolbar>
  </q-header>
  <q-drawer
    v-model="leftDrawerOpen"
    bordered
    content-class="bg-grey-1"
  >
    <q-list>
      <q-item-label header></q-item-label>
      <MainNav></MainNav>
    </q-list>
  </q-drawer>
  </div>
</template>
<script>
import MainNav from 'components/MainNav.vue'
export default {
  name: 'TopToolbar',
  mounted () {
    this.getProfile('facebook')
  },
  components: { MainNav },
  data () {
    return {
      profile: {},
      leftDrawerOpen: true
    }
  },
  watch: {
    profile: function (val) {
      this.$forceUpdate()
    }
  },
  methods: {
    getProfile (network) {
      if (this.$hello.getAuthResponse(network) == null) {
        return
      }
      this.$hello(network).api('me')
        .then((res) => {
          this.profile = res
        })
    }
  }
}
</script>
