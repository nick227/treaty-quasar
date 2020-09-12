<template>
  <div class="row q-pa-lg justify-start content-start">
    <div class="col col-shrink" v-for="user in users" :key="user.id">
      <q-card class="org-card flex-break q-mr-md">
    <img :src="user.avatar_url">
    <q-card-section>
      <div class="text-h6">{{ user.name }}</div>
      <q-badge v-if="user.location" outline color="orange" :label="user.location" />
      <div v-if="user.slugline" class="text-subtitle2">{{ user.slugline }}</div>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <q-btn :to="'/profile/'+user.id" class="full-width" color="primary">PROFILE</q-btn>
    </q-card-section>
  </q-card>
    </div>
  </div>
</template>
<script>
export default {
  meta () {
    return {
      title: 'Members'
    }
  },
  name: 'MemberListPage',
  data () {
    return {
      users: []
    }
  },
  async mounted () {
    const q = `${process.env.api}/users/`
    const users = await this.$axios.get(q)
    this.users = users.data
  }
}
</script>
