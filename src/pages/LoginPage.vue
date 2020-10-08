<template>
  <q-page class="river-width flex flex-center">
    <div class="q-mt-xl">
      <q-btn color="primary" push class="full-width" icon="facebook" label="Login with Facebook" size="md" @click="auth('facebook')"></q-btn>
      <q-btn color="white" v-if="isLocal()" push class="full-width q-mt-sm text-black" icon="login" label="Login as Admin" size="md" @click="adminlogin()"></q-btn>
      <div class="text-caption text-center q-pa-lg">We collect no personal information!</div>
    </div>
  </q-page>
</template>
<script>
export default {
  meta () {
    return {
      title: 'Login'
    }
  },
  name: 'Login',
  methods: {
    isLocal: function () {
      return window.location.href.indexOf('localhost') > -1
    },
    adminlogin: function () {
      const obj = {
        id: '10158432748220049'
      }
      this.checkUser(obj)
    },
    auth: async function (network) {
      this.$hello(network).login()
        .then((e) => {
          this.$hello(network).api('me')
            .then((res) => {
              this.checkUser(res)
            })
        })
    },
    checkUser: async function (obj) {
      this.$q.loading.show({
        message: 'Logging in'
      })
      const q = `${process.env.api}/users?filter[where][facebook_uuid]=${obj.id}`
      const res = await this.$axios.get(q)
      if (res.data.length) {
        this.addStoreUser(res)
      } else {
        this.addDbUser(obj)
      }
    },
    addDbUser: async function (obj) {
      const q = `${process.env.api}/users`
      const payload = {
        name: obj.name,
        avatar_url: obj.picture,
        facebook_uuid: obj.id
      }
      const self = this
      this.$axios.post(q, payload).then(function (res) {
        self.addStoreUser(res)
      }).catch(function (error) {
        self.$q.notify({
          type: 'negative',
          icon: 'error',
          message: 'DB Error:' + error
        })
      })
    },
    addStoreUser: async function (res) {
      this.$store.commit('user/updateName', res.data[0].name)
      this.$store.commit('user/updateUid', res.data[0].id)
      this.$store.commit('user/updateAvatar', res.data[0].avatar_url)
      window.location.href = '/'
    }
  }
}

</script>
