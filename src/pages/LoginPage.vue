<template>
  <q-page>
    <div class="q-mt-xl">
      <q-btn color="primary" push class="full-width" icon="facebook" label="Login with Facebook" size="md" @click="auth('facebook')">
      </q-btn>
    </div>
  </q-page>
</template>
<script>
export default {
  name: 'Login',
  methods: {
    async auth (network) {
      this.$hello(network).login({ scope: 'friends' })
        .then((e) => {
          this.$hello(network).api('me')
            .then((res) => {
              this.update(res)
            })
        })
    },
    async update (obj) {
      const q = `http://localhost:3000/users?filter[where][facebook_uuid]=${obj.id}`
      const res = await this.$axios.get(q)
      if (res.data.length) {
        this.$store.commit('user/updateUid', res.data[0].id)
        window.location.href = '/'
      } else {
        const q = 'http://localhost:3000/users'
        const payload = {
          name: obj.name,
          avatar_url: obj.picture,
          facebook_uuid: obj.id
        }
        this.$axios.post(q, payload).then(function (res) {
          this.$router.push('/')
        }).catch(function (error) {
          alert('error')
          console.log(error)
        })
      }
    }
  }
}

</script>
