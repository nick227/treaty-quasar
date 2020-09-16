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
          <img class="cursor-pointer" @click="showProfile()" :src="profile.avatar_url">
        </q-avatar>
        <q-btn v-if="!profile.id" to="/login" class="q-ml-lg" outline style="color: goldenrod;" label="Login" />
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
import MainNav from 'components/elements/MainNav.vue'
export default {
  name: 'TopToolbar',
  created () {
    this.getProfile('facebook')
  },
  components: { MainNav },
  data () {
    return {
      profile: {},
      leftDrawerOpen: true,
      miniState: false,
      searchTerm: ''
    }
  },
  methods: {
    showProfile: function () {
      this.$router.push('/profile/' + this.$store.state.user.uid)
    },
    search: function () {
      console.log('searching:', this.searchTerm)
    },
    getProfile: function (network) {
      if (this.$hello.getAuthResponse(network) == null) {
        return false
      }
      this.profile.id = this.$store.state.user.uid
      this.profile.avatar_url = this.$store.state.user.avatarUrl
      /*
      this.$hello(network).api('me')
        .then((res) => {
          this.profile = res
        })
        */
    }
  }
}
</script>
