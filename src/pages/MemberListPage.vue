<template>
<div class="">
<div class="row q-pa-lg">
  <div class="col col-shrink q-mb-lg" v-for="user in users" :key="user.id">
    <q-card class="org-card flex-break q-ma-lg">
      <img loading="lazy" style="height: 150px; width: 200px" :src="user.avatar_url">
      <q-card-section>
        <p class="caption">{{ user.name }}</p>
        <q-badge outline color="orange" :label="user.location.length > 2 ? user.location : 'Unknown'" />
      </q-card-section>
      <q-card-section class="q-pt-none">
          <q-btn :to="'/profile/'+user.id" class="full-width" color="primary">PROFILE</q-btn>
      </q-card-section>
    </q-card>
  </div>
</div>
  <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
    <q-spinner-dots color="primary" size="40px" />
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
      users: [],
      pointer: 0,
      limit: 25,
      done: false,
      loadNum: 0
    }
  },
  mounted () {
    this.getItems()
  },
  methods: {
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.getItems()
      }
      this.loadNum++
    },
    getItems: async function () {
      const q = `${process.env.api}/users?filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const users = await this.$axios.get(q)
      if (this.limit > users.data.length) {
        this.done = true
      }
      this.users = this.users.concat(users.data)
    }
  }
}
</script>
