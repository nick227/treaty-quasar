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
      <q-toolbar-title style="overflow:visible;">
        <span class="cursor-pointer" @click="$router.push('/')">CONCORDANT.IO</span>
        <q-avatar class="q-ml-lg" v-if="profile.id">
          <img class="cursor-pointer" @click="showProfile()" :src="profile.avatar_url">
        </q-avatar>
        <q-btn v-if="newMessages" round color="dark" to="/messages" class="q-pa-none q-ml-md" icon="email"><q-badge style="font-size:0.70em" class="" floating color="accent">new {{ newMessages }}</q-badge></q-btn>
        <q-btn v-if="!profile.id" to="/login" class="q-ml-lg" outline style="color: goldenrod;" label="Login" />
      </q-toolbar-title>
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
  mounted () {
    this.getProfile('facebook')
    this.checkMessages()
  },
  created () {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type === 'user/updateMsgCount') {
        this.checkMessages()
      }
    })
  },
  components: { MainNav },
  data () {
    return {
      profile: {},
      leftDrawerOpen: false,
      miniState: true,
      newMessages: false
    }
  },
  methods: {
    showProfile: function () {
      this.$router.push({ path: '/profile/' + this.$store.state.user.uid })
    },
    getProfile: function (network) {
      if (this.$hello.getAuthResponse(network) == null) {
        return false
      }
      this.profile.id = this.$store.state.user.uid
      this.profile.avatar_url = this.$store.state.user.avatarUrl
    },
    checkMessages: async function () {
      if (this.profile.id) {
        const q = `${process.env.api}/user-messages?filter[where][and][0][user_id]=${this.$store.state.user.uid}&filter[where][and][1][status]=0`
        const newMessages = await this.$axios.get(q)
        this.newMessages = newMessages.data.length
        if (this.newMessages) {
          this.$store.commit('user/updateMsgCount', this.newMessages)
        }
      }
    }
  }
}
</script>
