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
          <img class="cursor-pointer" @click="showProfile()" :src="profile.picture">
        </q-avatar>
      </q-toolbar-title>
          <q-form @submit="search">
      <q-input class="q-pa-none" style="width:300px;" dark v-model="searchTerm" label="Search">
        <template v-slot:append>
          <q-icon v-ripple clickable class="cursor-pointer" @click="search" name="search" />
        </template>
      </q-input>
        </q-form>
    </q-toolbar>
  </q-header>
  <q-drawer
    v-model="leftDrawerOpen"
    bordered
    :mini="miniState"
    @mouseover="miniState = false"
    @mouseout="miniState = true"
    :width="200"
    content-class="bg-black text-white"
  >
    <q-list class="q-pt-lg">
      <MainNav class="q-mt-lg"></MainNav>
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
      leftDrawerOpen: true,
      miniState: false,
      searchTerm: '',
      profile_url: '/profile/' + this.$store.state.user.uid
    }
  },
  methods: {
    showProfile: function () {
      this.$router.push(this.profile_url)
    },
    search: function () {
      console.log('searching:', this.searchTerm)
    },
    getProfile: function (network) {
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
