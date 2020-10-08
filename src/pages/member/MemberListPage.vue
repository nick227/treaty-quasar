<template>
<div class="river-width">
    <h6 class="q-mb-sm text-center q-mt-lg">Members</h6>
      <q-separator class="q-mb-lg" />
<div class="row q-pl-lg q-pr-lg">
      <h3 class="q-ma-lg text-center" v-if="!users.length && !done">LOADING...</h3>
      <h3 class="q-ma-lg text-center" v-if="!users.length && done">No members found.</h3>
  <div class="col col-shrink info-card q-mb-lg" v-for="user in users" :key="user.id">
    <q-card class="flex-break q-ma-lg">
      <div :style="'background-image:url(' + user.avatar_url + ')'" class="card-image"></div>
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
      limit: 9,
      done: false,
      loadNum: 0
    }
  },
  created () {
    this.getUsers()
  },
  methods: {
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.getUsers()
      }
      this.loadNum++
    },
    getUsers: async function () {
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
