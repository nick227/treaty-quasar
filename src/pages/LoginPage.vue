<template>
  <q-page class="river-column flex-middle">
    <div class="q-mt-xl">
      <q-btn color="primary" push class="full-width" icon="facebook" label="Login with Facebook" size="md" @click="auth('facebook')">
      </q-btn>
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
      const q = `${process.env.api}/users?filter[where][facebook_uuid]=${obj.id}`
      const res = await this.$axios.get(q)
      if (res.data.length) {
        this.addStoreUser(res)
        window.location.href = '/'
      } else {
        this.addDbUser(res)
      }
    },
    addDbUser: async function (obj) {
      const q = `${process.env.api}/users`
      const payload = {
        name: obj.name,
        avatar_url: obj.picture,
        facebook_uuid: obj.id
      }
      this.$axios.post(q, payload).then(function (res) {
        this.addStoreUser(res)
        this.$router.push('/')
      }).catch(function (error) {
        this.$q.notify({
          type: 'negative',
          icon: 'error',
          message: error
        })
      })
    },
    addStoreUser: async function (res) {
      this.$store.commit('user/updateUid', res.data[0].id)
      this.$store.commit('user/updateAvatar', res.data[0].avatar_url)
    }
  }
}

</script>
